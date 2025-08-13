import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/app/textStyle/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String heading;
  final String subTitle;

  const MyCustomAppBar({
    super.key,
    required this.heading,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.background,
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
      titleSpacing: 20,
      toolbarHeight: 100.h,

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading, style: t1heading().copyWith(fontSize: 30.sp)),
          Text(subTitle, style: t3White()),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
