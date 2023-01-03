import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:assignment3tibudan/models/todolist_model.dart';

import 'models/todolist_db.dart';

class EditTodoList extends StatefulWidget {
  final TodoList todo;
  final String appBarTitle;
  const EditTodoList({Key? key, required this.todo, required this.appBarTitle}) : super(key: key);

  @override
  State<EditTodoList> createState() => _EditTodoListState();
}

class _EditTodoListState extends State<EditTodoList> {
  TodoDatabase connection = TodoDatabase();
  var title = TextEditingController();
  var description = TextEditingController();
  var datestamp = TextEditingController();
  var key = GlobalKey<FormState>();
  late int id;

  @override
  void initState() {
    super.initState();
    id = widget.todo.postId!;
    title.text = widget.todo.title;
    description.text = widget.todo.description;
  }
  void updateTodo(TodoList todo) async {
    await connection.updateTodoList(todo);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text(widget.appBarTitle),
      ),
      body: Form(
        key: key,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: title,
                decoration: const InputDecoration(
                  icon: Icon(Icons.notes),
                  hintText: "ex. Goto Barbershop",
                  labelText: "Title",
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value){
                  return (value == "") ? "Input something!" : null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: TextFormField(
                cursorHeight: 20,
                keyboardType: TextInputType.text,
                controller: description,
                decoration: const InputDecoration(
                  icon: Icon(Icons.description),
                  hintText: "Description here",
                  labelText: "Description",
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value1){
                  return (value1 == "") ? "Input something!" : null;
                },
              ),
            ),
            Container(
              height: 37,
              width: 17,
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                onPressed: () {
                  if (key.currentState!.validate()){
                    setState(() {
                      var date = DateFormat.yMd().format(DateTime.now());
                      var data = TodoList(postId: id, title: title.text, description: description.text, datestamp: date.toString());
                      updateTodo(data);
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Todos'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
