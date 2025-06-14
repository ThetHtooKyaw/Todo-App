import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/shared/alert_dialog.dart';
import 'package:todoapp/widgets/todo_list_builder.dart';
import '../providers/main_provider.dart';

class AddTodo extends StatefulWidget {
  final GlobalKey<TodolistBuilderState> todolistKey;
  const AddTodo({super.key, required this.todolistKey});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  Future<void> handleSubmit() async {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);

    try {
      await mainProvider.addTodo(onAdded: (newTask) {
        final todoListState = widget.todolistKey.currentState;
        todoListState?.insertTask(newTask);
      });
      Navigator.pop(context);
    } catch (e) {
      final error = e.toString();
      if (error.contains('Task Already Exist')) {
        showDialog(
          context: context,
          builder: (context) {
            return const CustomAlertDialog(
                title: 'Task Already Exist',
                content: 'Task already added. Try something new!');
          },
        );
        return;
      } else if (error.contains('Task Input Empty')) {
        showDialog(
          context: context,
          builder: (context) {
            return const CustomAlertDialog(
              title: 'Oops!',
              content: 'Your task is empty. Try typing something first!',
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Error!',
              content: 'Something went wrong: $error',
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Create New Task',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        textfield(
          mainProvider.titleText,
          'Task Title',
          'assets/icons/title.png',
          'Type a new task...',
          1,
        ),
        textfield(
          mainProvider.contentText,
          'Notes (Optional)',
          'assets/icons/note.png',
          'Add a note (optional)..',
          5,
        ),
        addButton(),
      ],
    );
  }

  Widget textfield(controller, text, icon, hinText, max) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                icon,
                height: 20,
                width: 20,
                color: Colors.grey[900],
              ),
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            autofocus: true,
            controller: controller,
            minLines: 1,
            maxLines: max,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              hintText: hinText,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[900] ?? Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[900] ?? Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onSubmitted: (_) => handleSubmit(),
          ),
        ],
      ),
    );
  }

  Widget addButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      width: 150,
      child: ElevatedButton(
        onPressed: handleSubmit,
        style: ElevatedButton.styleFrom(
          elevation: 5,
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: const Text('ADD'),
      ),
    );
  }
}
