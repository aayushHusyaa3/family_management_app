import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'fetch_tasks_state.dart';

class FetchTasksCubit extends Cubit<FetchTasksState> {
  FetchTasksCubit()
    : super(FetchTasksState(status: FetchTasksStatus.initialFetching));

  Future<void> fetchTasks() async {
    emit(
      state.copyWith(
        status: FetchTasksStatus.fetching,
        errorMsg: "Tasks is being fetched.... Please Wait",
      ),
    );

    try {
      final firestore = await FirebaseFirestore.instance
          .collection('tasks')
          .get();
      final taskCount = firestore.docs.length;

      final userList = firestore.docs.map((doc) {
        final data = doc.data();
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
      final String taskId = FirebaseFirestore.instance
          .collection('tasks')
          .doc()
          .id;
      final urgentCount = await FirebaseFirestore.instance
          .collection('tasks')
          .where("priority", isEqualTo: "High")
          .get();

      emit(
        state.copyWith(
          status: FetchTasksStatus.fetched,
          errorMsg: "Tasks Fetched Sucessfully",
          taskCount: taskCount,
          taskInfoList: userList,
          taskId: taskId,
          urgentCount: urgentCount.docs.length,
        ),
      );
    } on FirebaseException catch (exe) {
      emit(
        state.copyWith(
          status: FetchTasksStatus.fetchingError,
          errorMsg: exe.message,
        ),
      );
    }
  }

  Future<void> deleteTask({required List<String> taskId}) async {
    emit(
      state.copyWith(
        status: FetchTasksStatus.deleting,
        errorMsg: "Deleting selected task(s).... Please Wait",
      ),
    );

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

      await Future.delayed(Duration(seconds: 1), () {
        emit(state.copyWith(status: FetchTasksStatus.fetched));
      });
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
          'isCompleted': true,
        });
      }
      final int markTaskCount = taskId.length;
      final String taskCount = markTaskCount == 1 ? "task" : "tasks";

      emit(
        state.copyWith(
          status: FetchTasksStatus.marked,
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
