import 'package:flutter/material.dart';
import '../data/workout_data.dart';

class CompletedWorkoutsScreen extends StatefulWidget {
  @override
  _CompletedWorkoutsScreenState createState() =>
      _CompletedWorkoutsScreenState();
}

class _CompletedWorkoutsScreenState extends State<CompletedWorkoutsScreen> {
  Map<String, int> _selectedMonths = {
    '1': 1,
    '3': 3,
    '6': 6,
    '12': 12,
  };
  String _selectedMonth = '1';

  Map<String, dynamic> _getStatistics() {
    final now = DateTime.now();
    final completedWorkouts = WorkoutData.completedWorkouts;

    // Filter workouts based on selected month range
    final monthRange = _selectedMonths[_selectedMonth]!;
    final startDate = DateTime(now.year, now.month - monthRange + 1, 1);

    final filteredWorkouts = completedWorkouts.where((day) {
      final workoutDate = _getDateFromDay(day);
      return workoutDate.isAfter(startDate) ||
          workoutDate.isAtSameMomentAs(startDate);
    }).toList();

    return {
      'total': completedWorkouts.length,
      'thisMonth': filteredWorkouts.length,
      'lastMonth': completedWorkouts.length - filteredWorkouts.length,
      'streak': _calculateStreak(completedWorkouts),
    };
  }

  DateTime _getDateFromDay(String dayName) {
    final now = DateTime.now();
    final weekday = _getWeekdayFromName(dayName);
    final daysToSubtract = now.weekday - weekday;
    return now.subtract(Duration(days: daysToSubtract));
  }

  int _getWeekdayFromName(String dayName) {
    switch (dayName) {
      case 'Monday':
        return 1;
      case 'Tuesday':
        return 2;
      case 'Wednesday':
        return 3;
      case 'Thursday':
        return 4;
      case 'Friday':
        return 5;
      case 'Saturday':
        return 6;
      case 'Sunday':
        return 7;
      default:
        return 0;
    }
  }

  int _calculateStreak(List<String> workouts) {
    if (workouts.isEmpty) return 0;

    final now = DateTime.now();
    final sortedDates = workouts.map((day) => _getDateFromDay(day)).toList()
      ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime currentDate = now;

    for (var date in sortedDates) {
      if (date.isAtSameMomentAs(currentDate) ||
          date.isAtSameMomentAs(currentDate.subtract(Duration(days: 1)))) {
        streak++;
        currentDate = date;
      } else {
        break;
      }
    }

    return streak;
  }

  @override
  Widget build(BuildContext context) {
    final stats = _getStatistics();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Completed Workouts',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                DropdownButton<String>(
                  value: _selectedMonth,
                  items: _selectedMonths.keys.map((String key) {
                    return DropdownMenuItem<String>(
                      value: key,
                      child: Text('$key Month${key != '1' ? 's' : ''}'),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedMonth = newValue;
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildStatCard(
                  'Total Completed',
                  stats['total'].toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildStatCard(
                  'This Period',
                  stats['thisMonth'].toString(),
                  Icons.calendar_today,
                  Colors.blue,
                ),
                _buildStatCard(
                  'Last Period',
                  stats['lastMonth'].toString(),
                  Icons.history,
                  Colors.orange,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_fire_department,
                              color: Colors.white, size: 24),
                          SizedBox(width: 8),
                          Text(
                            '${stats['streak']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Day Streak',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: WorkoutData.completedWorkouts.length,
              itemBuilder: (context, index) {
                final day = WorkoutData.completedWorkouts[index];
                final workoutDate = _getDateFromDay(day);
                return Card(
                  margin: EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(
                      day,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '${workoutDate.day}/${workoutDate.month}/${workoutDate.year}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Workout'),
                            content: Text(
                                'Are you sure you want to delete this completed workout?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text('Delete',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await WorkoutData.deleteCompletedWorkout(day);
                          setState(() {});
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      width: (MediaQuery.of(context).size.width - 48) / 2,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              SizedBox(width: 8),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            title,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
