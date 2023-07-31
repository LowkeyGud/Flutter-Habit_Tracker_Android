import 'dart:async';

import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:habittracker/src/app_export.dart';
import 'package:habittracker/src/repository/auth_repo/auth_repo.dart';
import 'package:habittracker/src/utils/theme/widget_theme/outlined_button.dart';
import 'package:habittracker/src/utils/theme/widget_theme/custom_button.dart';

class Habit {
  final String id;
  final String name;
  final List<String> subTasks;
  final DateTime startDate;
  final DateTime goalDate;
  final List<String> selectedDays;
  final String time;
  final String category;
  bool completed;
  int subTasksLength;

  Habit({
    required this.id,
    required this.name,
    required this.subTasks,
    required this.startDate,
    required this.goalDate,
    required this.selectedDays,
    required this.time,
    this.completed = false,
    required this.subTasksLength,
    required this.category,
  });
}

class Checklist extends StatefulWidget {
  const Checklist({super.key});

  @override
  State<Checklist> createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  final today = DateTime.now();
  List<Habit> _habits = [];
  StreamSubscription<QuerySnapshot>? _habitsSubscription;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _isOnline = true;
  final storage = GetStorage();
  // DateTime lastOpenedDate = DateTime.now();

  final user = AuthenticationRepository().auth.currentUser;

  CollectionReference<Map<String, dynamic>> get habitsCollection =>
      FirebaseFirestore.instance
          .collection('User')
          .doc(user!.email)
          .collection('Habit');

  @override
  void initState() {
    super.initState();
    checkAndUpdateCompleted();
    fetchHabits();
    checkConnectivity();
  }

  Future<void> checkAndUpdateCompletedd() async {
    final box = GetStorage();

    // Get the last stored date
    final lastDate = box.read('lastDate');

    // Get today's date
    final today = DateTime.now();
    final selectedDate = DateTime(today.year, today.month, today.day);

    // Compare the stored date with today's date
    if (lastDate != null && lastDate != selectedDate) {
      updateAllHabits();

      // Store today's date as the last date
      box.write('lastDate', selectedDate);
    } else if (lastDate == null) {
      // Store today's date as the last date if it's the first time the app is opened
      box.write('lastDate', selectedDate);
    }
  }

  Future<void> checkAndUpdateCompleted() async {
    final documentRef =
        FirebaseFirestore.instance.collection('User').doc(user!.email);

    final documentSnapshot = await documentRef.get();
    DateTime currentTimestamp = DateTime.now();

    if (documentSnapshot.exists) {
      final data = documentSnapshot.data();
      if (data != null && data['lastOpenedDate'] is Timestamp) {
        // The date in Firebase is stored as a Firestore Timestamp.
        Timestamp firebaseTimestamp = data['lastOpenedDate'];
        DateTime firebaseDT = firebaseTimestamp.toDate();

        DateTime currentDate = DateTime(currentTimestamp.year,
            currentTimestamp.month, currentTimestamp.day);
        DateTime firebaseDate =
            DateTime(firebaseDT.year, firebaseDT.month, firebaseDT.day);

        if (currentDate != firebaseDate) {
          updateAllHabits();
        }
      }
    }
    // If the document does not exist, add the current date to Firebase.
    documentRef.update({'lastOpenedDate': currentTimestamp});
  }

  Future<void> updateAllHabits() async {
    final batch = FirebaseFirestore.instance.batch();
    final querySnapshot = await habitsCollection.get();

    for (final completedDateDoc in querySnapshot.docs) {
      batch.update(completedDateDoc.reference, {'completed': false});
    }

    await batch.commit();
  }

  @override
  void dispose() {
    _habitsSubscription?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  void toggleHabitCompletion(Habit habit) {
    setState(() {
      habit.completed = !habit.completed;
    });
    updateHabitCompletionStatus(habit);
  }

  Future<void> fetchHabits() async {
    final Map<int, String> dayOfWeek = {
      7: 'Sun',
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
    };

    final Query query = habitsCollection.where('selectedDays',
        arrayContains: dayOfWeek[today.weekday]);

    _habitsSubscription = query.snapshots().listen((snapshot) {
      setState(() {
        _habits = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Habit(
            id: doc.id,
            name: data['habit_name'],
            subTasks: List<String>.from(data['subTasks'] ?? []),
            startDate: data['start_date'].toDate(),
            goalDate: data['goalDate'].toDate(),
            selectedDays: List<String>.from(data['selectedDays'] ?? []),
            time: data['habitTime'],
            completed: data['completed'],
            subTasksLength: data['subTasksLength'],
            category: data['category'] ?? '',
          );
        }).toList();
      });
    });
  }

  Future<void> updateHabitCompletionStatus(Habit habit) async {
    await habitsCollection.doc(habit.id).update({
      'completed': habit.completed,
    });
    final CollectionReference completedDatesRef =
        habitsCollection.doc(habit.id).collection('completedDates');

    if (habit.completed) {
      await completedDatesRef.add({'date': Timestamp.now()});
    }
  }

  Future<void> checkConnectivity() async {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isOnline = result != ConnectivityResult.none;
      });
      if (_isOnline) {
        syncHabits();
      }
    });
  }

  Future<void> syncHabits() async {
    final List<Habit> offlineCompletedHabits =
        _habits.where((habit) => habit.completed).toList();

    for (final habit in offlineCompletedHabits) {
      await habitsCollection.doc(habit.id).update({
        'completed': habit.completed,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('lbl_today_s_habit'.tr),
      ),
      body: ListView(
        children: [
          if (_habits.isEmpty)
            Center(
              child: Text("no_habits_today".tr),
            ),
          // for (final habitTime in _habits.where((habit) =>
          //     ['Morning', 'Afternoon', 'Night'].contains(habit.time) &&
          // habit.completed))
          for (final habitTime in ['Morning', 'Afternoon', 'Night'])
            if (_habits.any((habit) => habit.time == habitTime))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        habitTime.tr,
                        style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      for (final habit in _habits.where((habit) =>
                          !habit.completed && habit.time == habitTime))
                        Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 0,
                          margin: const EdgeInsets.only(
                              top: 13, left: 12, right: 12),
                          color: ColorConstant.whiteA700,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusStyle.roundedBorder16),
                          child: Container(
                              // height: getVerticalSize(220),
                              width: double.infinity,
                              padding: getPadding(
                                  left: 10, top: 14, right: 10, bottom: 14),
                              decoration: AppDecoration.fillWhiteA700.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder16),
                              child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                            padding: getPadding(right: 2),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        CustomButton(
                                                            height:
                                                                getVerticalSize(
                                                                    28),
                                                            width:
                                                                getHorizontalSize(
                                                                    79),
                                                            text: habit
                                                                .category.tr,
                                                            shape: ButtonShape
                                                                .RoundedBorder12,
                                                            padding:
                                                                ButtonPadding
                                                                    .PaddingAll6,
                                                            fontStyle:
                                                                ButtonFontStyle
                                                                    .PJSm12),
                                                        Text(
                                                          habit.name,
                                                          maxLines: null,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: AppStyle
                                                              .txtPJSSemiBold18Gray900
                                                              .copyWith(
                                                            letterSpacing:
                                                                getHorizontalSize(
                                                                    0.09),
                                                          ),
                                                        ),
                                                        OutlinedButton(
                                                            style:
                                                                HOutlinedButtontheme
                                                                    .cancelTheme,
                                                            onPressed: () =>
                                                                toggleHabitCompletion(
                                                                    habit),
                                                            child: Text(
                                                                'Complete'.tr)),
                                                      ]),
                                                  const SizedBox(height: 10.0),
                                                  Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        for (int i = 0;
                                                            i <
                                                                habit
                                                                    .subTasksLength;
                                                            i++)
                                                          Center(
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                    habit.subTasks[
                                                                        i],
                                                                    maxLines:
                                                                        null,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: AppStyle
                                                                        .txtPJSm14Gray600
                                                                        .copyWith(
                                                                            letterSpacing:
                                                                                getHorizontalSize(0.07))),
                                                                const SizedBox(
                                                                  height: 10,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                      ]),
                                                  Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Padding(
                                                          padding: getPadding(
                                                              top: 21),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                CustomImageView(
                                                                    svgPath:
                                                                        ImageConstant
                                                                            .imgPaperplus,
                                                                    height:
                                                                        getSize(
                                                                            18),
                                                                    width:
                                                                        getSize(
                                                                            18),
                                                                    margin: getMargin(
                                                                        bottom:
                                                                            2)),
                                                                Padding(
                                                                    padding: getPadding(
                                                                        left: 4,
                                                                        bottom:
                                                                            1),
                                                                    child: Text(
                                                                        "${habit.subTasksLength.toString()} ",
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .left,
                                                                        style: AppStyle
                                                                            .txtPJSm14Gray900
                                                                            .copyWith(letterSpacing: getHorizontalSize(0.07)))),
                                                                CustomImageView(
                                                                    svgPath:
                                                                        ImageConstant
                                                                            .imgTimecircle,
                                                                    height:
                                                                        getSize(
                                                                            18),
                                                                    width:
                                                                        getSize(
                                                                            18),
                                                                    margin: getMargin(
                                                                        left:
                                                                            12,
                                                                        bottom:
                                                                            0)),
                                                                Padding(
                                                                    padding: getPadding(
                                                                        left: 4,
                                                                        top: 2),
                                                                    child: RichText(
                                                                        text: TextSpan(children: [
                                                                          TextSpan(
                                                                              text: habit.goalDate.difference(today).inDays.toString(),
                                                                              style: TextStyle(color: ColorConstant.gray900, fontSize: getFontSize(14), fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w500, letterSpacing: getHorizontalSize(0.07))),
                                                                          TextSpan(
                                                                              text: "lbl_days".tr,
                                                                              style: TextStyle(color: ColorConstant.blueGray300, fontSize: getFontSize(14), fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w500, letterSpacing: getHorizontalSize(0.07)))
                                                                        ]),
                                                                        textAlign: TextAlign.left))
                                                              ])))
                                                ]))),
                                  ])),
                        ),
                    ],
                  ),
                ],
              ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Center(
              child: SizedBox(
                width: 270.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: AnimateGradient(
                    primaryColors: const [
                      Colors.pink,
                      Colors.pinkAccent,
                      Colors.white,
                    ],
                    secondaryColors: const [
                      Colors.white,
                      Color.fromARGB(255, 255, 142, 142),
                      Color.fromARGB(255, 255, 195, 195),
                    ],
                    child: Center(
                      child: Text(
                        'completed_habits'.tr,
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              for (final habit in _habits.where((habit) => habit.completed))
                Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 0,
                  margin: const EdgeInsets.only(top: 13, left: 12, right: 12),
                  color: ColorConstant.whiteA700,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusStyle.roundedBorder16),
                  child: Container(
                      // height: getVerticalSize(220),
                      width: double.infinity,
                      padding:
                          getPadding(left: 10, top: 14, right: 10, bottom: 14),
                      decoration: AppDecoration.fillWhiteA700.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder16),
                      child: Stack(alignment: Alignment.topRight, children: [
                        Align(
                            alignment: Alignment.center,
                            child: Padding(
                                padding: getPadding(right: 2),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CustomButton(
                                                height: getVerticalSize(28),
                                                width: getHorizontalSize(79),
                                                text: habit.category.tr,
                                                shape:
                                                    ButtonShape.RoundedBorder12,
                                                padding:
                                                    ButtonPadding.PaddingAll6,
                                                fontStyle:
                                                    ButtonFontStyle.PJSm12),
                                            Text(
                                              habit.name,
                                              maxLines: null,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtPJSSemiBold18Gray900
                                                  .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.09),
                                              ),
                                            ),
                                            OutlinedButton(
                                                style: HOutlinedButtontheme
                                                    .cancelTheme,
                                                onPressed: () {},
                                                child: Text('completed'.tr)),
                                          ]),
                                      const SizedBox(height: 14.0),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            for (int i = 0;
                                                i < habit.subTasksLength;
                                                i++)
                                              Center(
                                                child: Column(
                                                  children: [
                                                    Text(habit.subTasks[i],
                                                        maxLines: null,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: AppStyle
                                                            .txtPJSm14Gray600
                                                            .copyWith(
                                                                letterSpacing:
                                                                    getHorizontalSize(
                                                                        0.07))),
                                                    const SizedBox(
                                                      height: 10,
                                                    )
                                                  ],
                                                ),
                                              ),
                                          ]),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                              padding: getPadding(top: 21),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgPaperplus,
                                                        height: getSize(18),
                                                        width: getSize(18),
                                                        margin: getMargin(
                                                            bottom: 2)),
                                                    Padding(
                                                        padding: getPadding(
                                                            left: 4, bottom: 1),
                                                        child: Text(
                                                            "${habit.subTasksLength.toString()} ",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: AppStyle
                                                                .txtPJSm14Gray900
                                                                .copyWith(
                                                                    letterSpacing:
                                                                        getHorizontalSize(
                                                                            0.07)))),
                                                    CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgTimecircle,
                                                        height: getSize(18),
                                                        width: getSize(18),
                                                        margin: getMargin(
                                                            left: 12,
                                                            bottom: 0)),
                                                    Padding(
                                                        padding: getPadding(
                                                            left: 4, top: 2),
                                                        child: RichText(
                                                            text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                      text: habit
                                                                          .goalDate
                                                                          .difference(
                                                                              today)
                                                                          .inDays
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          color: ColorConstant
                                                                              .gray900,
                                                                          fontSize: getFontSize(
                                                                              14),
                                                                          fontFamily:
                                                                              'Plus Jakarta Sans',
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          letterSpacing:
                                                                              getHorizontalSize(0.07))),
                                                                  TextSpan(
                                                                      text: "lbl_days"
                                                                          .tr,
                                                                      style: TextStyle(
                                                                          color: ColorConstant
                                                                              .blueGray300,
                                                                          fontSize: getFontSize(
                                                                              14),
                                                                          fontFamily:
                                                                              'Plus Jakarta Sans',
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          letterSpacing:
                                                                              getHorizontalSize(0.07)))
                                                                ]),
                                                            textAlign:
                                                                TextAlign.left))
                                                  ])))
                                    ]))),
                      ])),
                ),
            ],
          )
        ],
      ),
    );
  }
}
