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
          title: const Text("Khong Charm"),
          backgroundColor: const Color.fromARGB(255, 207, 226, 32),
          titleTextStyle : const TextStyle(color : Color.fromARGB(255, 32, 31, 31) , fontSize: 28 , fontWeight: FontWeight.bold),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft:Radius.circular(15) , bottomRight: Radius.circular(15)),// มุมโค้งของการ์ด
            ),
        ),
        body: const GroceryList()
      )
    );
}
}