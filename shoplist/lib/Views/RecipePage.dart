import 'package:flutter/material.dart';

class RecipePage extends StatefulWidget {
  final String recipeName;
  final String recipeIngredients;
  final String recipeHowTo;
  final String recipeImage;

  RecipePage({
    Key key,
    @required this.recipeName,
    @required this.recipeIngredients,
    @required this.recipeImage,
    @required this.recipeHowTo,
  }) : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState(
        recipeName: this.recipeName,
        recipeIngredients: this.recipeIngredients,
        recipeImage: this.recipeImage,
        recipeHowTo: this.recipeHowTo,
      );
}

class _RecipePageState extends State<RecipePage> {
  final String recipeName;
  final String recipeIngredients;
  final String recipeHowTo;
  final String recipeImage;

  _RecipePageState({
    @required this.recipeName,
    @required this.recipeIngredients,
    @required this.recipeImage,
    @required this.recipeHowTo,
  });

  String searchString = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 35,
              color: Theme.of(context).cursorColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Receita",
            style: TextStyle(
              color: Theme.of(context).cursorColor,
              fontSize: 25,
              fontFamily: 'Helvetica',
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  this.recipeName.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).cursorColor,
                    fontSize: 20,
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Ingredientes:",
                              style: TextStyle(
                                color: Theme.of(context).cursorColor,
                                fontSize: 20,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              linhaSeparada(this.recipeIngredients),
                              style: TextStyle(
                                color: Theme.of(context).cursorColor,
                                fontSize: 15,
                                fontFamily: 'Helvetica',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 0),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Modo de preparo:",
                              style: TextStyle(
                                color: Theme.of(context).cursorColor,
                                fontSize: 20,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              this.recipeHowTo,
                              style: TextStyle(
                                color: Theme.of(context).cursorColor,
                                fontSize: 15,
                                fontFamily: 'Helvetica',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String linhaSeparada(String ingredientes) {
    String separado;

    for (var i = 0; i < ingredientes.split(", ").length; i++) {
      separado = "¤ ${ingredientes.split(", ")[i]}\n${separado}";
    }
    return separado.replaceAll("null", "");
  }
}
