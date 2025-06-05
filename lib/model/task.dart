class Task {
  final String id;
  final String title;
  bool isCompleted;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
  });

  // Creates a copy of the task with updated fields
  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Converts Task to Map for potential storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Creates Task from Map (for loading data)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      isCompleted: map['isCompleted'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.isCompleted == isCompleted &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        isCompleted.hashCode ^
        createdAt.hashCode;
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, isCompleted: $isCompleted, createdAt: $createdAt)';
  }
}

enum TaskFilter { all, completed, pending }
