import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/providers/main_provider.dart';
import 'package:todoapp/shared/appbar.dart';
import 'package:todoapp/widgets/add_todo.dart';
import 'package:todoapp/widgets/drawer.dart';
import 'package:todoapp/widgets/todo_list_builder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<TodolistBuilderState> todolistKey =
      GlobalKey<TodolistBuilderState>();

  @override
  void initState() {
    super.initState();
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    mainProvider.loadData();
  }

  void onButtonClicked() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: AddTodo(todolistKey: todolistKey),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: CustomAppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Image.asset(
                'assets/icons/menu.png',
                width: 35,
                height: 35,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
        body: TodolistBuilder(key: todolistKey),
        floatingActionButton: FloatingActionButton(
          onPressed: onButtonClicked,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.grey[900],
          child: const Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 55,
          ),
        ),
      ),
    );
  }
}
