import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Views/SignInPage.dart';

import 'Models/UserModel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          return MaterialApp(
            title: "ShopList",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Color.fromRGBO(133, 0, 249, 1),
              accentColor: Color.fromRGBO(174, 58, 255, 1),
            ),
            home: SignInPage(),
            // home: AdminHome(),
          );
        },
      ),
    );

    /*return MaterialApp(
      title: 'ShopList',
      theme: ThemeData(),
      home: HomePage(),
    );*/
  }
}
