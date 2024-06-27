
import 'package:dio/dio.dart';
import 'package:task_manager/app/shared/exceptions/app_exception.dart';
import 'package:task_manager/app/shared/exceptions/app_exception_handler.dart';
import 'package:task_manager/app/shared/models/get_all_tasks_response.dart';
import 'package:task_manager/app/shared/models/task.dart';
import 'package:task_manager/app/shared/services/local_storage_service.dart';
import 'package:task_manager/app/shared/utils/connection_util.dart';

class TaskRepo {
  final Dio _dio;
  final LocalStorageService _localStorageService;

  TaskRepo(this._dio, this._localStorageService);

  Future<GetAllTasksResponse> getAllTodos(
      {int limit = 0, required int skip}) async {
    try {
      if (await checkConnectivity()) {
        Response response = await _dio.get('/todos', queryParameters: {
          "skip": skip,
          "limit": limit,
        });

        final getAllTasksResponse = GetAllTasksResponse.fromMap(response.data);
        if (skip == 0) _localStorageService.deleteTasks();
        _localStorageService.setTasks(getAllTasksResponse.tasks);

        return getAllTasksResponse;
      } else {
        List<Task>? tasks = _localStorageService.getTasks();
        if (tasks != null) {
          return GetAllTasksResponse(
              limit: 0, skip: 0, tasks: tasks, total: tasks.length);
        }
      }
      throw AppException(message: "There were an error in connection");
    } catch (e) {
      if (AppExceptionHandler.isInternetIssue(e)) {
        List<Task>? tasks = _localStorageService.getTasks();
        if (tasks != null) {
          return GetAllTasksResponse(
              limit: 0, skip: 0, tasks: tasks, total: tasks.length);
        }
      }
      throw AppExceptionHandler.handleError(e);
    }
  }

  Future<Task> getTodoById({required int id}) async {
    try {
      Response response = await _dio.get('/todos/$id');
      return Task.fromMap(response.data);
    } catch (e) {
      throw AppExceptionHandler.handleError(e);
    }
  }

  Future<GetAllTasksResponse> getTodoByUserId({required int userId}) async {
    try {
      Response response = await _dio.get('/todos/user/$userId');
      return GetAllTasksResponse.fromMap(response.data);
    } catch (e) {
      throw AppExceptionHandler.handleError(e);
    }
  }

  Future<Task> addTodo({required int userId, required String todoTitle}) async {
    try {
      Response response = await _dio.post('/todos/add', data: {
        "todo": todoTitle,
        "completed": false,
        "userId": userId,
      });
      return Task.fromMap(response.data);
    } catch (e) {
      throw AppExceptionHandler.handleError(e);
    }
  }

  Future<Task> updateTodo({required Task updatedTask}) async {
    try {
      Response response = await _dio.put('/todos/${updatedTask.id}', data: {
        'todo': updatedTask.todo,
        'completed': updatedTask.completed,
      });
      return Task.fromMap(response.data);
    } catch (e) {
      throw AppExceptionHandler.handleError(e);
    }
  }

  Future<bool> deleteTodo({required int taskId}) async {
    try {
      Response response = await _dio.delete('/todos/$taskId');
      return response.data["isDeleted"];
    } catch (e) {
      throw AppExceptionHandler.handleError(e);
    }
  }
}
