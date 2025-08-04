import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/app/textStyle/textstyles.dart';
import 'package:family_management_app/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  String getFormatedDate() {
    DateTime timeNow = DateTime.now();
    String dayName = DateFormat('EEEE').format(timeNow);
    String monthDayYear = DateFormat('MMMM d, yyyy').format(timeNow);
    return "$dayName, $monthDayYear";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 50.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Calendar", style: t1heading().copyWith(fontSize: 30.sp)),
            Text(" Today's schedule overview", style: t3White()),
            SizedBox(height: 20.h),
            myTextHolderContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 30.sp,
                        color: AppColor.secondary,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        getFormatedDate(),
                        style: t3White().copyWith(fontSize: 22.sp),
                      ),
                    ],
                  ),
                  Text("  0 events scheduled", style: hintTextStyle()),
                ],
              ),

              horizontal: 25,
            ),
            SizedBox(height: 20.h),
            Text(
              " Today's Events",
              style: t1heading().copyWith(fontSize: 25.sp),
            ),
          ],
        ),
      ),
    );
  }
}
