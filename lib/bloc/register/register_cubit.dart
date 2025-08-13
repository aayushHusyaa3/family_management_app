import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:family_management_app/app/api/firebaseauth_Exception.dart';
import 'package:family_management_app/service/secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

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
    XFile? profileImage,
  }) async {
    emit(
      state.copyWith(
        status: RegisterStatus.registering,
        errorMsg: "Registering........ please Wait",
      ),
    );
    log("Registering");
    try {
      String? imagePath;

      if (profileImage != null) {
        imagePath = await uploadProfileImage(profileImage);
        await SecureStorage.save(key: "imagePath", data: imagePath);
      } else {
        imagePath = "";
      }
      log("Entered in try catch");
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      await firestore.collection("users").doc(uid).set({
        "name": name,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
        'imagePath': imagePath,
        "role": null,
        "joinStatus": null,
        "wasApprovedShown": false,
      });

      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      final savedEmail = doc.data()?['email'] as String?;
      final savedName = doc.data()?['name'] as String?;

      await SecureStorage.save(key: "email", data: savedEmail!);
      await SecureStorage.save(key: "name", data: savedName!);
      await SecureStorage.save(key: "uid", data: uid!);

      emit(
        state.copyWith(
          status: RegisterStatus.registered,
          errorMsg: "Your account has been successfully created",
          uid: uid,
          email: savedEmail,
          name: savedName,
        ),
      );
      log("Registered");
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

  Future<String> uploadProfileImage(XFile imageFile) async {
    try {
      File file = File(imageFile.path);

      String fileName = await SecureStorage.read(key: "uid") ?? "12345";
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$fileName.jpg');

      // Upload file
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  void resetStatus() {
    emit(state.copyWith(status: RegisterStatus.initialregister));
  }
}
