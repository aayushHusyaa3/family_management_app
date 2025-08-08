import 'dart:developer';

import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/app/images/app_images.dart';
import 'package:family_management_app/app/routes/app_routes.dart';
import 'package:family_management_app/app/textStyle/textstyles.dart';
import 'package:family_management_app/app/utils/utils.dart';
import 'package:family_management_app/bloc/register/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 25.w),
          child: Center(
            child: BlocListener<RegisterCubit, RegisterState>(
              listener: (context, state) {
                if (state.status == RegisterStatus.updating) {
                  setState(() {
                    isLoading = true;
                  });
                } else if (state.status == RegisterStatus.updated) {
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
                    Navigator.pushReplacementNamed(
                      context,
                      selectedIndex == 1
                          ? AppRoutes.waitingScreen
                          : AppRoutes.loginScreen,
                    );
                  });
                } else if (state.status == RegisterStatus.updatingFailure) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
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
                                      .toString()
                                      .isEmpty) {
                                    myAlertBox(
                                      context,
                                      subtittle: "Enter the title",
                                      heading: "Creation Failed",
                                    );
                                  } else {
                                    context.read<RegisterCubit>().updateRole(
                                      role: "Chief",
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
                    imagePath: AppImages.profilePlaceholder,
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
                                userController: boarddIdController,
                                hint: "724534",
                                labelText: "Board ID",
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
                                    isLoading;
                                  });
                                  if (boarddIdController.text
                                      .toString()
                                      .isEmpty) {
                                    myAlertBox(
                                      context,
                                      subtittle: "Enter the Board ID",
                                      heading: "Join Failed",
                                    );
                                  } else {
                                    context.read<RegisterCubit>().updateRole(
                                      role: "role",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
