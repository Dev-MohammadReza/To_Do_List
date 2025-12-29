import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:untitled33/data/dart.dart';
import 'package:untitled33/data/repo/repository.dart';
import 'package:untitled33/main.dart';
import 'package:untitled33/screens/Edit/Edit.dart';
import 'package:untitled33/screens/Edit/cubit/edit_task_cubit.dart';
import 'package:untitled33/screens/home/bloc/task_list_bloc.dart';
import 'package:untitled33/widget.dart';

class HomeScreen extends StatelessWidget {
  final Box<Task> box = Hive.box<Task>(taskBoxName);

  HomeScreen({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: themeData.colorScheme.background,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BlocProvider<EditTaskCubit>(
                    create: (context) =>
                        EditTaskCubit(Task(), context.read<Repository<Task>>()),
                    child: const EditTaskDcreen())));
          },
          label: const Text(
            'Add Task',
            style: TextStyle(fontSize: 20),
          )),
      body: BlocProvider<TaskListBloc>(
        create: (context) => TaskListBloc(context.read<Repository<Task>>()),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  themeData.colorScheme.primaryFixed,
                  primaryColor
                ])),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'To Do List',
                              style: TextStyle(
                                  color: surface,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 0),
                          child: TextField(
                            controller: _controller,
                            onChanged: (value) {
                              (context as Element).markNeedsBuild();
                            },
                            decoration: const InputDecoration(
                              hintText: 'Search Task',
                              prefixIcon: Icon(
                                CupertinoIcons.search,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(child:
                  Consumer<Repository<Task>>(builder: (context, model, child) {
                context.read<TaskListBloc>().add(TaskListStart());
                return BlocBuilder<TaskListBloc, TaskListState>(
                    builder: (context, state) {
                  if (state is TaskListSuccess) {
                    final query = _controller.text.toLowerCase();
                    final filteredItems = query.isEmpty
                        ? state.items
                        : state.items
                            .where((task) =>
                                task.name.toLowerCase().contains(query))
                            .toList();

                    return TaskList(items: filteredItems);
                  } else if (state is TaskListEmpty) {
                    return const EmptyState();
                  } else if (state is TaskListloding ||
                      state is TaskListInitial) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TaskListError) {
                    Center(
                      child: Text(state.errorMassage),
                    );
                  } else {}
                  (throw Exception('text'));
                });
              })),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.items,
  });

  final List<Task> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.only(right: 16, top: 16, left: 16, bottom: 100),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Today',
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      width: 65,
                      height: 3,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(1.5)),
                    )
                  ],
                ),
                MaterialButton(
                  onPressed: () {
                    context.read<TaskListBloc>().add(TaskListDeleteAll());
                  },
                  child: const Row(
                    children: [
                      Text(
                        'Delete All',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                      Icon(
                        CupertinoIcons.delete,
                        color: Colors.grey,
                      )
                    ],
                  ),
                )
              ],
            );
          } else {
            final Task task = items[index - 1];
            return ItemList(task: task);
          }
        });
  }
}

class ItemList extends StatefulWidget {
  const ItemList({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<Repository<Task>>(context, listen: false);
    final Color primaryColor;
    switch (widget.task.priority) {
      case Priority.low:
        primaryColor = Colors.blue;
      case Priority.normal:
        primaryColor = Colors.orange;
      case Priority.high:
        primaryColor = Colors.purple;
    }
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider<EditTaskCubit>(
                create: (context) => EditTaskCubit(
                    widget.task, context.read<Repository<Task>>()),
                child: EditTaskDcreen())));
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.only(left: 16),
        height: 65,
        decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20)
            ]),
        child: Row(
          children: [
            IconScreen(
              value: widget.task.isCompleted,
              onTap: () {
                setState(() {
                  widget.task.isCompleted = !widget.task.isCompleted;
                });
              },
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              overflow: TextOverflow.ellipsis,
              widget.task.name,
              style: TextStyle(
                  decoration: widget.task.isCompleted
                      ? TextDecoration.lineThrough
                      : null),
            )),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: InkWell(
                onTap: (){
                  repository.delete(widget.task);
                },
                  child: const Icon(Icons.delete_outline)),
            ),
            Container(
              width: 8,
              height: 65,
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
            )
          ],
        ),
      ),
    );
  }
}
