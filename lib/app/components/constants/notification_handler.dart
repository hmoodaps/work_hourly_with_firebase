import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:work_hourly/app/components/constants/size_manager.dart';

import 'font_manager.dart';
import 'general_strings.dart';

errorNotification(
    {required BuildContext context,
    required String description,
    Color? backgroundColor}) {
  return ElegantNotification.error(
    autoDismiss: true,
    isDismissable: false,
    borderRadius: BorderRadius.circular(20),
    background: backgroundColor ?? Colors.white,
    title: Text(
      GeneralStrings.error(context),
      style: TextStyleManager.titleStyle(context),
    ),
    description: Text(
      description,
      style: TextStyleManager.bodyStyle(context),
    ),
    animationDuration: Duration(seconds: SizeManager.i4),
    toastDuration: Duration(seconds: SizeManager.i10),
  ).show(context);
}

successNotification(
    {required BuildContext context,
    required String description,
    Color? backgroundColor}) {
  return ElegantNotification(
    autoDismiss: true,
    isDismissable: false,
    borderRadius: BorderRadius.circular(20),
    background: backgroundColor ?? Colors.white,
    title: Text(
      GeneralStrings.success(context),
      style: TextStyleManager.titleStyle(context),
    ),
    description: Text(
      description,
      style: TextStyleManager.bodyStyle(context),
    ),
    animationDuration: Duration(seconds: SizeManager.i4),
    toastDuration: Duration(seconds: SizeManager.i6),
  ).show(context);
}
