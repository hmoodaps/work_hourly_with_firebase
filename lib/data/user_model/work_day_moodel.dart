import 'package:uuid/uuid.dart';
import 'note_model.dart';

class WorkDayModel {
  DateTime? startTime; // Start time of the workday
  DateTime? endTime; // End time of the workday
  String id; // Use UUID for a persistent ID
  double? hourlyRate; // Hourly rate for the workday
  bool? archived; // Archived status of the workday
  double? totalHours; // Total hours worked
  double? totalMinutes; // Total minutes worked
  NoteModel? notes; // Single note for the workday
  double salary = 0.0; // New field to store calculated salary

  WorkDayModel({
    this.startTime,
    this.endTime,
    String? id,
    this.hourlyRate,
    this.archived = false, // Default to false if not provided
    this.totalHours = 0,
    this.totalMinutes = 0,
    this.notes,
  }) : id = id ?? Uuid().v4() {
    // Calculate salary when the object is initialized
    calculateSalary();
  }

  // Method to calculate salary based on total hours and minutes
  void calculateSalary() {
    if (hourlyRate != null) {
      double adjustedHours = totalHours ?? 0;
      double minutes = totalMinutes ?? 0;

      // Add half an hour if minutes >= 30
      if (minutes >= 30) {
        adjustedHours += 0.5;
      }

      salary = adjustedHours * hourlyRate!;
    }
  }

  // Convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'id': id,
      'hourlyRate': hourlyRate,
      'archived': archived, // Include archived status
      'totalHours': totalHours,
      'totalMinutes': totalMinutes,
      'notes': notes?.toJson(), // Ensure NoteModel has a toJson method
      'salary': salary, // Include salary in JSON
    };
  }

  // Create a WorkDayModel from JSON
  factory WorkDayModel.fromJson(Map<String, dynamic> json) {
    return WorkDayModel(
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      id: json['id'],
      hourlyRate: json['hourlyRate'],
      archived: json['archived'] ?? false, // Default to false if not present
      totalHours: json['totalHours'],
      totalMinutes: json['totalMinutes'],
      notes: json['notes'] != null ? NoteModel.fromJson(json['notes']) : null,
    )..calculateSalary(); // Ensure salary is recalculated after initialization
  }
}
