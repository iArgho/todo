import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String docId;
  final VoidCallback onTaskDeleted;

  const DeleteConfirmationDialog({
    super.key,
    required this.docId,
    required this.onTaskDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Task'),
      content: const Text('Are you sure you want to delete this task?'),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
          onPressed: () async {
            try {
              await FirebaseFirestore.instance
                  .collection('tasks')
                  .doc(docId)
                  .delete();
              onTaskDeleted();
              Navigator.of(context).pop();
            } catch (e) {
              print('Error deleting document: $e');
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
