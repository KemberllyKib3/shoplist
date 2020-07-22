import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shoplist/Views/RecipePage.dart';
import 'package:shoplist/utils/CustomDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:shoplist/utils/RecipeApi.dart';

class HomeRecipePage extends StatefulWidget {
  HomeRecipePage({Key key}) : super(key: key);

  @override
  _HomeRecipePageState createState() => _HomeRecipePageState();
}

class _HomeRecipePageState extends State<HomeRecipePage> {
  String _searchRecipe;

  Future<String> getJSONData() async {
    var response = await http.get(
        Uri.encodeFull(
            "https://gist.githubusercontent.com/lucasheriques/ed2214dba65b8903a5b62566f4439005/raw"),
        headers: {"Accept": "application/json"});

    setState(() {
      var data = json.decode(response.body)['results'];
    });

    return "Dados obtidos com sucesso";
  }

  Future<RecipesApi> fetchPost() async {
    final response = await http.get(
        'https://gist.githubusercontent.com/lucasheriques/ed2214dba65b8903a5b62566f4439005/raw');

    if (response.statusCode == 200) {
      return RecipesApi.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao carregar');
    }
  }

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
                tooltip: "Aba lateral",
              );
            },
          ),
        ),
        drawer: CustomDrawer(),
        body: Column(
          children: <Widget>[
            Container(
              height: 80,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          fillColor: Colors.black12,
                          hintText: "Quer fazer o que hoje?",
                          hintStyle: TextStyle(
                            color: Colors.black26,
                            fontSize: 20,
                            fontFamily: 'Helvetica',
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _searchRecipe = val;
                            print(_searchRecipe);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cursorColor.withOpacity(0.05),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: FutureBuilder<RecipesApi>(
                    future: fetchPost(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data.receitas.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 3,
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
                                trailing: Icon(
                                  Icons.arrow_forward,
                                  size: 25,
                                  color: Theme.of(context).accentColor,
                                ),
                                title: Text(
                                  snapshot.data.receitas[index].receita,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15,
                                    fontFamily: 'Helvetica',
                                  ),
                                ),
                                onLongPress: null,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecipePage(
                                        recipeName: snapshot
                                            .data.receitas[index].receita,
                                        recipeIngredients: snapshot
                                            .data.receitas[index].ingredientes,
                                        recipeHowTo: snapshot
                                            .data.receitas[index].modoPreparo,
                                        recipeImage: snapshot
                                            .data.receitas[index].linkImagem,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text("Houve um erro: ${snapshot.error}");
                      }
                      // exibe um spinner carregando
                      return Center(child: CircularProgressIndicator());
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
