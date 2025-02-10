import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controller for new todo input
  final _todoController = TextEditingController();
  
  List todoList = [
    ['Learn Flutter', false, DateTime.now()],
    ['Drink coffee', false, DateTime.now()],
  ];

  // Function to change checkbox state
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      todoList[index][1] = value;
    });
  }

  // Function to add new todo
  void addTodoItem() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple[100],
          content: Container(
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: _todoController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Add a new task",
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel',
                          style: TextStyle(color: Colors.deepPurple)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_todoController.text.isNotEmpty) {
                          setState(() {
                            todoList.add([
                              _todoController.text,
                              false,
                              DateTime.now()
                            ]);
                          });
                          _todoController.clear();
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Add'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to delete todo
  void deleteTodoItem(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      appBar: AppBar(
        title: Text("Todo App"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${todoList.where((item) => item[1] == true).length}/${todoList.length} Tasks Completed',
              style: TextStyle(
                fontSize: 20,
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (BuildContext context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                  ),
                  onDismissed: (direction) => deleteTodoItem(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: todoList[index][1],
                            onChanged: (value) => checkBoxChanged(value, index),
                            activeColor: Colors.deepPurple,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  todoList[index][0],
                                  style: TextStyle(
                                    fontSize: 18,
                                    decoration: todoList[index][1]
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    color: todoList[index][1]
                                        ? Colors.grey
                                        : Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Added ${timeAgo(todoList[index][2])}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodoItem,
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
      ),
    );
  }

  // Helper function to format time
  String timeAgo(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }
}
