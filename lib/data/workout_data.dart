import 'package:shared_preferences/shared_preferences.dart';

class WorkoutData {
  static List<List<String>> workoutTable = [
    ['Day', 'Workout Focus', 'Exercises'],
    [
      'Monday',
      'Upper Body Strength & Size',
      'Diamond Push-Ups (3x12) → Decline Push-Ups (3x15) → Dumbbell Curls (3x12) → Lateral Raises (3x12) → Sideways Bent Dumbbell Lifts (3x12) → Forearm Curls (Till Failure+1)'
    ],
    [
      'Tuesday',
      'Legs & Core',
      'Squats (3x15) → Lunges (3x12 each leg) → Calf Raises (3x20) → Planks (2x1 min) → Leg Raises (3x15) → Russian Twists (3x20)'
    ],
    [
      'Wednesday',
      'Upper Body Endurance & Shoulders',
      'Regular Push-Ups (3x20) → Lateral Raises (Till Failure) → Dumbbell Stand Raises (3x12) → Sideways Bent Dumbbell Lifts (3x12) → Forearm Curls (3x12)'
    ],
    [
      'Thursday',
      'Rest & Recovery',
      'Light Stretching → Hydration → Mobility Drills (shoulder & hip openers)'
    ],
    [
      'Friday',
      'Upper Body Power & Hypertrophy',
      'Diamond Push-Ups (3x12) → Decline Push-Ups (3x15) → Dumbbell Curls (3x12) → Lateral Raises (3x12) → Sideways Bent Dumbbell Lifts (3x12) → Forearm Curls (Till Failure+1)'
    ],
    [
      'Saturday',
      'Legs & Core',
      'Squats (3x15) → Lunges (3x12 each leg) → Calf Raises (3x20) → Planks (2x1 min) → Russian Twists (3x20)'
    ],
    [
      'Sunday',
      'Active Recovery or Rest',
      'Light Stretching → Walking → Yoga → Foam Rolling'
    ],
  ];

  static List<List<String>> mealTable = [
    ['Day', 'Workout Type', 'Post-Workout Meal'],
    [
      'Monday',
      'Upper Body Strength & Size',
      '✅ 2 Fried Eggs 🍳 → ✅ 2-3 tbsp Peanut Butter 🥜 → ✅ 1 Banana 🍌 → ✅ Whole Wheat Bread 🍞 → ✅ Mosambi Juice 🍊'
    ],
    [
      'Tuesday',
      'Legs & Core',
      '✅ Oats with Milk & Honey 🥣 → ✅ 5 Cashews + 5 Pistachios 🥜 → ✅ 1 Boiled Egg 🥚 → ✅ 1 Mosambi Juice 🍊'
    ],
    [
      'Wednesday',
      'Upper Body Endurance & Shoulders',
      '✅ 2 Boiled Eggs 🥚 → ✅ Peanut Butter Toast 🥜 → ✅ 1 Glass Milk 🥛 → ✅ Banana 🍌'
    ],
    [
      'Thursday',
      'Rest & Recovery',
      '✅ Light Meal: Curd & Fruits 🍓🍎 → ✅ 5-10 Almonds 🥜 → ✅ Hydration with Lemon Water 🍋'
    ],
    [
      'Friday',
      'Upper Body Power & Hypertrophy',
      '✅ 2 Fried Eggs 🍳 → ✅ 2-3 tbsp Peanut Butter 🥜 → ✅ French Fries 🍟 → ✅ Whole Wheat Bread 🍞 → ✅ Mosambi Juice 🍊'
    ],
    [
      'Saturday',
      'Legs & Core',
      '✅ Oats with Milk & Honey 🥣 → ✅ 5 Cashews + 5 Pistachios 🥜 → ✅ 1 Boiled Egg 🥚 → ✅ 1 Mosambi Juice 🍊'
    ],
    [
      'Sunday',
      'Active Recovery or Rest',
      '✅ Light Meal: Curd & Fruits 🍓🍎 → ✅ 5-10 Almonds 🥜 → ✅ Hydration with Lemon Water 🍋'
    ],
  ];

  static List<String> completedWorkouts = [];
  static const String _completedWorkoutsKey = 'completed_workouts';

  // Initialize completed workouts from storage
  static Future<void> initializeCompletedWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    completedWorkouts = prefs.getStringList(_completedWorkoutsKey) ?? [];
  }

  // Save completed workouts to storage
  static Future<void> _saveCompletedWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_completedWorkoutsKey, completedWorkouts);
  }

  static Map<String, Map<String, String>> getWorkoutForDay(String day) {
    int dayIndex = workoutTable.indexWhere((row) => row[0] == day);
    if (dayIndex == -1) return {};

    return {
      'workout': {
        'focus': workoutTable[dayIndex][1],
        'exercises': workoutTable[dayIndex][2],
      },
      'meal': {
        'type': mealTable[dayIndex][1],
        'plan': mealTable[dayIndex][2],
      },
    };
  }

  static void updateWorkoutDay(String day, String focus, String exercises) {
    int dayIndex = workoutTable.indexWhere((row) => row[0] == day);
    if (dayIndex != -1) {
      workoutTable[dayIndex][1] = focus;
      workoutTable[dayIndex][2] = exercises;
    }
  }

  static void updateMealDay(String day, String type, String meal) {
    int dayIndex = mealTable.indexWhere((row) => row[0] == day);
    if (dayIndex != -1) {
      mealTable[dayIndex][1] = type;
      mealTable[dayIndex][2] = meal;
    }
  }

  static bool isWorkoutCompleted(String dayName) {
    return completedWorkouts.contains(dayName);
  }

  static Future<void> toggleWorkoutCompletion(String dayName) async {
    if (completedWorkouts.contains(dayName)) {
      completedWorkouts.remove(dayName);
    } else {
      completedWorkouts.add(dayName);
    }
    await _saveCompletedWorkouts();
  }

  static Future<void> deleteCompletedWorkout(String dayName) async {
    completedWorkouts.remove(dayName);
    await _saveCompletedWorkouts();
  }

  static Future<void> clearAllCompletedWorkouts() async {
    completedWorkouts.clear();
    await _saveCompletedWorkouts();
  }
}
