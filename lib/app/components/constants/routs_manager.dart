import 'package:flutter/material.dart';
import 'package:work_hourly/app/components/constants/route_strings_manager.dart';

import '../../../presentation/routes_and_views/archive/archive_view.dart';
import '../../../presentation/routes_and_views/froget_password/forget_password_route.dart';
import '../../../presentation/routes_and_views/history/history_view.dart';
import '../../../presentation/routes_and_views/login/login.dart';
import '../../../presentation/routes_and_views/main/main_route.dart';
import '../../../presentation/routes_and_views/salaries/salaries_view.dart';

class Routes {
  static final Map<String, WidgetBuilder> routeBuilders = {
    RouteStringsManager.loginRoute: (context) => const LoginRoute(),
    RouteStringsManager.mainRoute: (context) => const MainRoute(),
    RouteStringsManager.salariesView: (context) => const SalariesView(),
    RouteStringsManager.historyView: (context) => const HistoryView(),
    RouteStringsManager.archiveView: (context) => const ArchiveView(),
    RouteStringsManager.forgetPasswordRoute: (context) =>
        const ForgetPasswordRoute(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final builder = routeBuilders[settings.name];
    if (builder != null) {
      return MaterialPageRoute(
        builder: builder,
        settings: settings,
      );
    }
    // Handle unknown routes
    return MaterialPageRoute(
      builder: (context) => const LoginRoute(),
      settings: settings,
    );
  }
}

// navigation to routes >>
void navigateTo(BuildContext context, String route) {
  final builder = Routes.routeBuilders[route];
  if (builder != null) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  } else {
    // Handle unknown routes
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginRoute(),
      ),
    );
  }
}
