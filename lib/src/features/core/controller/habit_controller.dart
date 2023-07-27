// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habittracker/src/features/core/models/habitmodel.dart';
import 'package:habittracker/src/repository/auth_repo/auth_repo.dart';

class HabitController extends GetxController {
  final user = Get.find<AuthenticationRepository>().firebaseUser.value;
  CollectionReference<Map<String, dynamic>> get habitsCollection =>
      FirebaseFirestore.instance
          .collection('User')
          .doc(user!.email)
          .collection('Habit');
  // final habitSnapshot = await habitsCollection.get();
  // Process the habitSnapshot as needed

// User/AaLXt2v4IsNaLWtvFyEg/Habit
  final RxList<HabitModel> habits = RxList<HabitModel>();
  // final habits = <HabitModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHabits();
  }

  Future<void> fetchHabits() async {
    try {
      final QuerySnapshot querySnapshot = await habitsCollection.get();
      for (var doc in querySnapshot.docs) {
        String documentId = doc.id;
        print('Document ID: $documentId');
      }

      print("Here it is ${querySnapshot.docs.length}");
      if (querySnapshot.docs.isNotEmpty) {
        habits.value = querySnapshot.docs
            .map((doc) => HabitModel.fromFirestore(doc))
            .toList();
      } else {
        habits.value = <HabitModel>[];
      }
    } catch (e) {
      // Handle any errors that occur during fetching
      print('Error fetching habits: $e');
    }
  }

  Future<void> addHabit(
    String name,
    DateTime? goalDate,
    String category,
    String habitTime,
    List<String> selectedDays,
    List<String>? subTasks,
    String description,
  ) async {
    try {
      final docRef = await habitsCollection.add({
        'habit_name': name,
        'goalDate': goalDate,
        'category': category,
        'habitTime': habitTime,
        'selectedDays': selectedDays,
        'subTasks': subTasks,
        'habit_des': description,
        'completed': false,
        'is_completed': false,
        'start_date': Timestamp.now(),
        'frequency': selectedDays.length,
        'is_active': true,
        'subTasksLength': subTasks!.length,
      });
      final habit = HabitModel(
        id: docRef.id,
        name: name,
        description: description,
        completed: false,
      );
      habits.add(habit);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> deleteHabit(String habitId) async {
    try {
      await habitsCollection.doc(habitId).delete();
      habits.removeWhere((habit) => habit.name == habitId);
    } catch (e) {
      print('Error deleting habit: $e');
    }
  }

  Future<void> updateHabit(
    String habitId,
    String name,
    DateTime? goalDate,
    String category,
    String habitTime,
    List<String> selectedDays,
    List<String>? subTasks,
    String description,
  ) async {
    try {
      await habitsCollection.doc(habitId).update({
        'habit_name': name,
        'goalDate': goalDate,
        'category': category,
        'habitTime': habitTime,
        'selectedDays': selectedDays,
        'subTasks': subTasks,
        'habit_des': description,
        'is_completed': false,
        'start_date': Timestamp.now(),
        'frequency': selectedDays.length,
        'is_active': true,
        'subTasksLength': subTasks!.length,
      });
    } catch (e) {
      print('Error updating habit: $e');
    }
  }
}
