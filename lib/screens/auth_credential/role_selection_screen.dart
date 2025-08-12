import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/app/images/app_images.dart';
import 'package:family_management_app/app/routes/app_routes.dart';
import 'package:family_management_app/app/textStyle/textstyles.dart';
import 'package:family_management_app/app/utils/utils.dart';
import 'package:family_management_app/bloc/role_update/role_update_cubit.dart';
import 'package:family_management_app/screens/auth_credential/join_status_screen.dart/waiting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoleSelectionScreen extends StatefulWidget {
  final String? uid;

  const RoleSelectionScreen({super.key, this.uid});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  TextEditingController boardTitleController = TextEditingController();
  TextEditingController boardDescriptionController = TextEditingController();
  TextEditingController boarddIdController = TextEditingController();
  TextEditingController boardNickNameController = TextEditingController();
  bool isLoading = false;
  int selectedIndex = 0;
  int boardExistsint = 0;

  void onBoardIdEntered(String inputBoardId) async {
    final exists = await context.read<RoleUpdateCubit>().checkBoardExists(
      inputBoardId,
    );

    if (exists) {
      setState(() {
        boardExistsint = 1;
      });
    } else {
      setState(() {
        boardExistsint = 0;
      });
    }
  }

  @override
  void dispose() {
    boardTitleController.dispose();
    boardDescriptionController.dispose();
    boarddIdController.dispose();
    boardNickNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: BlocListener<RoleUpdateCubit, RoleUpdateState>(
        listener: (context, state) {
          if (state.status == RoleUpdatingStatus.initialUpdating) {
            setState(() {
              isLoading = false;
            });
          } else if (state.status == RoleUpdatingStatus.updating) {
            setState(() {
              isLoading = true;
            });
          } else if (state.status == RoleUpdatingStatus.updated) {
            myAlertBox(
              context,
              subtittle: selectedIndex == 1
                  ? "Please wait for the approval"
                  : "Your board has been created successfully",
              heading: selectedIndex == 1
                  ? "Join Request Sent"
                  : "🎉You're all set!",
            );
            setState(() {
              isLoading = false;
            });
            Future.delayed(Duration(seconds: 3), () {
              selectedIndex == 0
                  ? Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.loginScreen,
                      (route) => false,
                    )
                  : Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WaitingScreen(
                          boardId: boarddIdController.text.trim(),
                        ),
                      ),
                      (route) => false,
                    );
            });
          } else if (state.status == RoleUpdatingStatus.updatingFailure) {
            setState(() {
              isLoading = false;
            });
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 25.w),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "What would you like to do next?",
                    style: t1heading(),
                    textAlign: TextAlign.center,
                  ),
                  BoardCard(
                    title: "Create Board",
                    subtitle:
                        "Start a new board as Chief & manage members, roles, & activities.",
                    imagePath: AppImages.createCardImage,
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                      showCustomBoardModalBottomSheet(
                        context,

                        builder: (setModalState) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyUploadTextField(
                                userController: boardTitleController,
                                hint: "The Gupta Family Hub",
                                labelText: "Board title",
                              ),
                              MyUploadTextField(
                                isDesc: true,
                                isRequired: false,
                                userController: boardDescriptionController,
                                hint:
                                    "Organize family tasks, groceries, and events",
                                labelText: "Board Description",
                              ),
                              MyButtton(
                                text: "Create",
                                isLoading: isLoading,
                                onPressed: () {
                                  setState(() {
                                    selectedIndex = 0;
                                  });
                                  setModalState(() {
                                    isLoading;
                                  });
                                  if (boardTitleController.text
                                      .trim()
                                      .isEmpty) {
                                    myAlertBox(
                                      context,
                                      subtittle: "Enter the title",
                                      heading: "Creation Failed",
                                    );
                                  } else {
                                    context
                                        .read<RoleUpdateCubit>()
                                        .updateChiefsRole(
                                          uid: widget.uid!,
                                          title: boardTitleController.text
                                              .trim(),
                                          description:
                                              boardDescriptionController.text
                                                  .trim(),
                                        );
                                  }
                                },
                              ),
                              SizedBox(height: 50),
                            ],
                          );
                        },
                      );
                    },
                  ),

                  BoardCard(
                    title: "Join Board",
                    subtitle:
                        "Request to join an existing board using the Chief’s email or Board ID.",
                    imagePath: AppImages.joinCardImage,
                    onTap: () {
                      setState(() {
                        setState(() {
                          selectedIndex = 1;
                        });
                      });
                      showCustomBoardModalBottomSheet(
                        context,

                        builder: (setModalState) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyUploadTextField(
                                onChangedValue: onBoardIdEntered,
                                userController: boarddIdController,
                                hint: "7245",
                                labelText: "Board ID",
                                isNumberKeyboard: true,
                                backIcon: Icons.check,
                                backIconcolor: boardExistsint == 1
                                    ? AppColor.secondary
                                    : Colors.white30,
                              ),
                              MyUploadTextField(
                                userController: boardNickNameController,
                                hint: "Chiku",
                                labelText: "Your NickName",
                                isRequired: false,
                              ),
                              MyButtton(
                                text: "Join",

                                isLoading: isLoading,
                                onPressed: () {
                                  setState(() {
                                    selectedIndex = 1;
                                  });
                                  setModalState(() {
                                    isLoading = true;
                                  });
                                  if (boarddIdController.text.trim().isEmpty) {
                                    myAlertBox(
                                      context,
                                      subtittle: "Enter the Board ID",
                                      heading: "Join Failed",
                                    );
                                  } else {
                                    if (boardExistsint == 1) {
                                      context
                                          .read<RoleUpdateCubit>()
                                          .updateMembersRole(
                                            nickname: boardNickNameController
                                                .text
                                                .trim(),

                                            boardId: boarddIdController.text
                                                .trim(),
                                          );
                                    } else {
                                      myAlertBox(
                                        context,
                                        subtittle: "Enter a vaild Id",
                                        heading: "Join Failed",
                                      );
                                    }
                                  }
                                },
                              ),
                              SizedBox(height: 50),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
