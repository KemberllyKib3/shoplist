import 'package:flutter/material.dart';
import 'package:shoplist/Views/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopList',
      theme: ThemeData(
        
      ),
      home: HomePage(),
    );
  }
}
