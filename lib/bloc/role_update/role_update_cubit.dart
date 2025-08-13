import 'dart:developer';
import 'dart:math' hide log;
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:family_management_app/app/api/firebaseauth_Exception.dart';
import 'package:family_management_app/service/notification_service.dart';
import 'package:family_management_app/service/secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'role_update_state.dart';

class RoleUpdateCubit extends Cubit<RoleUpdateState> {
  RoleUpdateCubit()
    : super(RoleUpdateState(status: RoleUpdatingStatus.initialUpdating));

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<bool> checkBoardExists(String boardId) async {
    final querySnapshot = await firestore
        .collection("users")
        .where("boardId", isEqualTo: boardId)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> updateChiefsRole({
    required String uid,
    required String title,
    String? description,
  }) async {
    emit(state.copyWith(status: RoleUpdatingStatus.updating));

    try {
      String boardCode = generateBoardCode(length: 5);
      log(boardCode);
      await firestore.collection('users').doc(uid).update({
        "role": "Chief",
        'boardId': boardCode,
        'title': title,
        'description': description ?? "",
      });
      final doc = await firestore.collection("users").doc(uid).get();

      final savedBoardId = doc.data()?['boardId'];
      final savedTitle = doc.data()?['title'];
      final savedDescription = doc.data()?['description'];
      await SecureStorage.save(key: "role", data: "Chief");
      await SecureStorage.save(key: "boardId", data: savedBoardId);

      emit(
        state.copyWith(
          status: RoleUpdatingStatus.updated,
          boardDescription: savedDescription,
          boardId: savedBoardId,
          boardTitle: savedTitle,
        ),
      );
      await NotificationService.showLocalBoardCreatedNotification();
    } on FirebaseAuthException catch (exe) {
      final errorMessage = FirebaseAuthErrorHandler.getMessage(exe);
      emit(
        state.copyWith(
          status: RoleUpdatingStatus.updatingFailure,
          errorMsg: errorMessage,
        ),
      );
    }
  }

  Future<void> updateMembersRole({
    required String boardId,
    String? nickname,
  }) async {
    emit(state.copyWith(status: RoleUpdatingStatus.updating));
    try {
      final uid = firebaseAuth.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      await firestore.collection("users").doc(uid).update({
        "role": null,
        "boardId": boardId,
        "nickname": nickname ?? "",
        "joinStatus": "pending",
        "status": "pending",
      });

      final userDoc = await firestore.collection("users").doc(uid).get();
      final userData = userDoc.data()!;
      await firestore
          .collection('board')
          .doc(boardId)
          .collection("joinRequests")
          .add({
            'userId': uid,
            'name': userData['name'] ?? "",
            "email": userData['email'] ?? "",
            "imagePath": userData["imagePath"] ?? "",
            'nickname': nickname ?? "",
            'createdAt': FieldValue.serverTimestamp(),
            "boardId": boardId,
            "joinStatus": 'pending',
            "status": 'pending',
          });

      emit(
        state.copyWith(
          status: RoleUpdatingStatus.updated,
          role: "",
          boardNickname: nickname,
        ),
      );
      await NotificationService.showLocalBoardJoiningNotification();
    } on FirebaseAuthException catch (exe) {
      final errorMessage = FirebaseAuthErrorHandler.getMessage(exe);
      emit(
        state.copyWith(
          status: RoleUpdatingStatus.updatingFailure,
          errorMsg: errorMessage,
        ),
      );
    }
  }

  String generateBoardCode({int length = 5}) {
    final random = Random();
    int min = pow(10, length - 1).toInt();
    int max = pow(10, length).toInt() - 1;

    return (min + random.nextInt(max - min)).toString();
  }
}
