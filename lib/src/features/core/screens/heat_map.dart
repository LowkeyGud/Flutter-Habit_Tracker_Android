import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habittracker/src/app_export.dart';
import 'package:habittracker/src/features/core/screens/heatmap.dart';

class HabitHeatMapWidget extends StatefulWidget {
  const HabitHeatMapWidget({super.key});

  @override
  State<HabitHeatMapWidget> createState() => _HabitHeatMapWidgetState();
}

class _HabitHeatMapWidgetState extends State<HabitHeatMapWidget> {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference<Map<String, dynamic>> get habitsCollection =>
      FirebaseFirestore.instance
          .collection('User')
          .doc(user!.email)
          .collection('Habit');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 15),
              child: Text('All_Habits_HeatMap'.tr,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtPJSSemiBold18Gray900
                      .copyWith(letterSpacing: getHorizontalSize(0.09))),
            ),
            Center(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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

                  for (var habitDoc in snapshot.data!.docs) {
                    final habitName = habitDoc['habit_name'];
                    final completedDatesRef = habitsCollection
                        .doc(habitDoc.id)
                        .collection('completedDates');

                    final completedDatesStream =
                        completedDatesRef.snapshots().map((snapshot) {
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
                          'Habit name: $habitName',
                          style: const TextStyle(fontSize: 16),
                        ),
                        heatMap,
                      ],
                    );

                    heatMaps.add(habitHeatMap);
                  }

                  return Column(children: heatMaps);
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
