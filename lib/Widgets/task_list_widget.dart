import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/Screens/task/edit_task_screen.dart';

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
                      padding: const EdgeInsets.all(12),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            leading: const Icon(
                              Icons.task_alt,
                              color: Colors.green,
                            ),
                            title: Text(
                              doc['task'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => EditTaskScreen(
                                          docId: doc.id,
                                          currentTask: doc['task'],
                                        ),
                                  ),
                                );

                                if (result == true) {
                                  onTaskDeleted();
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'No tasks found.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                },
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
