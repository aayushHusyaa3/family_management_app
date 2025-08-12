import 'dart:developer';
import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/app/textStyle/textstyles.dart';
import 'package:family_management_app/bloc/fetch%20User/fetch_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaitingScreen extends StatefulWidget {
  final String? boardId;

  const WaitingScreen({super.key, this.boardId});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  Future<void> holdOnWaiting(context) async {
    log(widget.boardId!);
  }

  @override
  void initState() {
    super.initState();
    holdOnWaiting(context);
    context.read<FetchUserCubit>().checkWaiting(
      boardId: widget.boardId ?? "45642",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decorative animation or icon
              Icon(
                Icons.hourglass_empty_rounded,
                size: 100,
                color: AppColor.secondary,
              ),

              const SizedBox(height: 30),

              // Title
              Text(
                "⏳ Waiting for Chief’s Approval",
                style: t1heading(),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 15),

              // Description
              Text(
                "Your join request has been sent to the board’s chief.\n"
                "Once they review and approve your request, "
                "you’ll be granted access.\n\n"
                "We’ll notify you as soon as it’s done — so you can start "
                "collaborating with your board members right away!\n",

                style: hintTextStyle(),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Decorative progress indicator
              const CircularProgressIndicator(
                color: AppColor.secondary,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
