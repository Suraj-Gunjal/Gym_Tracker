import { Router } from 'express';
import bcrypt from 'bcryptjs';
import { z } from 'zod';
import { v4 as uuidv4 } from 'uuid';

import prisma from '../lib/prisma.js';
import { 
  generateAccessToken, 
  generateRefreshToken, 
  verifyRefreshToken,
  getRefreshTokenExpiry 
} from '../lib/jwt.js';
import { validate } from '../middleware/validate.js';
import { authenticate } from '../middleware/auth.middleware.js';
import { AppError } from '../middleware/error-handler.js';

export const authRouter = Router();

// Validation schemas
const registerSchema = z.object({
  email: z.string().email('Invalid email format'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
  displayName: z.string().min(1).max(100).optional(),
});

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string(),
  deviceName: z.string().optional(),
  deviceId: z.string().optional(),
});

const refreshSchema = z.object({
  refreshToken: z.string(),
});

// POST /api/auth/register
authRouter.post('/register', validate(registerSchema), async (req, res, next) => {
  try {
    const { email, password, displayName } = req.body;
    
    // Check if user exists
    const existing = await prisma.user.findUnique({ where: { email } });
    if (existing) {
      throw new AppError(409, 'Email already registered', 'EMAIL_EXISTS');
    }
    
    // Hash password
    const passwordHash = await bcrypt.hash(password, 12);
    
    // Create user
    const user = await prisma.user.create({
      data: {
        email,
        passwordHash,
        displayName,
      },
      select: {
        id: true,
        email: true,
        displayName: true,
        createdAt: true,
      },
    });
    
    // Generate tokens
    const accessToken = generateAccessToken(user.id, user.email);
    const refreshToken = generateRefreshToken(user.id, user.email);
    
    // Store refresh token
    await prisma.refreshToken.create({
      data: {
        token: refreshToken,
        userId: user.id,
        expiresAt: getRefreshTokenExpiry(),
        deviceName: req.body.deviceName,
        deviceId: req.body.deviceId || uuidv4(),
      },
    });
    
    res.status(201).json({
      user,
      accessToken,
      refreshToken,
    });
  } catch (error) {
    next(error);
  }
});

// POST /api/auth/login
authRouter.post('/login', validate(loginSchema), async (req, res, next) => {
  try {
    const { email, password, deviceName, deviceId } = req.body;
    
    // Find user
    const user = await prisma.user.findUnique({ 
      where: { email, isDeleted: false } 
    });
    
    if (!user) {
      throw new AppError(401, 'Invalid credentials', 'INVALID_CREDENTIALS');
    }
    
    // Verify password
    const valid = await bcrypt.compare(password, user.passwordHash);
    if (!valid) {
      throw new AppError(401, 'Invalid credentials', 'INVALID_CREDENTIALS');
    }
    
    // Generate tokens
    const accessToken = generateAccessToken(user.id, user.email);
    const refreshToken = generateRefreshToken(user.id, user.email);
    
    // Store refresh token
    const newDeviceId = deviceId || uuidv4();
    
    // Remove existing token for this device if exists
    if (deviceId) {
      await prisma.refreshToken.deleteMany({
        where: { userId: user.id, deviceId },
      });
    }
    
    await prisma.refreshToken.create({
      data: {
        token: refreshToken,
        userId: user.id,
        expiresAt: getRefreshTokenExpiry(),
        deviceName,
        deviceId: newDeviceId,
      },
    });
    
    res.json({
      user: {
        id: user.id,
        email: user.email,
        displayName: user.displayName,
        avatarUrl: user.avatarUrl,
      },
      accessToken,
      refreshToken,
      deviceId: newDeviceId,
    });
  } catch (error) {
    next(error);
  }
});

// POST /api/auth/refresh
authRouter.post('/refresh', validate(refreshSchema), async (req, res, next) => {
  try {
    const { refreshToken } = req.body;
    
    // Verify token
    const payload = verifyRefreshToken(refreshToken);
    if (!payload) {
      throw new AppError(401, 'Invalid refresh token', 'INVALID_TOKEN');
    }
    
    // Find token in database
    const storedToken = await prisma.refreshToken.findUnique({
      where: { token: refreshToken },
      include: { user: true },
    });
    
    if (!storedToken || storedToken.expiresAt < new Date()) {
      // Clean up expired token
      if (storedToken) {
        await prisma.refreshToken.delete({ where: { id: storedToken.id } });
      }
      throw new AppError(401, 'Token expired or invalid', 'TOKEN_EXPIRED');
    }
    
    // Generate new tokens
    const newAccessToken = generateAccessToken(storedToken.userId, storedToken.user.email);
    const newRefreshToken = generateRefreshToken(storedToken.userId, storedToken.user.email);
    
    // Rotate refresh token
    await prisma.refreshToken.update({
      where: { id: storedToken.id },
      data: {
        token: newRefreshToken,
        expiresAt: getRefreshTokenExpiry(),
      },
    });
    
    res.json({
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
    });
  } catch (error) {
    next(error);
  }
});

// POST /api/auth/logout
authRouter.post('/logout', authenticate, async (req, res, next) => {
  try {
    const { deviceId } = req;
    const userId = req.user!.userId;
    
    if (deviceId) {
      // Logout from specific device
      await prisma.refreshToken.deleteMany({
        where: { userId, deviceId },
      });
    } else {
      // Logout from all devices
      await prisma.refreshToken.deleteMany({
        where: { userId },
      });
    }
    
    res.json({ message: 'Logged out successfully' });
  } catch (error) {
    next(error);
  }
});

// GET /api/auth/me
authRouter.get('/me', authenticate, async (req, res, next) => {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user!.userId },
      select: {
        id: true,
        email: true,
        displayName: true,
        avatarUrl: true,
        lastSyncAt: true,
        createdAt: true,
      },
    });
    
    if (!user) {
      throw new AppError(404, 'User not found', 'USER_NOT_FOUND');
    }
    
    res.json(user);
  } catch (error) {
    next(error);
  }
});

// PATCH /api/auth/me
authRouter.patch('/me', authenticate, async (req, res, next) => {
  try {
    const updateSchema = z.object({
      displayName: z.string().min(1).max(100).optional(),
      avatarUrl: z.string().url().optional().nullable(),
    });
    
    const data = updateSchema.parse(req.body);
    
    const user = await prisma.user.update({
      where: { id: req.user!.userId },
      data,
      select: {
        id: true,
        email: true,
        displayName: true,
        avatarUrl: true,
      },
    });
    
    res.json(user);
  } catch (error) {
    next(error);
  }
});

// DELETE /api/auth/me (soft delete)
authRouter.delete('/me', authenticate, async (req, res, next) => {
  try {
    await prisma.user.update({
      where: { id: req.user!.userId },
      data: {
        isDeleted: true,
        deletedAt: new Date(),
      },
    });
    
    // Remove all refresh tokens
    await prisma.refreshToken.deleteMany({
      where: { userId: req.user!.userId },
    });
    
    res.json({ message: 'Account deleted successfully' });
  } catch (error) {
    next(error);
  }
});
