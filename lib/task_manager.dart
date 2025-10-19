library task_manager;

import 'dart:async';

/// Modelo de tarea
class Task {
  int id;
  String title;
  String description;
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.completed = false,
  });

  void toggle() => completed = !completed;

  Task copyWith({
    String? title,
    String? description,
    bool? completed,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
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

  void addTask(String title, String description) {
    _tasks.add(Task(id: _nextId++, title: title, description: description));
    _notify();
  }

  void updateTask(int id, {String? title, String? description}) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] =
          _tasks[index].copyWith(title: title, description: description);
      _notify();
    }
  }

  void toggleTaskStatus(int id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].toggle();
      _notify();
    }
  }

  void deleteTask(int id) {
    _tasks.removeWhere((t) => t.id == id);
    _notify();
  }

  void clearAll() {
    _tasks.clear();
    _nextId = 1;
    _notify();
  }

  void dispose() {
    _taskStreamController.close();
  }
}
