import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Models/ItemModel.dart';
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
  final String listName;
  final String listID;
  _ShowListPageState({@required this.listName, @required this.listID});
  String searchString = "";

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
          )
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
                          .snapshots()
                      : Firestore.instance
                          .collection("listas")
                          .document(this.listID)
                          .collection("itens")
                          .where("searchItens", arrayContains: searchString)
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
                                leading: Icon(Icons.check),
                                onTap: () {},
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
}
