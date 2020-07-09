import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoplist/Controllers/auth.dart';
import 'package:shoplist/Views/Wrapper.dart';

import 'Models/UserModel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );

    /*return MaterialApp(
      title: 'ShopList',
      theme: ThemeData(),
      home: HomePage(),
    );*/
  }
}
