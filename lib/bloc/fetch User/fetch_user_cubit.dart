import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'fetch_user_state.dart';

class FetchUserCubit extends Cubit<FetchUserState> {
  FetchUserCubit()
    : super(FetchUserState(status: FetchUserStatus.initialFetching));
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> getUserRole() async {
    emit(
      state.copyWith(
        status: FetchUserStatus.fetching,
        errorMsg: "Fetching.... Please Wait",
      ),
    );

    try {
      final uid = auth.currentUser?.uid;
      final doc = await firestore.collection("users").doc(uid).get();
      final role = doc.data()?['role'] as String?;
      final email = doc.data()?['email'] as String?;
      final name = doc.data()?['name'] as String?;
      final imagePath = doc.data()?['imagePath'] as String?;
      log("UID: $uid, EMAIL: $email, ROLE: $role");

      emit(
        state.copyWith(
          status: FetchUserStatus.fetched,
          role: role,
          email: email,
          name: name,
          uid: uid,
          errorMsg: "User Fetched Successfully",
          imagePath: imagePath,
        ),
      );
    } on FirebaseAuthException catch (exe) {
      emit(
        state.copyWith(
          status: FetchUserStatus.fetchingError,
          errorMsg: exe.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FetchUserStatus.fetchingError,
          errorMsg: e.toString(),
        ),
      );
    }
  }

  Future<void> logOut() async {
    emit(
      state.copyWith(
        status: FetchUserStatus.logouting,
        errorMsg: "Logging Out.... Please Wait",
      ),
    );
    try {
      await FirebaseAuth.instance.signOut();
      emit(
        state.copyWith(
          status: FetchUserStatus.loggedOut,
          errorMsg: "log Out Successfully",
        ),
      );
    } on FirebaseAuthException catch (exe) {
      emit(
        state.copyWith(
          status: FetchUserStatus.logoutFailed,
          errorMsg: exe.toString(),
        ),
      );
    }
  }

  Future<void> getAllUser({required String role}) async {
    emit(
      state.copyWith(
        status: FetchUserStatus.fetchingAllUser,
        errorMsg: "User Fetching.......",
      ),
    );

    try {
      final snapshot = await firestore
          .collection('users')
          .where('role', isEqualTo: role)
          .get();

      final userList = snapshot.docs.map((doc) {
        final data = doc.data();
        return AllUserInfo(
          uid: data['uid'] ?? '',
          name: data['name'] ?? '',
          email: data['email'] ?? '',
        );
      }).toList();
      emit(
        state.copyWith(
          status: FetchUserStatus.fetchedAllUser,
          userInfo: userList,
          errorMsg: "All User Fetched Successfully",
        ),
      );
    } on FirebaseException catch (exe) {
      emit(
        state.copyWith(
          status: FetchUserStatus.fetchingAllUserFailed,
          errorMsg: exe.toString(),
        ),
      );
    }
  }
}
