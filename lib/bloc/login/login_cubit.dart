import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:family_management_app/app/api/firebaseauth_Exception.dart';
import 'package:family_management_app/service/secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState(status: LoginStatus.initialLogin));

  Future<void> login({required String email, required String password}) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    emit(
      state.copyWith(
        status: LoginStatus.logging,
        errorMsg: "Logging in please wait",
      ),
    );

    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();
      // final savedRole = userDoc.data()?['role'] as String?;
      final savedName = userDoc.data()?['name'] as String?;
      final savedEmail = userDoc.data()?['email'] as String?;
      final savedUid = user?.uid;

      // await SecureStorage.save(key: "role", data: savedRole!);
      await SecureStorage.save(key: "email", data: savedEmail!);
      await SecureStorage.save(key: "name", data: savedName!);
      await SecureStorage.save(key: "uid", data: savedUid!);

      emit(
        state.copyWith(
          status: LoginStatus.logged,
          errorMsg: "Logged in successfully",
        ),
      );
    } on FirebaseAuthException catch (exe) {
      final errorMessage = FirebaseAuthErrorHandler.getMessage(exe);

      emit(
        state.copyWith(
          status: LoginStatus.loginFailure,
          errorMsg: errorMessage,
        ),
      );
    }
  }
}
