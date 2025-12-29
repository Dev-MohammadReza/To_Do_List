part of 'task_list_bloc.dart';

@immutable
sealed class TaskListState {}

final class TaskListInitial extends TaskListState {}

class TaskListloding extends TaskListState {}

class TaskListSuccess extends TaskListState {
  final List<Task> items;

  TaskListSuccess({required this.items});
}

class TaskListEmpty extends TaskListState {}

class TaskListError extends TaskListState {
  final String errorMassage;

  TaskListError({required this.errorMassage});
}
