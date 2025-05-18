import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTaskScreen extends StatefulWidget {
  final String docId;
  final String currentTask;

  const EditTaskScreen({
    super.key,
    required this.docId,
    required this.currentTask,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _taskController;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.currentTask);
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> updateTask() async {
    final updatedText = _taskController.text.trim();
    if (updatedText.isEmpty) return;

    setState(() => _isUpdating = true);

    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.docId)
          .update({'task': updatedText});
      Navigator.of(context).pop(true); // Return success
    } catch (e) {
      setState(() => _isUpdating = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update task: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        backgroundColor: Colors.greenAccent.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: 'Task',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isUpdating ? null : updateTask,
              icon: const Icon(Icons.save),
              label: const Text('Update Task'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.shade400,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            if (_isUpdating)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
