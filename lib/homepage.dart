import 'package:flutter/material.dart';
import 'package:assignment3tibudan/models/todolist_db.dart';
import 'package:assignment3tibudan/todolist_edit.dart';
import 'package:assignment3tibudan/todolist_form.dart';

import 'models/todolist_model.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TodoDatabase connection = TodoDatabase();
  List<TodoList> todos = [];

  Future<List> refresher () async{
    var response =  await connection.readTodoList();
    setState(() {
      todos = response;
    });
    return todos;
  }
  void deleteData(TodoList todo) async{
    await connection.deleteTodoList(todo);
  }

  @override
  void initState() {
    super.initState();
    refresher();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.edit_note),
        backgroundColor: Colors.blue.shade700,
        title: Text(widget.title),
      ),
      body: todos.isEmpty
          ? const Center(child: Text('No Data!', style: TextStyle(color: Colors.deepOrangeAccent)))
          : ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, int curRow){
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            background: const Card(
              color: Colors.deepOrange,
              child: Icon(Icons.delete),
            ),
            onDismissed: (direction) => deleteData(todos[curRow]),
            child: Card(
              color: Colors.blue.shade50,
              margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
              elevation: 10,
              child: ListTile(
                title: Text(todos[curRow].title),
                subtitle: Text(todos[curRow].datestamp.toString()),
                onTap: () async{
                  await Navigator.push(
                      context, MaterialPageRoute(builder: (context) => EditTodoList(todo: todos[curRow], appBarTitle: "Edit My Todo"))
                  );
                  refresher();
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.push(
              context, MaterialPageRoute(builder: (context) => const TodoForm(appBarTitle: "Create New Todo"))
          );
          refresher();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
