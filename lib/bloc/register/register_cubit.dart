import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:family_management_app/app/api/firebaseauth_Exception.dart';
import 'package:family_management_app/service/secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit()
    : super(RegisterState(status: RegisterStatus.initialregister));

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    String? role,
  }) async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      emit(
        state.copyWith(
          status: RegisterStatus.emptyRegister,
          errorMsg: "Enter the required Field",
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: RegisterStatus.registering,
        errorMsg: "Registering........ please Wait",
      ),
    );
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      await firestore.collection("users").doc(uid).set({
        "name": name,
        "email": email,
        "role": role,
        "createdAt": FieldValue.serverTimestamp(),
      });

      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      final savedRole = doc.data()?['role'] as String?;
      final savedEmail = doc.data()?['email'] as String?;

      await SecureStorage.save(key: "role", data: savedRole!);
      await SecureStorage.save(key: "email", data: savedEmail!);

      emit(
        state.copyWith(
          status: RegisterStatus.registered,
          errorMsg: "User Register Successfully",
        ),
      );
    } on FirebaseAuthException catch (exe) {
      final errorMessage = FirebaseAuthErrorHandler.getMessage(exe);

      emit(
        state.copyWith(
          status: RegisterStatus.registerFailure,
          errorMsg: errorMessage,
        ),
      );
    }
  }
}
