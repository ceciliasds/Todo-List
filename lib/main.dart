import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'homepage.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('todoBox');
  await Hive.openBox('categoryBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-do List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 251, 251, 251),
      appBar: AppBar(
        title: Text(
          'To-do List App',
          style: TextStyle(
            color: Color.fromARGB(255, 75, 55, 42),
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Builder(
          builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'images/logo.jpg',
                  width: 300,
                  height: 300,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  'Stay on top of your tasks and conquer your day with our intuitive To-do list app!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 75, 55, 42)),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
