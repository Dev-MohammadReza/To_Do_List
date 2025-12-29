part of 'task_list_bloc.dart';

@immutable
sealed class TaskListEvent {}

class TaskListStart extends TaskListEvent {}

class TaskListSearch extends TaskListEvent {
  final String searchTerm;

  TaskListSearch({required this.searchTerm});
}

class TaskListDeleteAll extends TaskListEvent {}
