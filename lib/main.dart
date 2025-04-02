import 'package:flutter/material.dart';
import 'package:shopping_list/widgets/grocery_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Shopping List",
      home : Scaffold(
        appBar: AppBar(
          title: const Text("Botnoi Beauty"),
          backgroundColor: Colors.blueAccent,
          titleTextStyle : const TextStyle(color : Colors.white , fontSize: 28 , fontWeight: FontWeight.bold),
          centerTitle: true,
        ),
        body: const GroceryList()
     
      )
    );
}
}