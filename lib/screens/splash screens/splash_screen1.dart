import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/app/images/app_images.dart';
import 'package:family_management_app/app/routes/app_routes.dart';
import 'package:family_management_app/app/textStyle/textstyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    checkFlowAndNavigate(context);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = Tween<double>(begin: 0.0, end: 250.0).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> checkFlowAndNavigate(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isFirstInstall = pref.getBool("isFirstInstall") ?? true;
    User? user = auth.currentUser;
    Future.delayed(Duration(seconds: 3), () {
      if (isFirstInstall) {
        Navigator.pushNamed(context, AppRoutes.onBoardingScreen);
      } else {
        if (user != null && user.uid.isNotEmpty) {
          Navigator.pushReplacementNamed(context, AppRoutes.navigationScreen);
        } else {
          Navigator.pushNamed(context, AppRoutes.loginScreen);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("HOME OPS", style: t1heading()),
              SizedBox(height: 30.h),

              SizedBox(width: 250.w, child: Image.asset(AppImages.logo)),
              SizedBox(height: 30.h),
              Text(
                "RUN THE COMMAND CENTER FOR YOUR HOME",
                textAlign: TextAlign.center,
                style: t1().copyWith(color: AppColor.secondary),
              ),
              SizedBox(height: 30.h),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    width: _animation.value,
                    height: 4.h,
                    color: AppColor.secondary,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
