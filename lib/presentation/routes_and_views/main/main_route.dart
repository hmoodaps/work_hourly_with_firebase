import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:work_hourly/app/components/constants/color_manager.dart';
import 'package:work_hourly/presentation/cubit/app_states.dart';
import 'package:work_hourly/presentation/cubit/cubit_class.dart';

import '../../../app/handle_app_language/handle_app_language.dart';
import '../drawer/drawer_view.dart';
import '../main_screen/main_screen.dart';

class MainRoute extends StatefulWidget {
  const MainRoute({super.key});

  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  final _zoomDrawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitClass, AppStates>(builder: (context, state) {
      return Scaffold(
        backgroundColor: ColorManager.privateGrey,
        body: ZoomDrawer(
          menuScreenTapClose: true,
          moveMenuScreen: true,
          isRtl: TheAppLanguage.appLanguage == 'ar' ? true : false,
          controller: _zoomDrawerController,
          menuScreen: MenuScreen(),
          mainScreen: MainScreen(zoomDrawerController: _zoomDrawerController),
          borderRadius: 24.0,
          showShadow: true,
          angle: -12.0,
          shadowLayer1Color: ColorManager.green2,
          shadowLayer2Color: ColorManager.green4,
          drawerShadowsBackgroundColor: Colors.grey,
          slideWidth: MediaQuery.of(context).size.width * 0.65,
          openCurve: Curves.fastOutSlowIn,
          closeCurve: Curves.bounceIn,
        ),
      );
    });
  }
}
