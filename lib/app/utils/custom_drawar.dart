import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/app/images/app_images.dart';
import 'package:family_management_app/app/routes/app_routes.dart';
import 'package:family_management_app/app/textStyle/textstyles.dart';
import 'package:family_management_app/app/utils/utils.dart';
import 'package:family_management_app/bloc/fetch%20User/fetch_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCustomDrawar extends StatefulWidget {
  const MyCustomDrawar({super.key});

  @override
  State<MyCustomDrawar> createState() => _MyCustomDrawarState();
}

class _MyCustomDrawarState extends State<MyCustomDrawar> {
  String? role;

  Map<String, List> getIcon(BuildContext context) {
    if (role == "Cheif" || role == "Lead") {
      return {
        "icons": [
          Icons.home,
          Icons.check_circle_outline,
          Icons.dashboard_customize,
          Icons.shopping_cart,
          Icons.child_care,
          Icons.calendar_month,
          Icons.bar_chart,
          Icons.settings,
          Icons.logout,
        ],
        "label": [
          "Home",
          "Tasks",
          "Command Center",
          "Shopping Cart & Planner",
          "Kids Profile",
          "Calendar",
          "Weekly Insights",
          "Settings",
          "Log Out",
        ],
        "actions": [
          () => Navigator.pushNamed(context, AppRoutes.homeScreen),
          () => Navigator.pushNamed(context, AppRoutes.tasksScreen),
          () => Navigator.pushNamed(context, AppRoutes.commandCenterScreen),
          () => Navigator.pushNamed(context, AppRoutes.shoppingScreen),
          () => Navigator.pushNamed(context, AppRoutes.kidsScreen),
          () => Navigator.pushNamed(context, AppRoutes.calendarScreen),
          () => Navigator.pushNamed(context, AppRoutes.weeklyinsightsScreen),
          () => Navigator.pushNamed(context, AppRoutes.settingScreen),
          () {
            myAlertBox(
              context,
              subtittle: "Are you Sure  you want to logout?",
              heading: "Logout",
            );
          },
        ],
      };
    } else if (role == "Board Member") {
      return {
        "icons": [
          Icons.home,
          Icons.check_circle_outline,
          Icons.dashboard_customize,
          Icons.child_care,
          Icons.calendar_month,
          Icons.bar_chart,
          Icons.settings,
          Icons.logout,
        ],
        "label": [
          "Home",
          "Tasks",
          "Command Center",
          "Kids Profile",
          "Calendar",
          "Weekly Insights",
          "Settings",
          "Log Out",
        ],
        "actions": [
          () => Navigator.pushNamed(context, AppRoutes.homeScreen),
          () => Navigator.pushNamed(context, AppRoutes.tasksScreen),
          () => Navigator.pushNamed(context, AppRoutes.commandCenterScreen),
          () => Navigator.pushNamed(context, AppRoutes.kidsScreen),
          () => Navigator.pushNamed(context, AppRoutes.calendarScreen),
          () => Navigator.pushNamed(context, AppRoutes.weeklyinsightsScreen),
          () => Navigator.pushNamed(context, AppRoutes.settingScreen),
          () {
            myAlertBox(
              context,
              subtittle: "Are you Sure you want to logout?",
              heading: "Logout",
            );
          },
        ],
      };
    }
    return {
      "icons": [Icons.home, Icons.child_care, Icons.settings, Icons.logout],
      "label": ["Home", "Kids Profile", "Settings", "Log Out"],
      "actions": [
        () => Navigator.pushNamed(context, AppRoutes.homeScreen),
        () => Navigator.pushNamed(context, AppRoutes.kidsScreen),
        () => Navigator.pushNamed(context, AppRoutes.settingScreen),
        () {
          myAlertBox(
            context,
            subtittle: "Are you Sure you want to logout?",
            heading: "Logout",
          );
        },
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final roleBaseIcons = getIcon(context);
    return Drawer(
      backgroundColor: AppColor.background,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 70.h, horizontal: 30.w),
        child: BlocBuilder<FetchUserCubit, FetchUserState>(
          builder: (context, state) {
            if (state.status == FetchUserStatus.fetched) {
              role = state.role ?? "Guest";
            } else if (state.status == FetchUserStatus.fetching) {
              return myTasksShimmerBox(
                width: double.infinity,
                height: 50,
                itemCount: 6,
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    MyProfileHolder(
                      width: 70,
                      height: 70,
                      imagePath: AppImages.mainLogo,
                    ),
                    SizedBox(width: 15.sp),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Aayush",
                          style: t1heading().copyWith(fontSize: 20.sp),
                        ),
                        Text(
                          state.role!,
                          style: hintTextStyle().copyWith(fontSize: 20.sp),
                        ),
                      ],
                    ),
                  ],
                ),
                profileInfoROw(
                  icon: Icons.email,
                  text: state.email!,
                  onPressed: () {},
                ),
                Divider(thickness: 1, color: AppColor.secondary),
                SizedBox(height: 10.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(roleBaseIcons['icons']!.length, (
                    index,
                  ) {
                    return profileInfoROw(
                      onPressed: roleBaseIcons['actions']![index],
                      icon: roleBaseIcons['icons']![index],
                      text: roleBaseIcons['label']![index],
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget profileInfoROw({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: AppColor.secondary),
            SizedBox(width: 10.h),
            Expanded(
              child: Text(
                overflow: TextOverflow.ellipsis,

                text,
                style: t1heading().copyWith(
                  fontSize: 20.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
