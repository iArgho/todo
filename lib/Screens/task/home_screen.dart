import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/Service/network_service.dart';
import 'package:todo/Screens/auth/login_screen.dart';
import 'package:todo/Screens/task/todo_task_dialog_screen.dart';
import 'package:todo/Widgets/task_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream<QuerySnapshot>? taskStream;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    final stream = await NetworkService().getTasks();
    setState(() {
      taskStream = stream;
    });
  }

  void openAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => TodoTaskDialog(onTaskAdded: loadTasks),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ToDo',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.greenAccent.shade400,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent.shade400,
        onPressed: openAddTaskDialog,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              taskStream == null
                  ? const Center(child: CircularProgressIndicator())
                  : TaskList(todoStream: taskStream, onTaskDeleted: loadTasks),
        ),
      ),
    );
  }
}
