library task_manager;

import 'dart:async';

/// Modelo de tarea con fechas
class Task {
  int id;
  String title;
  String description;
  bool completed;
  DateTime createdAt;
  DateTime? deadline;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.completed = false,
    DateTime? createdAt,
    this.deadline,
  }) : createdAt = createdAt ?? DateTime.now();

  void toggle() => completed = !completed;

  Task copyWith({
    String? title,
    String? description,
    bool? completed,
    DateTime? deadline,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt,
      deadline: deadline ?? this.deadline,
    );
  }

  @override
  String toString() {
    final dl = deadline != null
        ? ' - Vence: ${deadline!.toLocal().toString().split(" ").first}'
        : '';
    return '[$id] $title - ${completed ? "✅" : "❌"}$dl';
  }
}

/// Gestor reutilizable de tareas
class TaskManager {
  final List<Task> _tasks = [];
  final StreamController<List<Task>> _taskStreamController =
      StreamController.broadcast();

  int _nextId = 1;

  Stream<List<Task>> get taskStream => _taskStreamController.stream;

  List<Task> get tasks => List.unmodifiable(_tasks);

  void _notify() => _taskStreamController.add(List.unmodifiable(_tasks));

  void addTask(String title, String description, {DateTime? deadline}) {
    _tasks.add(Task(
      id: _nextId++,
      title: title,
      descript
