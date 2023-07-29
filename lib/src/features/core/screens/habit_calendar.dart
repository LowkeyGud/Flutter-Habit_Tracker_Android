import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habittracker/src/app_export.dart';
import 'package:habittracker/src/common_widgets/core/date_formatter.dart';
import 'package:habittracker/src/features/core/screens/heat_map.dart';
import 'package:habittracker/src/utils/theme/widget_theme/outlined_button.dart';

class NotCalendar extends StatefulWidget {
  const NotCalendar({super.key});

  @override
  State<NotCalendar> createState() => _NotCalendarState();
}

class _NotCalendarState extends State<NotCalendar> {
  DateTime _selectedDate = DateTime.now();
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference<Map<String, dynamic>> get _habitsCollection =>
      FirebaseFirestore.instance
          .collection('User')
          .doc(user!.email)
          .collection('Habit');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: _selectDate,
              child: Text('Select_date'.tr),
            ),
            const SizedBox(height: 16),
            Text(
              '${'Date'.tr}: ${formatDate(_selectedDate)}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 16),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _habitsCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                List<QueryDocumentSnapshot<Map<String, dynamic>>> habitDocs =
                    snapshot.data!.docs;

                List<QueryDocumentSnapshot<Map<String, dynamic>>>
                    habitsForSelectedDate = habitDocs
                        .where((habitDoc) => habitDoc['selectedDays']
                            .contains(_getWeekdayString(_selectedDate.weekday)))
                        .toList();

                return Column(
                  children: habitsForSelectedDate
                      .map((habit) => HabitStatusWidget(
                            habitDoc: habit,
                            selectedDate: _selectedDate,
                          ))
                      .toList(),
                );
              },
            ),
            OutlinedButton(
                onPressed: () => Get.to(const HabitHeatMapWidget()),
                child: Text('All_Habits_HeatMap'.tr))
          ],
        ),
      ),
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _getWeekdayString(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }
}

class HabitStatusWidget extends StatelessWidget {
  // Checklist cl = const Checklist();
  final QueryDocumentSnapshot<Map<String, dynamic>> habitDoc;
  final DateTime selectedDate;

  const HabitStatusWidget({
    super.key,
    required this.habitDoc,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    DocumentReference<Map<String, dynamic>> habitRef = habitDoc.reference;

    CollectionReference<Map<String, dynamic>> completedDatesRef =
        habitRef.collection('completedDates');

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: completedDatesRef
          // .where('date', isEqualTo: selectedTimestamp)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final bool completed = snapshot.data!.docs
            .any((doc) => _isSameDate(doc['date'], selectedDate));
        DateTime currentDate = DateTime.now();
        // Today date without time
        DateTime today =
            DateTime(currentDate.year, currentDate.month, currentDate.day);
        return ListTile(
          trailing: (selectedDate.compareTo(today) > 0)
              ? null
              : !completed
                  ? OutlinedButton(
                      style: HOutlinedButtontheme.cancelTheme,
                      onPressed: () {
                        habitRef.update({'completed': true});
                        completedDatesRef.add({'date': selectedDate});
                      },
                      child: const Text('Complete'))
                  : null,
          leading: Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completed ? Colors.green : Colors.red,
          ),
          title: Text(habitDoc['habit_name']),
        );
      },
    );
  }

  bool _isSameDate(Timestamp timestamp, DateTime date) {
    DateTime dateTime = timestamp.toDate();
    return dateTime.year == date.year &&
        dateTime.month == date.month &&
        dateTime.day == date.day;
  }
}
