import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/app/images/app_images.dart';
import 'package:family_management_app/app/routes/app_routes.dart';
import 'package:family_management_app/app/textStyle/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> tweenController;

  @override
  void initState() {
    super.initState();
    navigateToNextSplashScreen(context);
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );
    tweenController = Tween<double>(
      begin: 0,
      end: 1.0,
    ).animate(animationController);
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> navigateToNextSplashScreen(context) async {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushNamed(context, AppRoutes.splashScreen1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: AnimatedBuilder(
        animation: tweenController,
        builder: (context, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: animationController,
                  child: Container(
                    width: 250.w,
                    height: 250.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      image: DecorationImage(
                        image: AssetImage(AppImages.logo),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                DefaultTextStyle(
                  style: t1White().copyWith(
                    fontSize: 35.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.secondary,
                  ),

                  child: AnimatedTextKit(
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TyperAnimatedText(
                        'Home Ops',
                        speed: Duration(milliseconds: 250),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
