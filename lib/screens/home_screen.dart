import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [
    Task(
      id: '1',
      title: 'Buy Groceries',
      description: 'Milk, eggs, bread',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Sorting: Starred tasks at the top
    tasks.sort((a, b) {
      if (a.isStarred && !b.isStarred) return -1;
      if (!a.isStarred && b.isStarred) return 1;
      return 0;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: tasks.isEmpty
          ? const Center(
        child: Text("No tasks yet! Tap + to add one."),
      )
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return Dismissible(
            key: Key(task.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              setState(() {
                tasks.removeAt(index);
              });
            },
            child: ListTile(
              onLongPress: () async {
                final updatedTask = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskScreen(existingTask: task),
                  ),
                );
                if (updatedTask != null) {
                  setState(() {
                    tasks[index] = updatedTask;
                  });
                }
              },
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (value) {
                  setState(() {
                    // CORRECT WAY: Create a copy with the new value
                    tasks[index] = task.copyWith(isCompleted: value!);
                  });
                },
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  color: task.isCompleted ? Colors.grey : Colors.black,
                ),
              ),
              subtitle: task.description.isNotEmpty ? Text(task.description) : null,
              trailing: IconButton(
                icon: Icon(
                  task.isStarred ? Icons.star : Icons.star_border,
                  color: task.isStarred ? Colors.amber : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    // CORRECT WAY: Create a copy with the toggled star
                    tasks[index] = task.copyWith(isStarred: !task.isStarred);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
          if (newTask != null) {
            setState(() {
              tasks.add(newTask);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}