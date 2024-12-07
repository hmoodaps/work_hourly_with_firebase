import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:work_hourly/app/components/constants/general_strings.dart';
import 'package:work_hourly/data/local_storage/shared_local.dart';
import 'package:work_hourly/presentation/base_view_model/base_view_model.dart';
import 'package:work_hourly/presentation/cubit/app_states.dart';
import 'package:work_hourly/presentation/cubit/cubit_class.dart';

import '../../../app/components/constants/notification_handler.dart';
import '../../../app/components/constants/route_strings_manager.dart';
import '../../../app/components/constants/routs_manager.dart';
import '../../../app/components/tranlate_massages/translate_massage.dart';
import '../../../domain/local_models/models/models.dart';

class LoginModelView extends BaseViewModel with LoginModelViewFunctions {
  // initialize variables to apply "Separation of Concerns"
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late final BuildContext context;
  late final CubitClass _bloc;
  late StreamSubscription blocStreamSubscription;

  _startLisitin() {
    blocStreamSubscription = _bloc.stream.listen((state) async {
      if (state is LoginErrorState) {
        errorNotification(
            context: context,
            description: translateErrorMessage(state.error, context));
      }
      if (state is LoginSuccessState) {
        if (kDebugMode) {
          print(SharedPref.prefs.get(GeneralStrings.currentUser));
        }
        navigateTo(context, RouteStringsManager.mainRoute);
      }
      if (state is signInwWithGoogleSuccess) {
        if (kDebugMode) {
          print(SharedPref.prefs.get(GeneralStrings.currentUser));
        }
        navigateTo(context, RouteStringsManager.mainRoute);
      }
    });
  }

  // Create user in Firebase
  @override
  onLoginPressed({
    required String email,
    required String password,
  }) async {
    CreateUserRequirements req = CreateUserRequirements(
      email: email,
      password: password,
    );
    _bloc.loginToFirebase(req);
  }

  @override
  void dispose() {
    emailController.dispose(); // Dispose of controllers to avoid memory leaks
    passwordController.dispose();
    blocStreamSubscription.cancel();
  }

  @override
  void start() {
    _bloc = CubitClass.get(context);
    _startLisitin();
  }

  @override
  onForgetPasswordPress() {
    navigateTo(context, RouteStringsManager.forgetPasswordRoute);
  }

  @override
  onSignInwWithGooglePress() async {
    _bloc.signInwWithGoogle();
  }
}

mixin LoginModelViewFunctions {
  Future<void> onLoginPressed({
    required String email,
    required String password,
  });

  void onForgetPasswordPress();

  onSignInwWithGooglePress();
}
