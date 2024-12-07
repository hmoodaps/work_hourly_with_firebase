import 'package:flutter/material.dart';

import '../../../app/components/constants/general_strings.dart';
import '../../../data/local_storage/shared_local.dart';
import '../../../data/user_model/note_model.dart';
import '../../../data/user_model/work_day_moodel.dart';
import '../../base_view_model/base_view_model.dart';
import '../../cubit/cubit_class.dart';

class ArchiveModelView extends BaseViewModel {
  late CubitClass cubit;
  BuildContext context;

  late TextEditingController hourlyRateController;

  late TextEditingController noteTextController = TextEditingController();

  late TextEditingController noteMoneyController = TextEditingController();

  late NoteModel noteModel;
  late double hourlyRate;
  late String yourWorkTodayText;
  late String startOrEndWork;

  ArchiveModelView(this.context);

  @override
  void dispose() {}

  @override
  Future<void> start() async {
    cubit = CubitClass.get(context);
    await cubit.getArchivedDate();
    double hourlyRateControllerText =
        SharedPref.prefs.getDouble(GeneralStrings.hourlyRate) ?? 9;

    yourWorkTodayText =
        "${cubit.selectedDay.day == DateTime.now().day && cubit.selectedDay.month == DateTime.now().month && cubit.selectedDay.year == DateTime.now().year ? GeneralStrings.yourWorkToday(context) : "${cubit.selectedDay.day}-${cubit.selectedDay.month}-${cubit.selectedDay.year}"}";
    startOrEndWork = cubit.isWorking
        ? GeneralStrings.endWork(context)
        : GeneralStrings.startWork(context);
    hourlyRateController =
        TextEditingController(text: hourlyRateControllerText.toString());
    hourlyRate = 0;
    noteModel = NoteModel(noteType: '', description: '', amount: 0);
  }

  String selectedBonusOrDiscount = '';

  void updateBonusOrDiscount(String value) {
    selectedBonusOrDiscount = value;
    cubit.updateBonusOrDiscount();
  }

  void onSaveInBottomSheetPressed(WorkDayModel workDayModel) {
    try {
      double hourlyRate = 0;
      try {
        hourlyRate = double.parse(hourlyRateController.text);
      } catch (e) {
        print('Error parsing hourly rate: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid hourly rate format')),
        );
      }

      WorkDayModel updatedWorkDayModel = WorkDayModel(
        endTime: workDayModel.endTime,
        startTime: workDayModel.startTime,
        id: workDayModel.id,
        notes: NoteModel(
          noteType: selectedBonusOrDiscount.isNotEmpty
              ? selectedBonusOrDiscount
              : workDayModel.notes!.noteType,
          description: noteTextController.text,
          amount: noteMoneyController.text.isEmpty
              ? 0
              : double.parse(noteMoneyController.text),
        ),
        hourlyRate: hourlyRate,
        archived: workDayModel.archived,
        totalMinutes: workDayModel.totalMinutes,
        totalHours: workDayModel.totalHours,
      );

      cubit.updateItem(updatedWorkDayModel);
      Navigator.pop(context);
    } catch (e) {
      print('Error parsing date: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error parsing date: $e')),
      );
    }
  }

  void handleOptionSelection(String option) {
    if (option == 'Bonus') {
      cubit.onBonusOrDiscountPress(true);
    } else if (option == 'Discount') {
      cubit.onBonusOrDiscountPress(false);
    }
  }

  onCancelButtonPress() {
    Navigator.pop(context);
  }
}
