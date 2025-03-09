class Todo {
  int? id;
  String title;
  bool completed;

  Todo({this.id, required this.title, required this.completed});

  // Convert JSON to Todo object
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  // Convert Todo object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}
