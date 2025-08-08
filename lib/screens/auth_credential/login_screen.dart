import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/app/routes/app_routes.dart';
import 'package:family_management_app/app/textStyle/textstyles.dart';
import 'package:family_management_app/app/utils/utils.dart';
import 'package:family_management_app/bloc/login/login_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  bool isHide = true;
  bool isLoading1 = false;
  bool isDialogOpen = false;
  String? emailError;

  String? passwordError;
  void _validateEmail(String value) {
    String emailPattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    if (value.isEmpty) {
      emailError = "Email is required";
    } else if (!RegExp(emailPattern).hasMatch(value)) {
      emailError = "Enter a valid email";
    } else {
      emailError = null;
    }
    setState(() {});
  }

  void _validatePassword(String value) {
    if (value.isEmpty) {
      passwordError = "Password is required";
    } else {
      passwordError = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.logging) {
            setState(() {
              isLoading1 = true;
            });
          } else if (state.status == LoginStatus.logged) {
            setState(() {
              isLoading1 = false;
            });

            Navigator.pushReplacementNamed(context, AppRoutes.navigationScreen);
          } else if (state.status == LoginStatus.loginFailure) {
            setState(() {
              isLoading1 = false;
            });
            myAlertBox(context, subtittle: state.errorMsg!);
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 30.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Welcome Back", style: t1heading()),
                  Text("Sign in to your command center", style: t3White()),

                  SizedBox(height: 40.h),
                  MyTextField(
                    userController: userEmailController,
                    hint: "Email",
                    frontIcon: Icons.email_outlined,
                    errorMsg: emailError,
                    onChangedValue: _validateEmail,
                    isHide: false,
                    onPasswordIconClicked: () {},
                  ),
                  MyTextField(
                    userController: userPasswordController,
                    hint: "Password",
                    frontIcon: Icons.lock_outline_sharp,
                    errorMsg: passwordError,
                    onChangedValue: _validatePassword,
                    isHide: isHide,
                    isbackIcon: true,
                    onPasswordIconClicked: () {
                      setState(() {
                        isHide = !isHide;
                      });
                    },
                  ),
                  BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      return MyButtton(
                        text: "Sign In",
                        isLoading: isLoading1,

                        onPressed: () {
                          _validateEmail(userEmailController.text.trim());
                          _validatePassword(
                            userPasswordController.text.toString(),
                          );
                          if (passwordError == null && emailError == null) {
                            context.read<LoginCubit>().login(
                              email: userEmailController.text.toString(),
                              password: userPasswordController.text.toString(),
                            );
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 30.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.registerScreen,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ", style: t3White()),
                        Text(
                          "Sign Up ",
                          style: t1heading().copyWith(fontSize: 18.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
