// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `The OTP link in the email has expired.`
  String get expiredActionCode {
    return Intl.message(
      'The OTP link in the email has expired.',
      name: 'expiredActionCode',
      desc: '',
      args: [],
    );
  }

  /// `The email address is invalid.`
  String get invalidEmail {
    return Intl.message(
      'The email address is invalid.',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `The user has been disabled.`
  String get userDisabled {
    return Intl.message(
      'The user has been disabled.',
      name: 'userDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Operation not allowed. Please enable this option in the Firebase Console.`
  String get operationNotAllowed {
    return Intl.message(
      'Operation not allowed. Please enable this option in the Firebase Console.',
      name: 'operationNotAllowed',
      desc: '',
      args: [],
    );
  }

  /// `The entered data does not match the user.`
  String get userMismatch {
    return Intl.message(
      'The entered data does not match the user.',
      name: 'userMismatch',
      desc: '',
      args: [],
    );
  }

  /// `No user found with the provided credentials.`
  String get userNotFound {
    return Intl.message(
      'No user found with the provided credentials.',
      name: 'userNotFound',
      desc: '',
      args: [],
    );
  }

  /// `The entered data is invalid or has expired.`
  String get invalidCredential {
    return Intl.message(
      'The entered data is invalid or has expired.',
      name: 'invalidCredential',
      desc: '',
      args: [],
    );
  }

  /// `The password is incorrect or no password was set for the account.`
  String get wrongPassword {
    return Intl.message(
      'The password is incorrect or no password was set for the account.',
      name: 'wrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `The verification code is invalid.`
  String get invalidVerificationCode {
    return Intl.message(
      'The verification code is invalid.',
      name: 'invalidVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `The verification ID is invalid.`
  String get invalidVerificationId {
    return Intl.message(
      'The verification ID is invalid.',
      name: 'invalidVerificationId',
      desc: '',
      args: [],
    );
  }

  /// `An account with this email exists but with different credentials.`
  String get accountExistsWithDifferentCredential {
    return Intl.message(
      'An account with this email exists but with different credentials.',
      name: 'accountExistsWithDifferentCredential',
      desc: '',
      args: [],
    );
  }

  /// `The email is already in use by another account.`
  String get emailAlreadyInUse {
    return Intl.message(
      'The email is already in use by another account.',
      name: 'emailAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `The password is too weak.`
  String get weakPassword {
    return Intl.message(
      'The password is too weak.',
      name: 'weakPassword',
      desc: '',
      args: [],
    );
  }

  /// `An unknown error occurred.`
  String get unknownError {
    return Intl.message(
      'An unknown error occurred.',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `Successfully completed`
  String get success {
    return Intl.message(
      'Successfully completed',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back!`
  String get welcomeBack {
    return Intl.message(
      'Welcome back!',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get fieldRequired {
    return Intl.message(
      'This field is required',
      name: 'fieldRequired',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get signWithGoogle {
    return Intl.message(
      'Sign in with Google',
      name: 'signWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get or {
    return Intl.message(
      'or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgetPassword {
    return Intl.message(
      'Forgot Password',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Start Work`
  String get startWork {
    return Intl.message(
      'Start Work',
      name: 'startWork',
      desc: '',
      args: [],
    );
  }

  /// `End Work`
  String get endWork {
    return Intl.message(
      'End Work',
      name: 'endWork',
      desc: '',
      args: [],
    );
  }

  /// `Workday Date`
  String get workDayDate {
    return Intl.message(
      'Workday Date',
      name: 'workDayDate',
      desc: '',
      args: [],
    );
  }

  /// `Salary Calculation`
  String get salaryCalculation {
    return Intl.message(
      'Salary Calculation',
      name: 'salaryCalculation',
      desc: '',
      args: [],
    );
  }

  /// `Delete History`
  String get deleteHistory {
    return Intl.message(
      'Delete History',
      name: 'deleteHistory',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password reset link sent. Check your inbox.`
  String get passwordResetSuccess {
    return Intl.message(
      'Password reset link sent. Check your inbox.',
      name: 'passwordResetSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Let’s try resetting your password. We’ll send a link to your email.`
  String get ltsResetPassword {
    return Intl.message(
      'Let’s try resetting your password. We’ll send a link to your email.',
      name: 'ltsResetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logout {
    return Intl.message(
      'Log Out',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Login or Register`
  String get loginOrRegister {
    return Intl.message(
      'Login or Register',
      name: 'loginOrRegister',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Bonus`
  String get bonus {
    return Intl.message(
      'Bonus',
      name: 'bonus',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message(
      'Discount',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `Notes:`
  String get notes {
    return Intl.message(
      'Notes:',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `Recorded Amount:`
  String get noteMoney {
    return Intl.message(
      'Recorded Amount:',
      name: 'noteMoney',
      desc: '',
      args: [],
    );
  }

  /// `Your work today:`
  String get yourWorkToday {
    return Intl.message(
      'Your work today:',
      name: 'yourWorkToday',
      desc: '',
      args: [],
    );
  }

  /// `No work scheduled for today!`
  String get noWorkInThisDay {
    return Intl.message(
      'No work scheduled for today!',
      name: 'noWorkInThisDay',
      desc: '',
      args: [],
    );
  }

  /// `Start Details:`
  String get startDetail {
    return Intl.message(
      'Start Details:',
      name: 'startDetail',
      desc: '',
      args: [],
    );
  }

  /// `End Details:`
  String get endDetail {
    return Intl.message(
      'End Details:',
      name: 'endDetail',
      desc: '',
      args: [],
    );
  }

  /// `Currently working`
  String get working {
    return Intl.message(
      'Currently working',
      name: 'working',
      desc: '',
      args: [],
    );
  }

  /// `Hourly Rate:`
  String get hourlyRateText {
    return Intl.message(
      'Hourly Rate:',
      name: 'hourlyRateText',
      desc: '',
      args: [],
    );
  }

  /// `Total Hours:`
  String get totalHours {
    return Intl.message(
      'Total Hours:',
      name: 'totalHours',
      desc: '',
      args: [],
    );
  }

  /// `Total Minutes:`
  String get totalMinutes {
    return Intl.message(
      'Total Minutes:',
      name: 'totalMinutes',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Salaries`
  String get salaries {
    return Intl.message(
      'Salaries',
      name: 'salaries',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Note Description:`
  String get noteDescription {
    return Intl.message(
      'Note Description:',
      name: 'noteDescription',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `No data available here ^_^ `
  String get noData {
    return Intl.message(
      'No data available here ^_^ ',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `Archive`
  String get archive {
    return Intl.message(
      'Archive',
      name: 'archive',
      desc: '',
      args: [],
    );
  }

  /// `Item archived successfully!`
  String get itemArchived {
    return Intl.message(
      'Item archived successfully!',
      name: 'itemArchived',
      desc: '',
      args: [],
    );
  }

  /// `Item deleted successfully!`
  String get itemDeleted {
    return Intl.message(
      'Item deleted successfully!',
      name: 'itemDeleted',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'nl'),
      Locale.fromSubtags(languageCode: 'tr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
