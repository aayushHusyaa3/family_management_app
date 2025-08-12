import 'dart:developer';

import 'package:family_management_app/app/routes/app_routes.dart';
import 'package:family_management_app/bloc/fetch%20User/fetch_user_cubit.dart';
import 'package:family_management_app/service/secure_storage.dart';
import 'package:flutter/material.dart';

import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/app/textStyle/textstyles.dart';
import 'package:family_management_app/app/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  int notificationCount = -1;
  List<IconData> iconsList = [
    Icons.security, // Security
    Icons.notifications, // Notifications
    Icons.lightbulb, // AI Smart Suggestions
    Icons.insights, // Mental Lead Tracker
    Icons.mic, // Voice Commands
    Icons.family_restroom, // Family Management
    Icons.settings, // Settings
    Icons.help_outline, // Help and Support
    Icons.logout,
  ];
  final List<Map<String, String>> moreOptions = [
    {'title': 'admin@homeops.com', 'subtitle': 'Chief'},
    {
      'title': 'Notifications',
      'subtitle': 'Manage push notifications and alerts',
    },
    {
      'title': 'AI Smart Suggestions',
      'subtitle': 'Personalized recommendations for your family',
    },
    {
      'title': 'Mental Load Tracker',
      'subtitle': 'Track and balance family responsibilities',
    },
    {
      'title': 'Voice Commands',
      'subtitle': 'Use voice to add tasks and events',
    },
    {
      'title': 'Family Management',
      'subtitle': 'Manage family members and roles',
    },
    {'title': 'Settings', 'subtitle': 'App preferences and account settings'},
    {'title': 'Help & Support', 'subtitle': 'Get help and contact support'},
    {'title': 'Sign Out', 'subtitle': 'Sign out of your account'},
  ];
  @override
  void initState() {
    super.initState();
    context.read<FetchUserCubit>().fetchJoinRequests();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FetchUserCubit>();
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        automaticallyImplyLeading: false,
        toolbarHeight: 80.h,
        titleSpacing: 20.w,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("More Options", style: t1heading().copyWith(fontSize: 30.sp)),
            Text("Settings and additional features", style: t3White()),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(moreOptions.length, (index) {
              return Padding(
                padding: EdgeInsetsGeometry.only(bottom: 15.h),
                child: GestureDetector(
                  onTap: () async {
                    if (index == 0) {
                      log('Tapped on item 0');
                    } else if (index == 1) {
                      bloc.resetNotificationCount();
                      setState(() {
                        notificationCount = -1; // Reset notification count
                      });
                      Navigator.pushNamed(
                        context,
                        AppRoutes.notificationShowerScreen,
                      );
                      log('Tapped on item 1');
                    } else if (index == 2) {
                      log('Tapped on item 2');
                    } else if (index == 3) {
                      log('Tapped on item 3');
                    } else if (index == 4) {
                      log('Tapped on item 4');
                    } else if (index == 5) {
                      log('Tapped on item 5');
                    } else if (index == 6) {
                      log('Tapped on item 6');
                    } else if (index == 7) {
                      log('Tapped on item 7');
                    } else if (index == 8) {
                      bloc.logOut();
                      await SecureStorage.deleteAll();
                    } else {
                      log('Tapped on other item');
                    }
                  },
                  child: myTextHolderContainer(
                    borderColor: index == 8
                        ? AppColor.error
                        : AppColor.secondary,
                    horizontal: 15.w,
                    child: BlocListener<FetchUserCubit, FetchUserState>(
                      listener: (context, state) {
                        if (state.status == FetchUserStatus.loggedOut) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.loginScreen,
                            (route) => false,
                          );
                          SecureStorage.deleteAll();

                          mySnackBar(context, title: "log out Successfully");
                        } else if (state.status == FetchUserStatus.fetched) {
                          if (notificationCount != 0) {
                            setState(() {
                              notificationCount = state.pendingCount ?? 0;
                            });
                          }
                        }
                      },
                      child: GestureDetector(
                        child: Row(
                          children: [
                            index == 0
                                ? Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor.secondary,
                                    ),

                                    child: Padding(
                                      padding: EdgeInsets.all(5.r),
                                      child: Icon(
                                        iconsList[index],
                                        color: AppColor.blackColor,
                                        size: 22.sp,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    iconsList[index],
                                    color: index == 8
                                        ? AppColor.error
                                        : AppColor.secondary,
                                    size: 25.sp,
                                  ),
                            SizedBox(width: 7.w),
                            BlocBuilder<FetchUserCubit, FetchUserState>(
                              builder: (context, state) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      index == 0
                                          ? state.email ?? "admin@homeops.com"
                                          : moreOptions[index]["title"]!,
                                      style: t3White().copyWith(
                                        color: index == 8
                                            ? AppColor.error
                                            : AppColor.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      index == 0
                                          ? state.role ?? "Chief"
                                          : moreOptions[index]['subtitle']!,
                                      style: hintTextStyle(),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Spacer(),
                            index == 1
                                ? notificationCount > 0
                                      ? Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColor.error,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.r),
                                            child: Text(
                                              "$notificationCount",
                                              style: hintTextStyle().copyWith(
                                                color: AppColor.textSecondary,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox()
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
