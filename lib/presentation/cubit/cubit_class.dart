import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_hourly/app/components/constants/theme_manager.dart';
import 'package:work_hourly/data/repositories_implementer/login_implementer.dart';
import 'package:work_hourly/data/repositories_implementer/work_repository_implementer.dart';
import 'package:work_hourly/domain/local_models/models/models.dart';
import 'package:work_hourly/domain/repositories/login_repository.dart';
import 'package:work_hourly/domain/repositories/work_repository.dart';

import '../../app/components/constants/general_strings.dart';
import '../../app/components/constants/variables_manager.dart';
import '../../app/components/firebase_error_handler/firebase_error_handler.dart';
import '../../app/handle_app_language/handle_app_language.dart';
import '../../data/local_storage/shared_local.dart';
import '../../data/user_model/note_model.dart';
import '../../data/user_model/salary_model.dart';
import '../../data/user_model/work_day_moodel.dart';
import 'app_states.dart';

class CubitClass extends Cubit<AppStates> {
  CubitClass() : super(InitState());
  LoginToFirebaseRepo _login = LoginToFirebaseImplementer();
  WorkRepository _workRepository = WorkRepositoryImplementer();
  late DateTime selectedDay;
  late DateTime focusedDay;
  bool? isBonus;
  bool languagePressed = false;
  int? expandedItem;
  bool isWorking = SharedPref.prefs.getBool(GeneralStrings.isWorking)!;
  DateTime startDateTime = DateTime.parse(
      SharedPref.prefs.getString(GeneralStrings.startTime) ??
          DateTime.now().toIso8601String());
  late List<WorkDayModel> workDays;
  late List<SalaryModel> salaries = [];
  late List<WorkDayModel> archivedWorkDays;
  Map<int, bool> animationCompletionStatus = {};

//calclate
  calculateSalary({
    required DateTime startDate,
    required DateTime endDate,
    required DateTime paymentDate,
  }) async {
    SalaryModel ?  salaryModel;
    try{
      salaryModel  =  await _workRepository.calculateSalary(
          startDate: startDate, endDate: endDate, paymentDate: paymentDate).then((_)async{
            await getSalaries(startDate: startDate, endDate: endDate);
            return null;
      });
    }catch(e){print("calculateSalary error ${e.toString()}");}
    emit(CalculateSalary());
    print(salaryModel);
    return salaryModel ;
  }

  //add fake data
  addFakeDates() async {
    await _workRepository.addFakeWorkDays();
    emit(AddFakeDates());
  }

  //update item
  updateItem(WorkDayModel workDayModel) async {
    try {
      await getDate().then((data) async {
        int indexToUpdate =
            data.indexWhere((workDay) => workDay.id == workDayModel.id);
        if (indexToUpdate != -1) {
          DocumentReference userDocRef = FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid);

          DocumentSnapshot userSnapshot = await userDocRef.get();
          if (userSnapshot.exists) {
            Map<String, dynamic> userData =
                userSnapshot.data() as Map<String, dynamic>;
            List<dynamic> workDays = userData['workDays'] ?? [];

            // Log the current workDays and index to ensure correctness
            workDays[indexToUpdate] = workDayModel.toJson();

            // Log the updated workDays list

            await userDocRef.update({
              'workDays': workDays,
            });
            await getDate();
            print("Work day updated successfully");
          } else {
            print("User document not found");
          }
        } else {
          print("Work day not found");
        }
      });
    } catch (e) {
      print("Error updating work day: $e");
    }
  }

  //---------Delete the workday item----------
  Future<void> deleteItem(WorkDayModel workDayToDelete) async {
    print("deleteItem start");
    try {
      await getDate().then((data) async {
        // Debugging: print the type of each element in data
        data.forEach((element) {
          print("Element type: ${element.runtimeType}");
        });

        // Find the index of the workDayToDelete in the list
        int indexToDelete =
            data.indexWhere((workDay) => workDay.id == workDayToDelete.id);
        if (indexToDelete != -1) {
          // Debugging: print index to be deleted
          print("Deleting workday at index: $indexToDelete");
          // Directly remove the item by its index
          data.removeAt(indexToDelete);
          // Update Firestore with the modified list
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({'workDays': data});
          print("Work day deleted successfully");
        } else {
          print("Work day not found");
        }
      });
    } catch (e) {
      print("Error deleting work day: $e");
    }

    // Re-fetch the data after deletion if necessary
    await getDate();
  }

  //---------Add or remove the workday from archive----------
  Future<void> addOrRemoveArchive(WorkDayModel workDayToArchive) async {
    print("Starting archiving process...");
    try {
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);

      // Fetch the workdays array
      final snapshot = await userDoc.get();
      if (!snapshot.exists) {
        print("User data not found");
        return;
      }

      List<dynamic> workDays = snapshot.data()?['workDays'] ?? [];

      // Find the index of the workday to archive
      int indexToArchive = workDays
          .indexWhere((workDay) => workDay['id'] == workDayToArchive.id);

      if (indexToArchive != -1) {
        // Update the archived property for the specific workday
        if (workDays[indexToArchive]['archived'] == true) {
          workDays[indexToArchive]['archived'] = false;
          archivedWorkDays.remove(workDayToArchive);
          this.workDays.add(workDayToArchive);
        } else {
          this.workDays.remove(workDayToArchive);
          archivedWorkDays.add(workDayToArchive);
          workDays[indexToArchive]['archived'] = true;
        }

        // Update Firestore with the modified workDays array
        await userDoc.update({'workDays': workDays});
        emit(AddToArchive());
        print("Work day archived successfully.");
      } else {
        print("Work day not found in the database.");
      }
    } catch (e) {
      print("Error archiving work day: $e");
    }
  }

  //---------Handle the expanded item state----------
  void onItemExpanded(int index) {
    if (expandedItem != index) {
      expandedItem = index;
    } else {
      expandedItem = null;
    }
    animationCompletionStatus[index] = false;
    emit(WorkItemExpanded());
  }

  //---------Handle animation completion----------
  void onAnimationComplete(int index) {
    animationCompletionStatus[index] = true;
    emit(AnimationComplete());
  }

  //---------Check if animation is complete----------
  bool isAnimationComplete(int index) {
    return animationCompletionStatus[index] ?? false;
  }

  //---------Change the app language----------
  changeLanguage(AppLanguage appLanguage) {
    TheAppLanguage.updateLanguage(appLanguage);
    SharedPref.prefs
        .setString(GeneralStrings.appLanguage, appLanguage.appLanguage);

    emit(ChangeLanguage());
  }

  //---------Set the initial language from shared preferences----------
  setLanguage() {
    if (SharedPref.prefs.getString(GeneralStrings.appLanguage) == null) {
      AppLanguage language = ApplicationLanguage.en.appLanguage;
      TheAppLanguage.updateLanguage(language);
    } else if (SharedPref.prefs.getString(GeneralStrings.appLanguage) == 'en') {
      AppLanguage language = ApplicationLanguage.en.appLanguage;
      TheAppLanguage.updateLanguage(language);
    } else if (SharedPref.prefs.getString(GeneralStrings.appLanguage) == 'ar') {
      AppLanguage language = ApplicationLanguage.ar.appLanguage;
      TheAppLanguage.updateLanguage(language);
    } else if (SharedPref.prefs.getString(GeneralStrings.appLanguage) == 'nl') {
      AppLanguage language = ApplicationLanguage.nl.appLanguage;
      TheAppLanguage.updateLanguage(language);
    } else if (SharedPref.prefs.getString(GeneralStrings.appLanguage) == 'tr') {
      AppLanguage language = ApplicationLanguage.tr.appLanguage;
      TheAppLanguage.updateLanguage(language);
    }
    emit(SetLanguage());
  }

  //---------Toggle language pressed state----------
  isLanguagePressed() {
    languagePressed = !languagePressed;
    emit(IsLanguagePressed());
  }

  //---------Handle calendar day selection----------
  Future<void> onCalenderDaySelected(
      DateTime selectedDay, DateTime focusedDay) async {
    this.selectedDay = selectedDay;
    this.focusedDay = focusedDay;
    await getDate(date: selectedDay);
    emit(OnCalenderDaySelected()); // Emit the updated state
  }

  //---------Start work process----------
  onStartWorkPressed() {
    isWorking = true;
    startWork();
  }

  //---------Handle bonus or discount press----------
  onBonusOrDiscountPress(bool bonus) {
    isBonus = bonus;
    emit(OnBonusOrDiscountPressState());
  }

  //---------Fetch workdays for a specific date----------
  Future<List<WorkDayModel>> getDate({DateTime? date}) async {
    workDays.clear();
    try {
      DocumentSnapshot data = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      List<dynamic> dates = data['workDays'] ?? [];
      if (dates.isNotEmpty) {
        for (var workDay in dates) {
          try {
            DateTime endTime;

            // التعامل مع الحقل endTime بجميع أنواعه
            if (workDay['endTime'] is Timestamp) {
              endTime = (workDay['endTime'] as Timestamp).toDate();
            } else if (workDay['endTime'] is String) {
              endTime = DateTime.parse(workDay['endTime']);
            } else {
              continue; // تخطي إذا كان التنسيق غير متوقع
            }

            if (date != null) {
              if (endTime.toUtc().year == date.toUtc().year &&
                  endTime.toUtc().month == date.toUtc().month &&
                  endTime.toUtc().day == date.toUtc().day &&
                  workDay['archived'] == false) {
                workDays.add(WorkDayModel.fromJson(workDay));
              }
            } else {
              if (workDay['archived'] == false) {
                workDays.add(WorkDayModel.fromJson(workDay));
              }
            }
          } catch (e) {
            print('Error processing workDay: $e');
          }
        }
      }
    } catch (e) {
      print('Error fetching workDays: $e');
    }

    print('GetDate');
    print(date.toString());
    if (workDays.isNotEmpty) {
      for (var workDay in workDays) {
        print('${workDay.id} === ${workDay.startTime}');
      }
      print('Total workDays: ${workDays.length}');
    }

    emit(GetDate());

    return workDays;
  }

  Future<List<SalaryModel>> getSalaries({     DateTime ? startDate,
     DateTime ? endDate}) async {
    salaries.clear();
    try {
      DocumentSnapshot data = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      List<dynamic> salaries = data['salaries'] ?? [];
      if (salaries.isNotEmpty) {
        for (var salary in salaries) {
          try {
            // if(startDate !=salary['startDate'] && endDate !=salary['endDate']){
              this.salaries.add(SalaryModel.fromJson(salary));
            // }
          } catch (e) {
            print("error fetching salaries ${e.toString()}");
          }
        }
      }
    } catch (e) {
      print("error fetching salaries ${e.toString()}");
    }

    return salaries;
  }


  //---------Fetch archived workdays----------
  Future<List<WorkDayModel>> getArchivedDate() async {
    archivedWorkDays.clear();
    try {
      DocumentSnapshot data = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      List<dynamic> dates = data['workDays'] ?? [];
      if (dates.isNotEmpty) {
        for (var workDay in dates) {
          if (workDay['archived'] == true) {
            archivedWorkDays.add(WorkDayModel.fromJson(workDay));
          }
        }
      }
    } catch (e) {
      print('Error fetching workDays: $e');
    }
    emit(GetArchivedDate());
    return archivedWorkDays;
  }

  //---------Initialize main screen on startup----------
  mainScreenStartup() async {
    startDateTime = DateTime.now();
    focusedDay = DateTime.now();
    selectedDay = DateTime.now();
    workDays = [];
    archivedWorkDays = [];
    await getDate(date: DateTime.now());
    await getArchivedDate();
    emit(MainScreenStartup());
  }

  // Start work and record the start time
  Future<void> startWork() async {
    try {
      await _workRepository
          .startWork(); // Start the work process using the repository
      isWorking = true;
      emit(
          startWorkSuccessState()); // Emit success state after starting the work
    } catch (e) {
      emit(startWorkErrorState(
          e.toString())); // Emit error state if starting work fails
    }
  }

  // End work and record the end time
  Future<void> endWork(
      {required NoteModel noteModel, required double hourlyRate}) async {
    try {
      if (selectedDay.day != DateTime.now().day) {
        onCalenderDaySelected(DateTime.now(),
            DateTime.now()); // Update the selected day if needed
      }
      await _workRepository
          .stopWork(
              noteModel: noteModel,
              hourlyRate: hourlyRate) // Stop work and pass necessary data
          .then((_) async {
        isWorking = false; // Set isWorking to false after stopping work
        await getDate(date: DateTime.now()).then((_) {
          // Fetch updated data for the day
          emit(EndWorkSuccess()); // Emit success state when work ends
        });
      });
    } catch (e) {
      emit(endWorkError(e.toString())); // Emit error state if ending work fails
    }
  }

  // Sign in with Google authentication
  Future<void> signInwWithGoogle() async {
    print('google');
    await _login.signInWithGoogle().then((result) {
      result.fold((error) {
        emit(signInwWithGoogleError(
            error.error)); // Emit error state if sign-in fails
      }, (success) {
        print(success.uid);
        emit(
            signInwWithGoogleSuccess()); // Emit success state after successful sign-in
      });
    }); // Sign in using Google
  }

  // Logout the user
  logout() async {
    final result = await _login.logout(); // Perform logout
    result.fold((error) {
      firebaseAuthErrorsHandler(
        failure: error.firebaseException, // Handle any errors during logout
        emit: emit,
        state: (String error) => logoutErrorState(error),
      );
    }, (success) {
      SharedPref.prefs.remove(GeneralStrings
          .currentUser); // Remove user data from shared preferences
      emit(logoutSuccessState()); // Emit success state after logout
    });
  }

  // Reset password by sending an email
  Future<void> resetPassword(String email) async {
    final result =
        await _login.forgetPassword(email); // Request password reset via email
    result.fold(
      (error) {
        firebaseAuthErrorsHandler(
          failure: error.firebaseException,
          // Handle any errors during password reset
          emit: emit,
          state: (String error) => ResetPasswordErrorState(error),
        );
      },
      (success) {
        emit(
            ResetPasswordSuccessState()); // Emit success state after sending reset email
      },
    );
  }

  // Login to Firebase with user credentials
  loginToFirebase(CreateUserRequirements req) async {
    final result = await _login.loginToFirebase(
        req: req); // Login using the provided credentials
    result.fold((fail) {
      firebaseAuthErrorsHandler(
        failure: fail.firebaseException, // Handle any login errors
        emit: emit,
        state: (error) => LoginErrorState(error),
      );
    }, (success) {
      SharedPref.prefs.setString(GeneralStrings.currentUser,
          FirebaseAuth.instance.currentUser!.uid); // Save user ID
      emit(LoginSuccessState()); // Emit success state after successful login
    });
  }

  // Toggle between light and dark themes based on system settings
  ThemeData? themeData = lightThemeData(); // Default theme is light

  ThemeData? toggleLightAndDark(context) {
    Brightness brightness = MediaQuery.of(context)
        .platformBrightness; // Get current system brightness
    brightness == Brightness.dark
        ? (
            themeData = darkThemeData(),
            VariablesManager.isDark = true
          ) // Switch to dark theme
        : (
            themeData = lightThemeData(),
            VariablesManager.isDark = false
          ); // Switch to light theme
    emit(ToggleLightAndDark()); // Emit theme change state
    return themeData;
  }

  // Create instance of the Cubit class if needed (for DI use)
  static CubitClass get(context) => BlocProvider.of<CubitClass>(context);

  // Light Theme Text Styles
  // Helper methods to set text styles for various text elements
  static headerStyle(BuildContext context) => Theme.of(context)
      .textTheme
      .headlineLarge
      ?.copyWith(color: VariablesManager.isDark ? Colors.white : Colors.black);

  static titleStyle(BuildContext context) => Theme.of(context)
      .textTheme
      .titleLarge
      ?.copyWith(color: VariablesManager.isDark ? Colors.white : Colors.black);

  static bodyStyle(BuildContext context) => Theme.of(context)
      .textTheme
      .bodyLarge
      ?.copyWith(color: VariablesManager.isDark ? Colors.white : Colors.black);

  static paragraphStyle(BuildContext context) => Theme.of(context)
      .textTheme
      .labelLarge
      ?.copyWith(color: VariablesManager.isDark ? Colors.white : Colors.black);

  static smallParagraphStyle(BuildContext context) => Theme.of(context)
      .textTheme
      .labelSmall
      ?.copyWith(color: VariablesManager.isDark ? Colors.white : Colors.black);

  // Set the initial language when the app starts
  void setInitialLanguage() {
    if (SharedPref.prefs.getString(GeneralStrings.appLanguage) == null) {
      AppLanguage language = ApplicationLanguage.en.appLanguage;
      TheAppLanguage.updateLanguage(
          language); // Set default language to English
    } else if (SharedPref.prefs.getString(GeneralStrings.appLanguage) == 'en') {
      AppLanguage language = ApplicationLanguage.en.appLanguage;
      TheAppLanguage.updateLanguage(language); // Set language to English
    } else if (SharedPref.prefs.getString(GeneralStrings.appLanguage) == 'ar') {
      AppLanguage language = ApplicationLanguage.ar.appLanguage;
      TheAppLanguage.updateLanguage(language); // Set language to Arabic
    } else if (SharedPref.prefs.getString(GeneralStrings.appLanguage) == 'nl') {
      AppLanguage language = ApplicationLanguage.nl.appLanguage;
      TheAppLanguage.updateLanguage(language); // Set language to Dutch
    } else if (SharedPref.prefs.getString(GeneralStrings.appLanguage) == 'tr') {
      AppLanguage language = ApplicationLanguage.tr.appLanguage;
      TheAppLanguage.updateLanguage(language); // Set language to Turkish
    }
  }

  // Change the app's language
  changeAppLanguage({required ApplicationLanguage language}) {
    TheAppLanguage.updateLanguage(language.appLanguage); // Update language
    emit(ChangeAppLanguage()); // Emit state for language change
  }

  updateBonusOrDiscount() {
    emit(UpdateBonusOrDiscount());
  }
}
