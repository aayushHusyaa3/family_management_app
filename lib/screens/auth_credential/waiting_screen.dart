import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/app/textStyle/textstyles.dart';
import 'package:flutter/material.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});

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
                "collaborating with your board members right away!",
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
