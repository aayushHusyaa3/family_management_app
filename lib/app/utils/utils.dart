import 'dart:io';

import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/app/images/app_images.dart';
import 'package:family_management_app/app/textStyle/textstyles.dart';
import 'package:family_management_app/bloc/fetch%20User/fetch_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:loading_indicator/loading_indicator.dart';
import 'package:shimmer/shimmer.dart';

class MyButtton extends StatefulWidget {
  final bool isLoading;
  final String text;
  final VoidCallback onPressed;

  const MyButtton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<MyButtton> createState() => _MyButttonState();
}

class _MyButttonState extends State<MyButtton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 65.h,
        decoration: BoxDecoration(
          color: AppColor.secondary,
          borderRadius: BorderRadius.circular(35.r),
        ),
        child: widget.isLoading
            ? LoadingAnimationWidget.inkDrop(
                color: AppColor.dropDownColor,
                size: 40.h,
              )
            : Text(widget.text, style: t1()),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final TextEditingController userController;
  final bool isHide;
  final IconData? frontIcon;
  final bool isbackIcon;
  final String? hint;
  final String? errorMsg;
  final VoidCallback onPasswordIconClicked;
  final ValueChanged<String>? onChangedValue;

  const MyTextField({
    super.key,
    this.isHide = false,
    required this.userController,
    this.frontIcon,
    this.hint,
    this.isbackIcon = false,
    this.errorMsg,
    this.onChangedValue,
    required this.onPasswordIconClicked,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: userController,

            onChanged: onChangedValue,
            obscureText: isHide,
            textAlignVertical: TextAlignVertical.center,
            cursorColor: Colors.blue,
            style: t3White(),

            decoration: InputDecoration(
              errorText: errorMsg,
              errorStyle: hintTextStyle().copyWith(
                fontSize: 12.sp,
                color: AppColor.error,
              ),

              contentPadding: EdgeInsets.symmetric(vertical: 17.h),
              filled: true,
              suffixIcon: isbackIcon
                  ? IconButton(
                      onPressed: onPasswordIconClicked,
                      icon: isHide
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                      color: AppColor.textSecondary.withAlpha(150),
                    )
                  : null,

              fillColor: AppColor.secondary.withAlpha(10),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 10.w, right: 3.w),
                child: Icon(frontIcon, color: AppColor.secondary),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
              hintText: hint,

              hintStyle: hintTextStyle(),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.secondary),
                borderRadius: BorderRadius.circular(10.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.secondary),
                borderRadius: BorderRadius.circular(10.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.secondary),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyProfileHolder extends StatelessWidget {
  final String? imagePath;
  final int width;
  final int height;
  const MyProfileHolder({
    super.key,
    this.imagePath,
    this.width = 35,
    this.height = 35,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height.h,
      decoration: BoxDecoration(
        border: BoxBorder.all(width: 1, color: AppColor.secondary),
        image: DecorationImage(
          image: imagePath != null
              ? NetworkImage(imagePath!)
              : AssetImage(AppImages.profilePlaceholder),
          fit: BoxFit.cover,
        ),

        shape: BoxShape.circle,
      ),
    );
  }
}

class MyTaskHolderBox extends StatelessWidget {
  final IconData icon;
  final String headingText;

  final String subtitle;
  final String feedback;
  final Widget? subWidget;
  final VoidCallback onPressed;

  const MyTaskHolderBox({
    super.key,
    required this.icon,
    required this.subtitle,
    required this.feedback,
    required this.headingText,
    this.subWidget,

    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: subtitle == 0.toString() ? onPressed : () {},
      child: Container(
        width: 170.w,

        decoration: BoxDecoration(
          color: AppColor.secondary.withAlpha(10),
          borderRadius: BorderRadius.circular(10.r),
          border: BoxBorder.all(width: 1.r, color: AppColor.secondary),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Column(
            children: [
              Icon(icon, color: AppColor.secondary, size: 35.sp),
              SizedBox(height: 3.h),
              Text(headingText, style: t2White()),
              subWidget == null
                  ? Text(subtitle, style: t1heading())
                  : subWidget!,
              SizedBox(height: 5.h),
              Text(
                feedback,
                style: hintTextStyle().copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void myAlertBox(
  BuildContext context, {
  String heading = "Sign In Failed",
  required subtittle,
}) async {
  return showDialog(
    context: context,

    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.only(
          bottom: 10.h,
          top: 15.h,
          left: 20.w,
          right: 20.w,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(heading, style: t2().copyWith(fontWeight: FontWeight.bold)),
            Text(
              subtittle,
              style: t2().copyWith(fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),

            Divider(),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Text(
                  "OK",
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(15),
        ),
      );
    },
  );
}

void mySnackBar(BuildContext context, {required String title}) {
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColor.border,
        duration: Duration(seconds: 2),
        content: Text(title, style: t3()),
      ),
    );
}

Widget myTextHolderContainer({
  required Widget child,
  double horizontal = 25,
  double containerWidth = double.infinity,
  bool isExpanded = true,
  Color borderColor = AppColor.secondary,
}) {
  return Container(
    width: isExpanded ? double.infinity : 160.w,
    decoration: BoxDecoration(
      color: AppColor.secondary.withAlpha(10),
      borderRadius: BorderRadius.circular(10.r),
      border: BoxBorder.all(width: 1, color: borderColor),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: horizontal.w),
      child: child,
    ),
  );
}

class MyButttonWithIcon extends StatelessWidget {
  final bool isLoading;
  final String text;
  final VoidCallback onPressed;
  final bool isInfinte;
  final IconData icon;

  const MyButttonWithIcon({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isInfinte = false,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: isInfinte ? double.infinity : null,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.h),

        decoration: BoxDecoration(
          color: AppColor.secondary,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black87),
            SizedBox(width: isInfinte ? 10.w : 3.w),

            Text(text, style: t2().copyWith(fontSize: 18.sp)),
          ],
        ),
      ),
    );
  }
}

class ProfileImageHolder extends StatelessWidget {
  final String imagePath;
  final int height;
  final int width;
  const ProfileImageHolder({
    super.key,
    required this.imagePath,
    this.height = 100,
    this.width = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: BoxBorder.all(width: 2, color: AppColor.secondary),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.contain,
        ),
        color: Colors.transparent,
      ),
    );
  }
}

class MyDropDownBUtton extends StatefulWidget {
  final List<String> itemsList;
  final IconData icon;
  final String? role;
  final String labelText;
  final ValueChanged<String?> onChanged;
  final IconData? backIcon;

  const MyDropDownBUtton({
    super.key,
    required this.labelText,
    required this.itemsList,
    this.icon = Icons.person,
    this.role,
    this.backIcon,
    required this.onChanged,
  });

  @override
  State<MyDropDownBUtton> createState() => _MyDropDownBUttonState();
}

class _MyDropDownBUttonState extends State<MyDropDownBUtton> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.role;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.labelText, style: t3White().copyWith(fontSize: 20.sp)),
          SizedBox(height: 10.h),
          DropdownButtonFormField<String>(
            // value: selectedValue,
            hint: Text(
              "Guest",
              style: hintTextStyle().copyWith(fontSize: 20.sp),
            ),

            style: hintTextStyle().copyWith(
              fontSize: 20.sp,
              color: widget.role == null ? null : AppColor.textSecondary,
            ),

            dropdownColor: AppColor.dropDownColor,
            borderRadius: BorderRadius.circular(15.r),
            icon: Icon(Icons.arrow_drop_down_sharp, color: AppColor.secondary),
            decoration: InputDecoration(
              fillColor: AppColor.secondary.withAlpha(10),
              filled: true,

              prefixIcon: Icon(widget.icon, color: AppColor.secondary),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColor.secondary),
                borderRadius: BorderRadius.circular(10.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColor.secondary),
                borderRadius: BorderRadius.circular(10.r),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColor.secondary),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),

            items: widget.itemsList
                .map(
                  (String dropDownRole) => DropdownMenuItem(
                    value: dropDownRole,
                    child: Text(dropDownRole),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
              widget.onChanged(value);
            },
          ),
        ],
      ),
    );
  }
}

class MyDropDownMemberBUtton extends StatefulWidget {
  final List<AllUserInfo> itemsList; // now use AllUserInfo, not String
  final IconData icon;
  final String? selectedEmail; // selection key
  final String labelText;
  final ValueChanged<String?> onChanged;
  final IconData? backIcon;

  const MyDropDownMemberBUtton({
    super.key,
    required this.labelText,
    required this.itemsList,
    this.icon = Icons.person,
    this.selectedEmail,
    this.backIcon,
    required this.onChanged,
  });

  @override
  State<MyDropDownMemberBUtton> createState() => _MyDropDownMemberBUttonState();
}

class _MyDropDownMemberBUttonState extends State<MyDropDownMemberBUtton> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedEmail;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          DropdownButtonFormField<String>(
            isExpanded: true,

            hint: Text(
              overflow: TextOverflow.ellipsis,

              "Aayush - (aaysuhhsuyaa3@gmail.com)",
              style: hintTextStyle().copyWith(fontSize: 20.sp),
            ),
            style: hintTextStyle().copyWith(
              fontSize: 20.sp,
              color: widget.selectedEmail == null
                  ? null
                  : AppColor.textSecondary,
            ),

            dropdownColor: AppColor.dropDownColor,
            borderRadius: BorderRadius.circular(15.r),
            icon: Icon(Icons.arrow_drop_down_sharp, color: AppColor.secondary),
            decoration: InputDecoration(
              fillColor: AppColor.secondary.withAlpha(10),
              filled: true,

              prefixIcon: Icon(widget.icon, color: AppColor.secondary),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColor.secondary),
                borderRadius: BorderRadius.circular(10.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColor.secondary),
                borderRadius: BorderRadius.circular(10.r),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColor.secondary),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            selectedItemBuilder: (context) {
              return widget.itemsList.map((user) {
                return Text(user.name.isEmpty ? user.email : user.name);
              }).toList();
            },

            items: widget.itemsList.map((user) {
              return DropdownMenuItem<String>(
                value: user.name.isEmpty ? user.email : user.name,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 7.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name.isEmpty ? "{No Name}" : user.name),
                      Text(user.email, style: hintTextStyle()),
                      Divider(color: AppColor.secondary),
                    ],
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
              widget.onChanged(value);
            },
          ),
        ],
      ),
    );
  }
}

class MyUploadTextField extends StatelessWidget {
  final TextEditingController userController;
  final IconData? frontIcon;
  final String hint;
  final String labelText;
  final IconData? backIcon;
  final bool isDesc;
  final bool isDateandTime;
  final bool isExpanded;
  final bool isRequired;
  const MyUploadTextField({
    super.key,
    required this.userController,
    this.backIcon,
    this.frontIcon,
    required this.hint,
    required this.labelText,
    this.isDesc = false,
    this.isDateandTime = false,
    this.isExpanded = true,
    this.isRequired = true,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: SizedBox(
        width: isExpanded ? double.infinity : 150.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(labelText, style: t3White().copyWith(fontSize: 20.sp)),
                isRequired
                    ? Text(
                        " *",
                        style: t3White().copyWith(
                          fontSize: 20.sp,
                          color: AppColor.error,
                        ),
                      )
                    : Container(),
              ],
            ),
            SizedBox(height: 10.h),
            TextField(
              keyboardType: isDateandTime ? TextInputType.datetime : null,
              maxLines: isDesc ? 3 : 1,
              controller: userController,
              textAlignVertical: TextAlignVertical.center,
              cursorColor: Colors.blue,
              style: t3White(),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 17.h,
                ).copyWith(right: 10.w),
                filled: true,
                fillColor: AppColor.secondary.withAlpha(10),
                suffixIcon: backIcon != null
                    ? Icon(backIcon, color: AppColor.secondary)
                    : null,
                prefixIcon: frontIcon != null
                    ? Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 3.w),
                        child: Icon(frontIcon, color: AppColor.secondary),
                      )
                    : SizedBox(width: 10.w),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                hintText: hint,
                hintStyle: hintTextStyle().copyWith(fontSize: 20.sp),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.secondary),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.secondary),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.secondary),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyDateAndTimePickerBox extends StatelessWidget {
  final IconData? frontIcon;
  final String? hint;
  final String labelText;
  final VoidCallback onPressed;
  final bool isExpanded;
  final bool isRequired;

  const MyDateAndTimePickerBox({
    super.key,
    this.isExpanded = true,
    required this.onPressed,
    this.frontIcon,
    this.hint,
    required this.labelText,
    this.isRequired = true,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(labelText, style: t3White().copyWith(fontSize: 20.sp)),
            isRequired
                ? Text(
                    " *",
                    style: t3White().copyWith(
                      fontSize: 20.sp,
                      color: AppColor.error,
                    ),
                  )
                : Container(),
          ],
        ),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: onPressed,
          child: myTextHolderContainer(
            isExpanded: isExpanded,
            horizontal: 13.w,
            child: Row(
              children: [
                Icon(frontIcon, color: AppColor.secondary),
                SizedBox(width: 5.w),
                Text(
                  hint!,
                  style: hintTextStyle().copyWith(
                    color: (hint == "12:00 AM" || hint == "dd/mm/yyyy")
                        ? null
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget myShimmerBox({double width = 90, double height = 60}) {
  return Shimmer.fromColors(
    baseColor: Color(0xFF152A4F),
    highlightColor: Color(0xFF1E3A70),
    child: Column(
      children: [
        Container(
          height: height.h,
          width: width.w,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Color(0xFF152A4F),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    ),
  );
}

Widget myShimmerTextBox({double width = 90, double height = 60}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade700,
    highlightColor: Colors.grey.shade500,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(6),
      ),
    ),
  );
}

Widget myTasksShimmerBox({
  double width = 90,
  double height = 60,
  int itemCount = 6,
}) {
  return Shimmer.fromColors(
    baseColor: Color(0xFF152A4F),
    highlightColor: Color(0xFF1E3A70),
    child: Column(
      children: List.generate(itemCount, (index) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            height: height.h,
            width: width.w,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Color(0xFF152A4F),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }),
    ),
  );
}

class MySearchField extends StatefulWidget {
  final IconData? icon;
  final String hintText;
  const MySearchField({
    super.key,
    required this.hintText,
    this.icon = Icons.search,
  });

  @override
  State<MySearchField> createState() => _MySearchFieldState();
}

class _MySearchFieldState extends State<MySearchField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: AppColor.dropDownColor,
        boxShadow: [
          BoxShadow(
            color: AppColor.dropDownColor,
            offset: Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextField(
        cursorColor: AppColor.secondary,
        style: t3White().copyWith(fontSize: 18.sp),
        decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(maxWidth: 50.w),
          hintStyle: hintTextStyle().copyWith(fontSize: 18.sp),
          hintText: widget.hintText,
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 15.w, right: 10.w),
            child: Icon(Icons.search, color: AppColor.secondary),
          ),
          filled: true,
          fillColor: AppColor.dropDownColor,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: const BorderSide(color: AppColor.secondary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: const BorderSide(color: AppColor.secondary),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: const BorderSide(color: AppColor.secondary),
          ),
        ),
      ),
    );
  }
}

Widget imageHolderWithCamera({
  XFile? imagePath,
  required VoidCallback onPressed,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: GestureDetector(
      onTap: onPressed,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            key: ValueKey(imagePath?.path),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 2, color: AppColor.secondary),
              image: DecorationImage(
                image: imagePath != null
                    ? FileImage(File(imagePath.path))
                    : AssetImage(AppImages.profilePlaceholder) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Camera Icon Overlay
          Positioned(
            bottom: 0,
            right: -1,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.dropDownColor,
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Icon(
                Icons.camera_alt,
                color: AppColor.textSecondary,
                size: 15.sp,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void showImagePickerAlert({
  required BuildContext context,
  required VoidCallback onCameraTap,
  required VoidCallback onGalleryTap,
}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppColor.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppColor.border, width: 2),
      ),
      title: Text(
        "Choose Image Source",
        style: t1heading().copyWith(fontSize: 20.sp),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Camera Option
          ListTile(
            leading: Icon(Icons.camera_alt, color: AppColor.text),
            title: Text("Camera", style: t3White()),
            onTap: () {
              Navigator.pop(context);
              onCameraTap();
            },
          ),
          Divider(color: AppColor.border),

          // Gallery Option
          ListTile(
            leading: Icon(Icons.photo, color: AppColor.text),
            title: Text("Gallery", style: t3White()),
            onTap: () {
              Navigator.pop(context);
              onGalleryTap();
            },
          ),
        ],
      ),
    ),
  );
}

void showMyAddOptionsAlert({
  required BuildContext context,
  required VoidCallback onAddTaskTap,
  required VoidCallback onAddEventTap,
  required VoidCallback onAddAppointmentTap,
}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppColor.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppColor.border, width: 2),
      ),
      title: Text("Create New", style: t1heading().copyWith(fontSize: 20.sp)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Add Task
          ListTile(
            leading: Icon(Icons.check_circle_outline, color: AppColor.text),
            title: Text("Add Task", style: t3White()),
            onTap: () {
              Navigator.pop(context);
              onAddTaskTap();
            },
          ),
          Divider(color: AppColor.border),

          // Add Event
          ListTile(
            leading: Icon(Icons.event, color: AppColor.text),
            title: Text("Add Event", style: t3White()),
            onTap: () {
              Navigator.pop(context);
              onAddEventTap();
            },
          ),
          Divider(color: AppColor.border),

          // Add Appointment
          ListTile(
            leading: Icon(Icons.schedule, color: AppColor.text),
            title: Text("Add Appointment", style: t3White()),
            onTap: () {
              Navigator.pop(context);
              onAddAppointmentTap();
            },
          ),
        ],
      ),
    ),
  );
}

class BoardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onTap;

  const BoardCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,

          // padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColor.dropDownColor,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.white12,
                blurRadius: 5,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: AppColor.secondary, width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
            child: Column(
              children: [
                Text(
                  title,
                  style: t1heading().copyWith(color: AppColor.textSecondary),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Image.asset(imagePath, fit: BoxFit.cover, height: 150.h),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        subtitle,
                        textAlign: TextAlign.start,
                        style: hintTextStyle(),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.secondary,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: onTap,
                          child: Icon(
                            Icons.keyboard_double_arrow_right_rounded,
                            size: 25.sp,

                            color: AppColor.dropDownColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showCustomBoardModalBottomSheet(
  BuildContext context, {

  required Widget Function(void Function(VoidCallback) setState) builder,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    enableDrag: true,
    isDismissible: true,
    backgroundColor: AppColor.dropDownColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Wrap(
              children: [
                builder(
                  setModalState,
                ), // You can call setModalState to update UI
              ],
            );
          },
        ),
      ),
    ),
  );
}
