// lib/task_manager.dart
library task_manager;

/// Clase que representa una tarea individual.
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

  void toggleCompleted() => completed = !completed;

  @override
  String toString() =>
      '[$id] $title - ${completed ? "✅ Completada" : "❌ Pendiente"}';
}

/// Componente reutilizable para la gestión de tareas.
class TaskManager {
  final List<Task> _tasks = [];
  int _nextId = 1;

  /// Agrega una nueva tarea al sistema.
  Task addTask(String title, String description) {
    final task = Task(id: _nextId++, title: title, description: description);
    _tasks.add(task);
    return task;
  }

  /// Elimina una tarea por su ID.
  bool deleteTask(int id) {
    final initialLength = _tasks.length;
    _tasks.removeWhere((task) => task.id == id);
    return _tasks.length < initialLength; // Devuelve true si se eliminó algo
  }

  /// Cambia el estado de una tarea (completada / pendiente).
  bool toggleTaskStatus(int id) {
    final task = _tasks.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception('Tarea no encontrada'),
    );
    task.toggleCompleted();
    return task.completed;
  }

  /// Actualiza el título o descripción de una tarea.
  bool updateTask(int id, {String? title, String? description}) {
    final task = _tasks.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception('Tarea no encontrada'),
    );
    if (title != null) task.title = title;
    if (description != null) task.description = description;
    return true;
  }

  /// Devuelve todas las tareas (solo lectura).
  List<Task> getAllTasks() => List.unmodifiable(_tasks);

  /// Devuelve solo las tareas completadas.
  List<Task> getCompletedTasks() =>
      _tasks.where((t) => t.completed).toList(growable: false);

  /// Devuelve solo las tareas pendientes.
  List<Task> getPendingTasks() =>
      _tasks.where((t) => !t.completed).toList(growable: false);

  /// Limpia todas las tareas (reinicia el sistema).
  void clearAll() {
    _tasks.clear();
    _nextId = 1;
  }
}
