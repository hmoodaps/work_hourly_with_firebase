import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:work_hourly/app/components/constants/color_manager.dart';
import 'package:work_hourly/app/components/constants/font_manager.dart';
import 'package:work_hourly/app/components/constants/general_strings.dart';
import 'package:work_hourly/presentation/cubit/app_states.dart';
import 'package:work_hourly/presentation/cubit/cubit_class.dart';

import '../../../data/user_model/salary_model.dart';

class SalariesView extends StatefulWidget {
  const SalariesView({super.key});

  @override
  State<SalariesView> createState() => _SalariesViewState();
}

class _SalariesViewState extends State<SalariesView> {
  List<SalaryModel> salaries = [];
  DateTime? startDate;
  DateTime? endDate;

  Future<void> _selectDates(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      confirmText: 'Start Date',
    ).then(
      (value) async {
        if (value != null) {
          setState(() {
            startDate = value;
          });
          await showDatePicker(
            context: context,
            initialDate: endDate ?? startDate!,
            firstDate: startDate!,
            lastDate: DateTime.now(),
            confirmText: 'End Date',
          ).then((value) {
            if (value != null) {
              setState(() {
                endDate = value;
              });
            }
          });
        }
        ;
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitClass, AppStates>(builder: (context, state) {
      CubitClass cubit = CubitClass.get(context);
      return Scaffold(
          appBar: AppBar(
            title: Text(
              GeneralStrings.salary(context),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  _selectDates(context).then((_) async {
                    try {
                      this.salaries.add(await cubit.calculateSalary(
                          startDate: startDate!,
                          endDate: endDate!,
                          paymentDate: DateTime.now()));
                    } catch (e) {
                      print("error after _selectDates $e");
                    }
                  });
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
          body: ConditionalBuilder(
            condition: cubit.salaries.isNotEmpty,
            builder: (context) => ListView.separated(
                itemBuilder: (context, index) =>
                    _salaryItem(cubit.salaries[index], index , cubit),
                reverse: true,
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                itemCount: cubit.salaries.length),
            fallback: (context) =>
                Center(child: Text('there is nothing here yet')),
          ));
    });
  }

  Widget _salaryItem(SalaryModel salary, int index , CubitClass cubit) {
    String formattedStartDate =
        DateFormat('dd MMM yyyy').format(salary.startDate);
    String formattedEndDate = DateFormat('dd MMM yyyy').format(salary.endDate);
    String formattedPaymentDate =
        DateFormat('dd MMM yyyy HH:mm:ss').format(salary.paymentDate);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: ColorManager.green2,
            child: Center(
              child: Text(
                "${index + 1}",
                style: TextStyleManager.header(context)
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: GestureDetector(
              onTap: () {
                cubit.onItemExpanded(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                height: cubit.expandedItem == index
                    ? MediaQuery.of(context).size.height / 3.3
                    : MediaQuery.of(context).size.height / 7.5,

                decoration: BoxDecoration(
                  color: ColorManager.green2,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('From: ',
                              style: TextStyleManager.titleStyle(context)
                                  ?.copyWith(color: Colors.white)),
                          Text(formattedStartDate,
                              style: TextStyleManager.titleStyle(context)
                                  ?.copyWith(color: Colors.white)),
                          Spacer(),
                          Text('To: ',
                              style: TextStyleManager.titleStyle(context)
                                  ?.copyWith(color: Colors.white)),
                          Text(formattedEndDate,
                              style: TextStyleManager.titleStyle(context)
                                  ?.copyWith(color: Colors.white)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text('Base Salary: ',
                              style: TextStyleManager.titleStyle(context)
                                  ?.copyWith(color: Colors.white)),
                          Text("${salary.baseSalary.toStringAsFixed(2)}",
                              style: TextStyleManager.titleStyle(context)
                                  ?.copyWith(color: Colors.white)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text('Salary to Pay: ',
                              style: TextStyleManager.titleStyle(context)
                                  ?.copyWith(color: Colors.white)),
                          Text("${salary.totalPay.toStringAsFixed(2)}",
                              style: TextStyleManager.titleStyle(context)
                                  ?.copyWith(color: Colors.white)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Visibility(
                          visible: cubit.expandedItem == index,
                          child: _onExpandedItems(salary, formattedPaymentDate)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onExpandedItems(SalaryModel salary, formattedPaymentDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Payment Date: ',
                style: TextStyleManager.titleStyle(context)
                    ?.copyWith(color: Colors.white)),
            Text(formattedPaymentDate,
                style: TextStyleManager.titleStyle(context)
                    ?.copyWith(color: Colors.white)),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text('Total Hours: ',
                style: TextStyleManager.titleStyle(context)
                    ?.copyWith(color: Colors.white)),
            Text("${salary.totalHours.toStringAsFixed(2)}",
                style: TextStyleManager.titleStyle(context)
                    ?.copyWith(color: Colors.white)),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text('Total Bonuses: ',
                style: TextStyleManager.titleStyle(context)
                    ?.copyWith(color: Colors.white)),
            Text("${salary.totalBonuses.toStringAsFixed(2)}",
                style: TextStyleManager.titleStyle(context)
                    ?.copyWith(color: Colors.white)),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text('Total Deductions: ',
                style: TextStyleManager.titleStyle(context)
                    ?.copyWith(color: Colors.white)),
            Text("${salary.totalDeductions.toStringAsFixed(2)}",
                style: TextStyleManager.titleStyle(context)
                    ?.copyWith(color: Colors.white)),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text('Total Days: ',
                style: TextStyleManager.titleStyle(context)
                    ?.copyWith(color: Colors.white)),
            Text("${salary.days.toStringAsFixed(2)}",
                style: TextStyleManager.titleStyle(context)
                    ?.copyWith(color: Colors.white)),
          ],
        ),
      ],
    );
  }
}
