import 'dart:developer';
import 'dart:io';
import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CropImageScreen extends StatefulWidget {
  final XFile? pickedFile;
  const CropImageScreen({super.key, required this.pickedFile});

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  @override
  void initState() {
    super.initState();
    cropImage(context);
  }

  Future<void> cropImage(context) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: widget.pickedFile!.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Crop Image",
          toolbarColor: AppColor.surface,
          toolbarWidgetColor: AppColor.text,
          backgroundColor: AppColor.background,
          statusBarColor: AppColor.background,
          activeControlsWidgetColor: AppColor.text,
          initAspectRatio: CropAspectRatioPreset.square,
          cropStyle: CropStyle.rectangle,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: "Crop Image"),
      ],
    );

    if (croppedFile != null) {
      log("🚀 Cropped file ready: ${croppedFile.path}");
      Navigator.pop(context, File(croppedFile.path));
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: LoadingIndicator(
            indicatorType: Indicator.pacman,
            colors: [AppColor.secondary],
          ),
        ),
      ),
    );
  }
}
