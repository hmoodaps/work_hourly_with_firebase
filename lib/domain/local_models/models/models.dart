import 'package:flutter/material.dart';
import 'package:staggered_animated_widget/staggered_animated_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:work_hourly/app/components/constants/icons_manager.dart';

import '../../../app/components/constants/color_manager.dart';
import '../../../app/components/constants/font_manager.dart';
import '../../../app/components/constants/general_strings.dart';
import '../../../app/components/constants/size_manager.dart';
import '../../../app/components/constants/text_form_manager.dart';
import '../../../app/handle_app_language/handle_app_language.dart';
import '../../../data/user_model/work_day_moodel.dart';
import '../../../presentation/cubit/cubit_class.dart';

class CreateUserRequirements {
  String? password;
  String? email;
  String? fullName;

  CreateUserRequirements({
    this.password,
    this.email,
    this.fullName,
  });

  Map<String, dynamic> toMap() {
    return {
      'password': password,
      'email': email,
      'fullName': fullName,
    };
  }

  factory CreateUserRequirements.fromMap(Map<String, dynamic> map) {
    return CreateUserRequirements(
      password: map['password'],
      email: map['email'],
      fullName: map['fullName'],
    );
  }
}

bool toNextField(BuildContext context) {
  return FocusScope.of(context).nextFocus();
}

validator(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return GeneralStrings.fieldRequired(context);
  }
  return null;
}

Widget myCalender(CubitClass cubit) => TableCalendar(
      firstDay: DateTime.utc(2024, 10, 16),
      lastDay: DateTime.now(),
      focusedDay: cubit.focusedDay,
      calendarStyle: CalendarStyle(
        disabledTextStyle: TextStyle(
          color: Colors.grey.shade600,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
      ),
      selectedDayPredicate: (day) {
        return isSameDay(cubit.selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        cubit.onCalenderDaySelected(selectedDay, focusedDay);
      },
      enabledDayPredicate: (day) {
        return day.isBefore(DateTime.now().add(Duration(days: 1)));
      },
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
      ),
    );

class LanguageSelector extends StatelessWidget {
  final CubitClass cubit;

  LanguageSelector(this.cubit);

  final Map<String, String> languages = {
    'en': 'English',
    'ar': 'Arabic',
    'tr': 'Turkish',
    'nl': 'Dutch',
  };

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      // Set the value based on TheAppLanguage.appLanguage
      value: TheAppLanguage.appLanguage,
      onChanged: (String? newLanguage) {
        if (newLanguage != null) {
          cubit.changeLanguage(changeLanguage(
              newLanguage)); // Change the language using the cubit
        }
      },
      items: languages.entries.map<DropdownMenuItem<String>>((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
    );
  }

  AppLanguage changeLanguage(String newLanguage) {
    switch (newLanguage) {
      case 'en':
        return ApplicationLanguage.en.appLanguage;
      case 'tr':
        return ApplicationLanguage.tr.appLanguage;
      case 'nl':
        return ApplicationLanguage.nl.appLanguage;
      case 'ar':
        return ApplicationLanguage.ar.appLanguage;
      default:
        return ApplicationLanguage.en.appLanguage;
    }
  }
}

class WorkItemWidget extends StatefulWidget {
  final WorkDayModel workModel;
  final int index;
  final CubitClass cubit;
  final VoidCallback onEditTap;

  const WorkItemWidget({
    Key? key,
    required this.workModel,
    required this.onEditTap,
    required this.index,
    required this.cubit,
  }) : super(key: key);

  @override
  State<WorkItemWidget> createState() => _WorkItemWidgetState();
}

class _WorkItemWidgetState extends State<WorkItemWidget> {
  @override
  Widget build(BuildContext context) {
    final workModel = widget.workModel;
    final index = widget.index;
    final cubit = widget.cubit;

    return Dismissible(
        key: ValueKey(index),
        direction: DismissDirection.horizontal,
        background: _getDismissBackground(DismissDirection.startToEnd),
        secondaryBackground: _getDismissBackground(DismissDirection.endToStart),
        // Background for swipe right
        confirmDismiss: (direction) =>
            _confirmDismiss(direction, cubit, workModel),
        child: _getItem(cubit: cubit, index: index, workModel: workModel));
  }

  Widget _getItem({
    required WorkDayModel workModel,
    required int index,
    required CubitClass cubit,
  }) =>
      GestureDetector(
        onTap: () {
          cubit.onItemExpanded(index);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            padding: EdgeInsets.all(SizeManager.d14),
            color: ColorManager.green4,
            height: cubit.expandedItem == index
                ? (workModel.notes != null &&
                        workModel.notes!.noteType.isNotEmpty)
                    ? MediaQuery.of(context).size.height / 3
                    : MediaQuery.of(context).size.height / 4
                : MediaQuery.of(context).size.height / 7,
            width: MediaQuery.of(context).size.width - 50,
            duration: const Duration(milliseconds: 600),
            onEnd: () {
              cubit.onAnimationComplete(index);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 10),
                _buildDates(context, workModel),
                const SizedBox(height: 10),
                if (cubit.isAnimationComplete(index))
                  Visibility(
                    visible: cubit.expandedItem == index,
                    child: Row(
                      children: [
                        _buildExpandedDetails(workModel),
                        Spacer(),
                        GestureDetector(
                            onTap: widget.onEditTap,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20,
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(Icons.edit),
                              ),
                            )),
                      ],

                      // اول اشي بدنا نفوت ع المودل تبع المين نسحب كل الاون بريس فيها ونخلي اللبوتوم شيت عام عشاننقدر نعدل العنصر ونطلع البوتوم شيت لبرا عشان اقدر اوصل له من برا من الهيستوري والارشيف
                      //   وبعدين نسوي الرواتب .. وبعدي
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            GeneralStrings.startDetail(context),
            style: TextStyleManager.titleStyle(context),
          ),
        ),
        const Spacer(),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            GeneralStrings.endDetail(context),
            style: TextStyleManager.titleStyle(context),
          ),
        ),
      ],
    );
  }

  Widget _buildDates(BuildContext context, WorkDayModel workModel) {
    return Row(
      children: [
        Column(
          children: [
            Text(
              '${workModel.startTime!.day}/${workModel.startTime!.month}/${workModel.startTime!.year}',
              style: TextStyleManager.titleStyle(context)
                  ?.copyWith(color: Colors.white),
            ),
            SizedBox(height: SizeManager.d10),
            Text(
              '${workModel.startTime!.hour} : ${workModel.startTime!.minute} : ${workModel.startTime!.second}',
              style: TextStyleManager.titleStyle(context)
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
        const Spacer(),
        Column(
          children: [
            Text(
              '${workModel.endTime?.day ?? '-'}'
              '/${workModel.endTime?.month ?? '-'}'
              '/${workModel.endTime?.year ?? '-'}',
              style: TextStyleManager.titleStyle(context)
                  ?.copyWith(color: Colors.white),
            ),
            SizedBox(height: SizeManager.d10),
            Text(
              '${workModel.endTime?.hour ?? '-'} : ${workModel.endTime?.minute ?? '-'} : ${workModel.endTime?.second ?? '-'}',
              style: TextStyleManager.titleStyle(context)
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpandedDetails(WorkDayModel workModel) {
    return Column(
      children: [
        _buildRowDetail(
          GeneralStrings.hourlyRateText(context),
          workModel.hourlyRate.toString(),
        ),
        SizedBox(height: SizeManager.d10),
        _buildRowDetail(
          GeneralStrings.totalHours(context),
          workModel.totalHours.toString(),
        ),
        SizedBox(height: SizeManager.d10),
        _buildRowDetail(
          GeneralStrings.totalMinutes(context),
          workModel.totalMinutes.toString(),
        ),
        if (workModel.notes != null &&
            workModel.notes!.noteType.isNotEmpty) ...[
          SizedBox(height: SizeManager.d10),
          _buildNoteDetails(workModel),
        ],
      ],
    );
  }

  Widget _buildRowDetail(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyleManager.titleStyle(context),
        ),
        const SizedBox(width: 5),
        Text(
          value,
          style: TextStyleManager.titleStyle(context)
              ?.copyWith(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildNoteDetails(WorkDayModel workModel) {
    return Column(
      children: [
        _buildRowDetail(
          GeneralStrings.notes(context),
          workModel.notes!.noteType,
        ),
        SizedBox(height: SizeManager.d10),
        _buildRowDetail(
          GeneralStrings.noteDescription(context),
          workModel.notes!.description,
        ),
        SizedBox(height: SizeManager.d10),
        _buildRowDetail(
          GeneralStrings.noteMoney(context),
          workModel.notes!.amount.toString(),
        ),
      ],
    );
  }

  Widget _getDismissBackground(DismissDirection direction) {
    Color backgroundColor;
    IconData iconData;

    switch (direction) {
      case DismissDirection.endToStart:
        backgroundColor = Colors.red;
        iconData = Icons.delete;
        break;
      case DismissDirection.startToEnd:
        backgroundColor = Colors.green;
        iconData = Icons.archive;
        break;
      default:
        throw Exception('Unsupported dismiss direction: $direction');
    }

    return Container(
      color: backgroundColor,
      child: Align(
        alignment: direction == DismissDirection.endToStart
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmDismiss(DismissDirection direction, CubitClass cubit,
      WorkDayModel workModel) async {
    switch (direction) {
      case DismissDirection.endToStart:
        bool confirmDelete = await _confirmDelete();
        if (!confirmDelete) {
          return false;
        } else {
          cubit.deleteItem(workModel);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('تم حذف العنصر بنجاح!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ));
          return true;
        }
      case DismissDirection.startToEnd:
        cubit.addOrRemoveArchive(workModel);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم أرشفة العنصر بنجاح!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        return true;
      default:
        return true;
    }
  }

  Future<bool> _confirmDelete() async {
    // Implement optional confirmation logic (e.g., dialog)
    // return true to dismiss, false to cancel
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: Text("Are you sure you want to delete?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }
}

class DynamicSwitch extends StatefulWidget {
  final String type;
  final Function(String) onSwitchChanged; // إضافة callback هنا

  DynamicSwitch({required this.type, required this.onSwitchChanged});

  @override
  _DynamicSwitchState createState() => _DynamicSwitchState();
}

class _DynamicSwitchState extends State<DynamicSwitch> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.type == "Bonus";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isActive ? "Bonus" : "Discount",
          style: TextStyle(
            fontSize: 16,
            color: isActive ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Switch(
          value: isActive,
          activeColor: Colors.green,
          inactiveThumbColor: Colors.red,
          inactiveTrackColor: Colors.red.withOpacity(0.5),
          onChanged: (value) {
            setState(() {
              isActive = value;
            });

            // عندما يتغير التبديل، قم بإرجاع القيمة عبر الـ callback
            widget.onSwitchChanged(isActive ? "Bonus" : "Discount");
          },
        ),
      ],
    );
  }
}

class FlexibleBottomSheet extends StatefulWidget {
  final WorkDayModel workModel;
  final VoidCallback onBonusPressed;
  final VoidCallback onDiscountPressed;
  final VoidCallback onSavePressed;
  final VoidCallback onCancelPressed;
  final TextEditingController hourlyRateController;
  final TextEditingController noteDescriptionController;
  final TextEditingController noteAmountController;
  final Function(String) bonusOrDiscount;
  final bool? isBonus;

  const FlexibleBottomSheet({
    Key? key,
    required this.workModel,
    required this.onBonusPressed,
    required this.bonusOrDiscount,
    required this.onDiscountPressed,
    required this.onSavePressed,
    required this.onCancelPressed,
    required this.hourlyRateController,
    required this.isBonus,
    required this.noteAmountController,
    required this.noteDescriptionController,
  }) : super(key: key);

  @override
  State<FlexibleBottomSheet> createState() => _FlexibleBottomSheetState();
}

class _FlexibleBottomSheetState extends State<FlexibleBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      onPressed: widget.onSavePressed,
                      child: Text('Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: ElevatedButton(
                      onPressed: widget.onCancelPressed,
                      child: Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            StaggeredAnimatedWidget(
              delay: SizeManager.i200,
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 20, left: 20, top: 20, bottom: 10),
                child: Text(
                  GeneralStrings.hourlyRateText(context),
                  style: TextStyleManager.titleStyle(context),
                ),
              ),
            ),
            StaggeredAnimatedWidget(
              delay: SizeManager.i400,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: textFormField(
                  keyboardType: TextInputType.number,
                  fillColor: ColorManager.primary,
                  filled: true,
                  controller: widget.hourlyRateController,
                  prefix: Icon(IconsManager.dolar),
                  onFieldSubmitted: (p0) => toNextField,
                  validator: (p0) => validator(p0, context),
                  context: context,
                ),
              ),
            ),
            StaggeredAnimatedWidget(
              delay: SizeManager.i600,
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 20, left: 20, top: 20, bottom: 10),
                child: Text(
                  'Notes : ',
                  style: TextStyleManager.titleStyle(context),
                ),
              ),
            ),
            widget.workModel.notes!.noteType == ''
                ? StaggeredAnimatedWidget(
                    delay: SizeManager.i600,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: widget.onBonusPressed,
                            icon: Icon(Icons.add, color: Colors.white),
                            label: Text('Bonus'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: widget.onDiscountPressed,
                            icon: Icon(Icons.remove, color: Colors.white),
                            label: Text('Discount'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : StaggeredAnimatedWidget(
                    delay: SizeManager.i600,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: DynamicSwitch(
                        type: widget.workModel.notes!.noteType,
                        onSwitchChanged: (value) =>
                            widget.bonusOrDiscount(value),
                      ),
                    ),
                  ),
            Visibility(
                visible: widget.isBonus != null ||
                    widget.workModel.notes!.noteType != '',
                child: _notesColumn(context)),
            SizedBox(
              height: SizeManager.d30,
            ),
          ],
        ),
      ),
    );
  }

  Column _notesColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StaggeredAnimatedWidget(
          delay: SizeManager.i600,
          child: Padding(
            padding:
                const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
            child: Text(
              GeneralStrings.notes(context),
              style: TextStyleManager.titleStyle(context),
            ),
          ),
        ),
        StaggeredAnimatedWidget(
          delay: SizeManager.i800,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: textFormField(
              keyboardType: TextInputType.text,
              fillColor: ColorManager.primary,
              filled: true,
              controller: widget.noteDescriptionController,
              prefix: Icon(IconsManager.note),
              onFieldSubmitted: (p0) => toNextField,
              validator: (p0) => validator(p0, context),
              context: context,
            ),
          ),
        ),
        StaggeredAnimatedWidget(
          delay: SizeManager.i1000,
          child: Padding(
            padding:
                const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
            child: Text(
              GeneralStrings.noteMoney(context),
              style: TextStyleManager.titleStyle(context),
            ),
          ),
        ),
        StaggeredAnimatedWidget(
          delay: SizeManager.i1200,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: textFormField(
              keyboardType: TextInputType.number,
              fillColor: ColorManager.primary,
              filled: true,
              controller: widget.noteAmountController,
              prefix: Icon(IconsManager.dolar),
              onFieldSubmitted: (p0) => toNextField,
              validator: (p0) => validator(p0, context),
              context: context,
            ),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
