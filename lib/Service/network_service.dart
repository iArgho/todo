import 'package:cloud_firestore/cloud_firestore.dart';

class NetworkService {
  Future addTask(Map<String, dynamic> taskData, String id) async {
    return await FirebaseFirestore.instance
        .collection("tasks")
        .doc(id)
        .set(taskData);
  }

  Future<Stream<QuerySnapshot>> getTasks() async {
    return FirebaseFirestore.instance.collection("tasks").snapshots();
  }

  Future deleteTask(String id) async {
    return await FirebaseFirestore.instance
        .collection("tasks")
        .doc(id)
        .delete();
  }
}
