import 'package:firebase_auth/firebase_auth.dart';

class FailureClass {
  String error;

  FailureClass({required this.error});
}

class FirebaseFailureClass {
  final FirebaseException firebaseException;

  FirebaseFailureClass({
    required this.firebaseException,
  });
}
