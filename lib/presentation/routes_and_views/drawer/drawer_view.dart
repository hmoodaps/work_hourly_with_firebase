import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_hourly/app/components/constants/general_strings.dart';
import 'package:work_hourly/app/components/constants/route_strings_manager.dart';
import 'package:work_hourly/app/components/constants/routs_manager.dart';
import 'package:work_hourly/app/components/constants/size_manager.dart';
import 'package:work_hourly/domain/local_models/models/models.dart';
import 'package:work_hourly/presentation/cubit/cubit_class.dart';

import '../../../app/components/constants/assets_manager.dart';
import '../../../app/components/constants/color_manager.dart';
import '../../../app/components/constants/icons_manager.dart';
import '../../cubit/app_states.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitClass, AppStates>(builder: (context, state) {
      CubitClass cubit = CubitClass.get(context);
      return Scaffold(
        body: Container(
          color: ColorManager.privateGrey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 4,
                child: Image.asset(AssetsManager.just4prog),
              ),
              SizedBox(height: 150),
              ListTile(
                  leading: Icon(IconsManager.home, color: ColorManager.green2),
                  title: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(GeneralStrings.home(context)))),
              ListTile(
                  onTap: () {
                    navigateTo(context, RouteStringsManager.historyView);
                  },
                  leading: Icon(
                    IconsManager.history,
                    color: ColorManager.green2,
                  ),
                  title: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(GeneralStrings.history(context)))),
              ListTile(
                  onTap: () {
                    navigateTo(context, RouteStringsManager.archiveView);
                  },
                  leading: Icon(
                    IconsManager.archive,
                    color: ColorManager.green2,
                  ),
                  title: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(GeneralStrings.archive(context)))),
              ListTile(
                  onTap: () {
                    navigateTo(context, RouteStringsManager.salariesView);
                  },
                  leading: Icon(
                    IconsManager.salary,
                    color: ColorManager.green2,
                  ),
                  title: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(GeneralStrings.salary(context)))),
              ListTile(
                onTap: () {
                  cubit.isLanguagePressed();
                },
                leading: Icon(
                  IconsManager.language,
                  color: ColorManager.green2,
                ),
                title: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    children: [
                      Text(
                        GeneralStrings.language(context),
                      ),
                      Visibility(
                          visible: cubit.languagePressed,
                          child: SizedBox(
                            width: SizeManager.d8,
                          )),
                      Visibility(
                        visible: cubit.languagePressed,
                        child: LanguageSelector(cubit),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              ListTile(
                  onTap: () {
                    cubit.logout();
                  },
                  leading: Icon(
                    IconsManager.login,
                    color: ColorManager.green2,
                  ),
                  title:
                      FittedBox(child: Text(GeneralStrings.logout(context)))),
            ],
          ),
        ),
      );
    });
  }
}
