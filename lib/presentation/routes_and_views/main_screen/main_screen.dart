import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:work_hourly/app/components/constants/color_manager.dart';
import 'package:work_hourly/app/components/constants/font_manager.dart';
import 'package:work_hourly/app/components/constants/general_strings.dart';
import 'package:work_hourly/data/local_storage/shared_local.dart';
import 'package:work_hourly/domain/local_models/models/models.dart';
import 'package:work_hourly/presentation/routes_and_views/main_screen/main_screen_model_view.dart';

import '../../cubit/app_states.dart';
import '../../cubit/cubit_class.dart';

class MainScreen extends StatefulWidget {
  final ZoomDrawerController zoomDrawerController;

  const MainScreen({Key? key, required this.zoomDrawerController})
      : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MainScreenModelView _model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _model.start();
  }

  @override
  void dispose() {
    super.dispose();
    _model.dispose();
  }

  @override
  void initState() {
    super.initState();
    _model = MainScreenModelView(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitClass, AppStates>(
        builder: (context, state) {
          return _getScaffold();
        },
        listener: (context, state) {});
  }

  Widget _getScaffold() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            widget.zoomDrawerController.toggle!();
          },
        ),
        title: Text(
          GeneralStrings.myWorkTracker,
          style: TextStyleManager.header(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              myCalender(_model.cubit),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_model.cubit.isWorking) {
                    _model.startOrEndWork = GeneralStrings.startWork(context);
                    _model.onSaveButtonPressed();
                  } else {
                    _model.startOrEndWork = GeneralStrings.endWork(context);
                    _model.cubit.startWork();
                  }
                },
                child: Text(_model.startOrEndWork),
              ),
              Visibility(
                visible: _model.cubit.isWorking,
                child: _isWorkingBox(),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    _model.yourWorkTodayText,
                    style: TextStyleManager.titleStyle(context),
                  )),
              Container(
                color: Colors.black,
                height: 1,
                width: double.infinity,
              ),
              SizedBox(
                height: 20,
              ),
              ConditionalBuilder(
                condition: _model.cubit.workDays.isNotEmpty,
                builder: (context) => ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => SizedBox(
                    height: 20,
                  ),
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: _model.cubit.workDays.length,
                  itemBuilder: (context, index) => WorkItemWidget(
                    workModel: _model.cubit.workDays[index],
                    onEditTap: () async {
                      _model.clearControllers();
                      print('1');
                      await showModalBottomSheet(
                        context: context,
                        builder: (context) => FlexibleBottomSheet(
                          bonusOrDiscount: (value) {
                            _model.updateBonusOrDiscount(
                                value); // تحديث القيمة عند التبديل
                          },
                          hourlyRateController: _model.hourlyRateController,
                          isBonus: _model.cubit.isBonus,
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
                          noteAmountController: _model.noteMoneyController,
                          noteDescriptionController: _model.noteTextController,
                        ),
                      );
                    },
                    index: index,
                    cubit: _model.cubit,
                  ),
                ),
                fallback: (context) =>
                    Text(GeneralStrings.noWorkInThisDay(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _isWorkingBox() {
    String startTime = SharedPref.prefs.getString(GeneralStrings.startTime) ??
        DateTime.now().toString();
    DateTime startDateTime = DateTime.parse(startTime);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
          color: ColorManager.green4,
          height: 120,
          width: MediaQuery.of(context).size.width - 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        GeneralStrings.startDetail(context),
                        style: TextStyleManager.titleStyle(context),
                      ),
                    ),
                    Spacer(),
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 8,
                    ),
                    SizedBox(width: 5),
                    Text(
                      GeneralStrings.working(context),
                      style: TextStyleManager.titleStyle(context)
                          ?.copyWith(color: Colors.green),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '${startDateTime.day}/${startDateTime.month}/${startDateTime.year}',
                  style: TextStyleManager.titleStyle(context)
                      ?.copyWith(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '${startDateTime.hour} : ${startDateTime.minute} : ${startDateTime.second}',
                  style: TextStyleManager.titleStyle(context)
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ],
          )),
    );
  }
}
