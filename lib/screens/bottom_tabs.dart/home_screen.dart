import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/app/images/app_images.dart';
import 'package:family_management_app/app/routes/app_routes.dart';
import 'package:family_management_app/app/textStyle/textstyles.dart';
import 'package:family_management_app/app/utils/custom_drawar.dart';
import 'package:family_management_app/app/utils/utils.dart';
import 'package:family_management_app/bloc/fetch%20User/fetch_user_cubit.dart';
import 'package:family_management_app/bloc/fetch_tasks/fetch_tasks_cubit.dart';
import 'package:family_management_app/service/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initialCallingFunction();
  }

  Future<String?> getRole() async {
    return await SecureStorage.read(key: "role");
  }

  Future<void> initialCallingFunction() async {
    context.read<FetchUserCubit>().getUserRole();
    context.read<FetchTasksCubit>().fetchTasks();
  }

  List<IconData> icons = [
    Icons.check_box_outlined,
    Icons.calendar_month_outlined,
    Icons.trending_up,
    Icons.notifications_none_outlined,
  ];

  List<String> headings = [
    "Active Tasks",
    "Today's Events",
    "Efficiency Score",
    "Notifications",
  ];

  List<String> noHeadings = [
    "Add Tasks",
    "Add Events",
    "Efficiency Score",
    "Notifications",
  ];
  List<String> subtitles = ["3", "10", "87%", "2"];
  List<String> feedbacks = [
    "1 urgent",
    "0 upcoming",
    "+5% this week",
    "1 requires action",
  ];
  String? taskCount;
  String? urgentCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      drawer: MyCustomDrawar(),

      appBar: AppBar(
        backgroundColor: AppColor.background,
        iconTheme: IconThemeData(color: AppColor.secondary, size: 25.sp),
        title: Text("Home Ops", style: t1heading().copyWith(fontSize: 30.sp)),
        centerTitle: true,
        actionsPadding: EdgeInsets.only(right: 15.w),
        actions: [
          Row(
            children: [
              MyProfileHolder(imagePath: AppImages.logo),
              SizedBox(width: 10.w),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.addTasksScreen);
                },
                child: Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),

      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 17.w, right: 17.w, bottom: 80.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<FetchUserCubit, FetchUserState>(
                    builder: (context, state) {
                      return Text(
                        "Welcome back, ${state.role ?? getRole()} \nExecutive",
                        style: t1heading().copyWith(fontSize: 30.sp),
                      );
                    },
                  ),
                  Text(" Your command center overview", style: t3White()),
                  SizedBox(height: 20.h),
                  BlocListener<FetchTasksCubit, FetchTasksState>(
                    listener: (context, state) {
                      if (state.status == FetchTasksStatus.fetching) {
                      } else if (state.status == FetchTasksStatus.fetched) {
                        setState(() {
                          taskCount = state.taskCount?.toString() ?? "1";
                          urgentCount = state.urgentCount?.toString() ?? "0";
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyTaskHolderBox(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.addTasksScreen,
                            );
                          },
                          icon: icons[0],
                          headingText: headings[0],
                          subtitle: taskCount ?? "1",
                          noHeadingText: noHeadings[0],
                          subWidget: (state) {
                            if (state.status == FetchTasksStatus.fetching) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: myShimmerTextBox(width: 40, height: 35),
                              );
                            } else {
                              return Text(taskCount ?? "1", style: t1heading());
                            }
                          }(context.watch<FetchTasksCubit>().state),
                          feedback: "${urgentCount ?? "0"} urgent",
                        ),
                        MyTaskHolderBox(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.addTasksScreen,
                            );
                          },
                          icon: icons[1],
                          headingText: headings[1],
                          subtitle: subtitles[1],
                          feedback: feedbacks[1],
                          noHeadingText: noHeadings[1],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyTaskHolderBox(
                        onPressed: () {},
                        icon: icons[2],
                        headingText: headings[2],
                        subtitle: subtitles[2],
                        feedback: feedbacks[2],
                        noHeadingText: noHeadings[2],
                      ),
                      MyTaskHolderBox(
                        onPressed: () {},
                        icon: icons[3],
                        headingText: headings[3],
                        subtitle: subtitles[3],
                        feedback: feedbacks[3],
                        noHeadingText: noHeadings[3],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    " Quick Actions",
                    style: t1heading().copyWith(fontSize: 20.sp),
                  ),
                  SizedBox(height: 10.h),
                  myTextHolderContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("• Add New Task", style: t3White()),
                        Text("• Schedule Event", style: t3White()),
                        Text("• View Reports", style: t3White()),
                        Text("• Add New Task", style: t3White()),
                        Text("• Schedule Event", style: t3White()),
                        Text("• View Reports", style: t3White()),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    " AI Insights",
                    style: t1heading().copyWith(fontSize: 20.sp),
                  ),
                  SizedBox(height: 10.h),
                  myTextHolderContainer(
                    child: Text(
                      softWrap: true,
                      "Based on your family's schedule, consider moving grocery shopping to Tuesday mornings for better efficiency",
                      style: t3White(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 50.h,
                  left: 17.w,
                  right: 17.w,
                  bottom: 15.h,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.background,
                    borderRadius: BorderRadius.circular(20.r),
                    border: BoxBorder.all(
                      width: 1.w,
                      color: AppColor.secondary,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 25.w,
                    ),
                    child: Row(
                      children: [
                        Text("Ask Home Ops AI", style: t3White()),
                        Spacer(),
                        Icon(Icons.mic_outlined, color: AppColor.secondary),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Drawarclass(){
  //   return Drawer()
  // }
}
