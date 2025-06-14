import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/classes/task.dart';

class MainProvider extends ChangeNotifier {
  TextEditingController titleText = TextEditingController();
  TextEditingController contentText = TextEditingController();
  List<Task> todoList = [];

  Future<void> addTodo({Function(Task)? onAdded}) async {
    // FocusScope.of(context).unfocus();
    final titleInput = titleText.text.trim();
    final contentInput = contentText.text.trim();

    if (titleInput.isEmpty) {
      throw Exception('Task Input Empty');
    }
    if (todoList
        .any((task) => task.title.toLowerCase() == titleInput.toLowerCase())) {
      throw Exception('Task Already Exist');
    }

    final newTask = Task(title: titleInput, content: contentInput);
    print(todoList);
    todoList.insert(0, newTask);
    print(todoList);
    await updateLocalData();
    notifyListeners();
    onAdded?.call(newTask);
  }

  Future<void> removeTodo(Task task) async {
    todoList.remove(task);
    await updateLocalData();
    notifyListeners();
  }

  String capitalizeFirstLetter(String input) =>
      input.isEmpty ? input : '${input[0].toUpperCase()}${input.substring(1)}';

  Future<void> updateLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'todoList',
      todoList.map((task) => task.toJson()).toList(),
    );
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final taskString = prefs.getStringList('todoList') ?? [];

    todoList.clear();
    todoList =
        taskString.map((jsonString) => Task.fromJson(jsonString)).toList();
    notifyListeners();
  }

  @override
  void dispose() {
    titleText.clear();
    contentText.clear();
    super.dispose();
  }
}
