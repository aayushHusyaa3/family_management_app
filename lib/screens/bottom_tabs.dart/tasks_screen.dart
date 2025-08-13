import 'package:confetti/confetti.dart';
import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/app/images/app_images.dart';
import 'package:family_management_app/app/routes/app_routes.dart';
import 'package:family_management_app/app/textStyle/textstyles.dart';
import 'package:family_management_app/app/utils/utils.dart';
import 'package:family_management_app/bloc/fetch%20User/fetch_user_cubit.dart';
import 'package:family_management_app/bloc/fetch_tasks/fetch_tasks_cubit.dart';
import 'package:family_management_app/service/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late ConfettiController confettiController;
  List<String> tasksChecked = [];
  List<String> deletedTaskIds = [];
  int selectedIndex = 0;
  bool isOpacity = false;
  int activeTab = 0;

  String? secureRole;
  String? secureEmail;

  @override
  void initState() {
    super.initState();
    context.read<FetchUserCubit>().getUserRole();
    getSecureData();
    confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  Future<void> getSecureData() async {
    final role = await SecureStorage.read(key: "role");
    final email = await SecureStorage.read(key: "email");
    setState(() {
      secureRole = role ?? "Guest";
      secureEmail = email ?? "";
    });
  }

  void onMarkAsDoneButtonPressed() {
    confettiController.play();
  }

  final List<Map<String, dynamic>> expandedIcons = [
    {"icon": Icons.add, "color": AppColor.secondary},
    {"icon": Icons.done, "color": AppColor.success},
    {"icon": Icons.delete_outline, "color": AppColor.error},
  ];
  final List<String> tabTitles = ["Pending", "Completed"];

  @override
  Widget build(BuildContext context) {
    final taskBloc = context.read<FetchTasksCubit>();
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
            Text(
              "Task Management",
              style: t1heading().copyWith(fontSize: 30.sp),
            ),
            Text(" Manage and assign tasks", style: t3White()),
          ],
        ),
      ),
      body: BlocListener<FetchUserCubit, FetchUserState>(
        listener: (context, state) {
          if (state.status == FetchUserStatus.fetched) {
            context.read<FetchTasksCubit>().fetchTasks();
          }
        },
        child: BlocListener<FetchTasksCubit, FetchTasksState>(
          listener: (context, taskState) {
            if (taskState.status == FetchTasksStatus.deleting) {
              setState(() {
                isOpacity = true;
              });
            } else if (taskState.status == FetchTasksStatus.deleted) {
              mySnackBar(context, title: taskState.errorMsg!);
              setState(() {
                tasksChecked.clear();
                isOpacity = false;
              });
            } else if (taskState.status == FetchTasksStatus.marking) {
              setState(() {
                isOpacity = true;
              });
            } else if (taskState.status == FetchTasksStatus.marked) {
              mySnackBar(context, title: taskState.errorMsg!);
              setState(() {
                tasksChecked.clear();
                isOpacity = false;
              });
            }
          },
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple,
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ).copyWith(bottom: 0.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: MySearchField(hintText: "Search for tasks"),
                        ),
                        secureRole == "Chief" || secureRole == "Lead"
                            ? tasksChecked.isEmpty
                                  ? Padding(
                                      padding: EdgeInsets.only(left: 10.w),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            AppRoutes.addTasksScreen,
                                          );
                                        },
                                        child: Icon(
                                          expandedIcons[0]['icon'],
                                          size: 27.sp,
                                          color: expandedIcons[0]['color'],
                                        ),
                                      ),
                                    )
                                  : SizedBox()
                            : SizedBox(),

                        secureRole == "Chief" || secureRole == "Lead"
                            ? tasksChecked.isNotEmpty
                                  ? Row(
                                      children: List.generate(2, (index) {
                                        return Padding(
                                          padding: EdgeInsets.only(left: 10.w),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (index == 1) {
                                                taskBloc.deleteTask(
                                                  taskId: tasksChecked,
                                                );
                                              }
                                              if (index == 0 &&
                                                  selectedIndex == 0) {
                                                taskBloc.markAsDoneFun(
                                                  taskId: tasksChecked,
                                                );
                                                if (isOpacity == false) {
                                                  onMarkAsDoneButtonPressed();
                                                }
                                              }
                                            },
                                            child: Icon(
                                              expandedIcons[index + 1]['icon'],
                                              size: 27.sp,
                                              color:
                                                  selectedIndex == 1 &&
                                                      index == 0
                                                  ? Colors.grey
                                                  : expandedIcons[index +
                                                        1]['color'],
                                            ),
                                          ),
                                        );
                                      }),
                                    )
                                  : SizedBox()
                            : tasksChecked.isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: GestureDetector(
                                  onTap: () {
                                    taskBloc.markAsDoneFun(
                                      taskId: tasksChecked,
                                    );
                                    onMarkAsDoneButtonPressed();
                                  },
                                  child: Icon(
                                    expandedIcons[1]['icon'],
                                    size: 27.sp,
                                    color: expandedIcons[1]['color'],
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Container(
                          height: 1.h,
                          width: double.infinity,
                          color: Colors.grey[500],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(tabTitles.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                context.read<FetchTasksCubit>().fetchTasks(
                                  status: index == 0 ? "pending" : "completed",
                                );
                                setState(() {
                                  selectedIndex = index;
                                  activeTab = selectedIndex;
                                  tasksChecked.clear();
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 20.w),
                                child: IntrinsicWidth(
                                  child: Column(
                                    children: [
                                      Text(
                                        tabTitles[index],
                                        style: t1().copyWith(
                                          color: selectedIndex == index
                                              ? AppColor.border
                                              : Colors.grey.shade400,
                                          fontSize: 25.sp,
                                        ),
                                      ),

                                      SizedBox(height: 8.h),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: selectedIndex == index
                                              ? AppColor.warning
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            2.r,
                                          ),
                                        ),
                                        height: 1.4.h,
                                        width: double.infinity,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    BlocBuilder<FetchUserCubit, FetchUserState>(
                      builder: (context, userState) {
                        return BlocBuilder<FetchTasksCubit, FetchTasksState>(
                          builder: (context, state) {
                            if (state.status == FetchTasksStatus.fetching ||
                                userState.status == FetchUserStatus.fetching) {
                              return Expanded(
                                child: ListView.builder(
                                  itemCount: selectedIndex == 1
                                      ? state.taskCount
                                      : 4,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return myTasksShimmerBox(
                                      width: double.infinity,
                                      height: 120,
                                      itemCount: 1,
                                    );
                                  },
                                ),
                              );
                            }
                            return state.taskInfoList!.isEmpty
                                ? Column(
                                    children: [
                                      SizedBox(height: 30.h),
                                      Image.asset(
                                        AppImages.noItem,
                                        fit: BoxFit.cover,
                                      ),

                                      Text(
                                        textAlign: TextAlign.center,
                                        selectedIndex == 0
                                            ? "No Assisgned Tasks\nClick '+' to assign Task"
                                            : "No Completed Tasks ",
                                        style: t1White(),
                                      ),
                                    ],
                                  )
                                : selectedIndex == 0
                                ? Expanded(
                                    child: ListView.builder(
                                      itemCount: state.taskInfoList!.length,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      padding: EdgeInsets.only(bottom: 30.h),
                                      itemBuilder: (context, index) {
                                        final taskInfo =
                                            state.taskInfoList![index];
                                        final bool isDeleting = tasksChecked
                                            .contains(taskInfo.taskId);
                                        return AnimatedOpacity(
                                          duration: const Duration(
                                            milliseconds: 350,
                                          ),
                                          opacity: isDeleting && isOpacity
                                              ? 0
                                              : 1.0,
                                          child: AnimatedSize(
                                            duration: Duration(
                                              milliseconds: 500,
                                            ),

                                            child: listTile(
                                              heading: taskInfo.title,
                                              subTitle: taskInfo.description,
                                              level: taskInfo.priority,
                                              time: taskInfo.date,
                                              isChecked: taskInfo.isChecked,
                                              name: taskInfo.assignedTo!.isEmpty
                                                  ? ""
                                                  : "@${taskInfo.assignedTo}",
                                              onPressed: (newValue) {
                                                setState(() {
                                                  taskInfo.isChecked =
                                                      newValue!;
                                                  if (taskInfo.isChecked) {
                                                    if (!tasksChecked.contains(
                                                      taskInfo.taskId,
                                                    )) {
                                                      tasksChecked.add(
                                                        taskInfo.taskId,
                                                      );
                                                    }
                                                  } else {
                                                    tasksChecked.remove(
                                                      taskInfo.taskId,
                                                    );
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      itemCount: state.taskInfoList!.length,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      padding: EdgeInsets.only(bottom: 30.h),
                                      itemBuilder: (context, index) {
                                        final taskInfo =
                                            state.taskInfoList![index];
                                        final bool isDeleting = tasksChecked
                                            .contains(taskInfo.taskId);

                                        return AnimatedOpacity(
                                          duration: const Duration(
                                            milliseconds: 700,
                                          ),
                                          opacity: isDeleting && isOpacity
                                              ? 0
                                              : 1.0,
                                          child: AnimatedSize(
                                            duration: Duration(
                                              milliseconds: 500,
                                            ),

                                            child: listTile(
                                              heading: taskInfo.title,
                                              subTitle: taskInfo.description,
                                              level: taskInfo.priority,
                                              time: taskInfo.date,
                                              isChecked: taskInfo.isChecked,
                                              selectedIndex: 1,
                                              name: taskInfo.assignedTo!.isEmpty
                                                  ? ""
                                                  : "@${taskInfo.assignedTo}",
                                              onPressed: (newValue) {
                                                setState(() {
                                                  taskInfo.isChecked =
                                                      newValue!;
                                                  if (taskInfo.isChecked) {
                                                    if (!tasksChecked.contains(
                                                      taskInfo.taskId,
                                                    )) {
                                                      tasksChecked.add(
                                                        taskInfo.taskId,
                                                      );
                                                    }
                                                  } else {
                                                    tasksChecked.remove(
                                                      taskInfo.taskId,
                                                    );
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listTile({
    required String heading,
    required String subTitle,
    required String level,
    String? time,
    String? name,
    required ValueChanged<bool?> onPressed,
    int selectedIndex = 0,
    bool isChecked = false,
  }) {
    Color newColor() {
      if (level == "Low") {
        return AppColor.success;
      } else if (level == "Medium") {
        return AppColor.warning;
      } else if (level == "Completed") {
        return AppColor.border;
      }
      return AppColor.error;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: myTextHolderContainer(
        horizontal: 10,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            SizedBox(
              height: 35,
              child: Checkbox(
                checkColor: selectedIndex == 1 ? AppColor.background : null,
                activeColor: selectedIndex == 1
                    ? AppColor.border
                    : AppColor.success,
                side: BorderSide(color: AppColor.border),
                value: isChecked,
                onChanged: onPressed,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    heading,
                    style: t3White().copyWith(fontSize: 25.sp),
                  ),
                  Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    subTitle,
                    style: hintTextStyle(),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            selectedIndex == 1
                                ? Icons.done
                                : Icons.watch_later_outlined,
                            color: selectedIndex == 1
                                ? AppColor.secondary
                                : newColor(),
                            size: 15.sp,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            selectedIndex == 1 ? "Completed" : level,
                            style: t3White().copyWith(
                              fontSize: 14.sp,
                              color: selectedIndex == 1
                                  ? AppColor.secondary
                                  : newColor(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 15.w),
                      Row(
                        children: [
                          Icon(
                            Icons.watch_later_outlined,
                            color: Colors.white30,
                            size: 15.sp,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            time!,
                            style: hintTextStyle().copyWith(fontSize: 14.sp),
                          ),
                        ],
                      ),
                      SizedBox(width: 15.w),
                      name != null
                          ? Expanded(
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                name,
                                style: hintTextStyle().copyWith(
                                  color: AppColor.text,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
