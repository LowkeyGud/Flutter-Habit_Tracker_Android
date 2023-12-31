import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  final _confirmationController = TextEditingController();
  final _confirmationKey = GlobalKey<FormState>();

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('❌Delete Confirmation❌', style: TextStyle(fontSize: 15.0)),
              SizedBox(height: 19),
              Text(
                'Details of this habit will be lost forever',
                style: TextStyle(fontSize: 15.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Form(
            key: _confirmationKey,
            child: TextFormField(
              controller: _confirmationController,
              decoration:
                  const InputDecoration(labelText: 'Type "confirm" to delete'),
              validator: (value) {
                if (value!.trim().toLowerCase() != 'confirm') {
                  return 'Invalid confirmation';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            OutlinedButton(
              onPressed: () async {
                if (_confirmationKey.currentState!.validate()) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  await deleteHabit(habitsRef);
                  // Close the dialog
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
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
                            onPressed: () {
                              _showDeleteConfirmationDialog(context);
                            },
                            child: Text('Delete_Habit'.tr)),
                      ),
                    ],
                  ),
                ),
                list('Habit Name'.tr, habitName),
                list('Habit Description'.tr, description),
                buildTopicListTile('Habit Subtasks'.tr, subTasks),
                list('Habit Category'.tr, category),
                list('Habit Time'.tr, habitTime),
                buildTopicListTile('Habit Selected Days'.tr, selectedDays),
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
                          ' $habitName ${'Heatmap'.tr}',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 255, 0, 0),
                          ),
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

  Card list(String topic, var details) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 255, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    details,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card buildTopicListTile(String topic, List<dynamic>? details) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 255, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: details!
                        .map(
                          (item) => Text(
                            '• $item',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
