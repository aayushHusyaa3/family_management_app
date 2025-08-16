import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:family_management_app/service/secure_storage.dart';
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
      final boardId = doc.data()?['boardId'] as String?;
      final imagePath = doc.data()?['imagePath'] as String?;

      log("UID: $uid, EMAIL: $email, ROLE: $role,");

      emit(
        state.copyWith(
          status: FetchUserStatus.fetched,
          role: role,
          email: email,
          name: name,
          uid: uid,

          boardId: boardId,
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

  Future<void> fetchJoinRequests() async {
    emit(
      state.copyWith(
        status: FetchUserStatus.fetching,
        itemCount: state.joinRequestList?.length ?? 5,
      ),
    );
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        emit(
          state.copyWith(
            status: FetchUserStatus.fetchingError,
            errorMsg: "Missing uid",
          ),
        );
        return;
      }

      final userDoc = await firestore.collection("users").doc(uid).get();
      final role = userDoc.data()?['role'] as String?;
      final boardId = userDoc.data()?['boardId'] as String?;

      if (role != 'Chief' || boardId == null) {
        emit(
          state.copyWith(
            status: FetchUserStatus.fetchingError,
            errorMsg: "Only chief can view join requests",
          ),
        );
        return;
      }

      // Fetch all join requests for the chief's board
      final snapshot = await firestore
          .collection('board')
          .doc(boardId)
          .collection("joinRequests")
          .orderBy("createdAt", descending: true)
          .get();

      final list = snapshot.docs.map((doc) {
        final data = doc.data();
        data['docId'] = doc.id;
        return {
          'docId': doc.id,
          'email': data['email'] as String? ?? '',
          'name': data['name'] as String? ?? '',
          'imagePath': data['imagePath'] as String? ?? '',
          "userId": data['userId'] as String? ?? "",
          'status': data['status'] as String? ?? "",
          'joinsStatus': data['joinsStatus'] as String? ?? "",
        };
      }).toList();
      log("pendingCount:");
      final pendingCount = list
          .where((req) => req['status'] == 'pending')
          .length;

      log("pendingCount: $pendingCount");

      emit(
        state.copyWith(
          joinRequestList: list,
          status: FetchUserStatus.fetched,
          roleStatus: role,
          pendingCount: pendingCount,
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

  Future<void> rejectJoinRequest(String email, String docId) async {
    try {
      await firestore
          .collection('board')
          .doc(state.boardId)
          .collection("joinRequests")
          .doc(docId)
          .update({'status': 'rejected', "role": ""});
      await fetchJoinRequests();
    } catch (e) {
      // handle error
    }
  }

  Future<void> acceptJoinRequest(
    String email,
    String docId,
    String role,
  ) async {
    try {
      await firestore
          .collection('board')
          .doc(state.boardId)
          .collection("joinRequests")
          .doc(docId)
          .update({
            'status': 'accepted',
            'role': role,
            "joinStatus": 'accepted',
          });
      await fetchJoinRequests();
      await SecureStorage.save(key: "savedRole", data: role);

      final joinRequestDoc = await firestore
          .collection('board')
          .doc(state.boardId)
          .collection("joinRequests")
          .doc(docId)
          .get();

      final userId = joinRequestDoc.data()?['userId'] as String?;

      if (userId != null && userId.isNotEmpty) {
        await firestore.collection('users').doc(userId).update({
          'joinStatus': 'accepted',
          'role': role,
        });
      }
    } catch (e) {
      // handle error
    }
  }

  Future<void> checkWaiting({required String boardId}) async {
    final uid = auth.currentUser?.uid;
    log("Uid: ${uid}");

    emit(
      state.copyWith(
        status: FetchUserStatus.fetching,
        itemCount: state.joinRequestList?.length ?? 5,
      ),
    );
    try {
      final singleSnapShot = await firestore.collection("users").doc(uid).get();
      final roleStatus = singleSnapShot.data()?['joinStatus'] as String?;

      log("RoleStatus: $roleStatus");

      emit(
        state.copyWith(status: FetchUserStatus.fetched, roleStatus: roleStatus),
      );
    } catch (e) {
      // handle error
      emit(state.copyWith(status: FetchUserStatus.fetchingError));
    }
  }

  void resetNotificationCount() {
    emit(state.copyWith(pendingCount: 0));
  }
}
