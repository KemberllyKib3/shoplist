import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Models/ItemModel.dart';
import 'package:shoplist/Models/ListModel.dart';
import 'package:shoplist/Models/UserModel.dart';
import 'package:shoplist/Views/HomePage.dart';
import 'package:shoplist/Views/SearchItemPage.dart';

class ShowListPage extends StatefulWidget {
  final String listName;
  final String listID;
  ShowListPage({Key key, @required this.listName, @required this.listID})
      : super(key: key);

  @override
  _ShowListPageState createState() =>
      _ShowListPageState(listName: this.listName, listID: this.listID);
}

class _ShowListPageState extends State<ShowListPage> {
  final String listName, listID;
  static final UserModel user = UserModel();
  static final ItemModel itens = ItemModel();
  _ShowListPageState({@required this.listName, @required this.listID});

  String searchString = "";

  ListModel model = ListModel(user, itens);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.listName),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.playlist_add,
              size: 35,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchItemPage(listID: this.listID),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              size: 35,
            ),
            onPressed: () {
              _showDialogApagarLista(context);
            },
          ),
        ],
      ),
      body: ScopedModelDescendant<ItemModel>(
        builder: (context, child, model) {
          if (model.isloading)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: "Pesquise itens na sua lista",
                ),
                onChanged: (String value) {
                  setState(() {
                    searchString = value.toLowerCase();
                  });
                  // print(model.getSuggestion(value.toLowerCase()));
                },
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: (searchString == null || searchString.trim() == "")
                      ? Firestore.instance
                          .collection("listas")
                          .document(this.listID)
                          .collection("itens")
                          .orderBy("nomeItem")
                          .snapshots()
                      : Firestore.instance
                          .collection("listas")
                          .document(this.listID)
                          .collection("itens")
                          .where("searchItens", arrayContains: searchString)
                          .orderBy("nomeItem")
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Text("Erro: ${snapshot.error}");
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );

                      default:
                        return ListView(
                          children: snapshot.data.documents.map(
                            (DocumentSnapshot document) {
                              return ListTile(
                                title: Text(document["nomeItem"]),
                                trailing: Icon(Icons.delete),
                                onTap: () {
                                  _showDialogRemoverItem(
                                      context, document.documentID);
                                },
                              );
                            },
                          ).toList(),
                        );
                    }
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void _showDialogApagarLista(BuildContext context) {
    Widget cancelaButton = FlatButton(
      child: Text("Apaga não"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continuaButton = FlatButton(
      child: Text("Pufavô apaga logo isso"),
      onPressed: () async {
        model.excluirLista(this.listID);
        FirebaseUser _user = await FirebaseAuth.instance.currentUser();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(userID: _user.uid.toString()),
          ),
        );
      },
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Excluir Lista?"),
          content: Text("Tem certeza que vai excluir a listinha?? :("),
          actions: [
            cancelaButton,
            continuaButton,
          ],
        );
      },
    );
  }

  void _showDialogRemoverItem(BuildContext context, String itemID) {
    Widget cancelaButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget removeButton = FlatButton(
      child: Text("Remover"),
      onPressed: () async {
        model.removerItemDaLista(this.listID, itemID);
        Navigator.of(context).pop();
      },
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Deseja remover item da Lista?"),
            content: Text("Esta ação é irreversível"),
            actions: [
              cancelaButton,
              removeButton,
            ],
          );
        });
  }
}
