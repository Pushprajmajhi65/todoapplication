import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiUrl = 'http://10.0.2.2:8000/api/todos/'; // Use this for Android Emulator

class ApiService {
  final String baseUrl = apiUrl;

  Future<List<dynamic>> fetchTodos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load todos. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load todos');
      }
    } catch (e) {
      print('Exception occurred while fetching todos: $e');
      throw Exception('Failed to load todos');
    }
  }

  Future<void> addTodo({
    required String title,
    required String description,
    required String category,
    required String duration,
    required String date,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': title,
          'description': description,
          'category': category,
          'duration': duration,
          'date': date,
          'completed': false,
        }),
      );

      if (response.statusCode == 201) {
        print('Task added successfully');
      } else {
        print('Failed to add task. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to add todo');
      }
    } catch (e) {
      print('Exception occurred while adding todo: $e');
      throw Exception('Failed to add todo');
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl$id/'));

      if (response.statusCode == 204) {
        print('Task deleted successfully');
      } else {
        print('Failed to delete task. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to delete todo');
      }
    } catch (e) {
      print('Exception occurred while deleting todo: $e');
      throw Exception('Failed to delete todo');
    }
  }

  Future<void> updateTodo({
    required int id,
    bool? completed,
    String? title,
    String? description,
    String? category,
    String? duration,
    String? date,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl$id/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          if (completed != null) 'completed': completed,
          if (title != null) 'title': title,
          if (description != null) 'description': description,
          if (category != null) 'category': category,
          if (duration != null) 'duration': duration,
          if (date != null) 'date': date,
        }),
      );

      if (response.statusCode == 200) {
        print('Task updated successfully: ${response.body}');
      } else {
        print('Failed to update task. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to update todo');
      }
    } catch (e) {
      print('Exception occurred while updating todo: $e');
      throw Exception('Failed to update todo');
    }
  }
}