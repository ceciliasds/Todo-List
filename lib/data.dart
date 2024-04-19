import 'package:hive/hive.dart';

class ToDoData {
  ToDoData._privateConstructor();
  static final ToDoData _instance = ToDoData._privateConstructor();

  factory ToDoData() {
    return _instance;
  }

  late List<Map<String, dynamic>> toDoList;
  final _todoBox = Hive.box('todoBox');

  void loadData() {
    final dynamicData = _todoBox.get("TODOLIST");
    if (dynamicData != null) {
      if (dynamicData is Map) {
        toDoList = [dynamicData.cast<String, dynamic>()];
      } else if (dynamicData is List) {
        toDoList = List<Map<String, dynamic>>.from(dynamicData.map((e) => e.cast<String, dynamic>()));
      }
    } else {
      toDoList = [];
    }
  }

  void updateDataBase() {
    _todoBox.put("TODOLIST", toDoList);
  }

  void updateToDoCheckedState(int index, bool isChecked) {
    if (index >= 0 && index < toDoList.length) {
      toDoList[index]['checked'] = isChecked;
      updateDataBase();
    }
  }

  void removeToDoItem(int index) {
    if (index >= 0 && index < toDoList.length) {
      toDoList.removeAt(index);
      updateDataBase();
    }
  }

  void removeToDoItemsByCategory(String category) {
    toDoList.removeWhere((item) => item['category'] == category);
    updateDataBase();
  }

  void updateToDoCategoryName(String oldCategory, String newCategory) {
    for (var item in toDoList) {
      if (item['category'] == oldCategory) {
        item['category'] = newCategory;
      }
    }
    updateDataBase();
  }
}




class CategoryData {
  final _categoryBox = Hive.box('categoryBox');

  List<String>? loadCategories() {
    return _categoryBox.get("CATEGORYLIST")?.cast<String>() ?? [];
  }

  void addCategory(String categoryName) {
    List<String>? categories = loadCategories();
    if (!categories!.contains(categoryName)) {
      categories.add(categoryName);
      _categoryBox.put("CATEGORYLIST", categories);
    }
  }

  void removeCategory(String categoryName) {
    List<String>? categories = loadCategories();
    categories?.remove(categoryName);
    _categoryBox.put("CATEGORYLIST", categories);
  }

  void updateCategoryName(String oldName, String newName) {
    List<String>? categories = loadCategories();
    final index = categories!.indexOf(oldName);
    if (index != -1) {
      categories[index] = newName;
      _categoryBox.put("CATEGORYLIST", categories);
    }
  }

 bool isCategoryExists(String categoryName) {
  List<String>? categories = loadCategories();
  return categories!.any((category) => category.toLowerCase() == categoryName.toLowerCase());
}

}

