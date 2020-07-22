import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Models/ItemModel.dart';
import 'package:shoplist/Models/ListModel.dart';
import 'package:shoplist/Models/UserModel.dart';
import 'package:shoplist/Views/HomePage.dart';
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
  final String listName, listID;
  static final UserModel user = UserModel();
  static final ItemModel itens = ItemModel();
  _ListPageState({@required this.listName, @required this.listID});

  String searchString = "";

  ListModel model = ListModel(user, itens);

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
          onPressed: () async {
            FirebaseUser _firebaseUser =
                await FirebaseAuth.instance.currentUser();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    HomePage(userID: _firebaseUser.uid.toString()),
              ),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
              size: 30,
              color: Colors.redAccent,
            ),
            tooltip: "Excluir lista",
            onPressed: () {
              _showDialogApagarLista(context);
            },
          ),
        ],
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
                          fontFamily: 'Helvetica',
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
                          .orderBy("nomeItem", descending: false)
                          .snapshots()
                      : Firestore.instance
                          .collection("listas")
                          .document(this.listID)
                          .collection("itens")
                          .orderBy("nomeItem", descending: false)
                          .where("searchItens", arrayContains: searchString)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Text("Erro: ${snapshot.error}");
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return ListTile(
                          title: Text(
                            "Você ainda não adicionou este item nesta lista.",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                          subtitle: Text(
                            "Clique ao lado para adicionar.",
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
                                  builder: (context) =>
                                      SearchItemPage(listID: listID),
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
                                  title: Text(
                                    document["nomeItem"],
                                    style: TextStyle(
                                      color: Theme.of(context).cursorColor,
                                      fontSize: 18,
                                      fontFamily: 'Helvetica',
                                    ),
                                  ),
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
                                  onLongPress: () {
                                    _showDialogRemoverItem(
                                        context, document.documentID);
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

  void _showDialogApagarLista(BuildContext context) {
    Widget cancelaButton = FlatButton(
      child: Text(
        "Cancelar",
        style: TextStyle(
          fontFamily: "Helvetica",
          color: Theme.of(context).cursorColor,
          fontSize: 14,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continuaButton = FlatButton(
      color: Colors.redAccent,
      child: Text("Excluir"),
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
          title: Text("Deseja excluir esta lista?"),
          content: Text("Ao excluir você nao terá mais acesso a ela."),
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
      child: Text(
        "Cancelar",
        style: TextStyle(
          fontFamily: "Helvetica",
          color: Theme.of(context).cursorColor,
          fontSize: 14,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget removeButton = FlatButton(
      color: Colors.redAccent,
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
          title: Text("Deseja remover item da sua lista?"),
          content:
              Text("Ao remover este item, ele não estará mais na sua lista."),
          actions: [
            cancelaButton,
            removeButton,
          ],
        );
      },
    );
  }
}
