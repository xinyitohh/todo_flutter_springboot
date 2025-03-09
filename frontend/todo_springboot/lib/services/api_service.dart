import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/todos';

  // Fetch all todos
  static Future<List<Todo>> getTodos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => Todo.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  // Add a new todo
  static Future<Todo> createTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create todo');
    }
  }

  // Delete a todo
  static Future<void> deleteTodo(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete todo');
    }
  }

  // Update a todo (mark as completed or edit title)
static Future<Todo> updateTodo(Todo todo) async {
  final response = await http.put(
    Uri.parse('$baseUrl/${todo.id}'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(todo.toJson()),
  );

  if (response.statusCode == 200) {
    return Todo.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update todo');
  }
}

}
