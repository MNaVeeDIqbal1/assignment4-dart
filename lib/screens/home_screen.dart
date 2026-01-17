import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';
import '../services/firestore_service.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cloud Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: StreamBuilder<List<Task>>(
        stream: _firestoreService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final tasks = snapshot.data ?? [];
          if (tasks.isEmpty) return const Center(child: Text("No tasks yet!"));

          tasks.sort((a, b) => (b.isStarred ? 1 : 0).compareTo(a.isStarred ? 1 : 0));

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              // --- DELETE FUNCTIONALITY WRAPPER STARTS HERE ---
              return Dismissible(
                key: Key(task.id),
                direction: DismissDirection.endToStart, // Swipe left to delete
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  _firestoreService.deleteTask(task.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${task.title} deleted")),
                  );
                },
                child: ListTile(
                  onTap: () async {
                    final updated = await Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AddTaskScreen(existingTask: task),
                    ));
                    if (updated != null) _firestoreService.saveTask(updated);
                  },
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (val) => _firestoreService.saveTask(task.copyWith(isCompleted: val)),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: task.dueDate != null
                      ? Text("Due: ${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}")
                      : null,
                  trailing: IconButton(
                    icon: Icon(task.isStarred ? Icons.star : Icons.star_border, color: Colors.amber),
                    onPressed: () => _firestoreService.saveTask(task.copyWith(isStarred: !task.isStarred)),
                  ),
                ),
              );
              // --- DELETE FUNCTIONALITY WRAPPER ENDS HERE ---
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
          if (newTask != null && newTask is Task) {
            _firestoreService.saveTask(newTask);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}