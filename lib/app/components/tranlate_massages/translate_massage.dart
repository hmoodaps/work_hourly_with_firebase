import 'package:flutter/cupertino.dart';

import '../../../generated/l10n.dart';
import '../constants/error_strings.dart';

String translateErrorMessage(String errorKey, BuildContext context) {
  switch (errorKey) {
    //firebase errors
    case ErrorStrings.expiredActionCode:
      return S.of(context).expiredActionCode;
    case ErrorStrings.invalidEmail:
      return S.of(context).invalidEmail;
    case ErrorStrings.userDisabled:
      return S.of(context).userDisabled;
    case ErrorStrings.operationNotAllowed:
      return S.of(context).operationNotAllowed;
    case ErrorStrings.userMismatch:
      return S.of(context).userMismatch;
    case ErrorStrings.userNotFound:
      return S.of(context).userNotFound;
    case ErrorStrings.invalidCredential:
      return S.of(context).invalidCredential;
    case ErrorStrings.wrongPassword:
      return S.of(context).wrongPassword;
    case ErrorStrings.invalidVerificationCode:
      return S.of(context).invalidVerificationCode;
    case ErrorStrings.invalidVerificationId:
      return S.of(context).invalidVerificationId;
    case ErrorStrings.accountExistsWithDifferentCredential:
      return S.of(context).accountExistsWithDifferentCredential;
    case ErrorStrings.emailAlreadyInUse:
      return S.of(context).emailAlreadyInUse;
    case ErrorStrings.weakPassword:
      return S.of(context).weakPassword;
    default:
      return S.of(context).unknownError;
  }
}
