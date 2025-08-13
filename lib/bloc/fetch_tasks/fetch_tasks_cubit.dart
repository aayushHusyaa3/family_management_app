import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:family_management_app/service/secure_storage.dart';

part 'fetch_tasks_state.dart';

class FetchTasksCubit extends Cubit<FetchTasksState> {
  FetchTasksCubit()
    : super(FetchTasksState(status: FetchTasksStatus.initialFetching));

  Future<void> fetchTasks({String? status}) async {
    String currentRole = await SecureStorage.read(key: "role") ?? "Chief";
    String email = await SecureStorage.read(key: "email") ?? "";

    emit(
      state.copyWith(
        status: FetchTasksStatus.fetching,
        errorMsg: "Tasks are being fetched... Please wait",
      ),
    );

    try {
      Query query = FirebaseFirestore.instance.collection('tasks');

      if (currentRole != "Chief") {
        query = query.where("assignedMember", isEqualTo: email);
      }

      if (status != null && status.isNotEmpty) {
        query = query.where("status", isEqualTo: status);
      }

      // Fetch tasks
      final firestore = await query.get();
      final taskCount = firestore.docs.length;

      // Map Firestore docs to TaskInfo objects
      final userList = firestore.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return TaskInfo(
          taskId: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          priority: data['priority'] ?? '',
          date: data['date'] ?? '',
          assignedTo: data['assignedMember'] ?? '',
          isChecked: false,
        );
      }).toList();

      // Generate a new task ID for adding tasks
      final String taskId = FirebaseFirestore.instance
          .collection('tasks')
          .doc()
          .id;

      // Urgent tasks count (role-based as well)
      Query urgentQuery = FirebaseFirestore.instance
          .collection('tasks')
          .where("priority", isEqualTo: "High");

      if (currentRole != "Chief") {
        urgentQuery = urgentQuery.where("assignedMember", isEqualTo: email);
      }
      final urgentCountSnapshot = await urgentQuery.get();
      emit(
        state.copyWith(
          status: FetchTasksStatus.fetched,
          errorMsg: "Tasks fetched successfully",
          taskCount: taskCount,
          taskInfoList: userList,
          taskId: taskId,
          urgentCount: urgentCountSnapshot.docs.length,
        ),
      );
      log('$taskCount');
    } on FirebaseException catch (exe) {
      emit(
        state.copyWith(
          status: FetchTasksStatus.fetchingError,
          errorMsg: exe.message,
        ),
      );
    }
  }

  // Future<void> fetchStatusTasks(String status) async {
  //   emit(
  //     state.copyWith(
  //       status: FetchTasksStatus.fetchingStatusTasks,
  //       errorMsg: "Tasks is being fetched.... Please Wait",
  //     ),
  //   );

  //   try {
  //     final firestore = await FirebaseFirestore.instance
  //         .collection('tasks')
  //         .where("status", isEqualTo: status)
  //         .get();
  //     final taskCount = firestore.docs.length;

  //     final userList = firestore.docs.map((doc) {
  //       final data = doc.data();
  //       return TaskInfo(
  //         taskId: doc.id,
  //         title: data['title'] ?? '',
  //         description: data['description'] ?? '',
  //         priority: data['priority'] ?? '',
  //         date: data['date'] ?? '',
  //         assignedTo: data['assignedMember'] ?? '',
  //         isChecked: false,
  //       );
  //     }).toList();
  //     final String taskId = FirebaseFirestore.instance
  //         .collection('tasks')
  //         .doc()
  //         .id;

  //     emit(
  //       state.copyWith(
  //         status: FetchTasksStatus.fetchedStatusTasks,
  //         errorMsg: "Tasks Fetched Sucessfully",
  //         taskCount: taskCount,
  //         taskInfoList: userList,
  //         taskId: taskId,
  //       ),
  //     );
  //   } on FirebaseException catch (exe) {
  //     emit(
  //       state.copyWith(
  //         status: FetchTasksStatus.fetchingStatusTasksError,
  //         errorMsg: exe.message,
  //       ),
  //     );
  //   }
  // }

  // Future<void> fetchTasks() async {
  //   emit(
  //     state.copyWith(
  //       status: FetchTasksStatus.fetching,
  //       errorMsg: "Tasks is being fetched.... Please Wait",
  //     ),
  //   );

  //   try {
  //     final firestore = await FirebaseFirestore.instance
  //         .collection('tasks')
  //         .get();
  //     final taskCount = firestore.docs.length;

  //     final userList = firestore.docs.map((doc) {
  //       final data = doc.data();
  //       return TaskInfo(
  //         taskId: doc.id,
  //         title: data['title'] ?? '',
  //         description: data['description'] ?? '',
  //         priority: data['priority'] ?? '',
  //         date: data['date'] ?? '',
  //         assignedTo: data['assignedMember'] ?? '',
  //         isChecked: false,
  //       );
  //     }).toList();
  //     final String taskId = FirebaseFirestore.instance
  //         .collection('tasks')
  //         .doc()
  //         .id;
  //     final urgentCount = await FirebaseFirestore.instance
  //         .collection('tasks')
  //         .where("priority", isEqualTo: "High")
  //         .get();

  //     emit(
  //       state.copyWith(
  //         status: FetchTasksStatus.fetched,
  //         errorMsg: "Tasks Fetched Sucessfully",
  //         taskCount: taskCount,
  //         taskInfoList: userList,
  //         taskId: taskId,
  //         urgentCount: urgentCount.docs.length,
  //       ),
  //     );
  //   } on FirebaseException catch (exe) {
  //     emit(
  //       state.copyWith(
  //         status: FetchTasksStatus.fetchingError,
  //         errorMsg: exe.message,
  //       ),
  //     );
  //   }
  // }

  Future<void> deleteTask({required List<String> taskId}) async {
    emit(
      state.copyWith(
        status: FetchTasksStatus.deleting,
        errorMsg: "Deleting selected task(s).... Please Wait",
      ),
    );
    Future.delayed(Duration(milliseconds: 500), () {
      removeTasks(taskId);
    });

    try {
      for (var task in taskId) {
        await FirebaseFirestore.instance.collection('tasks').doc(task).delete();
      }
      int deleteTaskCount = taskId.length;
      final String taskCount = deleteTaskCount == 1 ? "task" : "tasks";

      emit(
        state.copyWith(
          status: FetchTasksStatus.deleted,
          errorMsg: "$deleteTaskCount $taskCount deleted sucessfully",
        ),
      );
    } on FirebaseException catch (exe) {
      emit(
        state.copyWith(
          status: FetchTasksStatus.deletingFailed,
          errorMsg: exe.message,
        ),
      );
    }
  }

  Future<void> markAsDoneFun({required List<String> taskId}) async {
    emit(state.copyWith(status: FetchTasksStatus.marking));
    try {
      for (var task in taskId) {
        await FirebaseFirestore.instance.collection('tasks').doc(task).update({
          'status': "completed",
          "priority": "completed",
        });
      }
      Future.delayed(Duration(milliseconds: 500), () {
        removeTasks(taskId);
      });
      final updatedList = state.taskInfoList!
          .where((task) => !taskId.contains(task.taskId))
          .toList();
      final int markTaskCount = taskId.length;
      final String taskCount = markTaskCount == 1 ? "task" : "tasks";

      emit(
        state.copyWith(
          status: FetchTasksStatus.marked,
          taskInfoList: updatedList,
          errorMsg: "$markTaskCount $taskCount completed Sucessfully",
        ),
      );
    } on FirebaseException catch (exe) {
      emit(
        state.copyWith(
          status: FetchTasksStatus.markingFailed,
          errorMsg: exe.message,
        ),
      );
    }
  }

  Future<void> removeTasks(List<String> taskIds) async {
    final updatedTasks = List<TaskInfo>.from(state.taskInfoList!)
      ..removeWhere((task) => taskIds.contains(task.taskId));
    emit(state.copyWith(taskInfoList: updatedTasks));
  }
}
