import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:task_manager/app/shared/exceptions/app_exception.dart';
import 'package:task_manager/app/shared/models/get_all_tasks_response.dart';
import 'package:task_manager/app/shared/models/task.dart';
import 'package:task_manager/app/shared/repos/task_repo.dart';
import 'package:task_manager/app/shared/utils/extensions.dart';
import 'package:collection/collection.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';

class TasksBloc extends Bloc<TaskEvent, TasksState> {
  final TaskRepo _taskRepository;
  final PagingController<int, Task> pagingController =
      PagingController(firstPageKey: 0);

  TasksBloc(this._taskRepository) : super(TasksState.init()) {
    on<TasksRequested>(_onTaskRequested);

    on<TaskAdded>(_onAddTask);
    on<TaskDeleted>(_onDeleteTask);
    on<TaskUpdated>(_onUpdateTask);

    pagingController.addPageRequestListener((pageKey) {
      add(TasksRequested(
          skip: pageKey,
          total: state.totalTasks,
          limit: pageKey + tasksLimit > state.totalTasks
              ? state.totalTasks - pageKey
              : tasksLimit));
    });
  }

  Future<void> _onTaskRequested(
      TasksRequested event, Emitter<TasksState> emit) async {
    try {
      final GetAllTasksResponse getAllTasksResponse =
          await _taskRepository.getAllTodos(
        skip: event.skip,
        limit: event.limit,
      );

      final nextPageKey = (event.total == state.pagingState.itemList?.length)
          ? null
          : event.skip + event.limit;

      final List<Task> itemList = [
        ...state.pagingState.itemList ?? [],
        ...getAllTasksResponse.tasks
      ];

      emit(
        state.copyWith(
          totalTasks: getAllTasksResponse.total,
          pagingState: PagingState(
            nextPageKey: nextPageKey,
            itemList: itemList,
          ),
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          pagingState: state.pagingState.copyWithError(
            error: e.message,
          ),
        ),
      );
    }
  }

  Future<void> _onAddTask(TaskAdded event, Emitter<TasksState> emit) async {
    final state = this.state;
    try {
      Task task = await _taskRepository.addTodo(
          userId: event.task.userId, todoTitle: event.task.todo);
      final List<Task> taskList = [
        task,
        ...state.pagingState.itemList ?? [],
      ];

      emit(
        state.copyWith(
          pagingState: PagingState(
            itemList: taskList,
            nextPageKey: state.pagingState.nextPageKey,
          ),
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(error: e.message),
      );
    }
  }

  Future<void> _onDeleteTask(
      TaskDeleted event, Emitter<TasksState> emit) async {
    final state = this.state;

    try {
      bool result = await _taskRepository.deleteTodo(taskId: event.task.id);
      if (result) {
        final tasks = state.pagingState.itemList ?? [];
        tasks.removeWhere((task) {
          return task.id == event.task.id;
        });

        emit(
          state.copyWith(
            pagingState: PagingState(
              itemList: [...tasks],
              nextPageKey: state.pagingState.nextPageKey,
            ),
          ),
        );
      }
    } on AppException catch (e) {
      emit(
        state.copyWith(error: e.message),
      );
    }
  }

  Future<void> _onUpdateTask(
      TaskUpdated event, Emitter<TasksState> emit) async {
    final state = this.state;

    try {
      final newTask = await _taskRepository.updateTodo(updatedTask: event.task);
      final tasks = state.pagingState.itemList ?? [];
      final index = (tasks.indexOf(event.task));
      tasks[index] = newTask;

      emit(
        state.copyWith(
          pagingState: PagingState(
            itemList: [...tasks],
            nextPageKey: state.pagingState.nextPageKey,
          ),
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(error: e.message),
      );
    }
  }
}
