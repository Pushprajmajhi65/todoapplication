import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiUrl = 'http://127.0.0.1:8000/api/todos/';

class ApiService {
  Future<List<dynamic>> fetchTodos() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> addTodo(String title) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'completed': false}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add todo');
    }
  }

  Future<void> deleteTodo(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl$id/'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete todo');
    }
  }

  Future<void> updateTodo(int id, bool completed) async {
    final response = await http.patch(
      Uri.parse('$apiUrl$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'completed': completed}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update todo');
    }
  }
}