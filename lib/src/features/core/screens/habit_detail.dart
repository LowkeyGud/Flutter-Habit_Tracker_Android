import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habittracker/src/app_export.dart';
import 'package:habittracker/src/features/core/screens/habit_update.dart';
import 'package:habittracker/src/features/core/screens/heatmap.dart';
import 'package:habittracker/src/repository/auth_repo/auth_repo.dart';
import 'package:habittracker/src/utils/theme/widget_theme/outlined_button.dart';
import 'package:intl/intl.dart';

class HabitDetail extends StatelessWidget {
  final String habitId;

  HabitDetail({super.key, required this.habitId});
  final user = AuthenticationRepository().auth.currentUser;

  DocumentReference<Map<String, dynamic>> get habitsRef =>
      FirebaseFirestore.instance
          .collection('User')
          .doc(user!.email)
          .collection('Habit')
          .doc(habitId);

  CollectionReference<Map<String, dynamic>> get habitsCollection =>
      habitsRef.collection('completedDates');

  Future<void> deleteHabit(DocumentReference docRef) async {
    // Delete all subcollections recursively
    await deleteCompletedDatesSubcollection(docRef);

    // Delete the document itself
    await docRef.delete();
  }

  Future<void> deleteCompletedDatesSubcollection(
      DocumentReference docRef) async {
    final CollectionReference completedDatesRef =
        docRef.collection('completedDates');

    // Get all documents in the subcollection
    final QuerySnapshot snapshot = await completedDatesRef.get();

    // Delete each document in the subcollection
    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: habitsRef.get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Habit Details'),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Habit Details'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Habit Details'),
            ),
            body: const Center(
              child: Text('Habit not found.'),
            ),
          );
        }

        // Habit details found, display them in the screen
        Map<String, dynamic> habitData =
            snapshot.data!.data() as Map<String, dynamic>;
        String habitName = habitData['habit_name'];
        String description = habitData['habit_des'];
        Timestamp? goalDate = habitData['goalDate'];
        String category = habitData['category'];
        String habitTime = habitData['habitTime'];
        List<dynamic> selectedDays = habitData['selectedDays'];
        List<dynamic>? subTasks = habitData['subTasks'];
        Timestamp startDate = habitData['start_date'];

        return Scaffold(
          appBar: AppBar(
            title: Text('Habit_details'.tr),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateHabit(
                                        habitId: habitId,
                                      )),
                            );
                          },
                          // style: HOutlinedButtontheme.cancelTheme.copyWith(),
                          child: Text(
                            'Edit_Habit'.tr,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: OutlinedButton(
                            style: HOutlinedButtontheme.cancelTheme,
                            onPressed: () async {
                              Navigator.pop(context);
                              await deleteHabit(habitsRef);
                            },
                            child: Text('Delete_Habit'.tr)),
                      ),
                    ],
                  ),
                ),
                list('Habit Name'.tr, habitName),
                list('Habit Description'.tr, description),
                list('Habit Subtasks'.tr, subTasks),
                list('Habit Category'.tr, category),
                list('Habit Time'.tr, habitTime),
                list('Habit Selected Days'.tr, selectedDays),
                list('Start Date'.tr,
                    DateFormat('yyyy-MM-dd HH:mm').format(startDate.toDate())),
                list('lbl_goal_date'.tr,
                    DateFormat('yyyy-MM-dd').format(goalDate!.toDate())),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: habitsCollection.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    final List<Widget> heatMaps = [];

                    final completedDatesStream =
                        habitsCollection.snapshots().map((snapshot) {
                      final completedDates = snapshot.docs.map((dateDoc) {
                        final DateTime dateTime = dateDoc['date'].toDate();
                        return DateTime(
                            dateTime.year, dateTime.month, dateTime.day);
                      }).toList();
                      return completedDates;
                    });

                    final heatMap = Heatmap(
                      completedDatesStream: completedDatesStream,
                      colorThresholds: const {
                        1: Color.fromARGB(255, 255, 116, 106),
                        5: Colors.orange,
                        10: Colors.green,
                      },
                    );

                    final habitHeatMap = Column(
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          '${'Habit Name'.tr}: $habitName',
                        ),
                        heatMap,
                      ],
                    );

                    heatMaps.add(habitHeatMap);

                    return Column(children: heatMaps);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Container list(String field, var data) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            field,
            style: const TextStyle(
                // color: Colors.white, // Text color
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          const SizedBox(width: 8.0),
          Flexible(
            flex: 1,
            child: Text(
              data.toString().tr,
              style: const TextStyle(
                  // color: Colors.white,
                  // fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
