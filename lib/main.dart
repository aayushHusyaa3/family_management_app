import 'package:family_management_app/app/app%20Color/app_color.dart';
import 'package:family_management_app/app/routes/app_router.dart';
import 'package:family_management_app/app/routes/app_routes.dart';
import 'package:family_management_app/service/multi_bloc_widget.dart';
import 'package:family_management_app/service/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initFCM();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(MultiBlocWidget(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      splitScreenMode: true,
      minTextAdapt: true,
      ensureScreenSize: true,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            iconTheme: IconThemeData(size: 25.sp, color: AppColor.secondary),
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppColor.background,
          ),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter().generateRoutes,
          initialRoute: AppRoutes.splashScreen,
        );
      },
    );
  }
}
