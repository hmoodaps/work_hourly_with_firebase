import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:work_hourly/app/components/constants/general_strings.dart';
import 'package:work_hourly/domain/repositories/work_repository.dart';

import '../local_storage/shared_local.dart';
import '../user_model/note_model.dart';
import '../user_model/salary_model.dart';
import '../user_model/work_day_moodel.dart';

class WorkRepositoryImplementer implements WorkRepository {
  @override
  Future<void> startWork() async {
    DateTime startTime = DateTime.now();
    await SharedPref.prefs
        .setString(GeneralStrings.startTime, startTime.toIso8601String());
    await SharedPref.prefs.setBool(GeneralStrings.isWorking, true);
  }

  @override
  Future<void> stopWork(
      {required NoteModel noteModel, required double hourlyRate}) async {
    String? startTimeString =
        SharedPref.prefs.getString(GeneralStrings.startTime);
    if (startTimeString == null) {
      throw Exception(
          "Start time not found. Make sure work session has started.");
    }

    DateTime startTime = DateTime.parse(startTimeString);
    DateTime endTime = DateTime.now();

    double totalHours = 0.0;
    double totalMinutes = endTime.difference(startTime).inMinutes.toDouble();

    if (totalMinutes >= 60) {
      totalHours = endTime.difference(startTime).inHours.toDouble();
      totalMinutes =
          (endTime.difference(startTime).inMinutes - (totalHours * 60));
    }

    WorkDayModel workDay = WorkDayModel(
      startTime: startTime,
      endTime: endTime,
      totalHours: totalHours,
      totalMinutes: totalMinutes,
      hourlyRate: hourlyRate,
      notes: noteModel,
    );

    await _saveToFirebase(workDay: workDay);
    await SharedPref.prefs.remove(GeneralStrings.startTime);
    await SharedPref.prefs.setBool(GeneralStrings.isWorking, false);
  }

  @override
  Future<void> addFakeWorkDays() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

    // التأكد من وجود المستند الخاص بالمستخدم
    DocumentSnapshot docSnapshot = await userDoc.get();
    if (!docSnapshot.exists) {
      await userDoc.set({'workDays': []});
    }

    // بيانات العمل الجديدة لأيام معينة
    List<Map<String, dynamic>> realisticWorkDays = [
      // أيام إضافية من 20 نوفمبر 2024 إلى 28 نوفمبر 2024 مع بيانات مختلفة
      {
        'id': Uuid().v4(),
        'startTime': DateTime(2024, 11, 20, 8, 0).toIso8601String(),
        // 20 نوفمبر 2024 الساعة 8:00 صباحاً
        'endTime': DateTime(2024, 11, 20, 17, 0).toIso8601String(),
        // 20 نوفمبر 2024 الساعة 5:00 مساءً
        'hourlyRate': 23.0,
        // المعدل الساعي
        'totalHours': 9.0,
        // ساعات العمل الفعلية (9 ساعات)
        'totalMinutes': 0.0,
        // دقائق العمل (0 دقيقة)
        'archived': false,
        'notes': {
          'noteType': 'Bonus',
          'description': 'Completion Bonus',
          'amount': 70.0, // المكافأة
        }
      },
      {
        'id': Uuid().v4(),
        'startTime': DateTime(2024, 11, 22, 10, 0).toIso8601String(),
        // 22 نوفمبر 2024 الساعة 10:00 صباحاً
        'endTime': DateTime(2024, 11, 22, 18, 30).toIso8601String(),
        // 22 نوفمبر 2024 الساعة 6:30 مساءً
        'hourlyRate': 21.0,
        // المعدل الساعي
        'totalHours': 8.5,
        // ساعات العمل الفعلية (8.5 ساعات)
        'totalMinutes': 30.0,
        // دقائق العمل (30 دقيقة)
        'archived': false,
        'notes': {
          'noteType': 'Discount',
          'description': 'Late Arrival Deduction',
          'amount': 15.0, // خصم
        }
      },
      {
        'id': Uuid().v4(),
        'startTime': DateTime(2024, 11, 24, 7, 0).toIso8601String(),
        // 24 نوفمبر 2024 الساعة 7:00 صباحاً
        'endTime': DateTime(2024, 11, 24, 16, 15).toIso8601String(),
        // 24 نوفمبر 2024 الساعة 4:15 مساءً
        'hourlyRate': 25.0,
        // المعدل الساعي
        'totalHours': 9.25,
        // ساعات العمل الفعلية (9.25 ساعات)
        'totalMinutes': 15.0,
        // دقائق العمل (15 دقيقة)
        'archived': false,
        'notes': {
          'noteType': 'Bonus',
          'description': 'Task Completion Bonus',
          'amount': 100.0, // مكافأة إنهاء المهمة
        }
      },
      {
        'id': Uuid().v4(),
        'startTime': DateTime(2024, 11, 26, 8, 30).toIso8601String(),
        // 26 نوفمبر 2024 الساعة 8:30 صباحاً
        'endTime': DateTime(2024, 11, 26, 17, 30).toIso8601String(),
        // 26 نوفمبر 2024 الساعة 5:30 مساءً
        'hourlyRate': 22.0,
        // المعدل الساعي
        'totalHours': 9.0,
        // ساعات العمل الفعلية (9 ساعات)
        'totalMinutes': 0.0,
        // دقائق العمل (0 دقيقة)
        'archived': false,
        'notes': {
          'noteType': 'Bonus',
          'description': 'Special Project Bonus',
          'amount': 60.0, // مكافأة المشروع الخاص
        }
      },
      {
        'id': Uuid().v4(),
        'startTime': DateTime(2024, 11, 28, 9, 0).toIso8601String(),
        // 28 نوفمبر 2024 الساعة 9:00 صباحاً
        'endTime': DateTime(2024, 11, 28, 17, 0).toIso8601String(),
        // 28 نوفمبر 2024 الساعة 5:00 مساءً
        'hourlyRate': 24.0,
        // المعدل الساعي
        'totalHours': 8.0,
        // ساعات العمل الفعلية (8 ساعات)
        'totalMinutes': 0.0,
        // دقائق العمل (0 دقيقة)
        'archived': false,
        'notes': {
          'noteType': 'Discount',
          'description': 'Absence Deduction',
          'amount': 20.0, // خصم غياب
        }
      },
      {
        'id': Uuid().v4(),
        'startTime': DateTime(2024, 12, 1, 8, 30).toIso8601String(),
        // 1 ديسمبر 2024 الساعة 8:30 صباحاً
        'endTime': DateTime(2024, 12, 1, 16, 45).toIso8601String(),
        // 1 ديسمبر 2024 الساعة 4:45 مساءً
        'hourlyRate': 20.5,
        // المعدل الساعي
        'totalHours': 8.25,
        // ساعات العمل الفعلية (8.25 ساعات)
        'totalMinutes': 15.0,
        // دقائق العمل (15 دقيقة)
        'archived': false,
        'notes': {
          'noteType': 'Bonus',
          'description': 'Excellent Performance',
          'amount': 80.0, // مكافأة الأداء الممتاز
        }
      },
      {
        'id': Uuid().v4(),
        'startTime': DateTime(2024, 12, 2, 9, 30).toIso8601String(),
        // 2 ديسمبر 2024 الساعة 9:30 صباحاً
        'endTime': DateTime(2024, 12, 2, 18, 0).toIso8601String(),
        // 2 ديسمبر 2024 الساعة 6:00 مساءً
        'hourlyRate': 22.0,
        // المعدل الساعي
        'totalHours': 8.5,
        // ساعات العمل الفعلية (8.5 ساعات)
        'totalMinutes': 0.0,
        // دقائق العمل (0 دقيقة)
        'archived': false,
        'notes': {
          'noteType': 'Discount',
          'description': 'Late Arrival',
          'amount': 25.0, // خصم بسبب التأخير
        }
      },
      {
        'id': Uuid().v4(),
        'startTime': DateTime(2024, 12, 3, 7, 45).toIso8601String(),
        // 3 ديسمبر 2024 الساعة 7:45 صباحاً
        'endTime': DateTime(2024, 12, 3, 16, 30).toIso8601String(),
        // 3 ديسمبر 2024 الساعة 4:30 مساءً
        'hourlyRate': 18.5,
        // المعدل الساعي
        'totalHours': 8.75,
        // ساعات العمل الفعلية (8.75 ساعات)
        'totalMinutes': 45.0,
        // دقائق العمل (45 دقيقة)
        'archived': false,
        'notes': {
          'noteType': 'Bonus',
          'description': 'Extra Hours Bonus',
          'amount': 40.0, // مكافأة الساعات الإضافية
        }
      },
      {
        'id': Uuid().v4(),
        'startTime': DateTime(2024, 12, 4, 10, 0).toIso8601String(),
        // 4 ديسمبر 2024 الساعة 10:00 صباحاً
        'endTime': DateTime(2024, 12, 4, 19, 30).toIso8601String(),
        // 4 ديسمبر 2024 الساعة 7:30 مساءً
        'hourlyRate': 19.0,
        // المعدل الساعي
        'totalHours': 9.5,
        // ساعات العمل الفعلية (9.5 ساعات)
        'totalMinutes': 30.0,
        // دقائق العمل (30 دقيقة)
        'archived': false,
        'notes': {
          'noteType': 'Bonus',
          'description': 'Project Completion',
          'amount': 90.0, // مكافأة إتمام المشروع
        }
      },
      {
        'id': Uuid().v4(),
        'startTime': DateTime(2024, 12, 5, 12, 15).toIso8601String(),
        // 5 ديسمبر 2024 الساعة 12:15 مساءً
        'endTime': DateTime(2024, 12, 5, 20, 0).toIso8601String(),
        // 5 ديسمبر 2024 الساعة 8:00 مساءً
        'hourlyRate': 24.0,
        // المعدل الساعي
        'totalHours': 7.75,
        // ساعات العمل الفعلية (7.75 ساعات)
        'totalMinutes': 45.0,
        // دقائق العمل (45 دقيقة)
        'archived': false,
        'notes': {
          'noteType': 'Discount',
          'description': 'Break Deduction',
          'amount': 15.0, // خصم بسبب الاستراحة
        }
      },
      {
        'id': Uuid().v4(),
        'startTime': DateTime(2024, 12, 6, 9, 0).toIso8601String(),
        // 6 ديسمبر 2024 الساعة 9:00 صباحاً
        'endTime': DateTime(2024, 12, 6, 17, 15).toIso8601String(),
        // 6 ديسمبر 2024 الساعة 5:15 مساءً
        'hourlyRate': 21.5,
        // المعدل الساعي
        'totalHours': 8.25,
        // ساعات العمل الفعلية (8.25 ساعات)
        'totalMinutes': 15.0,
        // دقائق العمل (15 دقيقة)
        'archived': false,
        'notes': {
          'noteType': 'Bonus',
          'description': 'Employee of the Month',
          'amount': 120.0, // مكافأة الموظف المثالي
        }
      },
    ];

    // إضافة البيانات إلى Firestore
    await userDoc.update({
      'workDays': FieldValue.arrayUnion(realisticWorkDays),
    });

    print("تمت إضافة بيانات صحيحة لخمسة أيام عمل بنجاح.");
  }

  Future<void> _saveToFirebase({
    required WorkDayModel workDay,
  }) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    DocumentSnapshot docSnapshot = await userDoc.get();
    if (!docSnapshot.exists) {
      await userDoc.set({'workDays': []});
    }
    await userDoc.update({
      'workDays': FieldValue.arrayUnion([workDay.toJson()]),
    });
  }

  Future<void> _saveSalaryToFirebase({
    required SalaryModel salary,
  }) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    DocumentSnapshot docSnapshot = await userDoc.get();
    if (!docSnapshot.exists) {
      await userDoc.set({'salaries': []});
    }
    await userDoc.update({
      'salaries': FieldValue.arrayUnion([salary.toJson()]),
    });
  }

  @override
  Future<SalaryModel?> calculateSalary({
    required DateTime startDate,
    required DateTime endDate,
    required DateTime paymentDate,
  }) async {
    SalaryModel? salary;
    try {
      int daysDifference = endDate.difference(startDate).inDays;
      List<WorkDayModel> workDays =
          await getWorkDaysFromFirebase(startDate, endDate);
      List<WorkDayModel> updatedWorkDays = [];

      for (var workDay in workDays) {
        DateTime currentDate = workDay.startTime!;
        if (currentDate.isAfter(
              startDate.subtract(
                Duration(days: 1),
              ),
            ) &&
            currentDate.isBefore(
              endDate.add(
                Duration(days: 1),
              ),
            )) {
          double totalMinutes = workDay.endTime!
              .difference(workDay.startTime!)
              .inMinutes
              .toDouble();
          double totalHours = (totalMinutes / 60).floorToDouble();
          totalMinutes = totalMinutes % 60;

          updatedWorkDays.add(WorkDayModel(
            startTime: workDay.startTime,
            endTime: workDay.endTime,
            totalHours: totalHours,
            totalMinutes: totalMinutes,
            hourlyRate: workDay.hourlyRate,
            notes: workDay.notes,
          ));
        }
      }

      salary = SalaryModel(
        days: daysDifference,
        startDate: startDate,
        endDate: endDate,
        workDays: updatedWorkDays,
        paymentDate: paymentDate,
      )..calculateSalaryDetails();
      await _saveSalaryToFirebase(salary: salary);
    } catch (e) {
      if (e is FirebaseException && e.code == 'permission-denied') {
        print("Permission denied: ${e.message}");
      } else {
        print("Unexpected error 1: $e");
      }
    }

    return salary;
  }

  Future<List<WorkDayModel>> getWorkDaysFromFirebase(
      DateTime startDate, DateTime endDate) async {
    List<WorkDayModel> workDays = [];
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        List<dynamic> data = (userDoc['workDays'] ?? []) as List<dynamic>;

        for (var item in data) {
          var workDay = item as Map<String, dynamic>;
          DateTime startTime = DateTime.parse(workDay['startTime']);
          DateTime endTime = DateTime.parse(workDay['endTime']);

          if (startTime.isAfter(startDate) && endTime.isBefore(endDate)) {
            workDays.add(
              WorkDayModel(
                startTime: startTime,
                endTime: endTime,
                hourlyRate: workDay['hourlyRate'],
                notes: NoteModel(
                  noteType: workDay['notes']['noteType'],
                  description: workDay['notes']['description'],
                  amount: workDay['notes']['amount'],
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (e is FirebaseException && e.code == 'permission-denied') {
        print("Permission denied: ${e.message}");
      } else {
        print("Unexpected error 2: $e");
      }
    }

    return workDays;
  }
}
