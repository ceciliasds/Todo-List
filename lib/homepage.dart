import 'package:flutter/material.dart';
import 'addCategory.dart';
import 'CategoryList.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'To-Do List',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Color.fromARGB(255, 75, 55, 42),
        centerTitle: true,
        leading: Container(),
      ),
      backgroundColor: Color.fromRGBO(243, 230, 202, 1.0),
      body: CategoryList(),
      floatingActionButton: AddCategoryButton(),
    );
  }   
}

