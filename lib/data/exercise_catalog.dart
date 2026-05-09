import '../domain/models/exercise.dart';
import '../domain/models/muscle_group.dart';

/// Built-in catalog of common exercises. IDs use a stable slug so they survive
/// re-seeding without breaking references in saved sessions.
const List<Exercise> kBuiltInExercises = [
  // --- Chest
  Exercise(
    id: 'bench-press',
    name: 'Barbell Bench Press',
    primaryMuscle: MuscleGroup.chest,
    secondaryMuscles: [MuscleGroup.triceps, MuscleGroup.shoulders],
    equipment: Equipment.barbell,
  ),
  Exercise(
    id: 'incline-db-press',
    name: 'Incline Dumbbell Press',
    primaryMuscle: MuscleGroup.chest,
    secondaryMuscles: [MuscleGroup.shoulders, MuscleGroup.triceps],
    equipment: Equipment.dumbbell,
  ),
  Exercise(
    id: 'push-up',
    name: 'Push-Up',
    primaryMuscle: MuscleGroup.chest,
    secondaryMuscles: [MuscleGroup.triceps, MuscleGroup.core],
    equipment: Equipment.bodyweight,
  ),
  Exercise(
    id: 'cable-fly',
    name: 'Cable Fly',
    primaryMuscle: MuscleGroup.chest,
    equipment: Equipment.cable,
  ),

  // --- Back
  Exercise(
    id: 'pull-up',
    name: 'Pull-Up',
    primaryMuscle: MuscleGroup.back,
    secondaryMuscles: [MuscleGroup.biceps],
    equipment: Equipment.bodyweight,
  ),
  Exercise(
    id: 'lat-pulldown',
    name: 'Lat Pulldown',
    primaryMuscle: MuscleGroup.back,
    secondaryMuscles: [MuscleGroup.biceps],
    equipment: Equipment.cable,
  ),
  Exercise(
    id: 'bb-row',
    name: 'Barbell Row',
    primaryMuscle: MuscleGroup.back,
    secondaryMuscles: [MuscleGroup.biceps],
    equipment: Equipment.barbell,
  ),
  Exercise(
    id: 'db-row',
    name: 'Dumbbell Row',
    primaryMuscle: MuscleGroup.back,
    secondaryMuscles: [MuscleGroup.biceps],
    equipment: Equipment.dumbbell,
  ),
  Exercise(
    id: 'deadlift',
    name: 'Deadlift',
    primaryMuscle: MuscleGroup.back,
    secondaryMuscles: [MuscleGroup.hamstrings, MuscleGroup.glutes],
    equipment: Equipment.barbell,
  ),

  // --- Shoulders
  Exercise(
    id: 'ohp',
    name: 'Overhead Press',
    primaryMuscle: MuscleGroup.shoulders,
    secondaryMuscles: [MuscleGroup.triceps],
    equipment: Equipment.barbell,
  ),
  Exercise(
    id: 'lateral-raise',
    name: 'Lateral Raise',
    primaryMuscle: MuscleGroup.shoulders,
    equipment: Equipment.dumbbell,
  ),
  Exercise(
    id: 'face-pull',
    name: 'Face Pull',
    primaryMuscle: MuscleGroup.shoulders,
    secondaryMuscles: [MuscleGroup.back],
    equipment: Equipment.cable,
  ),

  // --- Arms
  Exercise(
    id: 'bb-curl',
    name: 'Barbell Curl',
    primaryMuscle: MuscleGroup.biceps,
    secondaryMuscles: [MuscleGroup.forearms],
    equipment: Equipment.barbell,
  ),
  Exercise(
    id: 'db-curl',
    name: 'Dumbbell Curl',
    primaryMuscle: MuscleGroup.biceps,
    secondaryMuscles: [MuscleGroup.forearms],
    equipment: Equipment.dumbbell,
  ),
  Exercise(
    id: 'hammer-curl',
    name: 'Hammer Curl',
    primaryMuscle: MuscleGroup.biceps,
    secondaryMuscles: [MuscleGroup.forearms],
    equipment: Equipment.dumbbell,
  ),
  Exercise(
    id: 'tricep-pushdown',
    name: 'Triceps Pushdown',
    primaryMuscle: MuscleGroup.triceps,
    equipment: Equipment.cable,
  ),
  Exercise(
    id: 'skull-crusher',
    name: 'Skull Crusher',
    primaryMuscle: MuscleGroup.triceps,
    equipment: Equipment.barbell,
  ),

  // --- Legs
  Exercise(
    id: 'back-squat',
    name: 'Back Squat',
    primaryMuscle: MuscleGroup.quads,
    secondaryMuscles: [MuscleGroup.glutes, MuscleGroup.hamstrings],
    equipment: Equipment.barbell,
  ),
  Exercise(
    id: 'front-squat',
    name: 'Front Squat',
    primaryMuscle: MuscleGroup.quads,
    secondaryMuscles: [MuscleGroup.glutes, MuscleGroup.core],
    equipment: Equipment.barbell,
  ),
  Exercise(
    id: 'leg-press',
    name: 'Leg Press',
    primaryMuscle: MuscleGroup.quads,
    secondaryMuscles: [MuscleGroup.glutes],
    equipment: Equipment.machine,
  ),
  Exercise(
    id: 'rdl',
    name: 'Romanian Deadlift',
    primaryMuscle: MuscleGroup.hamstrings,
    secondaryMuscles: [MuscleGroup.glutes],
    equipment: Equipment.barbell,
  ),
  Exercise(
    id: 'leg-curl',
    name: 'Leg Curl',
    primaryMuscle: MuscleGroup.hamstrings,
    equipment: Equipment.machine,
  ),
  Exercise(
    id: 'hip-thrust',
    name: 'Hip Thrust',
    primaryMuscle: MuscleGroup.glutes,
    secondaryMuscles: [MuscleGroup.hamstrings],
    equipment: Equipment.barbell,
  ),
  Exercise(
    id: 'calf-raise',
    name: 'Standing Calf Raise',
    primaryMuscle: MuscleGroup.calves,
    equipment: Equipment.machine,
  ),

  // --- Core
  Exercise(
    id: 'plank',
    name: 'Plank',
    primaryMuscle: MuscleGroup.core,
    equipment: Equipment.bodyweight,
  ),
  Exercise(
    id: 'hanging-leg-raise',
    name: 'Hanging Leg Raise',
    primaryMuscle: MuscleGroup.core,
    equipment: Equipment.bodyweight,
  ),
  Exercise(
    id: 'cable-crunch',
    name: 'Cable Crunch',
    primaryMuscle: MuscleGroup.core,
    equipment: Equipment.cable,
  ),

  // --- Cardio
  Exercise(
    id: 'run',
    name: 'Run',
    primaryMuscle: MuscleGroup.cardio,
    kind: ExerciseKind.cardio,
  ),
  Exercise(
    id: 'cycling',
    name: 'Cycling',
    primaryMuscle: MuscleGroup.cardio,
    kind: ExerciseKind.cardio,
  ),
  Exercise(
    id: 'rowing',
    name: 'Rowing',
    primaryMuscle: MuscleGroup.cardio,
    kind: ExerciseKind.cardio,
  ),
];
