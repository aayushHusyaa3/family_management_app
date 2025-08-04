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
  Future<String?> getEmail() async {
    return await SecureStorage.read(key: 'email');
  }

  Future<String?> getRole() async {
    return await SecureStorage.read(key: 'role');
  }

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
                child: myTextHolderContainer(
                  borderColor: index == 8 ? AppColor.error : AppColor.secondary,
                  horizontal: 15.w,
                  child: GestureDetector(
                    onTap: () {
                      bloc.logOut();
                    },
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
                            if (state.status == FetchUserStatus.logout) {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.loginScreen,
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  index == 0
                                      ? "${state.email}"
                                      : moreOptions[index]["title"]!,
                                  style: t3White().copyWith(
                                    color: index == 8
                                        ? AppColor.error
                                        : AppColor.textSecondary,
                                  ),
                                ),
                                Text(
                                  index == 0
                                      ? "${state.role ?? getRole()}"
                                      : moreOptions[index]['subtitle']!,
                                  style: hintTextStyle(),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
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
