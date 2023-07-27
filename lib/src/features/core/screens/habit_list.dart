import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:habittracker/src/features/core/screens/habit_detail.dart';
import 'package:habittracker/src/repository/auth_repo/auth_repo.dart';

class AllHabits extends StatefulWidget {
  const AllHabits({super.key});

  @override
  State<AllHabits> createState() => _AllHabitsState();
}

class _AllHabitsState extends State<AllHabits> {
  Map<String, String> categoryMap = {
    'Fun': 'assets/images/category/fun.png',
    'Relations': 'assets/images/category/relation.png',
    'Mindfulness': 'assets/images/category/mindfullness.png',
    'Finances': 'assets/images/category/finance.png',
    'Skill': 'assets/images/category/skill.png',
    'Health': 'assets/images/category/health.png',
    'Productivity': 'assets/images/category/productivity.png',
  };
  final user = AuthenticationRepository().auth.currentUser;
  CollectionReference<Map<String, dynamic>> get habitsCollection =>
      FirebaseFirestore.instance
          .collection('User')
          .doc(user!.email)
          .collection('Habit');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All_Habits'.tr),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: habitsCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          List<Widget> habitWidgets =
              snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> habitData =
                document.data() as Map<String, dynamic>;
            String habitName = habitData['habit_name'];
            String habitCategory = habitData['category'];
            String habitTime = habitData['habitTime'];
            String habitId = document.id;

            return Container(
              margin: const EdgeInsets.all(7),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HabitDetail(habitId: habitId)),
                  );
                },
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 255, 214, 211),
                    ),
                    child: Image.asset(categoryMap[habitCategory]!),
                  ),
                  title: Text(
                    habitName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    habitTime.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.red,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HabitDetail(habitId: habitId)),
                    );
                  },
                ),
              ),
            );
          }).toList();

          return ListView(
            children: habitWidgets,
          );
        },
      ),
    );
  }
}
