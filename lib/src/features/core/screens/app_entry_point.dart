import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habittracker/src/features/core/screens/habit_create.dart';
import 'package:habittracker/src/features/core/screens/habit_checklist.dart';
import 'package:habittracker/src/features/core/screens/habit_list.dart';
import 'package:habittracker/src/features/core/screens/not_calendar.dart';
import 'package:habittracker/src/features/core/screens/profile_screen.dart';

import '../../../app_export.dart';

class AppEntryPoint extends StatefulWidget {
  const AppEntryPoint({super.key});

  @override
  State<AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<AppEntryPoint> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Checklist(),
    const NotCalendar(),
    const AllHabits(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    currentFocus.unfocus();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: ColorConstant.redA700,
        onPressed: () => Get.to(() => const HabitCreateOneScreen()),
        child: CustomImageView(
          svgPath: ImageConstant.imgNavAddHabit,
          height: getSize(55),
          width: getSize(55),
          // color: ColorConstant.blueGray300,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: WillPopScope(
          onWillPop: () async {
            // Show a confirmation dialog
            bool exit = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Exit_App'.tr),
                content: Text('Are_u_sure'.tr),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No'.tr),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Yes'.tr),
                  ),
                ],
              ),
            );

            // If the user confirms, exit the app
            if (exit == true) {
              SystemNavigator.pop();
            }

            // If the user cancels, do nothing
            return false;
          },
          child: Column(
            children: [
              Expanded(
                  child: IndexedStack(
                index: _currentIndex,
                children: _pages,
              ))
            ],
          )),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        height: 60,
        notchMargin: 10.0,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(FluentIcons.home_28_regular,
                    color: _currentIndex == 0
                        ? ColorConstant.redA700
                        : ColorConstant.blueGray300),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                    FluentIcons.calendar_arrow_counterclockwise_28_filled,
                    color: _currentIndex == 1
                        ? ColorConstant.redA700
                        : ColorConstant.blueGray300),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
              const SizedBox(width: 48.0), // Empty space for the FAB
              IconButton(
                icon: Icon(FluentIcons.task_list_square_rtl_16_filled,
                    color: _currentIndex == 2
                        ? ColorConstant.redA700
                        : ColorConstant.blueGray300),
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.person,
                    color: _currentIndex == 3
                        ? ColorConstant.redA700
                        : ColorConstant.blueGray300),
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
