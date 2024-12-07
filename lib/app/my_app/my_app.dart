import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:work_hourly/app/components/constants/general_strings.dart';
import 'package:work_hourly/app/components/constants/theme_manager.dart';
import 'package:work_hourly/data/local_storage/shared_local.dart';
import 'package:work_hourly/presentation/cubit/cubit_class.dart';
import 'package:work_hourly/presentation/routes_and_views/login/login.dart';
import 'package:work_hourly/presentation/routes_and_views/main/main_route.dart';

import '../../generated/l10n.dart';
import '../../presentation/cubit/app_states.dart';
import '../components/constants/routs_manager.dart';
import '../handle_app_language/handle_app_language.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal();

  static const MyApp _app = MyApp._internal();

  factory MyApp() => _app;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CubitClass()
        ..mainScreenStartup()
        ..setLanguage()..getSalaries()
      ,
      child: BlocBuilder<CubitClass, AppStates>(
        builder: (context, state) {
          return MaterialApp(
            locale: Locale(TheAppLanguage.appLanguage),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            onGenerateRoute: Routes.onGenerateRoute,
            debugShowCheckedModeBanner: false,
            theme: lightThemeData(),
            //   cubit.toggleLightAndDark(context),
            home: SharedPref.prefs.getString(GeneralStrings.currentUser) != null
                ? MainRoute()
                : LoginRoute(),
            // SharedPref.getBool(GeneralStrings.isManual)!
            //   ? TheAppMode.appMode
            //   : bloc.toggleLightAndDark(context),
          );
        },
      ),
    );
  }
}
