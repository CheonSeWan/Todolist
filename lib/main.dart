import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class ToDo {
  bool isDone = false;
  String title;
  DateTime date;

  ToDo(this.title, this.date) {
    if (date == null) {
      date = DateTime.now();
    }
  }
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
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  Widget _buildItemWidget(ToDo todo) {
    return ListTile(
      onTap: () => _toggleTodoItem(todo),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => _deleteTodoItem(todo),
      ),
      title: Row(
        children: [
          if (todo.isDone) Icon(Icons.favorite, color: Colors.red),
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
                DateFormat('yyyy-MM-dd').format(todo.date),
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
        _items.add(ToDo(todoTitle, _selectedDate));
        _todoController.clear();
      });
    }
  }

  void _deleteTodoItem(ToDo todo) {
    setState(() {
      _items.remove(todo);
    });
  }

  void _toggleTodoItem(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
    });
  }

  List<ToDo> _getFilteredToDos(DateTime date) {
    return _items.where((todo) =>
    todo.date.year == date.year &&
        todo.date.month == date.month &&
        todo.date.day == date.day).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('남은 할 일'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              focusedDay: _selectedDate,
              firstDay: DateTime(DateTime.now().year - 1),
              lastDay: DateTime(DateTime.now().year + 1),
              selectedDayPredicate: (day) {
                return _items.any((todo) =>
                todo.date.year == day.year &&
                    todo.date.month == day.month &&
                    todo.date.day == day.day);
              },
              onDaySelected: _onDaySelected,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      hintText: '할 일 추가',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTodo,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text(
                    '추가하기',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: _getFilteredToDos(_selectedDate)
                    .map((todo) => _buildItemWidget(todo))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}















