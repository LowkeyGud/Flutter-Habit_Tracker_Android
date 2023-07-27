import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habittracker/src/app_export.dart';
import 'package:habittracker/src/features/core/controller/habit_controller.dart';
import 'package:habittracker/src/features/core/screens/dialogs/habit_created_dialog.dart';
import 'package:habittracker/src/utils/theme/widget_theme/outlined_button.dart';
import 'package:habittracker/src/utils/theme/widget_theme/text_theme.dart';
import 'package:habittracker/src/utils/theme/widget_theme/app_bar/appbar_subtitle_2.dart';
import 'package:habittracker/src/utils/theme/widget_theme/app_bar/custom_app_bar.dart';
import 'package:habittracker/src/utils/theme/widget_theme/custom_button.dart';
import 'package:habittracker/src/utils/theme/widget_theme/custom_text_form_field.dart';
import 'package:intl/intl.dart';

// ignore_for_file: must_be_immutable
class HabitCreateOneScreen extends StatefulWidget {
  const HabitCreateOneScreen({Key? key}) : super(key: key);

  @override
  State<HabitCreateOneScreen> createState() => _HabitCreateOneScreenState();
}

class _HabitCreateOneScreenState extends State<HabitCreateOneScreen> {
  final GlobalKey<FormState> _habitCreateFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final habitController = Get.put(HabitController());

  String habitName = '';
  DateTime? goalDate;
  String habitTime = 'Morning'.tr;
  List<String> subTasks = [];
  String habitDescription = '';
  String _category = 'Productivity'.tr;
  final List<String> _selectedDays = [];
  String? _selectedDaysError;

  @override
  void dispose() {
    // _dateController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 60)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != goalDate) {
      setState(() {
        goalDate = picked;
        _dateController.text = DateFormat('MM/dd/yyyy').format(picked!);
      });
    }
  }

  final List<String> _dropdownItems = [
    'Fun'.tr,
    'Relations'.tr,
    'Mindfulness'.tr,
    'Finances'.tr,
    'Skill'.tr,
    'Health'.tr,
    'Productivity'.tr
  ];

  final List<String> _daysOfWeek = [
    'Sun'.tr,
    'Mon'.tr,
    'Wed'.tr,
    'Tue'.tr,
    'Thu'.tr,
    'Fri'.tr,
    'Sat'.tr,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        appBar: CustomAppBar(
            height: getVerticalSize(68),
            leadingWidth: 72,
            centerTitle: true,
            title: AppbarSubtitle2(text: "lbl_create_habit".tr)),
        body: SingleChildScrollView(
          child: Form(
            key: _habitCreateFormKey,
            child: Container(
              padding: getPadding(left: 14, top: 30, right: 14, bottom: 30),
              child: Column(
                // alignment: Alignment.bottomCenter,
                children: [
                  Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                          padding: getPadding(left: 10),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    margin: getMargin(right: 10),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadiusStyle.roundedBorder8),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("lbl_habit_name".tr,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle.txtPJSm14
                                                  .copyWith(
                                                      letterSpacing:
                                                          getHorizontalSize(
                                                              0.07))),
                                          CustomTextFormField(
                                            autofocus: false,
                                            controller: nameController,
                                            hintText: "msg_habit_name_here".tr,
                                            margin: getMargin(top: 9),
                                            padding: TextFormFieldPadding
                                                .PaddingAll15,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please_enter_habit_name"
                                                    .tr;
                                              }
                                              return null;
                                            },
                                          )
                                        ])),
                                Padding(
                                    padding: getPadding(top: 20),
                                    child: Text("msg_goal_date_60_days".tr,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle.txtPJSm14.copyWith(
                                            letterSpacing:
                                                getHorizontalSize(0.07)))),
                                InkWell(
                                  onTap: () => _selectDate(context),
                                  child: IgnorePointer(
                                    child: CustomTextFormField(
                                      // focusNode: FocusNode(),
                                      // autofocus: true,
                                      controller: _dateController,
                                      hintText: "lbl_choose_date".tr,
                                      margin: getMargin(top: 7, right: 10),
                                      textInputAction: TextInputAction.done,
                                      suffix: Container(
                                          margin: getMargin(
                                              left: 30,
                                              top: 14,
                                              right: 12,
                                              bottom: 14),
                                          child: CustomImageView(
                                              svgPath:
                                                  ImageConstant.imgCalendar)),
                                      suffixConstraints: BoxConstraints(
                                          maxHeight: getVerticalSize(52)),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Goal_Date_is_Important".tr;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),

                                /// Category
                                Padding(
                                    padding: getPadding(top: 20),
                                    child: Text("lbl_category".tr,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle.txtPJSm14.copyWith(
                                            letterSpacing:
                                                getHorizontalSize(0.07)))),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: DropdownButtonFormField<String>(
                                    value: _category,
                                    items: _dropdownItems.map((String value) {
                                      IconData icon;
                                      switch (value) {
                                        case 'Fun':
                                          icon = FontAwesomeIcons.gamepad;
                                          break;
                                        case 'Relations':
                                          icon = FontAwesomeIcons.faceGrin;
                                          break;
                                        case 'Mindfulness':
                                          icon = FontAwesomeIcons.brain;
                                          break;
                                        case 'Finances':
                                          icon =
                                              FontAwesomeIcons.moneyCheckDollar;
                                          break;
                                        case 'Skill':
                                          icon = Icons.fingerprint;
                                          break;
                                        case 'Health':
                                          icon = FontAwesomeIcons.heart;
                                          break;
                                        case 'Productivity':
                                        default:
                                          icon = Icons.rocket_launch_rounded;
                                          break;
                                      }
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(value,
                                                style:
                                                    HTextTheme.normalTextStyle),
                                            const SizedBox(
                                              width: 30,
                                            ),
                                            Icon(icon),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _category = newValue!;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      constraints: BoxConstraints.tight(
                                          const Size(double.infinity, 60)),
                                      filled: true,
                                      fillColor: ColorConstant.gray50,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorConstant
                                                .createButtonBorder),
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorConstant
                                                .createButtonBorder),
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: Colors.red),
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      errorStyle:
                                          const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ),

                                /// Categories option

                                /// Habit Time
                                Padding(
                                    padding: getPadding(top: 19),
                                    child: Text("lbl_habit_time".tr,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle.txtPJSm14.copyWith(
                                            letterSpacing:
                                                getHorizontalSize(0.07)))),

                                /// Habit Time Options
                                Padding(
                                  padding: getPadding(top: 7, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              habitTime = 'Morning';
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            side: BorderSide(
                                              color: habitTime == 'Morning'
                                                  ? ColorConstant.redA700
                                                  : ColorConstant
                                                      .createButtonBorder,
                                            ),
                                            backgroundColor:
                                                habitTime == 'Morning'
                                                    ? ColorConstant.redA700
                                                    : Colors.white,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(40),
                                              ),
                                            ),
                                          ).copyWith(),
                                          child: Text(
                                            'Morning'.tr,
                                            style: TextStyle(
                                              color: habitTime == 'Morning'
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              habitTime = 'Afternoon';
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            side: BorderSide(
                                              color: habitTime == 'Afternoon'
                                                  ? ColorConstant.redA700
                                                  : ColorConstant
                                                      .createButtonBorder,
                                            ),
                                            backgroundColor:
                                                habitTime == 'Afternoon'
                                                    ? ColorConstant.redA700
                                                    : Colors.white,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(40),
                                              ),
                                            ),
                                          ).copyWith(),
                                          child: Text(
                                            'Afternoon'.tr,
                                            style: TextStyle(
                                              color: habitTime == 'Afternoon'
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              habitTime = 'Night';
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            side: BorderSide(
                                              color: habitTime == 'Night'
                                                  ? ColorConstant.redA700
                                                  : ColorConstant
                                                      .createButtonBorder,
                                            ),
                                            backgroundColor:
                                                habitTime == 'Night'
                                                    ? ColorConstant.redA700
                                                    : Colors.white,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(40),
                                              ),
                                            ),
                                          ).copyWith(),
                                          child: Text(
                                            "Night".tr,
                                            style: TextStyle(
                                              color: habitTime == 'Night'
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15.0),
                                Text(
                                  'lbl_select_days'.tr,
                                  style: AppStyle.txtPJSm14.copyWith(
                                      letterSpacing: getHorizontalSize(0.07)),
                                ),
                                const SizedBox(height: 8.0),
                                Wrap(
                                  spacing: 8.0,
                                  children: _daysOfWeek.map((day) {
                                    return FilterChip(
                                      label: Text(day),
                                      selected: _selectedDays.contains(day),
                                      onSelected: (selected) {
                                        setState(() {
                                          if (selected) {
                                            _selectedDays.add(day);
                                          } else {
                                            _selectedDays.remove(day);
                                          }
                                          _selectedDaysError = null;
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                                Text(
                                  _selectedDaysError ?? '',
                                  style: const TextStyle(color: Colors.red),
                                ),

                                /// Task List
                                Padding(
                                    padding: getPadding(top: 19),
                                    child: Text("lbl_task_list".tr,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle.txtPJSm14.copyWith(
                                            letterSpacing:
                                                getHorizontalSize(0.07)))),

                                const SizedBox(height: 10.0),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.add),
                                  style: HOutlinedButtontheme.cancelTheme,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        String newTask = '';
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          content: TextField(
                                            autofocus: true,
                                            maxLines: null,
                                            onChanged: (value) {
                                              newTask = value;
                                            },
                                          ),
                                          actions: [
                                            OutlinedButton(
                                              style: HOutlinedButtontheme
                                                  .cancelTheme,
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            OutlinedButton(
                                              onPressed: () {
                                                setState(() {
                                                  subTasks.add(newTask);
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Add'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  label: Text("lbl_add_task".tr),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: subTasks.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      title: Text(subTasks[index]),
                                      trailing: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              subTasks.removeAt(index);
                                            });
                                          },
                                          icon: const Icon(Icons
                                              .remove_circle_outline_rounded)),
                                    );
                                  },
                                ),

                                /// Your Goal Behind This Habit
                                Text("msg_your_goal_behind".tr,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtPJSm14.copyWith(
                                        letterSpacing:
                                            getHorizontalSize(0.07))),
                                const SizedBox(height: 10.0),
                                CustomTextFormField(
                                  maxLines: 2,
                                  textInputType: TextInputType.multiline,
                                  controller: descriptionController,
                                  hintText: "lbl_type_here".tr,
                                  margin: getMargin(top: 0),
                                  padding: TextFormFieldPadding.PaddingAll15,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "What_keeps_you_going".tr;
                                    }
                                    return null;
                                  },
                                ),
                              ]))),
                  const SizedBox(
                    height: 20.0,
                  ),
                  CustomButton(
                    height: getVerticalSize(56),
                    width: getHorizontalSize(327),
                    text: "lbl_create".tr,
                    margin: getMargin(bottom: 3),
                    onTap: () async => await onTapCreate(),
                    alignment: Alignment.bottomCenter,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Displays a dialog with the [HabitCreatedDialog] content.
  ///
  /// The [HabitCreatedDialog] widget is created with a new
  /// instance of the [HabitCreatedController],
  /// which is obtained using the Get.put() method.
  onTapCreate() async {
    if (_selectedDays.isEmpty) {
      setState(() {
        _selectedDaysError = 'Please select at least one day';
      });
    } else if (_habitCreateFormKey.currentState!.validate()) {
      _habitCreateFormKey.currentState!.save();
      final name = nameController.text;
      final description = descriptionController.text;
      await habitController.addHabit(name, goalDate, _category, habitTime,
          _selectedDays, subTasks, description);
      nameController.clear();
      descriptionController.clear();

      Get.dialog(const AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.only(left: 0),
        content: HabitCreatedDialog(),
      ));
    } else {
      Get.snackbar("Error", "Habit Creation failed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
          colorText: const Color.fromARGB(255, 255, 255, 255));
    }
  }
}
