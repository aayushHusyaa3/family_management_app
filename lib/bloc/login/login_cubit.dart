import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:family_management_app/app/api/firebaseauth_Exception.dart';
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
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(
        state.copyWith(
          status: LoginStatus.logged,
          errorMsg: "Logged in successfully",
        ),
      );
    } on FirebaseAuthException catch (exe) {
      final errorMessage = FirebaseAuthErrorHandler.getMessage(exe);

      // Only emit failure — do NOT reset immediately
      emit(
        state.copyWith(
          status: LoginStatus.loginFailure,
          errorMsg: errorMessage,
        ),
      );
    }
  }

  void resetStatus() {
    emit(state.copyWith(status: LoginStatus.initialLogin, errorMsg: ''));
  }
}
