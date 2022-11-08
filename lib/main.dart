import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'data/TodoItem.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoItemAdapter());
  var box = await Hive.openBox('todos');
  runApp(MyApp(box));
}

class MyApp extends StatelessWidget {
  MyApp(this.box);

  Box box;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', box: box),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title, required this.box});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final Box box;

  @override
  State<MyHomePage> createState() => _MyHomePageState(box: box);
}

class _MyHomePageState extends State<MyHomePage> {
  String task = "";
  List<TodoItem> todos = List.empty();
  bool checkBoxState = false;
  Box box;

  _MyHomePageState({required this.box}) {
    todos = box!.values.map((e) => e as TodoItem).toList();
    print(this.box.length.toString());
  }

  void setTaskName(String name) {
    setState(() {
      task = name;
    });
  }

  void updateList() {
    setState(() {
      var tmp = box?.values.map((e) => e as TodoItem).toList();
      if (tmp == null) {
        todos = List.empty();
      } else {
        todos = tmp!;
      }
    });
  }

  void updateCheckboxState() {
    setState(() {
      checkBoxState = !checkBoxState;
    });
    updateList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff0f4f7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: SizedBox(
              child: Container(
                  margin: const EdgeInsets.only(top: 70),
                  width: MediaQuery.of(context).size.width,
                  decoration: ShapeDecoration.fromBoxDecoration(
                      const BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50)))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 50),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Daily task",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff8d95a4)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Add new item'),
                                    content: TextField(
                                      onChanged: (value) {
                                        setTaskName(value);
                                      },
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Approve'),
                                        onPressed: () {
                                          if (task.isNotEmpty) {
                                            var item = TodoItem(task);
                                            box?.put(item.task, item);
                                          }
                                          Navigator.pop(context);
                                          updateList();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(10),
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xff3598eb),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 40.0,
                            ),
                          )
                        ],
                      ),
                      Expanded(
                          child: SizedBox(
                              width: double.infinity,
                              child: ListView.builder(
                                  itemCount: todos.length,
                                  itemBuilder:
                                      (BuildContext context, int position) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Checkbox(
                                            value: todos[position].isChecked,
                                            onChanged: (isCompleted) {
                                              box.delete(todos[position].task);
                                              updateCheckboxState();
                                            }),
                                        Text(todos[position].task)
                                      ],
                                    );
                                  })))
                    ]),
                  )),
            ))
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
