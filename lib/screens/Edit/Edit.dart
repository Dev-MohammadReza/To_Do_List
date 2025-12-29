import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:provider/provider.dart';
import 'package:untitled33/data/dart.dart';
import 'package:untitled33/data/repo/repository.dart';
import 'package:untitled33/main.dart';
import 'package:untitled33/screens/Edit/cubit/edit_task_cubit.dart';

class EditTaskDcreen extends StatefulWidget {
  const EditTaskDcreen({
    super.key,
  });

  @override
  State<EditTaskDcreen> createState() => _EditTaskDcreenState();
}

class _EditTaskDcreenState extends State<EditTaskDcreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(
        text: context.read<EditTaskCubit>().state.task.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.read<EditTaskCubit>().onSaveChangesClick();
            Navigator.of(context).pop();
          },
          label: const Text('Add new Task')),
      appBar: AppBar(
        backgroundColor: surface,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text('Add new Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BlocBuilder<EditTaskCubit, EditTaskState>(
                builder: (context, state) {
              final priority = state.task.priority;
              return Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                      flex: 1,
                      child: CuntinerEdit(
                        onTap: () {
                          context
                              .read<EditTaskCubit>()
                              .onPriorityChanged(Priority.high);
                        },
                        name: 'High',
                        color: Colors.purple,
                        isSelected: priority == Priority.high,
                      )),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                      flex: 1,
                      child: CuntinerEdit(
                        onTap: () {
                          context
                              .read<EditTaskCubit>()
                              .onPriorityChanged(Priority.normal);
                        },
                        name: 'Normal',
                        color: Colors.orange,
                        isSelected: priority == Priority.normal,
                      )),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                      flex: 1,
                      child: CuntinerEdit(
                        onTap: () {
                          context
                              .read<EditTaskCubit>()
                              .onPriorityChanged(Priority.low);
                        },
                        name: 'low',
                        color: const Color.fromARGB(255, 17, 210, 123),
                        isSelected: priority == Priority.low,
                      )),
                ],
              );
            }),
            TextField(
              onChanged: (value) {
                context.read<EditTaskCubit>().onTaskChanged(value);
              },
              controller: _controller,
              decoration:
                  const InputDecoration(label: Text('Add a Task for today...')),
            )
          ],
        ),
      ),
    );
  }
}

class CuntinerEdit extends StatelessWidget {
  final String name;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;

  const CuntinerEdit(
      {super.key,
      required this.name,
      required this.color,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.2), width: 2)),
        child: Stack(
          children: [
            Center(
              child: Text(name),
            ),
            Positioned(
                right: 8,
                bottom: 0,
                top: 0,
                child: Center(
                    child: IconScreenEdit(value: isSelected, color: color)))
          ],
        ),
      ),
    );
  }
}

class IconScreenEdit extends StatelessWidget {
  final bool value;
  final Color color;

  const IconScreenEdit({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: value
          ? const Icon(
              CupertinoIcons.checkmark_alt,
              color: Colors.white,
              size: 15,
            )
          : null,
    );
  }
}
