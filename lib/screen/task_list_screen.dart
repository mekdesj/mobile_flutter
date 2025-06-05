import 'package:flutter/material.dart';
import '../model/task.dart';
import '../widgets/task_item.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [];
  TaskFilter _currentFilter = TaskFilter.all;

  void _addTask(String title) {
    if (title.trim().isEmpty) return;

    setState(() {
      _tasks.add(
        Task(
          id: DateTime.now().toString(),
          title: title,
          createdAt: DateTime.now(),
        ),
      );
    });
  }

  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
  }

  void _toggleTaskCompletion(String id) {
    setState(() {
      final index = _tasks.indexWhere((task) => task.id == id);
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted,
      );
    });
  }

  List<Task> _getFilteredTasks() {
    switch (_currentFilter) {
      case TaskFilter.completed:
        return _tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.pending:
        return _tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.all:
      default:
        return _tasks;
    }
  }

  void _showAddTaskDialog() {
    final textController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Add New Task',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                hintText: 'e.g., Finish the report',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a task title';
                }
                return null;
              },
              autofocus: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _addTask(textController.text);
                  Navigator.of(ctx).pop();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _getFilteredTasks();

    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Task Manager'),
        elevation: 4,
        backgroundColor: Colors.indigoAccent,
        actions: [
          PopupMenuButton<TaskFilter>(
            onSelected: (filter) {
              setState(() {
                _currentFilter = filter;
              });
            },
            icon: const Icon(Icons.filter_alt_outlined),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: TaskFilter.all,
                child: Text('All Tasks'),
              ),
              const PopupMenuItem(
                value: TaskFilter.completed,
                child: Text('Completed'),
              ),
              const PopupMenuItem(
                value: TaskFilter.pending,
                child: Text('Pending'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: filteredTasks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.inbox, size: 60, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No tasks found. Add some tasks!',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (ctx, index) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 2,
                  child: TaskItem(
                    task: filteredTasks[index],
                    onToggleComplete: _toggleTaskCompletion,
                    onDelete: _deleteTask,
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
        backgroundColor: Colors.indigoAccent,
      ),
    );
  }
}
