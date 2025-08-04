import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/app/routes/app_routes.dart';
import 'package:family_management_app/app/textStyle/textstyles.dart';
import 'package:family_management_app/app/utils/custom_appbar.dart';
import 'package:family_management_app/app/utils/utils.dart';
import 'package:family_management_app/bloc/add%20tasks/add_tasks_cubit.dart';
import 'package:family_management_app/bloc/fetch%20User/fetch_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AddtaskScreen extends StatefulWidget {
  const AddtaskScreen({super.key});

  @override
  State<AddtaskScreen> createState() => _AddtaskScreenState();
}

class _AddtaskScreenState extends State<AddtaskScreen> {
  DateTime? selectedDate;
  String? hintDate;

  bool isLoading = false;

  TimeOfDay? selectedTime;
  String? hintTime;

  String? selectedRole;
  String? selectedMember;

  String selectedPriority = "High";
  final List<Map<String, dynamic>> priorities = [
    {"label": "High", "color": AppColor.error},
    {"label": "Medium", "color": AppColor.warning},
    {"label": "Low", "color": AppColor.success},
  ];

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        String formatted = DateFormat('dd/MM/yyyy').format(picked);
        hintDate = formatted;
      });
    }
  }

  Future<void> pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    DateTime fullTime = DateTime(0, 1, 1, picked!.hour, picked.minute);

    setState(() {
      selectedTime = picked;
      String formatted = DateFormat(' hh:mm a').format(fullTime);
      hintTime = formatted;
    });
  }

  TextEditingController usertitleController = TextEditingController();
  TextEditingController userDescController = TextEditingController();
  TextEditingController userController = TextEditingController();
  List<String> roleSelection = ["Cheif", "Lead", "Board Member", "Guest"];
  List<AllUserInfo> personSelectionList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final addTaskBloc = context.read<AddTasksCubit>();
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: MyCustomAppBar(heading: "Add Tasks", subTitle: "Assign Tasks"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 25.w),
          child: BlocListener<AddTasksCubit, AddTasksState>(
            listener: (context, state) {
              if (state.status == PostStatus.emptyPosting) {
                myAlertBox(
                  context,
                  subtittle: state.errorMsg,
                  heading: "Assign Task Failed",
                );
              } else if (state.status == PostStatus.posted) {
                myAlertBox(
                  context,
                  subtittle: state.errorMsg,
                  heading: "Assign Task Success",
                );

                usertitleController.clear();
                userDescController.clear();
                selectedDate = null;
                selectedMember = "Guest";
                selectedPriority = "High";
                hintDate = null;
                hintTime = '12:00 AM';
                isLoading = false;

                setState(() {});
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.pushNamed(context, AppRoutes.navigationScreen);
                });
              } else if (state.status == PostStatus.postingFailed) {
                myAlertBox(
                  context,
                  subtittle: state.errorMsg,
                  heading: "Assign Task Failed",
                );
                setState(() {
                  isLoading = false;
                });
              } else if (state.status == PostStatus.posting) {
                setState(() {
                  isLoading = true;
                });
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyUploadTextField(
                  userController: usertitleController,
                  labelText: "  Title",
                  hint: "Grocery Shopping",
                  frontIcon: Icons.title,
                ),
                MyUploadTextField(
                  userController: userDescController,
                  labelText: "  Description",
                  hint: "Weekly grocery run - check the family List......",
                  isDesc: true,
                ),
                MyDropDownBUtton(
                  labelText: "Select role to assign task",
                  role: roleSelection[0],
                  itemsList: roleSelection,
                  icon: Icons.manage_accounts,
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value ?? "Guest";
                      context.read<FetchUserCubit>().getAllUser(
                        role: selectedRole!,
                      );
                    });
                  },
                ),
                Text(
                  "Select team member to assign task",
                  style: t3White().copyWith(fontSize: 20.sp),
                ),
                BlocBuilder<FetchUserCubit, FetchUserState>(
                  builder: (context, state) {
                    if (state.status == FetchUserStatus.fetchedAllUser) {
                      personSelectionList = state.userInfo!;
                    } else if (state.status ==
                        FetchUserStatus.fetchingAllUser) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 20.h, top: 10),
                        child: myShimmerBox(width: double.infinity, height: 57),
                      );
                    }
                    return MyDropDownMemberBUtton(
                      labelText: "Select team member to assign task",
                      selectedEmail: personSelectionList.isNotEmpty
                          ? personSelectionList.last.email
                          : null,
                      itemsList: personSelectionList,

                      icon: Icons.person,
                      onChanged: (value) {
                        setState(() {
                          selectedMember = value;
                        });
                      },
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyDateAndTimePickerBox(
                      onPressed: () {
                        pickDate();
                      },
                      hint: hintDate ?? "dd/mm/yyyy",
                      labelText: ' Schedule Date',
                      isExpanded: false,
                      frontIcon: Icons.calendar_month_outlined,
                    ),

                    MyDateAndTimePickerBox(
                      onPressed: () {
                        pickTime();
                      },
                      isRequired: false,
                      hint: hintTime ?? "12:00 AM",
                      labelText: ' Schedule Time',
                      isExpanded: false,
                      frontIcon: Icons.alarm,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Text(
                      "Task Priority",
                      style: t3White().copyWith(fontSize: 20.sp),
                    ),

                    Text(
                      " *",
                      style: t3White().copyWith(
                        fontSize: 20.sp,
                        color: AppColor.error,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(priorities.length, (index) {
                    final priority = priorities[index];
                    return Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: priority["label"],
                            groupValue: selectedPriority,
                            activeColor: priority["color"],
                            onChanged: (value) {
                              setState(() {
                                selectedPriority = value!;
                              });
                            },
                          ),
                          Text(priority["label"], style: t3White()),
                        ],
                      ),
                    );
                  }),
                ),
                SizedBox(height: 20.h),
                MyButtton(
                  text: "Assign Task",
                  isLoading: isLoading,
                  onPressed: () {
                    addTaskBloc.addTaskFun(
                      title: usertitleController.text.toString(),
                      desc: userDescController.text.toString(),
                      date: hintDate ?? "",
                      priority: selectedPriority,
                      time: hintTime,
                      assignedMember: selectedMember,
                      assignedRole: selectedRole,
                    );
                  },
                ),
                SizedBox(height: 50.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
