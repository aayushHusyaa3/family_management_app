import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:family_management_app/bloc/fetch_tasks/fetch_tasks_cubit.dart';

import 'package:firebase_auth/firebase_auth.dart';

part 'add_tasks_state.dart';

class AddTasksCubit extends Cubit<AddTasksState> {
  AddTasksCubit() : super(AddTasksState(status: PostStatus.initalPosting));

  Future<void> addTaskFun({
    required String title,
    required String desc,
    String? assignedRole,
    String? assignedMember,
    required String date,
    String? time,
    required String priority,
  }) async {
    emit(state.copyWith(status: PostStatus.initalPosting));
    if (title.isEmpty || desc.isEmpty || date.isEmpty || priority.isEmpty) {
      emit(
        state.copyWith(
          status: PostStatus.emptyPosting,
          errorMsg: "Enter the required field",
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: PostStatus.posting,
        errorMsg: "Assigning task... Please Wait",
      ),
    );

    try {
      final user = FirebaseAuth.instance.currentUser;
      final firestore = FirebaseFirestore.instance.collection("tasks").doc();
      final uid = user?.uid;
      final String taskId = firestore.id;

      Map<String, dynamic> taskData = {
        "taskId": taskId,
        "title": title,
        "description": desc,
        "assignedRole": assignedRole ?? "",
        "assignedMember": assignedMember ?? "",
        "date": date,
        "time": time ?? "",
        "priority": priority,
        "status": "pending",
        "createdBy": uid,
        "createdAt": FieldValue.serverTimestamp(),
      };
      await firestore.set(taskData);

      emit(
        state.copyWith(
          status: PostStatus.posted,
          errorMsg: "Task Assigned Successfully",
          taskId: taskId,
        ),
      );
    } on FirebaseAuthException catch (exe) {
      emit(
        state.copyWith(status: PostStatus.postingFailed, errorMsg: exe.message),
      );
    }
  }

  Future<void> deleteTask({
    required List<String> taskId,
    required FetchTasksCubit fetchCubit,
  }) async {
    emit(
      state.copyWith(
        status: PostStatus.deleting,
        errorMsg: "Deleting selected task.... Please Wait",
      ),
    );
    fetchCubit.removeTasks(taskId);
    try {
      for (var task in taskId) {
        await FirebaseFirestore.instance.collection('tasks').doc(task).delete();
      }
      final int deleteTaskCount = taskId.length;
      final String taskCount = deleteTaskCount == 1 ? "task" : "tasks";

      emit(
        state.copyWith(
          status: PostStatus.deleted,
          errorMsg: "$deleteTaskCount $taskCount deleted sucessfully",
        ),
      );
    } on FirebaseException catch (exe) {
      emit(
        state.copyWith(
          status: PostStatus.deletingFailed,
          errorMsg: exe.message,
        ),
      );
    }
  }

  Future<void> markAsDoneFun({required List<String> taskId}) async {
    emit(state.copyWith(status: PostStatus.marking));
    try {
      for (var task in taskId) {
        await FirebaseFirestore.instance.collection('tasks').doc(task).update({
          'isCompleted': true,
        });
      }
      final int markTaskCount = taskId.length;
      final String taskCount = markTaskCount == 1 ? "task" : "tasks";

      emit(
        state.copyWith(
          status: PostStatus.marked,
          errorMsg: "$markTaskCount $taskCount completed Sucessfully",
        ),
      );
    } on FirebaseException catch (exe) {
      emit(
        state.copyWith(status: PostStatus.markingFailed, errorMsg: exe.message),
      );
    }
  }
}
