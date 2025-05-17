import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/Screens/delete_confirmation_dialog.dart';

class TaskList extends StatelessWidget {
  final Stream<QuerySnapshot>? todoStream;
  final VoidCallback onTaskDeleted;

  const TaskList({
    super.key,
    required this.todoStream,
    required this.onTaskDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
          todoStream != null
              ? StreamBuilder<QuerySnapshot>(
                stream: todoStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(doc['task']),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => DeleteConfirmationDialog(
                                        docId: doc.id,
                                        onTaskDeleted: onTaskDeleted,
                                      ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No tasks found.'));
                  }
                },
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
