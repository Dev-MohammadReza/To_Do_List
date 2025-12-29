import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:untitled33/data/Hive_Task_source.dart';

import 'package:untitled33/data/repo/repository.dart';

import 'package:untitled33/data/dart.dart';
import 'package:untitled33/screens/home/home.dart';

const taskBoxName = '';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<Task>(taskBoxName);
  runApp(ChangeNotifierProvider<Repository<Task>>(
      create: (context) => Repository<Task>(
          localDatasource: HiveTaskDataSource(box: Hive.box(taskBoxName))),
      child: const MyApp()));
}

const primaryColor = Colors.purple;
const surface = Colors.white;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            inputDecorationTheme: const InputDecorationTheme(
                border: InputBorder.none,
                floatingLabelBehavior: FloatingLabelBehavior.never),
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              primaryFixed: Color(0xffa351d3),
              background: Color(0xffF3F5F7),
            )),
        home: HomeScreen());
  }
}
