import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staggered_animated_widget/staggered_animated_widget.dart';
import 'package:work_hourly/presentation/cubit/cubit_class.dart';

import '../../../app/components/constants/buttons_manager.dart';
import '../../../app/components/constants/color_manager.dart';
import '../../../app/components/constants/font_manager.dart';
import '../../../app/components/constants/general_strings.dart';
import '../../../app/components/constants/icons_manager.dart';
import '../../../app/components/constants/size_manager.dart';
import '../../../app/components/constants/text_form_manager.dart';
import '../../../domain/local_models/models/models.dart';
import '../../cubit/app_states.dart';
import 'forget_password_model.dart';

class ForgetPasswordRoute extends StatefulWidget {
  const ForgetPasswordRoute({super.key});

  @override
  State<ForgetPasswordRoute> createState() => _ForgetPasswordRouteState();
}

class _ForgetPasswordRouteState extends State<ForgetPasswordRoute> {
  late ForgetPasswordModelView _model;
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _model = ForgetPasswordModelView();
    _model.context = context;
    _model.start();
  }

  @override
  void dispose() {
    super.dispose();
    _model.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitClass, AppStates>(
        builder: (context, state) => _getScaffold());
  }

  Widget _getScaffold() => Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: IconsManager.arrowBack),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(SizeManager.d24),
              child: Form(
                key: formkey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StaggeredAnimatedWidget(
                          delay: SizeManager.i200,
                          child: Text(
                            GeneralStrings.resetPassword(context),
                            style: TextStyleManager.header(context)
                                ?.copyWith(fontSize: SizeManager.d24),
                          )),
                      SizedBox(
                        height: SizeManager.d50,
                      ),
                      StaggeredAnimatedWidget(
                        delay: SizeManager.i400,
                        child: Text(
                          GeneralStrings.ltsResetPassword(context),
                          style: TextStyleManager.titleStyle(context),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 8,
                      ),
                      StaggeredAnimatedWidget(
                        delay: SizeManager.i600,
                        child: textFormField(
                          controller: _model.emailController,
                          context: context,
                          labelText: GeneralStrings.ahmadEmail,
                          fillColor: ColorManager.privateGrey,
                          filled: true,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => validator(value, context),
                          prefix: Icon(IconsManager.email),
                        ),
                      ),
                      SizedBox(
                        height: SizeManager.d50,
                      ),
                      googleAndAppleButton(
                        nameOfButton: GeneralStrings.resetPassword(context),
                        context: context,
                        delay: SizeManager.i800,
                        onTap: () {
                          if (formkey.currentState!.validate()) {
                            _model.resetPassword(
                                _model.emailController.text.trim());
                          }
                        },
                        color: ColorManager.primarySecond,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
