
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Laptop Price Prediction',
      home: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0D47A1), // Dark Blue
                  Color(0xFF42A5F5), // Light Blue
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              child: Column(
                children: [
                  Center(
                    child: Text('Laptop Price Prediction',style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                  Text('Enter The Specifications',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: Colors.white),),
                  MainPage(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  }