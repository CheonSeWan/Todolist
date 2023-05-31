import 'package:flutter/material.dart';

class ToDo {
  bool isDone = false; // 현재 진행여부
  String title; // 할일

  ToDo(this.title);
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
  // 할일 저장할 리스트
  final _items = <ToDo>[];
  // 할일 문자열 다룰 컨트롤러
  var _todoController = TextEditingController();

  @override
  void dispose() {
    _todoController.dispose(); // 컨트롤러는 종료시 반드시 해제해줘야 함
    super.dispose();
  }

  Widget _buildItemWidget(ToDo todo) {
    return ListTile(
      onTap: () => _toggleTodo(todo),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => _deleteTodo(todo),
      ),
      title: Text(
        todo.title,
        style: todo.isDone? // 할일 완료 여부로 스타일 변경
        TextStyle(
          decoration: TextDecoration.lineThrough, // 취소선
          fontStyle: FontStyle.italic, // 이탤릭체
        ) : null, // 할일 중이면 아무 작업 안함
      ),
    );
  }

  // 할 일 추가 메소드
  void _addTodo(ToDo todo) {
    setState(() {
      _items.add(todo);
      _todoController.text = ''; // 할일을 리스트에 추가하며 할일 입력 필드 비우기
    });
  }

  // 할 일 삭제 메소드
  void _deleteTodo(ToDo todo) {
    setState(() {
      _items.remove(todo);
    });
  }

  // 할 일 완료/미완료 메소드
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
                    controller: _todoController, // 입력한 TextField 컨트롤러로 조작
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _addTodo(ToDo(_todoController.text)),
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
