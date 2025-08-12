import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/app/images/app_images.dart';
import 'package:family_management_app/app/routes/app_routes.dart';
import 'package:family_management_app/app/textStyle/textstyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late Animation<double> tweenController;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _handleSplashNavigation(context);
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

  Future<void> _handleSplashNavigation(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isFirstInstall = pref.getBool("isFirstInstall") ?? true;
    User? user = auth.currentUser;

    await Future.delayed(const Duration(seconds: 2));

    if (isFirstInstall) {
      Navigator.pushReplacementNamed(context, AppRoutes.splashScreen1);
      return;
    }

    if (user == null || user.uid.isEmpty) {
      Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
      return;
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final role = userDoc.data()?['role'];
    final joinStatus = userDoc.data()?['joinStatus'];
    final wasApprovedShown = userDoc.data()?['wasApprovedShown'] ?? false;

    if (role == 'Chief') {
      Navigator.pushReplacementNamed(context, AppRoutes.navigationScreen);
      return;
    }
    if (role == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.roleSelectionScreen);
      return;
    }

    // For members, check joinStatus
    switch (joinStatus) {
      case 'pending':
        // Navigator.pushReplacementNamed(context, AppRoutes.waitingScreen);
        Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
        break;
      case 'accepted':
        if (!wasApprovedShown) {
          Navigator.pushReplacementNamed(context, AppRoutes.acceptedScreen);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({"wasApprovedShown": true});
        } else {
          if (user.uid.isNotEmpty) {
            Navigator.pushNamed(context, AppRoutes.navigationScreen);
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
          }
        }
        break;
      case 'rejected':
        Navigator.pushReplacementNamed(context, AppRoutes.rejectedScreen);
        break;
      default:
        Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
        break;
    }
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
