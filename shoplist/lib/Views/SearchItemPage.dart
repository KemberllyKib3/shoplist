import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Models/ItemModel.dart';

class SearchItemPage extends StatefulWidget {
  @override
  _SearchItemPageState createState() => _SearchItemPageState();
}

class _SearchItemPageState extends State<SearchItemPage> {
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
