import 'package:flutter/material.dart';
import 'models/todo_model.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoScreen(),
    );
  }
}

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Todo> todos = [];
  TextEditingController _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  // Fetch Todos from API
  void fetchTodos() async {
    try {
      List<Todo> fetchedTodos = await ApiService.getTodos();
      setState(() {
        todos = fetchedTodos;
      });
    } catch (e) {
      print("Error fetching todos: $e");
    }
  }

  // Add Todo
  void addTodo() async {
    if (_todoController.text.isEmpty) return;
    Todo newTodo = Todo(title: _todoController.text, completed: false);
    try {
      Todo createdTodo = await ApiService.createTodo(newTodo);
      setState(() {
        todos.add(createdTodo);
      });
      _todoController.clear();
    } catch (e) {
      print("Error adding todo: $e");
    }
  }

  // Toggle Completion
  void toggleTodoCompletion(Todo todo) async {
    Todo updatedTodo = Todo(
      id: todo.id,
      title: todo.title,
      completed: !todo.completed, // Toggle status
    );

    try {
      await ApiService.updateTodo(updatedTodo);
      setState(() {
        todo.completed = !todo.completed; // Update UI
      });
    } catch (e) {
      print("Error updating todo: $e");
    }
  }

  // Edit Todo Title
  void editTodo(Todo todo) {
    TextEditingController editController =
        TextEditingController(text: todo.title);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Todo"),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "New Title",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (editController.text.isEmpty) return;

                Todo updatedTodo = Todo(
                  id: todo.id,
                  title: editController.text,
                  completed: todo.completed,
                );

                try {
                  await ApiService.updateTodo(updatedTodo);
                  setState(() {
                    todo.title = editController.text; // Update UI
                  });
                  Navigator.pop(context);
                } catch (e) {
                  print("Error updating todo: $e");
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Delete Todo
  void deleteTodo(int id) async {
    try {
      await ApiService.deleteTodo(id);
      setState(() {
        todos.removeWhere((todo) => todo.id == id);
      });
    } catch (e) {
      print("Error deleting todo: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todo App")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      labelText: "Enter Todo",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addTodo,
                  child: Text("Add"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: todos[index].completed,
                    onChanged: (value) => toggleTodoCompletion(todos[index]),
                  ),
                  title: GestureDetector(
                    onTap: () => editTodo(todos[index]),
                    child: Text(
                      todos[index].title,
                      style: TextStyle(
                        decoration: todos[index].completed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteTodo(todos[index].id!),
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
