import 'package:assignment4/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget{
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'TaskManager',
      theme : ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      //routes: {
      //  '/add_task': (context) => AddTaskScreen(),
      //},
    );
  }
}