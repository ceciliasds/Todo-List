import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data.dart';
import 'ToDoList.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final CategoryData _categoryData = CategoryData();
  Map<String, bool> editingState = {};
  Map<String, TextEditingController> controllers = {}; 

  @override
  void initState() {
    super.initState();
    _initializeEditingState();
  }

  void _initializeEditingState() {
    List<String>? categories = _categoryData.loadCategories();
    categories?.forEach((category) {
      editingState[category] = false;
      controllers[category] = TextEditingController(text: category); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('categoryBox').listenable(),
      builder: (BuildContext context, Box box, Widget? _) {
        List<String>? categories = _categoryData.loadCategories();
        if (categories!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  child: Image.asset('images/empty.gif'),
                ),
                Text('No category items yet.'),
              ],
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 35.0, right: 35, top: 20),
                  
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    final category = categories[index];
                    controllers.putIfAbsent(category, () => TextEditingController(text: category));

                    return Padding(
                      padding: const EdgeInsets.only(left: 35.0, right: 35, top: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListTile(
                            leading: editingState[category] == true
                                ? IconButton(
                              icon: Icon(Icons.check, color: Colors.blue),
                              onPressed: () {
                                setState(() {
                                  editingState[category] = false;
                                });

                                String newName = controllers[category]!.text;
                                _categoryData.updateCategoryName(category, newName);
                              },
                            )
                                : Icon(Icons.summarize, color: Color.fromARGB(255, 237, 168, 191)),
                            title: editingState[category] == true
                                ? TextFormField(
                              controller: controllers[category], 
                              onChanged: (value) {
                              },
                            )
                                : Text(category),
                            trailing: PopupMenuButton(
                              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'delete') {
                                  _categoryData.removeCategory(category);
                                } else if (value == 'edit') {
                                  setState(() {
                                    editingState[category] = true;
                                  });
                                }
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ToDoList(category)),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}


void _updateToDoListCategory(String oldCategory, String newCategory) {
  ToDoData _toDoData = ToDoData();
  _toDoData.toDoList.forEach((toDoItem) {
    if (toDoItem['category'] == oldCategory) {
      toDoItem['category'] = newCategory;
    }
  });
  _toDoData.updateDataBase();
}
