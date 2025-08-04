import 'package:flutter/material.dart';
import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/app/textStyle/textstyles.dart';
import 'package:family_management_app/app/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KidsScreen extends StatefulWidget {
  const KidsScreen({super.key});

  @override
  State<KidsScreen> createState() => _KidsScreenState();
}

class _KidsScreenState extends State<KidsScreen> {
  List<String> namesList = ["Emma", "Jake"];
  List<String> ageList = ['8', '5'];
  List<String> eventList = [
    'Soccer practice at 4:00 PM',
    'Doctor appoitment tommorrow',
  ];
  List<String> activityList = ['Completed homework', 'Naptime finished'];
  List<Color> iconColorsList = [AppColor.success, AppColor.secondary];
  List<String> milestonesLsit = [
    '• Emma: School play audtion - 2024-01-20 ',
    "• Emma: Learn to ride bike - 2024-02-01",
    "• Jake: 6th Birthday Party - 2024-03-15",
    "• Jake: Learn to tie shoes - 2024-02-15",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.background,
        automaticallyImplyLeading: false,
        toolbarHeight: 80.h,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kids DashBoard",
              style: t1heading().copyWith(fontSize: 30.sp),
            ),
            Text(
              "Monitor and manage your children's activities",
              style: t3White(),
            ),
          ],
        ),
      ),
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: namesList.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: myTextHolderContainer(
                      horizontal: 20.w,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              iconWithColumn(
                                heading: namesList[index],
                                icon: Icons.child_care,
                                subtitle: "${ageList[index]} years old",
                                isBold: true,
                              ),
                              Spacer(),
                              iconContainer(color: iconColorsList[index]),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          iconWithColumn(
                            heading: "NEXT EVENT",
                            icon: Icons.calendar_month_outlined,
                            subtitle: eventList[index],
                          ),
                          SizedBox(height: 10.h),
                          iconWithColumn(
                            heading: "RECENT ACTIVITY",
                            icon: Icons.account_tree_rounded,
                            subtitle: activityList[index],
                            isGreen: true,
                          ),
                          SizedBox(height: 20.h),
                          MyButttonWithIcon(
                            text: "View Full Profile",
                            onPressed: () {},
                            isInfinte: true,
                            icon: Icons.menu_book_outlined,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Text(
                " Family Insights",
                style: t1heading().copyWith(fontSize: 25.sp),
              ),
              SizedBox(height: 10.h),
              myTextHolderContainer(
                child: Expanded(
                  child: Text(
                    "Emma's homework completion rate has improved by 25% this month. Consider rewarding her progress!",
                    style: t3White(),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                " Upcoming Milestones",
                style: t1heading().copyWith(fontSize: 25.sp),
              ),
              SizedBox(height: 10.h),
              myTextHolderContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(4, (index) {
                    return Text(milestonesLsit[index], style: t3White());
                  }),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconWithColumn({
    required String heading,
    required IconData icon,
    required String subtitle,
    bool isBold = false,
    isGreen = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 25.sp,
          color: isGreen ? AppColor.success : AppColor.secondary,
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(heading, style: isBold ? t1White() : hintTextStyle()),
            Text(subtitle, style: hintTextStyle()),
          ],
        ),
      ],
    );
  }

  Widget iconContainer({Color color = AppColor.success}) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8.r),

      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(Icons.favorite_outline, color: AppColor.textSecondary),
    );
  }
}
