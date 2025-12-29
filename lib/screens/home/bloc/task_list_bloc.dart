import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:untitled33/data/dart.dart';
import 'package:untitled33/data/repo/repository.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final Repository<Task> repository;
  TaskListBloc(this.repository) : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) async {
      if (event is TaskListStart || event is TaskListSearch) {
        final String searchTerm;
        emit(TaskListloding());

        if (event is TaskListSearch) {
          searchTerm = event.searchTerm;
        } else {
          searchTerm = '';
        }

        try {
          final items = await repository.getAll();
          if (items.isNotEmpty) {
            emit(TaskListSuccess(items: items));
          } else {
            emit(TaskListEmpty());
          }
        } catch (e) {
          emit(TaskListError(errorMassage: 'خطای نامشخص'));
        }
      } else if (event is TaskListDeleteAll) {
        await repository.deleteAll();
        emit(TaskListEmpty());
      }
    });
  }
}
