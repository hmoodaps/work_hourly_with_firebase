import 'package:uuid/uuid.dart';
import 'package:work_hourly/data/user_model/work_day_moodel.dart';

class SalaryModel {
  DateTime startDate;
  DateTime endDate;
  List<WorkDayModel> workDays;
  double totalHours = 0;
  int days ;
  String ?id ;
  double totalDeductions = 0;
  double totalBonuses = 0;
  double baseSalary = 0;
  double totalPay = 0;
  DateTime paymentDate;

  SalaryModel({
    required this.startDate,
    required this.days,
    required this.endDate,
    String? id,
    required this.workDays,
    required this.paymentDate,
  }) : id = id ?? Uuid().v4() {
    calculateSalaryDetails();
  }

  void calculateSalaryDetails() {
    totalHours = 0;
    totalDeductions = 0;
    totalBonuses = 0;
    baseSalary = 0;
    totalPay = 0;

    for (var day in workDays) {
      totalHours += day.totalHours ?? 0;
      if (day.notes != null && day.notes!.noteType == 'Bonus') {
        totalBonuses += day.notes!.amount;
      }
      if (day.notes != null && day.notes!.noteType == 'Discount') {
        totalDeductions += day.notes!.amount;
      }
      baseSalary += day.salary;
      totalPay = ((baseSalary + totalBonuses) - totalDeductions);
    }
  }

  // تحويل SalaryModel إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'workDays': workDays.map((work) => work.toJson()).toList(),
      'totalHours': totalHours,
      'days': days,
      'id': id,
      'totalDeductions': totalDeductions,
      'totalBonuses': totalBonuses,
      'baseSalary': baseSalary,
      'totalPay': totalPay,
      'paymentDate': paymentDate.toIso8601String(),
    };
  }

  // إنشاء SalaryModel من JSON
  factory SalaryModel.fromJson(Map<String, dynamic> json) {
    DateTime startDate = DateTime.parse(json['startDate']);
    DateTime endDate = DateTime.parse(json['endDate']);
    int days = endDate.difference(startDate).inDays; // حساب عدد الأيام

    return SalaryModel(
      startDate: startDate,
      endDate: endDate,
      days: days, // إضافة الأيام المحسوبة
      id: json['id'],
      workDays: (json['workDays'] as List<dynamic>)
          .map((item) => WorkDayModel.fromJson(item))
          .toList(),
      paymentDate: DateTime.parse(json['paymentDate']),
    )..calculateSalaryDetails(); // تأكد من حساب التفاصيل بعد التحميل.
  }
}
