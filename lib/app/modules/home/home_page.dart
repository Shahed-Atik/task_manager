import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:task_manager/app/modules/home/profile_bloc/profile_event.dart';
import 'package:task_manager/app/modules/home/tasks_bloc/tasks_event.dart';
import 'package:task_manager/app/modules/home/widget/profile_dialog.dart';
import 'package:task_manager/app/shared/models/task.dart';
import 'package:task_manager/main.dart';

import 'add_edit_task/add_edit_task_page.dart';
import 'profile_bloc/profile_bloc.dart';
import 'profile_bloc/profile_state.dart';
import 'tasks_bloc/tasks_bloc.dart';
import 'tasks_bloc/tasks_state.dart';
import 'widget/task_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TasksBloc>(
          create: (context) => TasksBloc(getIt.get()),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) {
            final ProfileBloc profileBloc = ProfileBloc(getIt.get());
            profileBloc.add(ProfileRequested());
            return profileBloc;
          },
        )
      ],
      child: Builder(
        builder: (context) {
          final tasksBloc = context.read<TasksBloc>();
          return MultiBlocListener(
            listeners: [
              BlocListener<TasksBloc, TasksState>(
                listenWhen: (previous, current) {
                  return current.pagingState != previous.pagingState;
                },
                listener: (context, state) {
                  tasksBloc.pagingController.value = state.pagingState;
                },
              ),
              BlocListener<TasksBloc, TasksState>(
                listenWhen: (previous, current) {
                  return current.error != previous.error &&
                      current.error != null;
                },
                listener: (context, state) {
                  _showSnackBar(context, state.error.toString());
                },
              ),
              BlocListener<ProfileBloc, ProfileState>(
                listenWhen: (previous, current) {
                  return current.error != previous.error &&
                      current.error != null;
                },
                listener: (context, state) {
                  _showSnackBar(context, state.error.toString());
                },
              ),
            ],
            child: Scaffold(
              appBar: AppBar(
                title: const Text("My Tasks"),
                actions: [
                  BlocBuilder<ProfileBloc, ProfileState>(
                      buildWhen: (previous, current) =>
                          previous.profile != current.profile,
                      builder: (context, state) {
                        if (state.profile != null) {
                          return InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                    child:
                                        ProfileDialog(profile: state.profile!)),
                              );
                            },
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                              child: Image.network(
                                state.profile!.image,
                                fit: BoxFit.cover,
                                height: 50,
                                width: 50,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      }),
                  const SizedBox(
                    width: 15,
                  )
                ],
              ),
              floatingActionButton: Builder(builder: (context) {
                return FloatingActionButton(
                    onPressed: () {
                      openAddEditSheet(context);
                    },
                    tooltip: "ADD task",
                    child: const Icon(Icons.add));
              }),
              body: PagedListView<int, Task>(
                pagingController: tasksBloc.pagingController,
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                builderDelegate: PagedChildBuilderDelegate<Task>(
                  itemBuilder: (context, task, index) => InkWell(
                    onTap: (() {
                      openAddEditSheet(context, task: task);
                    }),
                    child: TaskWidget(task: task),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void openAddEditSheet(BuildContext context, {Task? task}) {
    final tasksBloc = context.read<TasksBloc>();

    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: tasksBloc,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: AddEditTodoPage(
              task: task,
            ),
          ),
        );
      },
      elevation: 20,
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
