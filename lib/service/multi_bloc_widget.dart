import 'package:family_management_app/bloc/add%20tasks/add_tasks_cubit.dart';
import 'package:family_management_app/bloc/fetch%20User/fetch_user_cubit.dart';
import 'package:family_management_app/bloc/fetch_tasks/fetch_tasks_cubit.dart';
import 'package:family_management_app/bloc/login/login_cubit.dart';
import 'package:family_management_app/bloc/register/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MultiBlocWidget extends StatelessWidget {
  final Widget child;
  const MultiBlocWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => FetchUserCubit()),
        BlocProvider(create: (context) => FetchTasksCubit()),
        BlocProvider(create: (context) => AddTasksCubit()),
        // BlocProvider(create: (context) => PickImageCubit()),
      ],
      child: child,
    );
  }
}
