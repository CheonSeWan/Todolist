import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 필요한 패키지

class ToDo {
  bool isDone = false;
  String title;
  DateTime date; // 날짜 정보

  ToDo(this.title)
      : date = DateTime.now(); // 현재 날짜로 초기화
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ToDoListPage(),
    );
  }
}

class ToDoListPage extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  final _items = <ToDo>[];
  var _todoController = TextEditingController();

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  Widget _buildItemWidget(ToDo todo) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(todo.date); // 날짜 포맷 지정
    return ListTile(
      onTap: () => _toggleTodo(todo),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => _deleteTodo(todo),
      ),
      title: Row(
        children: [
          if (todo.isDone)
            Icon(Icons.favorite, color: Colors.red),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                todo.title,
                style: todo.isDone
                    ? TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                )
                    : null,
              ),
              Text(
                formattedDate, // 날짜 표시
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addTodo() {
    String todoTitle = _todoController.text.trim();
    if (todoTitle.isNotEmpty) {
      setState(() {
        _items.add(ToDo(todoTitle));
        _todoController.clear();
      });
    }
  }

  void _deleteTodo(ToDo todo) {
    setState(() {
      _items.remove(todo);
    });
  }

  void _toggleTodo(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('남은 할 일'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _todoController,
                  ),
                ),
                ElevatedButton(
                  onPressed: _addTodo,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text(
                    '추가하기',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            Expanded(
              child: ListView(
                children: _items.map((todo) => _buildItemWidget(todo)).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}



