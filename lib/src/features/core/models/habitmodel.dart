import 'package:cloud_firestore/cloud_firestore.dart';

class HabitModel {
  final String id;
  String name;
  String description;
  bool completed;

  HabitModel({
    required this.id,
    required this.name,
    required this.description,
    required this.completed,
  });

  factory HabitModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HabitModel(
      id: doc.id,
      name: data['habit_name'] ?? '',
      description: data['habit_des'] ?? '',
      completed: data['is_completed'],
    );
  }
}
