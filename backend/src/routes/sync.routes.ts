import { Router } from 'express';
import { z } from 'zod';
import prisma from '../lib/prisma.js';
import { authenticate } from '../middleware/auth.middleware.js';
import { validate } from '../middleware/validate.js';
import { MuscleGroup, PRType } from '@prisma/client';

export const syncRouter = Router();

// All sync routes require authentication
syncRouter.use(authenticate);

// Sync payload schema - accepts arrays of each entity type
const syncPushSchema = z.object({
  deviceId: z.string(),
  lastSyncAt: z.string().datetime().nullable().optional(),
  
  exercises: z.array(z.object({
    id: z.string().uuid(),
    name: z.string(),
    description: z.string().nullable().optional(),
    primaryMuscle: z.nativeEnum(MuscleGroup),
    secondaryMuscles: z.array(z.nativeEnum(MuscleGroup)).default([]),
    isCompound: z.boolean().default(false),
    isDeleted: z.boolean().default(false),
    updatedAt: z.string().datetime(),
  })).default([]),
  
  workouts: z.array(z.object({
    id: z.string().uuid(),
    name: z.string().nullable().optional(),
    notes: z.string().nullable().optional(),
    startTime: z.string().datetime(),
    endTime: z.string().datetime().nullable().optional(),
    durationMs: z.number().int().nullable().optional(),
    isDeleted: z.boolean().default(false),
    updatedAt: z.string().datetime(),
    exercises: z.array(z.object({
      id: z.string().uuid(),
      exerciseId: z.string().uuid(),
      orderIndex: z.number().int(),
      notes: z.string().nullable().optional(),
      restSeconds: z.number().int().nullable().optional(),
      sets: z.array(z.object({
        id: z.string().uuid(),
        setNumber: z.number().int(),
        weight: z.number().nullable().optional(),
        reps: z.number().int().nullable().optional(),
        durationSeconds: z.number().int().nullable().optional(),
        distance: z.number().nullable().optional(),
        rpe: z.number().nullable().optional(),
        isWarmup: z.boolean().default(false),
        isDropset: z.boolean().default(false),
        isFailure: z.boolean().default(false),
        isCompleted: z.boolean().default(false),
        completedAt: z.string().datetime().nullable().optional(),
      })).default([]),
    })).default([]),
  })).default([]),
  
  personalRecords: z.array(z.object({
    id: z.string().uuid(),
    exerciseId: z.string().uuid(),
    prType: z.nativeEnum(PRType),
    value: z.number(),
    weight: z.number().nullable().optional(),
    reps: z.number().int().nullable().optional(),
    achievedAt: z.string().datetime(),
    updatedAt: z.string().datetime(),
  })).default([]),
});

const syncPullSchema = z.object({
  deviceId: z.string(),
  lastSyncAt: z.string().datetime().nullable().optional(),
});

// POST /api/sync/push - Push local changes to server
syncRouter.post('/push', validate(syncPushSchema), async (req, res, next) => {
  try {
    const data = syncPushSchema.parse(req.body);
    const userId = req.user!.userId;
    const { deviceId, exercises, workouts, personalRecords } = data;
    
    let itemsPushed = 0;
    let conflicts = 0;
    
    // Start sync log
    const syncLog = await prisma.syncLog.create({
      data: {
        userId,
        deviceId,
        syncType: 'push',
        startedAt: new Date(),
      },
    });
    
    try {
      // Sync exercises
      for (const ex of exercises) {
        const existing = await prisma.exercise.findUnique({
          where: { clientId: ex.id },
        });
        
        if (existing) {
          // Check for conflicts (server is newer)
          if (existing.updatedAt > new Date(ex.updatedAt)) {
            conflicts++;
            continue; // Skip - server has newer version
          }
          
          await prisma.exercise.update({
            where: { id: existing.id },
            data: {
              name: ex.name,
              description: ex.description,
              primaryMuscle: ex.primaryMuscle,
              secondaryMuscles: ex.secondaryMuscles,
              isCompound: ex.isCompound,
              isDeleted: ex.isDeleted,
              deletedAt: ex.isDeleted ? new Date() : null,
            },
          });
        } else {
          await prisma.exercise.create({
            data: {
              clientId: ex.id,
              name: ex.name,
              description: ex.description,
              primaryMuscle: ex.primaryMuscle,
              secondaryMuscles: ex.secondaryMuscles,
              isCompound: ex.isCompound,
              isCustom: true,
              userId,
              isDeleted: ex.isDeleted,
              deletedAt: ex.isDeleted ? new Date() : null,
            },
          });
        }
        itemsPushed++;
      }
      
      // Sync workouts with nested exercises and sets
      for (const workout of workouts) {
        const existingWorkout = await prisma.workout.findUnique({
          where: { clientId: workout.id },
        });
        
        if (existingWorkout) {
          if (existingWorkout.updatedAt > new Date(workout.updatedAt)) {
            conflicts++;
            continue;
          }
          
          // Update workout
          await prisma.workout.update({
            where: { id: existingWorkout.id },
            data: {
              name: workout.name,
              notes: workout.notes,
              startTime: new Date(workout.startTime),
              endTime: workout.endTime ? new Date(workout.endTime) : null,
              durationMs: workout.durationMs,
              isDeleted: workout.isDeleted,
              deletedAt: workout.isDeleted ? new Date() : null,
            },
          });
          
          // Sync workout exercises
          for (const we of workout.exercises) {
            // Find exercise by clientId
            const exercise = await prisma.exercise.findFirst({
              where: {
                OR: [
                  { id: we.exerciseId },
                  { clientId: we.exerciseId },
                ],
              },
            });
            
            if (!exercise) continue;
            
            const existingWE = await prisma.workoutExercise.findUnique({
              where: { clientId: we.id },
            });
            
            if (existingWE) {
              await prisma.workoutExercise.update({
                where: { id: existingWE.id },
                data: {
                  exerciseId: exercise.id,
                  orderIndex: we.orderIndex,
                  notes: we.notes,
                  restSeconds: we.restSeconds,
                },
              });
              
              // Sync sets
              for (const set of we.sets) {
                await prisma.exerciseSet.upsert({
                  where: { clientId: set.id },
                  update: {
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
                  },
                  create: {
                    clientId: set.id,
                    workoutExerciseId: existingWE.id,
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
                  },
                });
              }
            } else {
              const newWE = await prisma.workoutExercise.create({
                data: {
                  clientId: we.id,
                  workoutId: existingWorkout.id,
                  exerciseId: exercise.id,
                  orderIndex: we.orderIndex,
                  notes: we.notes,
                  restSeconds: we.restSeconds,
                },
              });
              
              // Create sets
              for (const set of we.sets) {
                await prisma.exerciseSet.create({
                  data: {
                    clientId: set.id,
                    workoutExerciseId: newWE.id,
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
                  },
                });
              }
            }
          }
        } else {
          // Create new workout with all nested data
          const newWorkout = await prisma.workout.create({
            data: {
              clientId: workout.id,
              userId,
              name: workout.name,
              notes: workout.notes,
              startTime: new Date(workout.startTime),
              endTime: workout.endTime ? new Date(workout.endTime) : null,
              durationMs: workout.durationMs,
              isDeleted: workout.isDeleted,
              deletedAt: workout.isDeleted ? new Date() : null,
            },
          });
          
          for (const we of workout.exercises) {
            const exercise = await prisma.exercise.findFirst({
              where: {
                OR: [
                  { id: we.exerciseId },
                  { clientId: we.exerciseId },
                ],
              },
            });
            
            if (!exercise) continue;
            
            const newWE = await prisma.workoutExercise.create({
              data: {
                clientId: we.id,
                workoutId: newWorkout.id,
                exerciseId: exercise.id,
                orderIndex: we.orderIndex,
                notes: we.notes,
                restSeconds: we.restSeconds,
              },
            });
            
            for (const set of we.sets) {
              await prisma.exerciseSet.create({
                data: {
                  clientId: set.id,
                  workoutExerciseId: newWE.id,
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
                },
              });
            }
          }
        }
        itemsPushed++;
      }
      
      // Sync PRs
      for (const pr of personalRecords) {
        const exercise = await prisma.exercise.findFirst({
          where: {
            OR: [
              { id: pr.exerciseId },
              { clientId: pr.exerciseId },
            ],
          },
        });
        
        if (!exercise) continue;
        
        await prisma.personalRecord.upsert({
          where: {
            exerciseId_userId_prType: {
              exerciseId: exercise.id,
              userId,
              prType: pr.prType,
            },
          },
          update: {
            value: pr.value,
            weight: pr.weight,
            reps: pr.reps,
            achievedAt: new Date(pr.achievedAt),
          },
          create: {
            clientId: pr.id,
            exerciseId: exercise.id,
            userId,
            prType: pr.prType,
            value: pr.value,
            weight: pr.weight,
            reps: pr.reps,
            achievedAt: new Date(pr.achievedAt),
          },
        });
        itemsPushed++;
      }
      
      // Update user's last sync time
      await prisma.user.update({
        where: { id: userId },
        data: { lastSyncAt: new Date() },
      });
      
      // Complete sync log
      await prisma.syncLog.update({
        where: { id: syncLog.id },
        data: {
          status: 'completed',
          completedAt: new Date(),
          itemsPushed,
          conflicts,
        },
      });
      
      res.json({
        success: true,
        itemsPushed,
        conflicts,
        syncedAt: new Date().toISOString(),
      });
    } catch (error) {
      await prisma.syncLog.update({
        where: { id: syncLog.id },
        data: {
          status: 'failed',
          completedAt: new Date(),
          errorMessage: error instanceof Error ? error.message : 'Unknown error',
        },
      });
      throw error;
    }
  } catch (error) {
    next(error);
  }
});

// POST /api/sync/pull - Pull server changes to client
syncRouter.post('/pull', validate(syncPullSchema), async (req, res, next) => {
  try {
    const { lastSyncAt, deviceId } = syncPullSchema.parse(req.body);
    const userId = req.user!.userId;
    
    const since = lastSyncAt ? new Date(lastSyncAt) : new Date(0);
    
    // Get all updated data since last sync
    const [exercises, workouts, personalRecords] = await Promise.all([
      // Custom exercises only (system exercises don't sync)
      prisma.exercise.findMany({
        where: {
          userId,
          updatedAt: { gt: since },
        },
        select: {
          id: true,
          clientId: true,
          name: true,
          description: true,
          primaryMuscle: true,
          secondaryMuscles: true,
          isCompound: true,
          isDeleted: true,
          createdAt: true,
          updatedAt: true,
        },
      }),
      
      prisma.workout.findMany({
        where: {
          userId,
          updatedAt: { gt: since },
        },
        include: {
          exercises: {
            include: {
              sets: true,
            },
          },
        },
      }),
      
      prisma.personalRecord.findMany({
        where: {
          userId,
          updatedAt: { gt: since },
        },
      }),
    ]);
    
    // Log the pull
    await prisma.syncLog.create({
      data: {
        userId,
        deviceId,
        syncType: 'pull',
        startedAt: new Date(),
        completedAt: new Date(),
        status: 'completed',
        itemsPulled: exercises.length + workouts.length + personalRecords.length,
      },
    });
    
    res.json({
      exercises,
      workouts,
      personalRecords,
      syncedAt: new Date().toISOString(),
    });
  } catch (error) {
    next(error);
  }
});

// GET /api/sync/status - Get sync status
syncRouter.get('/status', async (req, res, next) => {
  try {
    const userId = req.user!.userId;
    
    const [user, lastSync] = await Promise.all([
      prisma.user.findUnique({
        where: { id: userId },
        select: { lastSyncAt: true },
      }),
      prisma.syncLog.findFirst({
        where: { userId },
        orderBy: { startedAt: 'desc' },
      }),
    ]);
    
    res.json({
      lastSyncAt: user?.lastSyncAt,
      lastSyncLog: lastSync,
    });
  } catch (error) {
    next(error);
  }
});
