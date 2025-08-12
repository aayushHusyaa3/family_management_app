import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:family_management_app/app/app Color/app_color.dart';
import 'package:family_management_app/app/textStyle/textstyles.dart';
import 'package:family_management_app/app/utils/utils.dart';
import 'package:family_management_app/bloc/fetch User/fetch_user_cubit.dart';

class NotificationShowerScreen extends StatefulWidget {
  const NotificationShowerScreen({super.key});

  @override
  State<NotificationShowerScreen> createState() =>
      _NotificationShowerScreenState();
}

class _NotificationShowerScreenState extends State<NotificationShowerScreen> {
  List<Map<String, dynamic>> joinRequests = [];
  String? selectedRole;

  @override
  void initState() {
    super.initState();
    context.read<FetchUserCubit>().fetchJoinRequests();
  }

  void _showAssignRoleDialog(int index, VoidCallback onPressed) {
    selectedRole = null; // Reset on dialog open
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.dropDownColor,
          title: Text(
            'Assign Role',
            style: t3White().copyWith(fontSize: 25.sp),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColor.secondary,
                    title: Text(
                      'Lead',
                      style: hintTextStyle().copyWith(
                        fontSize: 20.sp,
                        color: AppColor.textSecondary,
                      ),
                    ),
                    value: 'Lead',
                    groupValue: selectedRole,
                    onChanged: (value) => setState(() => selectedRole = value),
                  ),
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColor.secondary,
                    title: Text(
                      'Board Member',
                      style: hintTextStyle().copyWith(
                        fontSize: 20.sp,
                        color: AppColor.textSecondary,
                      ),
                    ),
                    value: 'Board Member',
                    groupValue: selectedRole,
                    onChanged: (value) => setState(() => selectedRole = value),
                  ),
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColor.secondary,
                    title: Text(
                      'Guest',
                      style: hintTextStyle().copyWith(
                        fontSize: 20.sp,
                        color: AppColor.textSecondary,
                      ),
                    ),
                    value: 'Guest',
                    groupValue: selectedRole,
                    onChanged: (value) => setState(() => selectedRole = value),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: hintTextStyle().copyWith(
                            color: AppColor.error,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: onPressed,
                        child: Text(
                          'Assign',
                          style: hintTextStyle().copyWith(
                            color: AppColor.border,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColor.secondary,
            size: 20.sp,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        leadingWidth: 50,
        title: Text(
          "Notification",
          style: t1heading().copyWith(fontSize: 30.sp),
        ),
        centerTitle: false,
        backgroundColor: AppColor.background,
      ),
      body: BlocConsumer<FetchUserCubit, FetchUserState>(
        listener: (context, state) {
          if (state.status == FetchUserStatus.fetched) {
            setState(() {
              joinRequests = state.joinRequestList ?? [];
            });
          }
        },

        builder: (context, state) {
          if (state.status == FetchUserStatus.fetching) {
            return myTasksShimmerBox(
              itemCount: state.itemCount ?? 5,
              height: 80.h,
              width: double.infinity,
            );
          } else if (state.status == FetchUserStatus.fetchingError) {
            return Center(child: Text(state.errorMsg!, style: hintTextStyle()));
          }

          if (joinRequests.isEmpty) {
            return Center(
              child: Text('No join requests found.', style: hintTextStyle()),
            );
          }

          return ListView.builder(
            itemCount: joinRequests.length,
            itemBuilder: (context, index) {
              final details = joinRequests[index];
              final email = details['email'] as String? ?? '';
              final selectedUserId = details['docId'] as String? ?? '';
              final status = (details['status'] ?? 'pending') as String;

              Widget trailingWidget;

              if (status == 'rejected') {
                trailingWidget = Text(
                  'Rejected',
                  style: hintTextStyle().copyWith(
                    color: AppColor.error,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                );
              } else if (status == 'accepted') {
                trailingWidget = Text(
                  'Accepted',
                  style: hintTextStyle().copyWith(
                    color: Colors.green,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                );
              } else {
                // pending
                trailingWidget = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.read<FetchUserCubit>().rejectJoinRequest(
                          email,
                          selectedUserId,
                        );
                        mySnackBar(
                          context,
                          title: "${details['name']} has been rejected.",
                        );
                      },
                      child: Text(
                        'Reject',
                        style: hintTextStyle().copyWith(
                          color: AppColor.error,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    MyAcceptButton(
                      text: "Accept",
                      onPressed: () {
                        _showAssignRoleDialog(index, () {
                          Navigator.of(context).maybePop();
                          if (selectedRole != null &&
                              selectedRole!.isNotEmpty) {
                            context.read<FetchUserCubit>().acceptJoinRequest(
                              email,
                              selectedUserId,
                              selectedRole!,
                            );
                            mySnackBar(
                              context,
                              title:
                                  "${details['name']} has been Approved as $selectedRole.",
                            );
                          }
                        });
                      },
                    ),
                  ],
                );
              }

              return Card(
                color: AppColor.dropDownColor,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 26.r,
                    backgroundColor: const Color.fromARGB(255, 33, 78, 155),
                    backgroundImage:
                        (details['imagePath'] != null &&
                            (details['imagePath'] as String).isNotEmpty)
                        ? NetworkImage(details['imagePath'])
                        : null,
                    child:
                        (details['imagePath'] == null ||
                            (details['imagePath'] as String).isEmpty)
                        ? Text(
                            (details['name'] != null &&
                                    (details['name'] as String).isNotEmpty)
                                ? (details['name'] as String)[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          )
                        : null,
                  ),
                  title: Text(
                    details['name'] ?? "No name",
                    style: t3White().copyWith(fontSize: 20.sp),
                  ),
                  subtitle: Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    email,
                    style: hintTextStyle().copyWith(fontSize: 14.sp),
                  ),
                  trailing: trailingWidget,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
