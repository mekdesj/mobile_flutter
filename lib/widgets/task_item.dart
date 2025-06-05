import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function(String) onToggleComplete;
  final Function(String) onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().add_jm().format(task.createdAt);

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(Icons.delete, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Delete',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onDelete(task.id),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Checkbox(
            shape: const CircleBorder(),
            activeColor: Colors.indigo,
            value: task.isCompleted,
            onChanged: (_) => onToggleComplete(task.id),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted ? Colors.grey : Colors.black87,
            ),
          ),
          subtitle: Text(
            'Created: $formattedDate',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          trailing: Icon(
            task.isCompleted
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            color: task.isCompleted ? Colors.green : Colors.grey,
          ),
        ),
      ),
    );
  }
}
