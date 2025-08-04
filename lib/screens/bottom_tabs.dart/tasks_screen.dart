import 'package:confetti/confetti.dart';
import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/app/images/app_images.dart';
import 'package:family_management_app/app/routes/app_routes.dart';
import 'package:family_management_app/app/textStyle/textstyles.dart';
import 'package:family_management_app/app/utils/utils.dart';
import 'package:family_management_app/bloc/fetch_tasks/fetch_tasks_cubit.dart';
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
  bool isOpacityDOne = false;

  @override
  void initState() {
    super.initState();
    context.read<FetchTasksCubit>().fetchTasks();
    confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  void onMarkAsDoneButtonPressed() {
    confettiController.play();
  }

  final List<Map<String, dynamic>> expandedIcons = [
    {"icon": Icons.add, "color": AppColor.secondary},
    {"icon": Icons.done, "color": AppColor.success},
    {"icon": Icons.delete_outline, "color": AppColor.error},
  ];

  @override
  Widget build(BuildContext context) {
    final addTaskBloc = context.read<FetchTasksCubit>();

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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
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
              ).copyWith(bottom: 50.h),
              child: BlocListener<FetchTasksCubit, FetchTasksState>(
                listener: (context, state) {
                  if (state.status == FetchTasksStatus.deleting) {
                    setState(() {
                      deletedTaskIds.addAll(tasksChecked);
                    });
                    Future.delayed(Duration(milliseconds: 500), () {
                      context.read<FetchTasksCubit>().removeTasks(tasksChecked);
                    });
                  } else if (state.status == FetchTasksStatus.deleted) {
                    mySnackBar(context, title: state.errorMsg!);

                    setState(() {
                      tasksChecked.clear();
                    });
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<FetchTasksCubit, FetchTasksState>(
                      builder: (context, state) {
                        return Row(
                          children: [
                            Expanded(
                              child: MySearchField(
                                hintText: "Search for tasks",
                              ),
                            ),
                            tasksChecked.isEmpty
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
                                : SizedBox(),

                            tasksChecked.isNotEmpty
                                ? Row(
                                    children: List.generate(2, (index) {
                                      return Padding(
                                        padding: EdgeInsets.only(left: 10.w),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (index == 0) {
                                              // addTaskBloc.(
                                              //   taskId: tasksChecked,
                                              // );
                                              onMarkAsDoneButtonPressed();
                                            } else if (index == 1) {
                                              addTaskBloc.deleteTask(
                                                taskId: tasksChecked,
                                              );
                                            }
                                          },
                                          child: Icon(
                                            expandedIcons[index + 1]['icon'],
                                            size: 27.sp,
                                            color:
                                                expandedIcons[index +
                                                    1]['color'],
                                          ),
                                        ),
                                      );
                                    }),
                                  )
                                : SizedBox(),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: 20.h),
                    BlocBuilder<FetchTasksCubit, FetchTasksState>(
                      builder: (context, state) {
                        if (state.status == FetchTasksStatus.fetching) {
                          return myTasksShimmerBox(
                            width: double.infinity,
                            height: 120,
                            itemCount: state.taskInfoList!.length,
                          );
                        } else if (state.status == FetchTasksStatus.fetched) {}
                        return state.taskInfoList!.isEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 30.h),
                                  Image.asset(
                                    AppImages.noItem,
                                    fit: BoxFit.cover,
                                  ),

                                  Text(
                                    textAlign: TextAlign.center,
                                    "No Assisgned Tasks\nClick '+' to assign Task",
                                    style: t1White(),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                itemCount: state.taskInfoList!.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  final taskInfo = state.taskInfoList![index];
                                  final bool deleted = deletedTaskIds.contains(
                                    taskInfo.taskId,
                                  );

                                  return AnimatedOpacity(
                                    duration: Duration(milliseconds: 500),
                                    opacity: deleted ? 0.0 : 1.0,
                                    onEnd: () {
                                      setState(() {
                                        isOpacityDOne = true;
                                      });
                                    },
                                    child: AnimatedSize(
                                      duration: Duration(milliseconds: 1500),
                                      curve: Curves.easeIn,
                                      child: Container(
                                        key: ValueKey(taskInfo.taskId),
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
                                              taskInfo.isChecked = newValue!;

                                              if (!tasksChecked.contains(
                                                taskInfo.taskId,
                                              )) {
                                                tasksChecked.add(
                                                  taskInfo.taskId,
                                                );
                                              } else {
                                                tasksChecked.remove(
                                                  taskInfo.taskId,
                                                );
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
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
    bool isChecked = false,
  }) {
    Color newColor() {
      if (level == "Low") {
        return AppColor.success;
      } else if (level == "Medium") {
        return AppColor.warning;
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
                activeColor: AppColor.success,
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
                            Icons.watch_later_outlined,
                            color: newColor(),
                            size: 15.sp,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            level,
                            style: t3White().copyWith(
                              fontSize: 14.sp,
                              color: newColor(),
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
