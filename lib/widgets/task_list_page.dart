import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TaskListPage extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;
  final Function(int) onDeleteTask;
  final Function(int) onToggleTaskCompletion;

  const TaskListPage({
    Key? key,
    required this.tasks,
    required this.onDeleteTask,
    required this.onToggleTaskCompletion,
  }) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final TextEditingController _textController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("en-US"); // Set the default language
  }

  Future<void> _speak() async {
    if (_textController.text.isNotEmpty) {
      try {
        await _flutterTts.setLanguage("en-US");
        await _flutterTts.setSpeechRate(0.5); // Adjust speech rate if needed
        await _flutterTts.setVolume(1.0); // Set volume if needed
        await _flutterTts.speak(_textController.text);
      } catch (e) {
        // Handle any errors that occur during speaking
        print("Error speaking text: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: Column(
        children: [
          // Text-to-Speech section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Speak Text:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter text to speak...',
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _speak,
                  child: Text('Speak'),
                ),
              ],
            ),
          ),
          // Clock section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).colorScheme.errorContainer,
            child: Center(
              child: CircularClockWidget(),
            ),
          ),
          // Task list section
          Expanded(
            child: ListView.builder(
              itemCount: widget.tasks.length,
              itemBuilder: (context, index) {
                final task = widget.tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 4.0,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      task['name'] ?? 'No Name',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    subtitle: Text(
                      'Category: ${task['category'] ?? 'No Category'} - Duration: ${task['duration'] ?? 'No Duration'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.black),
                      onPressed: () => widget.onDeleteTask(index),
                    ),
                    onTap: () => widget.onToggleTaskCompletion(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CircularClockWidget extends StatefulWidget {
  @override
  _CircularClockWidgetState createState() => _CircularClockWidgetState();
}

class _CircularClockWidgetState extends State<CircularClockWidget> {
  late Timer _timer;
  String _timeString = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    final timeString = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    setState(() {
      _timeString = timeString;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.0,
      height: 120.0,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 4,
            blurRadius: 8,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: Text(
          _timeString,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}