import { PrismaClient, MuscleGroup } from '@prisma/client';

const prisma = new PrismaClient();

// System exercises - same as Flutter app
const systemExercises = [
  // Chest
  { name: 'Barbell Bench Press', primaryMuscle: MuscleGroup.CHEST, secondaryMuscles: [MuscleGroup.TRICEPS, MuscleGroup.SHOULDERS], isCompound: true },
  { name: 'Incline Dumbbell Press', primaryMuscle: MuscleGroup.CHEST, secondaryMuscles: [MuscleGroup.TRICEPS, MuscleGroup.SHOULDERS], isCompound: true },
  { name: 'Cable Flyes', primaryMuscle: MuscleGroup.CHEST, secondaryMuscles: [], isCompound: false },
  { name: 'Push-ups', primaryMuscle: MuscleGroup.CHEST, secondaryMuscles: [MuscleGroup.TRICEPS, MuscleGroup.SHOULDERS], isCompound: true },
  { name: 'Dumbbell Flyes', primaryMuscle: MuscleGroup.CHEST, secondaryMuscles: [], isCompound: false },
  
  // Back
  { name: 'Deadlift', primaryMuscle: MuscleGroup.BACK, secondaryMuscles: [MuscleGroup.HAMSTRINGS, MuscleGroup.GLUTES, MuscleGroup.LOWER_BACK], isCompound: true },
  { name: 'Pull-ups', primaryMuscle: MuscleGroup.LATS, secondaryMuscles: [MuscleGroup.BICEPS, MuscleGroup.BACK], isCompound: true },
  { name: 'Barbell Rows', primaryMuscle: MuscleGroup.BACK, secondaryMuscles: [MuscleGroup.BICEPS, MuscleGroup.LATS], isCompound: true },
  { name: 'Lat Pulldown', primaryMuscle: MuscleGroup.LATS, secondaryMuscles: [MuscleGroup.BICEPS], isCompound: true },
  { name: 'Seated Cable Row', primaryMuscle: MuscleGroup.BACK, secondaryMuscles: [MuscleGroup.BICEPS, MuscleGroup.LATS], isCompound: true },
  { name: 'T-Bar Row', primaryMuscle: MuscleGroup.BACK, secondaryMuscles: [MuscleGroup.BICEPS, MuscleGroup.LATS], isCompound: true },
  
  // Shoulders
  { name: 'Overhead Press', primaryMuscle: MuscleGroup.SHOULDERS, secondaryMuscles: [MuscleGroup.TRICEPS], isCompound: true },
  { name: 'Lateral Raises', primaryMuscle: MuscleGroup.SHOULDERS, secondaryMuscles: [], isCompound: false },
  { name: 'Front Raises', primaryMuscle: MuscleGroup.SHOULDERS, secondaryMuscles: [], isCompound: false },
  { name: 'Face Pulls', primaryMuscle: MuscleGroup.SHOULDERS, secondaryMuscles: [MuscleGroup.TRAPS], isCompound: false },
  { name: 'Arnold Press', primaryMuscle: MuscleGroup.SHOULDERS, secondaryMuscles: [MuscleGroup.TRICEPS], isCompound: true },
  { name: 'Reverse Flyes', primaryMuscle: MuscleGroup.SHOULDERS, secondaryMuscles: [MuscleGroup.BACK], isCompound: false },
  
  // Biceps
  { name: 'Barbell Curl', primaryMuscle: MuscleGroup.BICEPS, secondaryMuscles: [MuscleGroup.FOREARMS], isCompound: false },
  { name: 'Dumbbell Curl', primaryMuscle: MuscleGroup.BICEPS, secondaryMuscles: [MuscleGroup.FOREARMS], isCompound: false },
  { name: 'Hammer Curl', primaryMuscle: MuscleGroup.BICEPS, secondaryMuscles: [MuscleGroup.FOREARMS], isCompound: false },
  { name: 'Preacher Curl', primaryMuscle: MuscleGroup.BICEPS, secondaryMuscles: [], isCompound: false },
  { name: 'Concentration Curl', primaryMuscle: MuscleGroup.BICEPS, secondaryMuscles: [], isCompound: false },
  
  // Triceps
  { name: 'Tricep Pushdown', primaryMuscle: MuscleGroup.TRICEPS, secondaryMuscles: [], isCompound: false },
  { name: 'Skull Crushers', primaryMuscle: MuscleGroup.TRICEPS, secondaryMuscles: [], isCompound: false },
  { name: 'Overhead Tricep Extension', primaryMuscle: MuscleGroup.TRICEPS, secondaryMuscles: [], isCompound: false },
  { name: 'Close Grip Bench Press', primaryMuscle: MuscleGroup.TRICEPS, secondaryMuscles: [MuscleGroup.CHEST], isCompound: true },
  { name: 'Dips', primaryMuscle: MuscleGroup.TRICEPS, secondaryMuscles: [MuscleGroup.CHEST, MuscleGroup.SHOULDERS], isCompound: true },
  
  // Legs
  { name: 'Barbell Squat', primaryMuscle: MuscleGroup.QUADS, secondaryMuscles: [MuscleGroup.GLUTES, MuscleGroup.HAMSTRINGS], isCompound: true },
  { name: 'Leg Press', primaryMuscle: MuscleGroup.QUADS, secondaryMuscles: [MuscleGroup.GLUTES, MuscleGroup.HAMSTRINGS], isCompound: true },
  { name: 'Romanian Deadlift', primaryMuscle: MuscleGroup.HAMSTRINGS, secondaryMuscles: [MuscleGroup.GLUTES, MuscleGroup.LOWER_BACK], isCompound: true },
  { name: 'Leg Curl', primaryMuscle: MuscleGroup.HAMSTRINGS, secondaryMuscles: [], isCompound: false },
  { name: 'Leg Extension', primaryMuscle: MuscleGroup.QUADS, secondaryMuscles: [], isCompound: false },
  { name: 'Lunges', primaryMuscle: MuscleGroup.QUADS, secondaryMuscles: [MuscleGroup.GLUTES, MuscleGroup.HAMSTRINGS], isCompound: true },
  { name: 'Bulgarian Split Squat', primaryMuscle: MuscleGroup.QUADS, secondaryMuscles: [MuscleGroup.GLUTES], isCompound: true },
  { name: 'Hip Thrust', primaryMuscle: MuscleGroup.GLUTES, secondaryMuscles: [MuscleGroup.HAMSTRINGS], isCompound: true },
  { name: 'Calf Raises', primaryMuscle: MuscleGroup.CALVES, secondaryMuscles: [], isCompound: false },
  
  // Abs
  { name: 'Plank', primaryMuscle: MuscleGroup.ABS, secondaryMuscles: [MuscleGroup.OBLIQUES], isCompound: false },
  { name: 'Crunches', primaryMuscle: MuscleGroup.ABS, secondaryMuscles: [], isCompound: false },
  { name: 'Hanging Leg Raise', primaryMuscle: MuscleGroup.ABS, secondaryMuscles: [MuscleGroup.OBLIQUES], isCompound: false },
  { name: 'Cable Woodchop', primaryMuscle: MuscleGroup.OBLIQUES, secondaryMuscles: [MuscleGroup.ABS], isCompound: false },
  { name: 'Ab Wheel Rollout', primaryMuscle: MuscleGroup.ABS, secondaryMuscles: [MuscleGroup.OBLIQUES], isCompound: false },
];

async function main() {
  console.log('🌱 Seeding database...');
  
  // Create system exercises (no userId = system exercise)
  for (const exercise of systemExercises) {
    await prisma.exercise.upsert({
      where: {
        // Use a composite check since we don't have unique on name
        clientId: `system-${exercise.name.toLowerCase().replace(/\s+/g, '-')}`,
      },
      update: {
        name: exercise.name,
        primaryMuscle: exercise.primaryMuscle,
        secondaryMuscles: exercise.secondaryMuscles,
        isCompound: exercise.isCompound,
      },
      create: {
        clientId: `system-${exercise.name.toLowerCase().replace(/\s+/g, '-')}`,
        name: exercise.name,
        primaryMuscle: exercise.primaryMuscle,
        secondaryMuscles: exercise.secondaryMuscles,
        isCompound: exercise.isCompound,
        isCustom: false,
        userId: null,
      },
    });
  }
  
  console.log(`✅ Seeded ${systemExercises.length} system exercises`);
}

main()
  .catch((e) => {
    console.error('❌ Seed error:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
