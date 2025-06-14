import 'dart:convert';

class Task {
  final String title;
  final String content;
  bool isCompleted;

  Task({
    required this.title,
    required this.content,
    this.isCompleted = false,
  });

  @override
  String toString() {
    return 'Task(title: $title, content: $content)';
  }

  String toJson() => jsonEncode(
      {'title': title, 'content': content, 'isCompleted': isCompleted});

  factory Task.fromJson(String json) {
    final map = jsonDecode(json);
    return Task(
      title: map['title'],
      content: map['content'],
      isCompleted: map['isCompleted'],
    );
  }
}
