import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_hourly/app/components/constants/general_strings.dart';
import 'package:work_hourly/app/components/constants/icons_manager.dart';
import 'package:work_hourly/app/components/constants/size_manager.dart';
import 'package:work_hourly/presentation/cubit/app_states.dart';
import 'package:work_hourly/presentation/cubit/cubit_class.dart';
import 'package:work_hourly/presentation/routes_and_views/history/history_model.dart';

import '../../../domain/local_models/models/models.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  late HistoryModelView _model;

  @override
  void initState() {
    super.initState();
    _model = HistoryModelView(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _model.start();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitClass, AppStates>(
      builder: (context, state) {
        CubitClass cubit = CubitClass.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(GeneralStrings.history(context)),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  cubit.getDate(date: cubit.selectedDay);
                },
                icon: IconsManager.arrowBack),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(SizeManager.d20),
              child: ConditionalBuilder(
                condition: cubit.workDays.isNotEmpty,
                builder: (context) => ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => SizedBox(
                    height: 20,
                  ),
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: cubit.workDays.length,
                  itemBuilder: (context, index) => WorkItemWidget(
                    onEditTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => FlexibleBottomSheet(
                                bonusOrDiscount: (value) {
                                  _model.updateBonusOrDiscount(
                                      value); // تحديث القيمة عند التبديل
                                },
                                hourlyRateController:
                                    _model.hourlyRateController,
                                isBonus: _model.cubit.isBonus!,
                                onBonusPressed: () {
                                  _model.handleOptionSelection('Bonus');
                                },
                                onDiscountPressed: () {
                                  _model.handleOptionSelection('Discount');
                                },
                                onSavePressed: () {
                                  _model.onSaveInBottomSheetPressed(
                                      _model.cubit.workDays[index]);
                                },
                                onCancelPressed: () {
                                  _model.onCancelButtonPress();
                                },
                                workModel: _model.cubit.workDays[index],
                                noteAmountController:
                                    _model.noteMoneyController,
                                noteDescriptionController:
                                    _model.noteTextController,
                              ));
                    },
                    workModel: cubit.workDays[index],
                    index: index,
                    cubit: cubit,
                  ),
                ),
                fallback: (context) => Center(
                    child: Text(GeneralStrings.noWorkInThisDay(context))),
              ),
            ),
          ),
        );
      },
    );
  }
}
