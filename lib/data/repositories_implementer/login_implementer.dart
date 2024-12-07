import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:work_hourly/data/user_model/user_model.dart';
import 'package:work_hourly/domain/repositories/login_repository.dart';

import '../../app/components/constants/general_strings.dart';
import '../../domain/local_models/fault_classes.dart';
import '../../domain/local_models/models/models.dart';
import '../local_storage/shared_local.dart';

class LoginToFirebaseImplementer implements LoginToFirebaseRepo {
  // Sign in with Google
  @override
  Future<Either<FailureClass, User>> signInWithGoogle() async {
    //sign in with google .>>
    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId:
          '136652407770-fi3cia58lo69m2b1tll8u0mie23sbc6n.apps.googleusercontent.com',
    );
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Check if googleUser is not null and get authentication details
      if (googleUser == null) {
        throw Exception("Google sign-in was cancelled or failed.");
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Call the method that handles the actual sign in and Firebase operations
      final response =
          await _createUserAtFirebaseWithCredential(credential: credential);

      // Use fold to handle the response and return a bool
      return response.fold(
        (failure) => Left(FailureClass(error: failure.toString())),
        // Handle failure
        (user) => Right(user), // Return bool on success
      );
    } catch (error) {
      return Left(FailureClass(
          error: error.toString())); // Return an error wrapped in Left
    }
  }

  @override
  Future<Either<FirebaseFailureClass, String>> loginToFirebase(
      {required CreateUserRequirements req}) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: req.email!,
        password: req.password!,
      );
      return Right(userCredential.user!.uid);
    } on FirebaseException catch (error) {
      return Left(FirebaseFailureClass(firebaseException: error));
    }
  }

  // -------Function: Create user with credentials -------
  Future<Either<FirebaseFailureClass, User>>
      _createUserAtFirebaseWithCredential(
          {required AuthCredential credential}) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      SharedPref.prefs
          .setString(GeneralStrings.currentUser, userCredential.user!.uid);
      await addUserToFirebase(
          req: CreateUserRequirements(
        email: userCredential.user!.email,
      ));
      return Right(userCredential.user!);
    } on FirebaseException catch (error) {
      return Left(FirebaseFailureClass(firebaseException: error));
    }
  }

  Future<Either<FirebaseFailureClass, void>> addUserToFirebase(
      {required CreateUserRequirements req}) async {
    try {
      final userResponse = UserModel(
        email: req.email!,
        userId: FirebaseAuth.instance.currentUser!.uid,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set(userResponse.toJson());
      return Right(null);
    } on FirebaseException catch (error) {
      return Left(FirebaseFailureClass(firebaseException: error));
    }
  }

  @override
  Future<Either<FirebaseFailureClass, void>> logout() async {
    try {
      FirebaseAuth.instance.signOut();
      return Right(null);
    } on FirebaseException catch (error) {
      return Left(FirebaseFailureClass(firebaseException: error));
    }
  }

  @override
  Future<Either<FirebaseFailureClass, void>> forgetPassword(
      String email) async {
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return Right(null);
    } on FirebaseException catch (error) {
      return Left(FirebaseFailureClass(firebaseException: error));
    }
  }
}
