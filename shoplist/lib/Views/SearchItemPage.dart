import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Models/ItemModel.dart';
import 'package:shoplist/Views/AddItemPage.dart';
import 'package:shoplist/custom_icons_icons.dart';
import 'package:shoplist/utils/Loading.dart';

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

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Adicionar item à lista",
          style: TextStyle(
            color: Theme.of(context).cursorColor,
            fontSize: 25,
            fontFamily: 'Helvetica',
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 35,
            color: Theme.of(context).cursorColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ScopedModelDescendant<ItemModel>(
        builder: (context, child, model) {
          if (model.isloading)
            return Center(
              child: Loading(),
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
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: (searchString == null || searchString.trim() == "")
                      ? Firestore.instance
                          .collection("itens")
                          .orderBy("nomeItem", descending: false)
                          .snapshots()
                      : Firestore.instance
                          .collection("itens")
                          .where("searchItens", arrayContains: searchString)
                          .orderBy("nomeItem", descending: false)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Text("Erro: ${snapshot.error}");
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return ListTile(
                          title: Text(
                            "Este item ainda não foi encontrado.",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                          subtitle: Text(
                            "Pode ser que não exista ainda, clique ao lado para criá-lo.",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.7),
                              fontSize: 15,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              size: 35,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddItemPage(),
                                ),
                              );
                            },
                          ),
                        );

                      default:
                        return ListView(
                          padding: EdgeInsets.only(bottom: 10),
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
                                  onTap: () async {
                                    QuerySnapshot teste = await Firestore
                                        .instance
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
                                      _onSuccess();
                                    } else {
                                      _itemExists();
                                    }
                                  },
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

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Item adicionado!"),
        backgroundColor: Colors.lightGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // void _onFail() {
  //   _scaffoldKey.currentState.showSnackBar(
  //     SnackBar(
  //       content: Text("Não foi possível adicionar este item!"),
  //       backgroundColor: Colors.redAccent,
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  // }

  void _itemExists() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Já está na sua lista!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
