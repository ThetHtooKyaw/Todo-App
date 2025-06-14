import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/classes/task.dart';
import 'package:todoapp/detail_screen.dart';
import 'package:todoapp/providers/main_provider.dart';

class TodolistBuilder extends StatefulWidget {
  const TodolistBuilder({super.key});

  @override
  State<TodolistBuilder> createState() => TodolistBuilderState();
}

class TodolistBuilderState extends State<TodolistBuilder> {
  final GlobalKey<AnimatedListState> animatedListKey =
      GlobalKey<AnimatedListState>();
  final List<Task> displayedList = [];

  void insertTask(Task task) {
    displayedList.insert(0, task);
    animatedListKey.currentState?.insertItem(0);
  }

  Future<void> loadAnimation(List<Task> tasks) async {
    for (Task task in tasks) {
      displayedList.add(task);
      animatedListKey.currentState?.insertItem(displayedList.length - 1);
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  void reloadAnimation() {
    if (animatedListKey.currentState == null) return;

    for (int i = displayedList.length - 1; i >= 0; i--) {
      final removedItem = displayedList.removeAt(i);
      animatedListKey.currentState?.removeItem(
        i,
        (context, animation) => buildTaskTile(removedItem),
        duration: Duration.zero,
      );
    }

    loadAnimation(Provider.of<MainProvider>(context, listen: false).todoList);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (context, mainProvider, _) {
      if (mainProvider.todoList.isEmpty) {
        return const Center(
          child: Text(
            'Add your first task!',
            style: TextStyle(fontSize: 16),
          ),
        );
      }

      if (displayedList.isEmpty) {
        Future.microtask(() {
          if (mounted) loadAnimation(mainProvider.todoList);
        });
      }

      return AnimatedList(
        key: animatedListKey,
        initialItemCount: displayedList.length,
        itemBuilder: (BuildContext context, int index, Animation animation) {
          final task = displayedList[index];

          return SlideTransition(
            position: animation.drive(
              Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeOut)),
            ),
            child: buildTaskTile(task),
          );
        },
      );
    });
  }

  Widget buildTaskTile(Task task) {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.green[400],
        child: const Row(
          children: [
            Icon(Icons.check),
          ],
        ),
      ),
      onDismissed: (direction) {
        final removedIndex = displayedList.indexOf(task);

        if (removedIndex != -1) {
          animatedListKey.currentState?.removeItem(
            removedIndex,
            (context, animation) => buildTaskTile(task),
            duration: Duration.zero,
          );

          displayedList.removeAt(removedIndex);
        }
        mainProvider.removeTodo(task);
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailScreen(
              taskTitle: task.title,
              taskContent: task.content,
              onPop: () {
                reloadAnimation();
              },
            );
          }));
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Container(
            height: 60,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.grey[900],
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  'assets/icons/task.png',
                  height: 26,
                  width: 26,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    mainProvider.capitalizeFirstLetter(task.title),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
