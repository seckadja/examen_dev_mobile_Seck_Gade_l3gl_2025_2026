
enum TaskStatus {
  todo,
  inProgress,
  done,
}


enum TaskPriority {
  low,
  medium,
  high,
}


class Task {
  final String id;
  final String title;
  final String? description;
  final String projectId;
  final String createdBy;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueDate;
  final DateTime createdAt;


  Task({
    required this.id,
    required this.title,
    this.description,
    required this.projectId,
    required this.createdBy,
    this.status = TaskStatus.todo,
    this.priority = TaskPriority.medium,
    this.dueDate,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();


  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? projectId,
    String? createdBy,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueDate,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      projectId: projectId ?? this.projectId,
      createdBy: createdBy ?? this.createdBy,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdBy': createdBy,
      'projectId': projectId,
      'status': status.index,
      'priority': priority.index,
    };
  }


  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      projectId: map['projectId'],
      status: TaskStatus.values[map['status']],
      priority: TaskPriority.values[map['priority']],
      createdBy: map['createdBy'],
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, status: $status, priority: $priority)';
  }
}