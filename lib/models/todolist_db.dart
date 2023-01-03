import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'todolist_model.dart';

class TodoDatabase {
  Database? _db;

  Future<Database> get myDatabase async {
    String dbPath = await getDatabasesPath();
    const String dbName = 'TodoList.db';
    String path = join(dbPath, dbName);
    _db = await openDatabase(path, version: 1, onCreate: createTodoDB);
    return _db!;
  }

  void createTodoDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Todos(
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        date TEXT)''');
  }

  Future<void> createTodoList(TodoList todo) async {
    final db = await myDatabase;
    await db.insert('Todos', todo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteTodoList(TodoList todo) async {
    final db = await myDatabase;
    await db.delete('Todos', where: 'id == ?', whereArgs: [todo.postId],);
  }

  Future<List<TodoList>> readTodoList() async {
    final db = await myDatabase;
    List<Map<String, dynamic>> rows = await db.query('Todos', orderBy: 'id DESC',);
    return List.generate(
      rows.length, (i) => TodoList(
        postId: rows[i]['id'],
        title: rows[i]['title'],
        description: rows[i]['description'],
        datestamp: rows[i]['date']
    ),
    ).toList();
  }

  Future<void> updateTodoList(TodoList todo) async {
    final conn = await myDatabase;
    await conn.update('Todos', todo.toMap(), where: 'id == ?', whereArgs: [todo.postId],);
  }
}