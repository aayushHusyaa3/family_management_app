import 'package:family_management_app/app/routes/app_routes.dart';
import 'package:family_management_app/screens/auth_credential/login_screen.dart';
import 'package:family_management_app/screens/auth_credential/register_screen.dart';
import 'package:family_management_app/screens/auth_credential/role_selection_screen.dart';
import 'package:family_management_app/screens/bottom_tabs.dart/calender_screen.dart';
import 'package:family_management_app/screens/bottom_tabs.dart/home_screen.dart';
import 'package:family_management_app/screens/bottom_tabs.dart/kids_screen.dart';
import 'package:family_management_app/screens/bottom_tabs.dart/more_screen.dart';
import 'package:family_management_app/screens/bottom_tabs.dart/navigation_screens.dart';
import 'package:family_management_app/screens/bottom_tabs.dart/tasks_screen.dart';
import 'package:family_management_app/screens/drawer_navigation/Weekly_insights.dart';
import 'package:family_management_app/screens/drawer_navigation/command_center.dart';
import 'package:family_management_app/screens/drawer_navigation/shopping.dart';
import 'package:family_management_app/screens/functionality/addevents_screen.dart';
import 'package:family_management_app/screens/functionality/addtask_screen.dart';

import 'package:family_management_app/screens/onBoardScreen/onboarding_Screen1.dart';
import 'package:family_management_app/screens/onBoardScreen/onboarding_screen.dart';
import 'package:family_management_app/screens/onBoardScreen/onboarding_screen2.dart';
import 'package:family_management_app/screens/splash%20screens/splash_screen1.dart';

import 'package:family_management_app/screens/splash%20screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  AppRouter();

  PageRouteBuilder transtionTo(Widget page) {
    return PageRouteBuilder(
      barrierColor: Colors.white,
      transitionDuration: Duration(microseconds: 300),
      reverseTransitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(
              begin: Offset(1.0, 00),
              end: Offset(0, 0),
            ).chain(CurveTween(curve: Curves.bounceIn)),
          ),
          child: page,
        );
      },
    );
  }

  Route generateRoutes(RouteSettings settings) {
    if (settings.name == AppRoutes.splashScreen) {
      return transtionTo(SplashScreen());
    } else if (settings.name == AppRoutes.splashScreen1) {
      return transtionTo(SplashScreen1());
    } else if (settings.name == AppRoutes.onBoardingScreen) {
      return transtionTo(Onboardingscreen());
    } else if (settings.name == AppRoutes.onBoardingScreen1) {
      return transtionTo(OnboardingScreen1());
    } else if (settings.name == AppRoutes.onBoardingScreen2) {
      return transtionTo(OnboardingScreen2());
    } else if (settings.name == AppRoutes.loginScreen) {
      return transtionTo(LoginScreen());
    } else if (settings.name == AppRoutes.registerScreen) {
      return transtionTo(RegisterScreen());
    } else if (settings.name == AppRoutes.navigationScreen) {
      return transtionTo(NavigationScreens());
    } else if (settings.name == AppRoutes.homeScreen) {
      return transtionTo(HomeScreen());
    } else if (settings.name == AppRoutes.commandCenterScreen) {
      return transtionTo(CommandCenterScreen());
    } else if (settings.name == AppRoutes.shoppingScreen) {
      return transtionTo(ShoppingScren());
    } else if (settings.name == AppRoutes.weeklyinsightsScreen) {
      return transtionTo(WeeklyInsightsScreen());
    } else if (settings.name == AppRoutes.dashBoardScreen) {
      return transtionTo(HomeScreen());
    } else if (settings.name == AppRoutes.tasksScreen) {
      return transtionTo(TasksScreen());
    } else if (settings.name == AppRoutes.kidsScreen) {
      return transtionTo(KidsScreen());
    } else if (settings.name == AppRoutes.calendarScreen) {
      return transtionTo(CalenderScreen());
    } else if (settings.name == AppRoutes.settingScreen) {
      return transtionTo(MoreScreen());
    } else if (settings.name == AppRoutes.addTasksScreen) {
      return transtionTo(AddtaskScreen());
    } else if (settings.name == AppRoutes.addEventsScreen) {
      return transtionTo(AddEventsScreen());
    } else if (settings.name == AppRoutes.roleSelectionScreen) {
      return transtionTo(RoleSelectionScreen());
    } else {
      return transtionTo(SplashScreen());
    }
  }
}
