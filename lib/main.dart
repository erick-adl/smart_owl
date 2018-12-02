import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:smart_owl/src/home-controller.dart';
import 'package:smart_owl/src/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Owl',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(hintColor: Colors.white, primaryColor: Colors.red),
      home: BlocProvider<HomeController>(
        bloc: HomeController(),
        child: Home(),
      ),
    );
  }
}
