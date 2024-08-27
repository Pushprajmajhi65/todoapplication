import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskPage extends StatefulWidget {
  final DocumentSnapshot? task;

  const TaskPage({Key? key, this.task}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  String _selectedPriority = 'Medium'; // Default priority
  String _selectedCategory = 'Work'; // Default category

  final List<String> _priorityOptions = ['Low', 'Medium', 'High'];
  final List<String> _categoryOptions = ['Work', 'Personal', 'Study', 'Other'];

  Future<void> _addTask() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    try {
      await _firestore.collection('tasks').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'completed': false,
        'timestamp': Timestamp.now(),
        'userId': _auth.currentUser?.uid,
        'dueDate': Timestamp.fromDate(DateTime.parse(_dueDateController.text)),
        'priority': _selectedPriority,
        'category': _selectedCategory,
        'timeTracked': 0, // Initialize timeTracked to 0
      });

      _titleController.clear();
      _descriptionController.clear();
      _dueDateController.clear();
      setState(() {
        _selectedPriority = 'Medium'; // Reset to default
        _selectedCategory = 'Work'; // Reset to default
      });
    } catch (e) {
      print('Error adding task: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add task')),
      );
    }
  }

  void _deleteTask(String taskId) {
    _firestore.collection('tasks').doc(taskId).delete();
  }

  Future<void> _showDeleteConfirmationDialog(String taskId) async {
    final theme = Theme.of(context);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task', style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this task?', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Delete'),
              style: ElevatedButton.styleFrom(iconColor: Colors.red),
              onPressed: () {
                _deleteTask(taskId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleTaskCompletion(DocumentSnapshot document) {
    _firestore.collection('tasks').doc(document.id).update({
      'completed': !document['completed'],
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      
       
      body: Column(
        children: [
          Text(
            "Your task list",
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: theme.textTheme.bodyLarge?.color),
          ),
          // Task List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('tasks')
                  .where('userId', isEqualTo: _auth.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final tasks = snapshot.data!.docs;

                if (tasks.isEmpty) {
                  return Center(child: Text('No tasks available.', style: TextStyle(color: theme.textTheme.bodyMedium?.color)));
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return ListTile(
                      title: Text(task['title'], style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
                      subtitle: Text(task['description'] ?? '', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              task['completed'] ? Icons.check_box : Icons.check_box_outline_blank,
                              color: task['completed'] ? Colors.green : Colors.grey,
                            ),
                            onPressed: () => _toggleTaskCompletion(task),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteConfirmationDialog(task.id),
                          ),
                        ],
                      ),
                      onTap: () {
                        _toggleTaskCompletion(task);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog();
        },
        backgroundColor: theme.primaryColor,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text('Add Task', style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.primaryColor),
                    ),
                  ),
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.primaryColor),
                    ),
                  ),
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                ),
                TextFormField(
                  controller: _dueDateController,
                  decoration: InputDecoration(
                    labelText: 'Due Date (YYYY-MM-DD)',
                    labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.primaryColor),
                    ),
                  ),
                  readOnly: true,
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null) {
                      String formattedDate = "${pickedDate.toLocal()}".split(' ')[0];
                      setState(() {
                        _dueDateController.text = formattedDate;
                      });
                    }
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.primaryColor),
                    ),
                  ),
                  items: _priorityOptions.map((String priority) {
                    return DropdownMenuItem<String>(
                      value: priority,
                      child: Text(priority, style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPriority = newValue!;
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.primaryColor),
                    ),
                  ),
                  items: _categoryOptions.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category, style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Add'),
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
}