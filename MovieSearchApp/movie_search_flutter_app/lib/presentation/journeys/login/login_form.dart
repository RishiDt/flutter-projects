import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_flutter_app/commons/constants/route_constants.dart';
import 'package:movie_search_flutter_app/commons/extensions/size_extension.dart';
import 'package:movie_search_flutter_app/di/get_it.dart';
import 'package:movie_search_flutter_app/domain/entities/login_request_params.dart';
import 'package:movie_search_flutter_app/presentation/blocs/log_in_out/log_in_out_bloc.dart';

import '../../../commons/constants/size_constants.dart';
import '../../themes/theme_text.dart';
import '../../widgets/button.dart';
import 'label_field_widget.dart';
import 'package:movie_search_flutter_app/di/get_it.dart' as getIt;

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController? _userNameController, _passwordController;
  bool enableSignIn = false;
  late LogInOutBloc logInOutBloc;

  @override
  void initState() {
    getIt.init();
    super.initState();
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    logInOutBloc = getItInstance<LogInOutBloc>();
    logInOutBloc.add(ResumelogInEvent());
    _userNameController?.addListener(() {
      print("login bloc isCLosed:${logInOutBloc.isClosed}");
      print("username changed");
      setState(() {
        enableSignIn = (_userNameController?.text.isNotEmpty ?? false) &&
            (_passwordController?.text.isNotEmpty ??
                false); //Checking whether both fields are filled to enable sign in
      });
    });
    _passwordController?.addListener(() {
      print("password changed");
      setState(() {
        enableSignIn = (_userNameController?.text.isNotEmpty ?? false) &&
            (_passwordController?.text.isNotEmpty ??
                false); //Checking whether both fields are filled to enable sign in
      });
    });
  }

  @override
  void dispose() {
    _userNameController?.dispose();
    _passwordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.dimen_32.w,
          vertical: Sizes.dimen_24.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: Sizes.dimen_8.h),
              child: Text(
                "Login TO TMDB",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            LabelFieldWidget(
              label: "USERNAME",
              hintText: "Enter your TMDB Username",
              controller: _userNameController!,
              textFieldKey: const ValueKey('username_text_field_key'),
            ),
            LabelFieldWidget(
              label: "PASSWORD",
              hintText: "Enter Password",
              controller: _passwordController!,
              isPasswordField: true,
              textFieldKey: const ValueKey('password_text_field_key'),
            ),
            BlocConsumer<LogInOutBloc, LogInOutState>(
              bloc: logInOutBloc,
              buildWhen: (previous, current) => current is LogInErrorState,
              builder: (context, state) {
                if (state is LogInErrorState)
                  return Text(
                    state.message!,
                    style: Theme.of(context).textTheme.orangeSubtitle1,
                  );
                return const SizedBox.shrink();
              },
              listenWhen: (previous, current) => current is LogInSuccessState,
              listener: (context, state) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteConstants.home,
                  (route) => false,
                );
              },
            ),
            // BlocBuilder(
            //   bloc: logInOutBloc,
            //   builder: (context, state) {
            //     if (state is LogInSuccessState) {
            //       Navigator.pushNamedAndRemoveUntil(
            //           context, RouteConstants.home, (route) => false);
            //     } else if (state is LogInErrorState)
            //       return Text(state.message!);

            //     return Text("none");
            //   },
            // ),

            Button(
              onPressed: () {
                print("login clicked and enableSignIn is ${enableSignIn}");
                print("username is :${_userNameController?.text}");
                print("password  is :${_passwordController?.text}");

                enableSignIn
                    ? logInOutBloc.add(LogInEvent(
                        params: LoginRequestParams(
                        userName: _userNameController?.text ?? '',
                        password: _passwordController?.text ?? '',
                      )))
                    : null;
                if (logInOutBloc.state is LogInSuccessState) {}
              },
              text: "Log in",
              isEnabled: enableSignIn,
            ),
            // Button(
            //   onPressed: () =>
            //       BlocProvider.of<LoginCubit>(context).initiateGuestLogin(),
            //   text: TranslationConstants.guestSignIn,
            // ),
          ],
        ),
      ),
    );
  }
}
