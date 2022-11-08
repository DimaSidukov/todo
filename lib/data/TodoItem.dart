import 'package:hive/hive.dart';
part 'TodoItem.g.dart';

@HiveType(typeId: 0)
class TodoItem extends HiveObject {

  @HiveField(0)
  String task;

  @HiveField(1)
  bool isChecked = false;

  TodoItem(this.task);

}