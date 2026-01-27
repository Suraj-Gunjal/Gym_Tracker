import { Router } from 'express';
import { z } from 'zod';
import prisma from '../lib/prisma.js';
import { authenticate, optionalAuth } from '../middleware/auth.middleware.js';
import { validate, validateQuery } from '../middleware/validate.js';
import { AppError } from '../middleware/error-handler.js';
import { MuscleGroup } from '@prisma/client';

export const exerciseRouter = Router();

// Validation schemas
const muscleGroupEnum = z.nativeEnum(MuscleGroup);

const createExerciseSchema = z.object({
  id: z.string().uuid().optional(), // Client-generated ID for sync
  name: z.string().min(1).max(100),
  description: z.string().max(1000).optional(),
  primaryMuscle: muscleGroupEnum,
  secondaryMuscles: z.array(muscleGroupEnum).default([]),
  isCompound: z.boolean().default(false),
  clientId: z.string().uuid().optional(),
});

const updateExerciseSchema = createExerciseSchema.partial().omit({ id: true, clientId: true });

const querySchema = z.object({
  muscle: muscleGroupEnum.optional(),
  search: z.string().optional(),
  customOnly: z.coerce.boolean().optional(),
  limit: z.coerce.number().min(1).max(100).default(50),
  offset: z.coerce.number().min(0).default(0),
});

// GET /api/exercises - List exercises
exerciseRouter.get('/', optionalAuth, validateQuery(querySchema), async (req, res, next) => {
  try {
    const { muscle, search, customOnly, limit, offset } = querySchema.parse(req.query);
    
    const where = {
      isDeleted: false,
      ...(muscle && { primaryMuscle: muscle }),
      ...(search && { 
        name: { contains: search, mode: 'insensitive' as const } 
      }),
      ...(customOnly && req.user && { userId: req.user.userId }),
      // Show system exercises + user's custom exercises
      ...(!customOnly && req.user && {
        OR: [
          { userId: null }, // System exercises
          { userId: req.user.userId }, // User's custom exercises
        ],
      }),
      ...(!req.user && { userId: null }), // Only system exercises for unauthenticated
    };
    
    const [exercises, total] = await Promise.all([
      prisma.exercise.findMany({
        where,
        take: limit,
        skip: offset,
        orderBy: { name: 'asc' },
        select: {
          id: true,
          name: true,
          description: true,
          primaryMuscle: true,
          secondaryMuscles: true,
          isCustom: true,
          isCompound: true,
          clientId: true,
          createdAt: true,
          updatedAt: true,
        },
      }),
      prisma.exercise.count({ where }),
    ]);
    
    res.json({
      exercises,
      total,
      limit,
      offset,
    });
  } catch (error) {
    next(error);
  }
});

// GET /api/exercises/:id - Get single exercise
exerciseRouter.get('/:id', optionalAuth, async (req, res, next) => {
  try {
    const exercise = await prisma.exercise.findFirst({
      where: {
        OR: [
          { id: req.params.id },
          { clientId: req.params.id },
        ],
        isDeleted: false,
      },
      include: {
        personalRecords: req.user ? {
          where: { userId: req.user.userId },
          orderBy: { achievedAt: 'desc' },
        } : false,
      },
    });
    
    if (!exercise) {
      throw new AppError(404, 'Exercise not found', 'NOT_FOUND');
    }
    
    // Check access for custom exercises
    if (exercise.userId && exercise.userId !== req.user?.userId) {
      throw new AppError(403, 'Access denied', 'FORBIDDEN');
    }
    
    res.json(exercise);
  } catch (error) {
    next(error);
  }
});

// POST /api/exercises - Create custom exercise
exerciseRouter.post('/', authenticate, validate(createExerciseSchema), async (req, res, next) => {
  try {
    const data = createExerciseSchema.parse(req.body);
    
    const exercise = await prisma.exercise.create({
      data: {
        ...data,
        isCustom: true,
        userId: req.user!.userId,
        clientId: data.clientId || data.id,
      },
      select: {
        id: true,
        name: true,
        description: true,
        primaryMuscle: true,
        secondaryMuscles: true,
        isCustom: true,
        isCompound: true,
        clientId: true,
        createdAt: true,
        updatedAt: true,
      },
    });
    
    res.status(201).json(exercise);
  } catch (error) {
    next(error);
  }
});

// PUT /api/exercises/:id - Update exercise
exerciseRouter.put('/:id', authenticate, validate(updateExerciseSchema), async (req, res, next) => {
  try {
    // Find exercise
    const existing = await prisma.exercise.findFirst({
      where: {
        OR: [
          { id: req.params.id },
          { clientId: req.params.id },
        ],
      },
    });
    
    if (!existing) {
      throw new AppError(404, 'Exercise not found', 'NOT_FOUND');
    }
    
    // Only allow updating own custom exercises
    if (!existing.isCustom || existing.userId !== req.user!.userId) {
      throw new AppError(403, 'Cannot modify this exercise', 'FORBIDDEN');
    }
    
    const data = updateExerciseSchema.parse(req.body);
    
    const exercise = await prisma.exercise.update({
      where: { id: existing.id },
      data,
      select: {
        id: true,
        name: true,
        description: true,
        primaryMuscle: true,
        secondaryMuscles: true,
        isCustom: true,
        isCompound: true,
        clientId: true,
        createdAt: true,
        updatedAt: true,
      },
    });
    
    res.json(exercise);
  } catch (error) {
    next(error);
  }
});

// DELETE /api/exercises/:id - Soft delete exercise
exerciseRouter.delete('/:id', authenticate, async (req, res, next) => {
  try {
    const existing = await prisma.exercise.findFirst({
      where: {
        OR: [
          { id: req.params.id },
          { clientId: req.params.id },
        ],
      },
    });
    
    if (!existing) {
      throw new AppError(404, 'Exercise not found', 'NOT_FOUND');
    }
    
    if (!existing.isCustom || existing.userId !== req.user!.userId) {
      throw new AppError(403, 'Cannot delete this exercise', 'FORBIDDEN');
    }
    
    await prisma.exercise.update({
      where: { id: existing.id },
      data: {
        isDeleted: true,
        deletedAt: new Date(),
      },
    });
    
    res.json({ message: 'Exercise deleted' });
  } catch (error) {
    next(error);
  }
});
