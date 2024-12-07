import 'dart:async';

import 'package:flutter/material.dart';
import 'package:work_hourly/presentation/base_view_model/base_view_model.dart';
import 'package:work_hourly/presentation/cubit/cubit_class.dart';

import '../../../app/components/constants/color_manager.dart';
import '../../../app/components/constants/general_strings.dart';
import '../../../app/components/constants/notification_handler.dart';
import '../../../app/components/constants/variables_manager.dart';
import '../../../app/components/tranlate_massages/translate_massage.dart';
import '../../cubit/app_states.dart';

class ForgetPasswordModelView extends BaseViewModel
    with ForgetPasswordModelFunctions {
  final emailController = TextEditingController();
  late final CubitClass _bloc;
  late StreamSubscription blocStreamSubscription;
  late final BuildContext context;

  @override
  void dispose() {
    emailController.dispose();
    blocStreamSubscription.cancel();
  }

  @override
  resetPassword(String email) {
    _bloc.resetPassword(email);
  }

  @override
  onResetPasswordSuccessState() {
    successNotification(
        context: context,
        description: GeneralStrings.passwordResetSuccess(context),
        backgroundColor: VariablesManager.isDark
            ? ColorManager.privateGrey
            : ColorManager.primary);
  }

  errorNoti(String error) => errorNotification(
      context: context,
      description: translateErrorMessage(error, context),
      backgroundColor:
          VariablesManager.isDark ? Colors.grey.shade400 : Colors.white);

  @override
  void start() {
    _bloc = CubitClass.get(context);
    startListin();
  }

  startListin() {
    blocStreamSubscription = _bloc.stream.listen(
      (state) {
        if (state is ResetPasswordSuccessState) {
          onResetPasswordSuccessState();
        }
        if (state is ResetPasswordErrorState) {
          errorNoti(state.error);
        }
      },
    );
  }
}

mixin ForgetPasswordModelFunctions {
  resetPassword(String email);

  onResetPasswordSuccessState();
}
