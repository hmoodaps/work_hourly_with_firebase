import 'package:firebase_auth/firebase_auth.dart';

import '../../../presentation/cubit/app_states.dart';
import '../constants/error_strings.dart';

firebaseAuthErrorsHandler({
  required FirebaseException failure,
  required void Function(AppStates) emit,
  required AppStates Function(String errorKey) state,
}) {
  switch (failure.code) {
    case 'expired-action-code':
      emit(state(ErrorStrings.expiredActionCode));
      break;
    case 'invalid-email':
      emit(state(ErrorStrings.invalidEmail));
      break;
    case 'user-disabled':
      emit(state(ErrorStrings.userDisabled));
      break;
    case 'operation-not-allowed':
      emit(state(ErrorStrings.operationNotAllowed));
      break;
    case 'user-mismatch':
      emit(state(ErrorStrings.userMismatch));
      break;
    case 'user-not-found':
      emit(state(ErrorStrings.userNotFound));
      break;
    case 'invalid-credential':
      emit(state(ErrorStrings.invalidCredential));
      break;
    case 'wrong-password':
      emit(state(ErrorStrings.wrongPassword));
      break;
    case 'invalid-verification-code':
      emit(state(ErrorStrings.invalidVerificationCode));
      break;
    case 'invalid-verification-id':
      emit(state(ErrorStrings.invalidVerificationId));
      break;
    case 'account-exists-with-different-credential':
      emit(state(ErrorStrings.accountExistsWithDifferentCredential));
      break;
    case 'email-already-in-use':
      emit(state(ErrorStrings.emailAlreadyInUse));
      break;
    case 'weak-password':
      emit(state(ErrorStrings.weakPassword));
      break;
    default:
      emit(state(ErrorStrings.unknownError));
  }
}
