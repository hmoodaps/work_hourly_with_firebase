import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../local_models/fault_classes.dart';
import '../local_models/models/models.dart';

abstract class LoginToFirebaseRepo {
  Future<Either<FirebaseFailureClass, String>> loginToFirebase(
      {required CreateUserRequirements req});

  Future<Either<FirebaseFailureClass, void>> logout();

  Future<Either<FirebaseFailureClass, void>> forgetPassword(String email);

  Future<Either<FailureClass, User>> signInWithGoogle();
}
