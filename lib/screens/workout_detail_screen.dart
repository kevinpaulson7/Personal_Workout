import 'package:flutter/material.dart';
import '../data/workout_data.dart';

class WorkoutDetailScreen extends StatefulWidget {
  @override
  _WorkoutDetailScreenState createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  bool _isEditing = false;

  void _showEditDialog(String day, String currentFocus, String currentExercises,
      String currentType, String currentMeal) {
    final focusController = TextEditingController(text: currentFocus);
    final exercisesController = TextEditingController(text: currentExercises);
    final typeController = TextEditingController(text: currentType);
    final mealController = TextEditingController(text: currentMeal);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $day Plan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: focusController,
                decoration: InputDecoration(labelText: 'Workout Focus'),
              ),
              TextField(
                controller: exercisesController,
                decoration: InputDecoration(labelText: 'Exercises'),
                maxLines: 3,
              ),
              TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: 'Workout Type'),
              ),
              TextField(
                controller: mealController,
                decoration: InputDecoration(labelText: 'Post-Workout Meal'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              WorkoutData.updateWorkoutDay(
                  day, focusController.text, exercisesController.text);
              WorkoutData.updateMealDay(
                  day, typeController.text, mealController.text);
              setState(() {});
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTableSection('Workout Schedule', WorkoutData.workoutTable),
            const SizedBox(height: 20),
            _buildTableSection('Post-Workout Meal Plan', WorkoutData.mealTable),
          ],
        ),
      ),
    );
  }

  Widget _buildTableSection(String title, List<List<String>> tableData) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 10,
              dataRowHeight: 50,
              headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.transparent),
              columns: tableData[0]
                  .map((header) => DataColumn(
                        label: Text(header,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                      ))
                  .toList(),
              rows: tableData.sublist(1).map((row) {
                return DataRow(
                  cells: row
                      .map((cell) => DataCell(Text(cell,
                          maxLines: 2, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onSelectChanged: _isEditing
                      ? (bool? selected) {
                          if (selected == true) {
                            _showEditDialog(
                              row[0],
                              row[1],
                              row[2],
                              WorkoutData.mealTable[WorkoutData.mealTable
                                  .indexWhere(
                                      (mealRow) => mealRow[0] == row[0])][1],
                              WorkoutData.mealTable[WorkoutData.mealTable
                                  .indexWhere(
                                      (mealRow) => mealRow[0] == row[0])][2],
                            );
                          }
                        }
                      : null,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
