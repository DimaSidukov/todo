import 'package:todo/data/TodoItem.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BoxManager {

  Box? _todosBox;

  static Future<Box?> openBox() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoItemAdapter());
    return await Hive.openBox('todos');
  }

  void addTodo(TodoItem item) async {
    await _todosBox?.put(item.task, item);
  }

  void removeTodo(TodoItem item) async {
    await _todosBox?.delete(item.task);
  }

  List<TodoItem> getTodos() {
    if (_todosBox == null || _todosBox?.length == 0) return List.empty();
    var a = _todosBox?.values.map((e) => e as TodoItem).toList();
    if (a == null || a.isEmpty) return List.empty();
    return a;
  }

}