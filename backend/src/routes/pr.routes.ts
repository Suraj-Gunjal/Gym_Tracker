import { Router } from 'express';
import { z } from 'zod';
import prisma from '../lib/prisma.js';
import { authenticate } from '../middleware/auth.middleware.js';
import { validate, validateQuery } from '../middleware/validate.js';
import { AppError } from '../middleware/error-handler.js';
import { PRType } from '@prisma/client';

export const prRouter = Router();

// All PR routes require authentication
prRouter.use(authenticate);

// Validation schemas
const prTypeEnum = z.nativeEnum(PRType);

const createPRSchema = z.object({
  id: z.string().uuid().optional(),
  clientId: z.string().uuid().optional(),
  exerciseId: z.string().uuid(),
  prType: prTypeEnum,
  value: z.number(),
  weight: z.number().nullable().optional(),
  reps: z.number().int().nullable().optional(),
  achievedAt: z.string().datetime(),
});

const querySchema = z.object({
  exerciseId: z.string().uuid().optional(),
  prType: prTypeEnum.optional(),
  limit: z.coerce.number().min(1).max(100).default(50),
  offset: z.coerce.number().min(0).default(0),
});

// GET /api/prs - List user's PRs
prRouter.get('/', validateQuery(querySchema), async (req, res, next) => {
  try {
    const { exerciseId, prType, limit, offset } = querySchema.parse(req.query);
    const userId = req.user!.userId;
    
    const where = {
      userId,
      ...(exerciseId && { exerciseId }),
      ...(prType && { prType }),
    };
    
    const [prs, total] = await Promise.all([
      prisma.personalRecord.findMany({
        where,
        take: limit,
        skip: offset,
        orderBy: { achievedAt: 'desc' },
        include: {
          exercise: {
            select: {
              id: true,
              name: true,
              primaryMuscle: true,
            },
          },
        },
      }),
      prisma.personalRecord.count({ where }),
    ]);
    
    res.json({
      prs,
      total,
      limit,
      offset,
    });
  } catch (error) {
    next(error);
  }
});

// GET /api/prs/exercise/:exerciseId - Get PRs for specific exercise
prRouter.get('/exercise/:exerciseId', async (req, res, next) => {
  try {
    const prs = await prisma.personalRecord.findMany({
      where: {
        exerciseId: req.params.exerciseId,
        userId: req.user!.userId,
      },
      orderBy: { prType: 'asc' },
    });
    
    // Return as a map for easy access
    const prMap = prs.reduce((acc, pr) => {
      acc[pr.prType] = pr;
      return acc;
    }, {} as Record<string, typeof prs[0]>);
    
    res.json(prMap);
  } catch (error) {
    next(error);
  }
});

// POST /api/prs - Create or update PR
prRouter.post('/', validate(createPRSchema), async (req, res, next) => {
  try {
    const data = createPRSchema.parse(req.body);
    const userId = req.user!.userId;
    
    // Check if exercise exists
    const exercise = await prisma.exercise.findFirst({
      where: {
        OR: [
          { id: data.exerciseId },
          { clientId: data.exerciseId },
        ],
        isDeleted: false,
      },
    });
    
    if (!exercise) {
      throw new AppError(404, 'Exercise not found', 'EXERCISE_NOT_FOUND');
    }
    
    // Upsert PR (update if better, or create if new)
    const existing = await prisma.personalRecord.findUnique({
      where: {
        exerciseId_userId_prType: {
          exerciseId: exercise.id,
          userId,
          prType: data.prType,
        },
      },
    });
    
    // Only update if new value is better
    if (existing && existing.value >= data.value) {
      res.json({ 
        pr: existing, 
        isNewRecord: false,
        message: 'Existing record is better or equal',
      });
      return;
    }
    
    const pr = await prisma.personalRecord.upsert({
      where: {
        exerciseId_userId_prType: {
          exerciseId: exercise.id,
          userId,
          prType: data.prType,
        },
      },
      update: {
        value: data.value,
        weight: data.weight,
        reps: data.reps,
        achievedAt: new Date(data.achievedAt),
      },
      create: {
        clientId: data.clientId || data.id,
        exerciseId: exercise.id,
        userId,
        prType: data.prType,
        value: data.value,
        weight: data.weight,
        reps: data.reps,
        achievedAt: new Date(data.achievedAt),
      },
      include: {
        exercise: {
          select: {
            id: true,
            name: true,
            primaryMuscle: true,
          },
        },
      },
    });
    
    res.status(existing ? 200 : 201).json({
      pr,
      isNewRecord: true,
      previousValue: existing?.value,
    });
  } catch (error) {
    next(error);
  }
});

// DELETE /api/prs/:id - Delete PR
prRouter.delete('/:id', async (req, res, next) => {
  try {
    const existing = await prisma.personalRecord.findFirst({
      where: {
        OR: [
          { id: req.params.id },
          { clientId: req.params.id },
        ],
        userId: req.user!.userId,
      },
    });
    
    if (!existing) {
      throw new AppError(404, 'PR not found', 'NOT_FOUND');
    }
    
    await prisma.personalRecord.delete({
      where: { id: existing.id },
    });
    
    res.json({ message: 'PR deleted' });
  } catch (error) {
    next(error);
  }
});

// GET /api/prs/leaderboard/:exerciseId - Get top PRs for exercise (future feature)
prRouter.get('/leaderboard/:exerciseId', async (req, res, next) => {
  try {
    const prType = (req.query.type as PRType) || PRType.MAX_WEIGHT;
    
    const topPRs = await prisma.personalRecord.findMany({
      where: {
        exerciseId: req.params.exerciseId,
        prType,
      },
      orderBy: { value: 'desc' },
      take: 10,
      include: {
        user: {
          select: {
            displayName: true,
          },
        },
      },
    });
    
    // Anonymize for privacy
    const leaderboard = topPRs.map((pr, index) => ({
      rank: index + 1,
      value: pr.value,
      displayName: pr.user.displayName || `User ${index + 1}`,
      achievedAt: pr.achievedAt,
    }));
    
    res.json(leaderboard);
  } catch (error) {
    next(error);
  }
});
