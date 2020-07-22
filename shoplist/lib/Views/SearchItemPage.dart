import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Models/ItemModel.dart';

class SearchItemPage extends StatefulWidget {
  final String listID;
  SearchItemPage({Key key, @required this.listID}) : super(key: key);
  @override
  _SearchItemPageState createState() =>
      _SearchItemPageState(listID: this.listID);
}

class _SearchItemPageState extends State<SearchItemPage> {
  final String listID;
  _SearchItemPageState({@required this.listID});
  String searchString = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buscador"),
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
                  labelText: "Pesquise um item",
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
                      ? Firestore.instance.collection("itens").snapshots()
                      : Firestore.instance
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
                                leading: Icon(Icons.add),
                                onTap: () async {
                                  QuerySnapshot teste = await Firestore.instance
                                      .collection("listas")
                                      .document(this.listID)
                                      .collection("itens")
                                      .where("nomeItem",
                                          isEqualTo:
                                              document["nomeItem"].toString())
                                      .getDocuments();
                                  if (teste.documents.isEmpty) {
                                    Firestore.instance
                                        .collection("listas")
                                        .document(this.listID)
                                        .collection("itens")
                                        .add(document.data);
                                    print("adicionadoh");
                                  } else {
                                    print(document["nomeItem"].toString() +
                                        " já está na sua lista!");
                                  }
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
}
