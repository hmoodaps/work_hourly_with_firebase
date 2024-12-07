import 'package:work_hourly/data/user_model/salary_model.dart';
import 'package:work_hourly/data/user_model/work_day_moodel.dart';

// UserModel represents the user with work details included
class UserModel {
  String userId; // User ID from Firebase Auth
  String email; // User's email address
  List<WorkDayModel> workDays; // List of work day details
  List<SalaryModel> salaries; // List of salary records for the user

  UserModel({
    required this.userId,
    required this.email,
    this.workDays = const [],
    this.salaries = const [],
  });

  // Convert UserModel to JSON for Firebase storage
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'workDays': workDays.map((work) => work.toJson()).toList(),
      'salaries': salaries.map((salary) => salary.toJson()).toList(),
    };
  }

  // Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      email: json['email'],
      workDays: (json['workDays'] as List<dynamic>?)
              ?.map((item) => WorkDayModel.fromJson(item))
              .toList() ??
          [],
      salaries: (json['salaries'] as List<dynamic>?)
              ?.map((item) => SalaryModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}
