import 'package:cloud_firestore/cloud_firestore.dart';

class NetworkService {
  Future<void> addTask(Map<String, dynamic> taskData, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection("tasks")
          .doc(id)
          .set(taskData);
      print("Task added with ID: $id");
    } catch (e) {
      print("Error adding task: $e");
      throw Exception('Failed to add task: $e');
    }
  }

  Future<Stream<QuerySnapshot>> getTasks() async {
    try {
      return FirebaseFirestore.instance.collection("tasks").snapshots();
    } catch (e) {
      print("Error fetching tasks: $e");
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await FirebaseFirestore.instance.collection("tasks").doc(id).delete();
      print("Task deleted with ID: $id");
    } catch (e) {
      print("Error deleting task: $e");
      throw Exception('Failed to delete task: $e');
    }
  }
}
