import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'stopwatch_page.dart';
import 'calendar_page.dart';
import 'task_list_page.dart';

class TodoPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeToggle;

  const TodoPage({super.key, required this.isDarkMode, required this.onThemeToggle});

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<String> _categories = [
    'Final Year Project',
    'Work at Ztudioo',
    'Self-Learning Homework',
    'Workout',
    'Other'
  ];
  String _selectedCategory = 'Work at Ztudioo';
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  String _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  DateTime _selectedCalendarDate = DateTime.now();

  List<Map<String, dynamic>> _tasks = [];

  void _fetchTasks() async {
    // Fetch tasks from your API here
  }

  void _addTask() async {
    if (_taskController.text.isNotEmpty) {
      // Add task to API here
      _fetchTasks(); // Refresh task list
    } else {
      print('Task text is empty');
    }
    _taskController.clear();
    _descriptionController.clear();
    _durationController.clear();
  }

  void _deleteTask(int index) async {
    // Delete task from API here
    _fetchTasks(); // Refresh task list
  }

  void _toggleTaskCompletion(int index) async {
    // Toggle task completion in API here
    _fetchTasks(); // Refresh task list
  }

  void _toggleTheme() {
    setState(() {
      widget.onThemeToggle(!widget.isDarkMode);
    });
  }

  void _showAddTaskDialog() {
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
                controller: _taskController,
                decoration: InputDecoration(
                  hintText: 'Enter task name',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Enter task description',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              DropdownButton<String>(
                value: _selectedCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category, style: Theme.of(context).textTheme.bodyLarge),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate =
                        DateFormat('yyyy-MM-dd').format(_selectedCalendarDate);
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text('Selected Date: $_selectedDate',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _durationController,
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
                _addTask();
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
        title: const Text('To-Do List'),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          ToggleButtons(
            isSelected: [!widget.isDarkMode, widget.isDarkMode],
            onPressed: (index) {
              if (index == 0 && widget.isDarkMode) {
                _toggleTheme();
              } else if (index == 1 && !widget.isDarkMode) {
                _toggleTheme();
              }
            },
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Light',
                    style: TextStyle(
                        color: !widget.isDarkMode
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).textTheme.bodyMedium?.color)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Dark',
                    style: TextStyle(
                        color: widget.isDarkMode
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).textTheme.bodyMedium?.color)),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _showAddTaskDialog,
              child: const Text('Add Task'),
              style: ElevatedButton.styleFrom(
                foregroundColor:
                    Theme.of(context).textTheme.labelLarge?.color,
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            StopwatchPage(),
            const SizedBox(height: 20),
            CalendarPage(
              selectedCalendarDate: _selectedCalendarDate,
              onDateSelected: (DateTime selectedDay) {
                setState(() {
                  _selectedCalendarDate = selectedDay;
                  _selectedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TaskListPage(
                tasks: _tasks,
                onDeleteTask: (index) => _deleteTask(index),
                onToggleTaskCompletion: (index) => _toggleTaskCompletion(index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}