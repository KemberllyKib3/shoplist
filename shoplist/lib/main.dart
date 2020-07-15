import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Models/ItemModel.dart';
import 'package:shoplist/Models/UserModel.dart';
import 'package:shoplist/Views/SignInPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model1) {
          return ScopedModel<ItemModel>(
            model: ItemModel(),
            child: ScopedModelDescendant<ItemModel>(
              builder: (context, child, model2) {
                return MaterialApp(
                  title: "ShopList",
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    // primaryColor: Color.fromRGBO(133, 0, 249, 1),
                    primaryColor: Colors.deepOrange,
                    accentColor: Color.fromRGBO(174, 58, 255, 1),
                  ),
                  home: SignInPage(),
                  // home: AdminHome(),
                );
              },
            ),
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
