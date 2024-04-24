import 'package:flutter/material.dart';
import 'data.dart';
import 'ToDoList.dart';

class addToDo extends StatelessWidget {
  final VoidCallback onPressed;
  final String category;

  addToDo({required this.category, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                  ),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Add a To-do item',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFEF9980)),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 60.0),
                        child: ElevatedButton(
                          onPressed: () {
                            String todo = _controller.text.trim();
                            if (todo.isNotEmpty) {
                              ToDoData().toDoList.add({'category': category, 'todo': todo});
                              ToDoData().updateDataBase();
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => ToDoList(category),
                                ),
                              );
                            }
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 105, 185, 112)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Icon(Icons.add, color: Colors.white),
      backgroundColor: Color.fromARGB(255, 233, 106, 146),
    );
  }
}
