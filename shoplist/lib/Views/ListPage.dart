import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Models/ItemModel.dart';
import 'package:shoplist/Views/SearchItemPage.dart';
import 'package:shoplist/custom_icons_icons.dart';

class ListPage extends StatefulWidget {
  final String listName;
  final String listID;
  ListPage({Key key, @required this.listName, @required this.listID})
      : super(key: key);
  @override
  _ListPageState createState() =>
      _ListPageState(listName: this.listName, listID: this.listID);
}

class _ListPageState extends State<ListPage> {
  final String listName;
  final String listID;
  _ListPageState({@required this.listName, @required this.listID});
  String searchString = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          this.listName,
          style: TextStyle(
            color: Theme.of(context).cursorColor,
            fontSize: 25,
            fontFamily: 'Helvetica',
          ),
          overflow: TextOverflow.ellipsis,
        ),
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
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 80,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            fillColor: Colors.black12,
                            hintText: "Pesquise itens",
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
                              searchString = val.toLowerCase();
                            });
                          },
                        ),
                      ),
                    ),
                    MaterialButton(
                      elevation: 3,
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "+Itens",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      height: 50,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                SearchItemPage(listID: this.listID),
                          ),
                        );
                      },
                    )
                  ],
                ),
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
                              return Card(
                                elevation: 3,
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  title: Text(document["nomeItem"]),
                                  leading: (document["categoria"] ==
                                          "Alimentos")
                                      ? Icon(
                                          CustomIcons.apple2,
                                          size: 35,
                                          color: Theme.of(context).primaryColor,
                                        )
                                      : (document["categoria"] == "Limpeza")
                                          ? Icon(
                                              CustomIcons.clean,
                                              size: 35,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            )
                                          : (document["categoria"] == "Higiene")
                                              ? Icon(
                                                  CustomIcons.washing_hands,
                                                  size: 35,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                )
                                              : (document["categoria"] ==
                                                      "Outros")
                                                  ? Icon(
                                                      Icons.more_vert,
                                                      size: 35,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    )
                                                  : null,
                                  onTap: () {},
                                ),
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
