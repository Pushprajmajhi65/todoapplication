import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _stopwatchTimer;
  final List<Map<String, String>> _trackedTasks = [
    {'title': 'Task 1', 'time': '1h 30m'},
    {'title': 'Task 2', 'time': '45m'},
    {'title': 'Task 3', 'time': '2h 15m'},
  ];


  List<Map<String, String>> _filteredTasks = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredTasks = _trackedTasks; // Initialize with all tasks
    _startStopwatchTimer();
    _searchController.addListener(_filterTasks);
  }

  @override
  void dispose() {
    _stopwatchTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _startStopwatchTimer() {
    _stopwatchTimer =
        Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      if (_stopwatch.isRunning) {
        setState(() {}); // Update UI
      }
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${duration.inHours}h ${minutes}m ${seconds}s';
  }

  void _filterTasks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTasks = _trackedTasks.where((task) {
        final title = task['title']?.toLowerCase() ?? '';
        final time = task['time']?.toLowerCase() ?? '';
        return title.contains(query) || time.contains(query);
      }).toList();
    });
  }

  void _showEditTaskDialog(int index) {
    final task = _trackedTasks[index];
    final TextEditingController _titleController =
        TextEditingController(text: task['title']);
    final TextEditingController _timeController =
        TextEditingController(text: task['time']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Enter task title',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _timeController,
                decoration: InputDecoration(
                  hintText: 'Enter time duration (e.g., 1h 30m)',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () {
                setState(() {
                  _trackedTasks[index] = {
                    'title': _titleController.text,
                    'time': _timeController.text,
                  };
                  _filterTasks(); // Reapply filter after updating
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(int index) {
    setState(() {
      _trackedTasks.removeAt(index);
      _filterTasks(); // Reapply filter after deleting
    });
  }

  void _showAddTaskDialog() {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Enter task title',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _timeController,
                decoration: InputDecoration(
                  hintText: 'Enter time duration (e.g., 1h 30m)',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Add"),
              onPressed: () {
                setState(() {
                  _trackedTasks.add({
                    'title': _titleController.text,
                    'time': _timeController.text,
                  });
                  _filterTasks(); // Reapply filter after adding
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stopwatch'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Stopwatch controls
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_stopwatch.isRunning) {
                            _stopwatch.stop();
                          } else {
                            _stopwatch.start();
                          }
                        });
                      },
                      child: Text(_stopwatch.isRunning ? 'Stop' : 'Start'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).textTheme.labelLarge?.color,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _stopwatch.reset();
                        });
                      },
                      child: const Text('Reset'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).textTheme.labelLarge?.color,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _showAddTaskDialog,
                      child: const Text('Add Task'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).textTheme.labelLarge?.color,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _formatDuration(_stopwatch.elapsed),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Search section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Tasks',
                  prefixIcon:
                      Icon(Icons.search, color: Theme.of(context).primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            // List of previously tracked tasks


            
            Expanded(
              child: ListView.builder(
                itemCount: _filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = _filteredTasks[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      title: Text(task['title'] ?? 'No Title',
                          style: Theme.of(context).textTheme.bodyLarge),
                      subtitle: Text('Time Tracked: ${task['time']}',
                          style: Theme.of(context).textTheme.bodyMedium),
                      leading: Icon(Icons.history,
                          color: Theme.of(context).primaryColor),
                      tileColor: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: Theme.of(context).primaryColor),
                            onPressed: () => _showEditTaskDialog(
                                _trackedTasks.indexOf(task)),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete,
                                color: Theme.of(context).focusColor),
                            onPressed: () =>
                                _deleteTask(_trackedTasks.indexOf(task)),
                          ),
                        ],

                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class Task {
  String title;
  String time;
  DateTime deadline;
  DateTime startTime;
  String duration;
  String priority;
  bool isComplete;

  Task({
    required this.title,
    required this.time,
    required this.deadline,
    required this.startTime,
    required this.duration,
    required this.priority,
    this.isComplete = false,
  });
}