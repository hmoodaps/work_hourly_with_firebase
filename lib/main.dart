import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:work_hourly/data/local_storage/shared_local.dart';

import 'app/components/constants/general_strings.dart';
import 'app/my_app/my_app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPref.init();
  if (SharedPref.prefs.getBool(GeneralStrings.isWorking) == null) {
    SharedPref.prefs.setBool(GeneralStrings.isWorking, false);
  }
  runApp(MyApp());
}
