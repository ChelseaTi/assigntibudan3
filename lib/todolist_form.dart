import 'package:flutter/material.dart';
import 'models/todolist_db.dart';
import 'package:intl/intl.dart';

import 'models/todolist_model.dart';

class TodoForm extends StatefulWidget {
  final String appBarTitle;
  const TodoForm({Key? key, required this.appBarTitle}) : super(key: key);

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  TodoDatabase connection = TodoDatabase();
  var title = TextEditingController();
  var description = TextEditingController();
  var datestamp = TextEditingController();
  var key = GlobalKey<FormState>();

  void createTodo(TodoList todo) async {
    await connection.createTodoList(todo);
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
                onPressed: () async{
                  if (key.currentState!.validate()){
                    setState(() {
                      var date = DateFormat.yMd().format(DateTime.now());
                      var data = TodoList(title: title.text, description: description.text, datestamp: date.toString());
                      createTodo(data);
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
