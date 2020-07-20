import 'package:flutter/material.dart';
import 'package:shoplist/utils/CustomDrawer.dart';

class RecipePage extends StatefulWidget {
  RecipePage({Key key}) : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Receitas",
            style: TextStyle(
              color: Theme.of(context).cursorColor,
              fontSize: 25,
              fontFamily: 'Helvetica',
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(
                  Icons.menu,
                  size: 35,
                  color: Theme.of(context).cursorColor,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                tooltip: "Aba lateral",
              );
            },
          ),
        ),
        drawer: CustomDrawer(),
        body: Center(
          child: Text("Recipe Page"),
        ),
      ),
    );
  }
}
