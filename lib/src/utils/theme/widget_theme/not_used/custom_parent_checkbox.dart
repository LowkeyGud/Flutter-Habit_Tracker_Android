import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habittracker/src/app_export.dart';
import 'package:habittracker/src/utils/theme/widget_theme/outlined_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

///Main widget of Parent Child Checkbox.
///Parent Child Checkbox is a type of checkbox where we can establish hierarchy in Checkboxes.
class ParentChildCheckbox extends StatefulWidget {
  ///Default constructor of ParentChildCheckbox
   ParentChildCheckbox({
    super.key,
    required this.parent,
    required this.children,
    this.parentCheckboxColor,
    this.childrenCheckboxColor,
    this.parentCheckboxScale,
    this.childrenCheckboxScale,
    this.gap,
    this.onCheckedChild,
    this.onCheckedParent,
    required this.childrenValue,
    this.parentValue
  });

  bool? parentValue;
  List<bool> childrenValue;

  ///Text Widget to specify the Parent checkbox
  final Text? parent;

  ///List<Text> Widgets to specify the Children checkboxes
  final List<Text>? children;

  ///Color of Parent CheckBox
  ///
  /// By default the value of [CheckboxThemeData.fillColor]
  /// is used. If that is also null, then [ThemeData.disabledColor] is used in
  /// the disabled state, [ColorScheme.secondary] is used in the
  /// selected state, and [ThemeData.unselectedWidgetColor] is used in the
  /// default state.
  final Color? parentCheckboxColor;

  ///Color of Parent CheckBox
  ///
  /// By default the value of [CheckboxThemeData.fillColor]
  /// is used. If that is also null, then [ThemeData.disabledColor] is used in
  /// the disabled state, [ColorScheme.secondary] is used in the
  /// selected state, and [ThemeData.unselectedWidgetColor] is used in the
  /// default state.
  final Color? childrenCheckboxColor;

  ///Scale of the Parent CheckBox
  ///
  /// Defaults to [1.0]
  final double? parentCheckboxScale;

  ///Scale of the Children CheckBox
  ///
  /// Defaults to [1.0]
  final double? childrenCheckboxScale;

  ///Gap between the Parent and Children CheckBox
  ///
  /// Defaults to [10.0]
  final double? gap;

  ///Function that will be executed if a child will be selected
  ///
  final void Function(int index)? onCheckedChild;

  ///Function that will be executed if the parent will be selected
  ///
  final void Function()? onCheckedParent;

  /// Map which shows whether particular parent is selected or not.
  ///
  /// Example: {'Parent 1' : true, 'Parent 2' : false} where
  /// Parent 1 and Parent 2 will be 2 separate parents if you are using multiple ParentChildCheckbox in your code.
  ///
  /// Default value will be false for all specified parents
  static final Map<String?, bool?> _isParentSelected = {};

  /// Getter to get whether particular parent is selected or not.
  ///
  /// Example: {'Parent 1' : true, 'Parent 2' : false} where
  /// Parent 1 and Parent 2 will be 2 separate parents if you are using multiple ParentChildCheckbox in your code.
  ///
  /// Default value will be false for all specified parents
  static get isParentSelected => _isParentSelected;

  /// Map which shows which childrens are selected for a particular parent.
  ///
  /// Example: {'Parent 1' : ['Children 1.1','Children 1.2'], 'Parent 2' : []} where
  /// Parent 1 and Parent 2 will be 2 separate parents if you are using multiple ParentChildCheckbox in your code.
  ///
  /// Default value is {'Parent 1' : [], 'Parent 2' : []}
  static final Map<String?, List<String?>> _selectedChildrenMap = {};

  /// Getter to get which childrens are selected for a particular parent.
  ///
  /// Example: {'Parent 1' : ['Children 1.1','Children 1.2'], 'Parent 2' : []} where
  /// Parent 1 and Parent 2 will be 2 separate parents if you are using multiple ParentChildCheckbox in your code.
  ///
  /// Default value is {'Parent 1' : [], 'Parent 2' : []}
  static get selectedChildrens => _selectedChildrenMap;

  @override
  State<ParentChildCheckbox> createState() => _ParentChildCheckboxState();
}

class _ParentChildCheckboxState extends State<ParentChildCheckbox> {
  ///Default widget.parentValue set to false
  // bool? widget.parentValue = false;

  ///List of childrenValue which depicts whether checkbox is clicked or not
  // List<bool?> childrenValue = [];

  @override
  void initState() {
    super.initState();
    widget.childrenValue = List.filled(widget.children!.length, false);
    ParentChildCheckbox._selectedChildrenMap.addAll({widget.parent!.data: []});
    ParentChildCheckbox._isParentSelected.addAll({widget.parent!.data: false});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Transform.scale(
              scale: widget.parentCheckboxScale ?? 1.0,
              child: Checkbox(
                fillColor: MaterialStateProperty.all(ColorConstant.redA700),
                shape: const CircleBorder(),
                value: widget.parentValue,
                splashRadius: 0.0,
                activeColor: widget.parentCheckboxColor,
                onChanged: (value) => _parentCheckBoxClick(),
                tristate: true,
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            widget.parent!,
          ],
        ),
        SizedBox(
          height: widget.gap ?? 10.0,
        ),
        for (int i = 0; i < widget.children!.length; i++)
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Row(
              children: [
                Transform.scale(
                  scale: widget.childrenCheckboxScale ?? 1.0,
                  child: Checkbox(
                    fillColor: MaterialStateProperty.all(ColorConstant.redA700),
                    shape: const CircleBorder(),
                    splashRadius: 0.0,
                    activeColor: widget.childrenCheckboxColor,
                    value: widget.childrenValue[i],
                    onChanged: (value) => _childCheckBoxClick(i),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                widget.children![i],
              ],
            ),
          ),
      ],
    );
  }

  ///onClick method when particular children of index i is clicked
  void _childCheckBoxClick(int i) {
    final Function(int index)? onCheckedChild = widget.onCheckedChild;
    if (onCheckedChild != null) {
      onCheckedChild(i);
    }
    setState(() {
      widget.childrenValue[i] = !widget.childrenValue[i]!;
      if (!widget.childrenValue[i]!) {
        ParentChildCheckbox._selectedChildrenMap.update(widget.parent!.data,
            (value) {
          value.removeWhere((element) => element == widget.children![i].data);
          return value;
        });
      } else {
        ParentChildCheckbox._selectedChildrenMap.update(widget.parent!.data,
            (value) {
          value.add(widget.children![i].data);
          return value;
        });
      }
      _parentCheckboxUpdate();
    });
  }

  ///onClick method when particular parent is clicked
  void _parentCheckBoxClick() {
    final Function()? onCheckedParent = widget.onCheckedParent;
    if (onCheckedParent != null) {
      onCheckedParent();
    }

    if (widget.parentValue != null) {
      if (widget.parentValue == false) {
        Alert(
          style: const AlertStyle(isButtonVisible: false),
          context: context,
          // title: "C",
          content: Column(
            children: <Widget>[
              SvgPicture.asset(
                ImageConstant.question,
                color: ColorConstant.redA700,
                height: getVerticalSize(50),
              ),
              SizedBox(height: getHorizontalSize(20)),
              Text(
                "Have you completed this habit?",
                maxLines: null,
                textAlign: TextAlign.center,
                style: AppStyle.txtPJSm14Gray600.copyWith(
                  letterSpacing: getHorizontalSize(
                    0.07,
                  ),
                ),
              ),
              SizedBox(height: getHorizontalSize(20)),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: HOutlinedButtontheme.cancelTheme.copyWith(
                    side: MaterialStatePropertyAll(
                        BorderSide(color: ColorConstant.redA700))),
                child: const Text("Don't show this agian"),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    widget.parentValue = !widget.parentValue!;
                    ParentChildCheckbox._isParentSelected
                        .update(widget.parent!.data, (value) => widget.parentValue);
                    ParentChildCheckbox._selectedChildrenMap.addAll({
                      widget.parent!.data: [],
                    });
                    for (int i = 0; i < widget.children!.length; i++) {
                      widget.childrenValue[i] = widget.parentValue!;
                      if (widget.parentValue!) {
                        ParentChildCheckbox._selectedChildrenMap
                            .update(widget.parent!.data, (value) {
                          value.add(widget.children![i].data);
                          return value;
                        });
                      }
                    }
                    Navigator.pop(context);
                  });
                },
                // style: HOutlinedButtontheme.lo,
                child: Text(
                  " Yes! I have completed",
                  style: AppStyle.txtPJSm14Gray600.copyWith(
                    color: Colors.white,
                    letterSpacing: getHorizontalSize(0.07),
                  ),
                ),
              ),
            ],
          ),
        ).show();
      } else {
        setState(() {
          widget.parentValue = !widget.parentValue!;
          ParentChildCheckbox._isParentSelected
              .update(widget.parent!.data, (value) => widget.parentValue);
          ParentChildCheckbox._selectedChildrenMap.addAll({
            widget.parent!.data: [],
          });
          for (int i = 0; i < widget.children!.length; i++) {
            widget.childrenValue[i] = widget.parentValue!;
            if (widget.parentValue!) {
              ParentChildCheckbox._selectedChildrenMap
                  .update(widget.parent!.data, (value) {
                value.add(widget.children![i].data);
                return value;
              });
            }
          }
        });
      }
    } else {
      widget.parentValue = false;
      ParentChildCheckbox._isParentSelected
          .update(widget.parent!.data, (value) => widget.parentValue);
      ParentChildCheckbox._selectedChildrenMap
          .update(widget.parent!.data, (value) => []);
      for (int i = 0; i < widget.children!.length; i++) {
        widget.childrenValue[i] = false;
      }
    }
  }

  ///Method to update the Parent Checkbox based on the status of Child checkbox
  void _parentCheckboxUpdate() {
    setState(() {
      if (widget.childrenValue.contains(false) && widget.childrenValue.contains(true)) {
        widget.parentValue = null;
        ParentChildCheckbox._isParentSelected
            .update(widget.parent!.data, (value) => false);
      } else {
        Alert(
          style: const AlertStyle(isButtonVisible: false),
          context: context,
          // title: "C",
          content: Column(
            children: <Widget>[
              SvgPicture.asset(
                ImageConstant.question,
                color: ColorConstant.redA700,
                height: getVerticalSize(50),
              ),
              SizedBox(height: getHorizontalSize(20)),
              Text(
                "Have you completed this habit?",
                maxLines: null,
                textAlign: TextAlign.center,
                style: AppStyle.txtPJSm14Gray600.copyWith(
                  letterSpacing: getHorizontalSize(
                    0.07,
                  ),
                ),
              ),
              SizedBox(height: getHorizontalSize(20)),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: HOutlinedButtontheme.cancelTheme.copyWith(
                    side: MaterialStatePropertyAll(
                        BorderSide(color: ColorConstant.redA700))),
                child: const Text("Don't show this agian"),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    widget.parentValue = true;
                  });
                  Navigator.pop(context);
                },
                // style: HOutlinedButtontheme.lo,
                child: Text(
                  " Yes! I have completed",
                  style: AppStyle.txtPJSm14Gray600.copyWith(
                    color: Colors.white,
                    letterSpacing: getHorizontalSize(0.07),
                  ),
                ),
              ),
            ],
          ),
        ).show();
      }
    });
  }
}
