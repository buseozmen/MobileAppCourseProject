import 'package:flutter/material.dart';
import 'screens/MealCategoryScreen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yemek Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MealCategoryScreen(), // Ana Ekran Başlangıç ekranı
    );
  }
}
