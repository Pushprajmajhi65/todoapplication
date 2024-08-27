import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<homePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String _elapsedTime = '00:00:00';
  String? _selectedTaskId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _updateTaskTime(String taskId, int timeTracked) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'timeTracked': timeTracked,
      });
      print('Task time updated successfully.');
    } catch (e) {
      print('Error updating task time: $e');
    }
  }

  void _startStopwatch(String taskId) {
    setState(() {
      _selectedTaskId = taskId;
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        setState(() {
          _elapsedTime = _formatTime(_stopwatch.elapsed.inSeconds);
        });
      });
    });
  }

  void _stopStopwatch() async {
    if (_selectedTaskId != null) {
      _stopwatch.stop();
      _timer?.cancel();
      final timeTracked = _stopwatch.elapsed.inSeconds;
      _stopwatch.reset();
      setState(() {
        _elapsedTime = '00:00:00';
      });
      await _updateTaskTime(_selectedTaskId!, timeTracked);
    }
  }

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.redAccent;
      case 'Medium':
        return Colors.orangeAccent;
      case 'Low':
        return Colors.lightGreen;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [
          // Task Summary Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('tasks')
                  .where('userId', isEqualTo: _auth.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final tasks = snapshot.data!.docs;
                final totalTasks = tasks.length;
                final pendingTasks = tasks.where((task) => !task['completed']).length;
                final ongoingTasks = tasks.where((task) => task['completed']).length;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _taskSummaryCard('Total Tasks', totalTasks, Color.fromARGB(255, 82, 62, 217)),
                      _taskSummaryCard('Pending Tasks', pendingTasks, Color.fromARGB(255, 105, 149, 2)),
                      _taskSummaryCard('Ongoing Tasks', ongoingTasks, Color.fromARGB(255, 15, 237, 245)),
                    ],
                  ),
                );
              },
            ),
          ),
          // Scrollable Row of Tasks Sorted by Priority (excluding completed tasks)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('tasks')
                  .where('userId', isEqualTo: _auth.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final tasks = snapshot.data!.docs;

                // Filter out completed tasks and sort by priority
                final filteredTasks = tasks.where((task) => !task['completed']).toList();
                filteredTasks.sort((a, b) {
                  final priorityA = a['priority'] ?? 'Low';
                  final priorityB = b['priority'] ?? 'Low';
                  final priorityOrder = {'High': 1, 'Medium': 2, 'Low': 3};

                  return priorityOrder[priorityA]!.compareTo(priorityOrder[priorityB]!);
                });

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Text(
                        'Tasks Sorted by Priority',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 200, // Adjust height as needed
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          final taskId = task.id;
                          final title = task['title'] ?? 'No Title';
                          final priority = task['priority'] ?? 'Low';
                          final timeTracked = task['timeTracked'] ?? 0;

                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Container(
                              width: 160, // Adjust width as needed
                              decoration: BoxDecoration(
                                color: _getPriorityColor(priority),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Time Tracked: ${_formatTime(timeTracked)}',
                                      style: const TextStyle(fontSize: 14, color: Colors.white),
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: _selectedTaskId == taskId
                                          ? _stopStopwatch
                                          : () => _startStopwatch(taskId),
                                      child: Text(_selectedTaskId == taskId
                                          ? 'Stop Tracking'
                                          : 'Start Tracking'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // List of Tasks
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('tasks')
                  .where('userId', isEqualTo: _auth.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final tasks = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final taskId = task.id;
                    final title = task['title'] ?? 'No Title';
                    final timeTracked = task['timeTracked'] ?? 0;
                    final isCompleted = task['completed'] ?? false;

                    return ListTile(
                      title: Text(title),
                      subtitle: Text('Time Tracked: ${_formatTime(timeTracked)}'),
                      trailing: !isCompleted
                          ? (_selectedTaskId == taskId
                              ? ElevatedButton(
                                  onPressed: _stopStopwatch,
                                  child: const Text('Stop Tracking'),
                                )
                              : ElevatedButton(
                                  onPressed: () => _startStopwatch(taskId),
                                  child: const Text('Start Tracking'),
                                ))
                          : null,
                    );
                  },
                );
              },
            ),
          ),
          // Stopwatch Display
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Elapsed Time: ',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  _elapsedTime,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskSummaryCard(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            count.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ],
      ),
    );
  }
}