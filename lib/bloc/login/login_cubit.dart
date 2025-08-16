import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:family_management_app/app/api/firebaseauth_Exception.dart';
import 'package:family_management_app/service/secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:google_sign_in/google_sign_in.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState(status: LoginStatus.initialLogin));

  Future<void> login({required String email, required String password}) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String? freshToken = await FirebaseMessaging.instance.getToken();

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

      if (userDoc.data()?['role'] == null) {
        emit(
          state.copyWith(
            status: LoginStatus.loginFailure,
            errorMsg: "You are not assigned a role yet.",
          ),
        );
        return;
      }

      final savedName = userDoc.data()?['name'] as String?;
      final savedEmail = userDoc.data()?['email'] as String?;
      final savedRole = userDoc.data()?['role'] as String?;
      final savedUid = user?.uid;

      await SecureStorage.save(key: "email", data: savedEmail!);
      await SecureStorage.save(key: "name", data: savedName!);
      await SecureStorage.save(key: "uid", data: savedUid!);
      await SecureStorage.save(key: "savedRole", data: savedRole!);

      emit(
        state.copyWith(
          status: LoginStatus.logged,
          errorMsg: "Logged in successfully",
        ),
      );
      if (freshToken != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .update({'fcmToken': freshToken, "wasLogin": true});
      }
      log(freshToken ?? "");
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

  Future<void> signInWithGoogle() async {
    final GoogleSignIn signIn = GoogleSignIn.instance;

    emit(
      state.copyWith(
        status: LoginStatus.googleLogin,
        errorMsg: "Signing in with Google",
      ),
    );

    try {
      await signIn.initialize();

      signIn.authenticationEvents
          .listen((event) async {
            final user = switch (event) {
              GoogleSignInAuthenticationEventSignIn() => event.user,
              GoogleSignInAuthenticationEventSignOut() => null,
            };

            if (user != null) {
              final auth = user.authentication;
              final credential = GoogleAuthProvider.credential(
                idToken: auth.idToken,
              );

              UserCredential userCredential = await FirebaseAuth.instance
                  .signInWithCredential(credential);

              final googleUser = userCredential.user;
              final String? displayName = googleUser!.displayName;
              final String? email = googleUser.email;
              final String? photoUrl = googleUser.photoURL;

              emit(
                state.copyWith(
                  status: LoginStatus.googleLoginSuccessful,
                  errorMsg: "Google Sign-In successful",
                  uid: googleUser.uid,
                ),
              );

              log("User UID: ${googleUser.uid}");
              log("User Name: $displayName");
              log("User Email: $email");
              log("User Photo URL: $photoUrl");

              final userDocRef = FirebaseFirestore.instance
                  .collection('users')
                  .doc(googleUser.uid);

              final snapshot = await userDocRef.get();
              final String? savedGoogleRole = await snapshot.data()?['role'];

              if (snapshot.exists && savedGoogleRole != null) {
                await SecureStorage.save(
                  key: "savedRole",
                  data: savedGoogleRole,
                );
              } else {
                // First-time user: create document
                await userDocRef.set({
                  'name': displayName ?? "",
                  'createdAt': FieldValue.serverTimestamp(),
                  'email': email ?? "",
                  'photoUrl': photoUrl ?? "",
                  'role': null,
                  'joinStatus': null,
                  'wasApprovedShown': false,
                });
              }

              if (!snapshot.exists) {
                // First-time user: create document
                await userDocRef.set({
                  'name': displayName ?? "",
                  'createdAt': FieldValue.serverTimestamp(),
                  'email': email ?? "",
                  'photoUrl': photoUrl ?? "",
                  'role': null,
                  'joinStatus': null,
                  'wasApprovedShown': false,
                });
              }

              await SecureStorage.save(key: "email", data: email!);
              await SecureStorage.save(key: "name", data: displayName!);
              await SecureStorage.save(key: "uid", data: googleUser.uid);
              await SecureStorage.save(key: "imagePath", data: photoUrl ?? "");
            }
          })
          .onError((e) {
            final errorMessage =
                GoogleSignInErrorHandler.getFriendlyErrorMessage(e);
            log('Google Sign-In error: $errorMessage');
            emit(
              state.copyWith(
                status: LoginStatus.googleLoginFailure,
                errorMsg: errorMessage,
              ),
            );
            log('Authentication error: $e');
          });

      await signIn.authenticate();
    } on FirebaseAuthException catch (exe) {
      final errorMessage = FirebaseAuthErrorHandler.getMessage(exe);
      emit(
        state.copyWith(
          status: LoginStatus.googleLoginFailure,
          errorMsg: errorMessage,
        ),
      );
      log('FirebaseAuthException: ${exe.message}');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(
      state.copyWith(
        status: LoginStatus.forgetting,
        errorMsg: "Sending password reset email",
      ),
    );
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      emit(
        state.copyWith(
          status: LoginStatus.forgetSucessful,
          errorMsg: "Password reset email sent successfully",
        ),
      );
      log('Password reset email sent to $email');
    } on FirebaseAuthException catch (exe) {
      final errorMessage = FirebaseAuthErrorHandler.getMessage(exe);
      emit(
        state.copyWith(
          status: LoginStatus.forgetFailure,
          errorMsg: errorMessage,
        ),
      );

      log('FirebaseAuthException: ${exe.message}');
    }
  }

  // Future<void> signInWithApple() async {
  //   try {
  //     final appleCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );

  //     final oauthCredential = OAuthProvider("apple.com").credential(
  //       idToken: appleCredential.identityToken,
  //       accessToken: appleCredential.authorizationCode,
  //     );

  //     UserCredential userCredential = await FirebaseAuth.instance
  //         .signInWithCredential(oauthCredential);

  //     final appleUser = userCredential.user;
  //     final String? displayName = appleUser!.displayName;
  //     final String? email = appleUser.email;
  //     final String? photoUrl = appleUser.photoURL;

  //     emit(
  //       state.copyWith(
  //         status: LoginStatus.appleLoginSuccessful,
  //         errorMsg: "Apple Sign-In successful",
  //         uid: appleUser.uid,
  //       ),
  //     );

  //     log("User UID: ${appleUser.uid}");
  //     log("User Name: $displayName");
  //     log("User Email: $email");
  //     log("User Photo URL: $photoUrl");
  //     log(
  //       "Apple Sign-In successful! User: ${FirebaseAuth.instance.currentUser?.uid}",
  //     );
  //     final userDocRef = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(appleUser.uid);

  //     final snapshot = await userDocRef.get();

  //     if (!snapshot.exists) {
  //       await userDocRef.set({
  //         'name': displayName ?? "",
  //         'createdAt': FieldValue.serverTimestamp(),
  //         'email': email ?? "",
  //         'photoUrl': photoUrl ?? "",
  //         'role': null,
  //         'joinStatus': null,
  //         'wasApprovedShown': false,
  //       });
  //     }

  //     await SecureStorage.save(key: "email", data: email!);
  //     await SecureStorage.save(key: "name", data: displayName!);
  //     await SecureStorage.save(key: "uid", data: appleUser.uid);
  //     await SecureStorage.save(key: "imagePath", data: photoUrl ?? "");
  //   } catch (e) {
  //     if (e is SignInWithAppleAuthorizationException &&
  //         e.code == AuthorizationErrorCode.canceled) {
  //       log("User canceled Apple Sign-In");
  //     } else {
  //       log("Apple Sign-In error: $e");
  //     }
  //   }
  // }
}
