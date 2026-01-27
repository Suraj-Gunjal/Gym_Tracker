import { Router } from 'express';
import { z } from 'zod';
import prisma from '../lib/prisma.js';
import { authenticate } from '../middleware/auth.middleware.js';
import { validate, validateQuery } from '../middleware/validate.js';
import { AppError } from '../middleware/error-handler.js';

export const workoutRouter = Router();

// All workout routes require authentication
workoutRouter.use(authenticate);

// Validation schemas
const setSchema = z.object({
  id: z.string().uuid().optional(),
  clientId: z.string().uuid().optional(),
  setNumber: z.number().int().min(1),
  weight: z.number().nullable().optional(),
  reps: z.number().int().nullable().optional(),
  durationSeconds: z.number().int().nullable().optional(),
  distance: z.number().nullable().optional(),
  rpe: z.number().min(1).max(10).nullable().optional(),
  isWarmup: z.boolean().default(false),
  isDropset: z.boolean().default(false),
  isFailure: z.boolean().default(false),
  isCompleted: z.boolean().default(false),
  completedAt: z.string().datetime().nullable().optional(),
});

const workoutExerciseSchema = z.object({
  id: z.string().uuid().optional(),
  clientId: z.string().uuid().optional(),
  exerciseId: z.string().uuid(),
  orderIndex: z.number().int().min(0),
  notes: z.string().nullable().optional(),
  restSeconds: z.number().int().nullable().optional(),
  sets: z.array(setSchema).default([]),
});

const createWorkoutSchema = z.object({
  id: z.string().uuid().optional(),
  clientId: z.string().uuid().optional(),
  name: z.string().max(200).nullable().optional(),
  notes: z.string().max(2000).nullable().optional(),
  startTime: z.string().datetime(),
  endTime: z.string().datetime().nullable().optional(),
  durationMs: z.number().int().nullable().optional(),
  exercises: z.array(workoutExerciseSchema).default([]),
});

const updateWorkoutSchema = createWorkoutSchema.partial().omit({ id: true, clientId: true });

const querySchema = z.object({
  from: z.string().datetime().optional(),
  to: z.string().datetime().optional(),
  limit: z.coerce.number().min(1).max(100).default(20),
  offset: z.coerce.number().min(0).default(0),
});

// GET /api/workouts - List user's workouts
workoutRouter.get('/', validateQuery(querySchema), async (req, res, next) => {
  try {
    const { from, to, limit, offset } = querySchema.parse(req.query);
    const userId = req.user!.userId;
    
    const where = {
      userId,
      isDeleted: false,
      ...(from && { startTime: { gte: new Date(from) } }),
      ...(to && { startTime: { lte: new Date(to) } }),
    };
    
    const [workouts, total] = await Promise.all([
      prisma.workout.findMany({
        where,
        take: limit,
        skip: offset,
        orderBy: { startTime: 'desc' },
        include: {
          exercises: {
            orderBy: { orderIndex: 'asc' },
            include: {
              exercise: {
                select: {
                  id: true,
                  name: true,
                  primaryMuscle: true,
                },
              },
              sets: {
                orderBy: { setNumber: 'asc' },
              },
            },
          },
        },
      }),
      prisma.workout.count({ where }),
    ]);
    
    res.json({
      workouts,
      total,
      limit,
      offset,
    });
  } catch (error) {
    next(error);
  }
});

// GET /api/workouts/:id - Get single workout
workoutRouter.get('/:id', async (req, res, next) => {
  try {
    const workout = await prisma.workout.findFirst({
      where: {
        OR: [
          { id: req.params.id },
          { clientId: req.params.id },
        ],
        userId: req.user!.userId,
        isDeleted: false,
      },
      include: {
        exercises: {
          orderBy: { orderIndex: 'asc' },
          include: {
            exercise: true,
            sets: {
              orderBy: { setNumber: 'asc' },
            },
          },
        },
      },
    });
    
    if (!workout) {
      throw new AppError(404, 'Workout not found', 'NOT_FOUND');
    }
    
    res.json(workout);
  } catch (error) {
    next(error);
  }
});

// POST /api/workouts - Create workout
workoutRouter.post('/', validate(createWorkoutSchema), async (req, res, next) => {
  try {
    const data = createWorkoutSchema.parse(req.body);
    const userId = req.user!.userId;
    
    const workout = await prisma.workout.create({
      data: {
        clientId: data.clientId || data.id,
        name: data.name,
        notes: data.notes,
        startTime: new Date(data.startTime),
        endTime: data.endTime ? new Date(data.endTime) : null,
        durationMs: data.durationMs,
        userId,
        exercises: {
          create: data.exercises.map(ex => ({
            clientId: ex.clientId || ex.id,
            exerciseId: ex.exerciseId,
            orderIndex: ex.orderIndex,
            notes: ex.notes,
            restSeconds: ex.restSeconds,
            sets: {
              create: ex.sets.map(set => ({
                clientId: set.clientId || set.id,
                setNumber: set.setNumber,
                weight: set.weight,
                reps: set.reps,
                durationSeconds: set.durationSeconds,
                distance: set.distance,
                rpe: set.rpe,
                isWarmup: set.isWarmup,
                isDropset: set.isDropset,
                isFailure: set.isFailure,
                isCompleted: set.isCompleted,
                completedAt: set.completedAt ? new Date(set.completedAt) : null,
              })),
            },
          })),
        },
      },
      include: {
        exercises: {
          include: {
            exercise: true,
            sets: true,
          },
        },
      },
    });
    
    res.status(201).json(workout);
  } catch (error) {
    next(error);
  }
});

// PUT /api/workouts/:id - Update workout
workoutRouter.put('/:id', validate(updateWorkoutSchema), async (req, res, next) => {
  try {
    const existing = await prisma.workout.findFirst({
      where: {
        OR: [
          { id: req.params.id },
          { clientId: req.params.id },
        ],
        userId: req.user!.userId,
      },
    });
    
    if (!existing) {
      throw new AppError(404, 'Workout not found', 'NOT_FOUND');
    }
    
    const data = updateWorkoutSchema.parse(req.body);
    
    // Update basic workout data
    const workout = await prisma.workout.update({
      where: { id: existing.id },
      data: {
        name: data.name,
        notes: data.notes,
        startTime: data.startTime ? new Date(data.startTime) : undefined,
        endTime: data.endTime ? new Date(data.endTime) : undefined,
        durationMs: data.durationMs,
      },
      include: {
        exercises: {
          include: {
            exercise: true,
            sets: true,
          },
        },
      },
    });
    
    res.json(workout);
  } catch (error) {
    next(error);
  }
});

// DELETE /api/workouts/:id - Soft delete workout
workoutRouter.delete('/:id', async (req, res, next) => {
  try {
    const existing = await prisma.workout.findFirst({
      where: {
        OR: [
          { id: req.params.id },
          { clientId: req.params.id },
        ],
        userId: req.user!.userId,
      },
    });
    
    if (!existing) {
      throw new AppError(404, 'Workout not found', 'NOT_FOUND');
    }
    
    await prisma.workout.update({
      where: { id: existing.id },
      data: {
        isDeleted: true,
        deletedAt: new Date(),
      },
    });
    
    res.json({ message: 'Workout deleted' });
  } catch (error) {
    next(error);
  }
});

// GET /api/workouts/stats/summary - Get workout statistics
workoutRouter.get('/stats/summary', async (req, res, next) => {
  try {
    const userId = req.user!.userId;
    
    const [totalWorkouts, thisWeek, thisMonth, totalVolume] = await Promise.all([
      // Total workouts
      prisma.workout.count({
        where: { userId, isDeleted: false },
      }),
      
      // This week
      prisma.workout.count({
        where: {
          userId,
          isDeleted: false,
          startTime: {
            gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
          },
        },
      }),
      
      // This month
      prisma.workout.count({
        where: {
          userId,
          isDeleted: false,
          startTime: {
            gte: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000),
          },
        },
      }),
      
      // Total volume (simplified)
      prisma.exerciseSet.aggregate({
        where: {
          workoutExercise: {
            workout: {
              userId,
              isDeleted: false,
            },
          },
          isCompleted: true,
        },
        _sum: {
          weight: true,
          reps: true,
        },
      }),
    ]);
    
    res.json({
      totalWorkouts,
      thisWeek,
      thisMonth,
      totalVolume: (totalVolume._sum.weight || 0) * (totalVolume._sum.reps || 0),
    });
  } catch (error) {
    next(error);
  }
});
