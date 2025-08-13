import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/app/routes/app_routes.dart';
import 'package:family_management_app/app/textStyle/textstyles.dart';
import 'package:family_management_app/bloc/fetch%20User/fetch_user_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaitingScreen extends StatefulWidget {
  final String? boardId;

  const WaitingScreen({super.key, this.boardId});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
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

  Future<void> checkStatus() async {
    User? user = auth.currentUser;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    final joinStatus = userDoc.data()?['joinStatus'];

    switch (joinStatus) {
      case 'accepted':
        Navigator.pushReplacementNamed(context, AppRoutes.acceptedScreen);
        break;
      case 'rejected':
        Navigator.pushReplacementNamed(context, AppRoutes.rejectedScreen);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<FetchUserCubit>().checkWaiting(
            boardId: widget.boardId ?? "45642",
          );
          checkStatus();
        },
        child: Center(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
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
        ),
      ),
    );
  }
}
