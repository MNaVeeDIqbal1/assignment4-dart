import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assignment4/models/task_model.dart';

class AddTaskScreen extends StatefulWidget{
  final Task? existingTask;
  const AddTaskScreen({super.key, this.existingTask});
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen>{
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;

  @override
  void initState(){
    super.initState();
    _titleController = TextEditingController(text: widget.existingTask?.title?? '');
    _descriptionController = TextEditingController(text: widget.existingTask?.description?? '');
  }

  Future<void> _pickDate() async{
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if(picked!= null)
    {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task Title',),
              ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(_selectedDate == null ?
                'No Data Chosen' :
                "Due Date:" '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                const Spacer(),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Choose Date'),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity,50)),
              onPressed: (){
                if(_titleController.text.isNotEmpty){
                  final newTask = Task(
                    id: DateTime.now().toString(),
                    title: _titleController.text,
                      description: _descriptionController.text,
                      dueDate: _selectedDate,
                  );
                  Navigator.pop(context,newTask);
                }
              }, child: const Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}