import 'package:flutter/material.dart';
import 'data.dart';
import 'addToDo.dart';

class ToDoList extends StatefulWidget {
  final String category;

  ToDoList(this.category);

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  late ToDoData _toDoData;

  @override
  void initState() {
    super.initState();
    _toDoData = ToDoData();
    _toDoData.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Color.fromARGB(255, 75, 55, 42),
      ),
      backgroundColor: Color.fromRGBO(243, 230, 202, 1.0),
      body: _toDoData.toDoList
              .where((item) => item['category'] == widget.category)
              .isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    child: ClipOval(
                      child: Image.asset(
                        'images/check.gif',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No tasks pending.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SizedBox(
                    height: _calculateBoxHeight(),
                    child: Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('To-do List for ${widget.category}'),
                          ),
                          SizedBox(height: 8),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _toDoData.toDoList.length,
                              itemBuilder: (BuildContext context, int index) {
                                final toDoItem = _toDoData.toDoList[index];
                                if (toDoItem['category'] == widget.category) {
                                  final todo = toDoItem['todo'] as String;
                                  final isChecked = toDoItem['checked'] ?? false;
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ListTile(
                                      leading: CircularCheckBox(
                                        value: isChecked,
                                        onChanged: (value) {
                                          setState(() {
                                            _toDoData.updateToDoCheckedState(index, value!);
                                          });
                                        },
                                      ),
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              todo,
                                              style: TextStyle(
                                                decoration: isChecked ? TextDecoration.lineThrough : TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete, color: Colors.red),
                                            onPressed: () {
                                              setState(() {
                                                _toDoData.removeToDoItem(index);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: addToDo(
        category: widget.category,
        onPressed: () {},
      ),
    );
  }

 double _calculateBoxHeight() {
  final itemCount = _toDoData.toDoList.where((item) => item['category'] == widget.category).length;
  final averageTileHeight = 10.0;
  final extraSpace = 2.0;

  print('Item count: $itemCount');

  if (itemCount == 0) {
    return extraSpace;
  }

  final calculatedHeight = itemCount * averageTileHeight + extraSpace;
  print('Calculated height: $calculatedHeight');
  return calculatedHeight;
}

}

class CircularCheckBox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;

  const CircularCheckBox({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: value ? Colors.green : Colors.grey),
          color: value ? Colors.green : Colors.transparent,
        ),
        child: value
            ? Icon(Icons.check, size: 20, color: Colors.white)
            : null,
      ),
    );
  }
}
