import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/bloc/fetch%20User/fetch_user_cubit.dart';
import 'package:family_management_app/screens/bottom_tabs.dart/calender_screen.dart';
import 'package:family_management_app/screens/bottom_tabs.dart/home_screen.dart';
import 'package:family_management_app/screens/bottom_tabs.dart/kids_screen.dart';
import 'package:family_management_app/screens/bottom_tabs.dart/more_screen.dart';
import 'package:family_management_app/screens/bottom_tabs.dart/tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavigationScreens extends StatefulWidget {
  const NavigationScreens({super.key});

  @override
  State<NavigationScreens> createState() => _NavigationScreensState();
}

class _NavigationScreensState extends State<NavigationScreens> {
  @override
  void initState() {
    super.initState();
    context.read<FetchUserCubit>().getUserRole();
  }

  String? role;
  int selectedIndex = 0;
  final Map<String, List<NavItem>> roleBasedNavigation = {
    "Chief": [
      NavItem(
        page: HomeScreen(),
        icon: Icons.chrome_reader_mode,
        label: "Home",
      ),
      NavItem(
        page: TasksScreen(),
        icon: Icons.check_box_outlined,
        label: "Tasks",
      ),

      NavItem(
        page: CalenderScreen(),
        icon: Icons.calendar_month_outlined,
        label: "Calendar",
      ),
      NavItem(page: KidsScreen(), icon: Icons.child_care, label: "Kids"),
      NavItem(page: MoreScreen(), icon: Icons.compare_arrows, label: "More"),
    ],
    "Lead": [
      NavItem(
        page: HomeScreen(),
        icon: Icons.chrome_reader_mode,
        label: "Home",
      ),
      NavItem(
        page: TasksScreen(),
        icon: Icons.check_box_outlined,
        label: "Tasks",
      ),
      NavItem(
        page: CalenderScreen(),
        icon: Icons.calendar_month_outlined,
        label: "Calendar",
      ),
      NavItem(page: KidsScreen(), icon: Icons.child_care, label: "Kids"),
      NavItem(page: MoreScreen(), icon: Icons.compare_arrows, label: "More"),
    ],
    "Board Member": [
      NavItem(
        page: HomeScreen(),
        icon: Icons.chrome_reader_mode,
        label: "Home",
      ),
      NavItem(
        page: TasksScreen(),
        icon: Icons.check_box_outlined,
        label: "Tasks",
      ),
      NavItem(
        page: CalenderScreen(),
        icon: Icons.calendar_month_outlined,
        label: "Calendar",
      ),
      NavItem(page: KidsScreen(), icon: Icons.child_care, label: "Kids"),
      NavItem(page: MoreScreen(), icon: Icons.compare_arrows, label: "More"),
    ],
    "Guest": [
      NavItem(
        page: HomeScreen(),
        icon: Icons.chrome_reader_mode,
        label: "Home",
      ),
      NavItem(
        page: TasksScreen(),
        icon: Icons.check_box_outlined,
        label: "Tasks",
      ),

      NavItem(page: KidsScreen(), icon: Icons.child_care, label: "Kids"),
      NavItem(page: MoreScreen(), icon: Icons.compare_arrows, label: "More"),
    ],
  };

  void toogleIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<NavItem> get navItems {
    final r = role ?? "Board Member";
    return roleBasedNavigation[r] ?? roleBasedNavigation['Board Member']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,

      body: navItems[selectedIndex].page,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocConsumer<FetchUserCubit, FetchUserState>(
            listener: (context, state) {
              if (state.status == FetchUserStatus.fetched) {
                setState(() {
                  role = state.role ?? "Board Member";
                });
              }
            },

            builder: (context, state) {
              return Container(height: 1, color: AppColor.secondary);
            },
          ),
          SizedBox(height: 5),
          BottomNavigationBar(
            backgroundColor: Colors.transparent,
            onTap: toogleIndex,
            type: BottomNavigationBarType.fixed,
            iconSize: 25.sp,

            selectedItemColor: AppColor.secondary,
            unselectedItemColor: AppColor.textSecondary,
            currentIndex: selectedIndex,
            items: List.generate(navItems.length, (index) {
              return BottomNavigationBarItem(
                icon: Icon(navItems[index].icon),
                label: navItems[index].label,
              );
            }),
          ),
        ],
      ),
    );
  }
}

class NavItem {
  final Widget page;
  final IconData icon;
  final String label;

  NavItem({required this.page, required this.icon, required this.label});
}
