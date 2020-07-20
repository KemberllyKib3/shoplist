import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Models/UserModel.dart';
import 'package:shoplist/Views/NewListPage.dart';
import 'package:shoplist/Views/UserPage.dart';
import 'package:shoplist/custom_icons_icons.dart';
import 'package:shoplist/utils/CustomDrawer.dart';
import 'package:shoplist/utils/Loading.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _searchLista;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
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
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.person,
                size: 35,
                color: Theme.of(context).cursorColor,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UserPage(),
                  ),
                );
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.add,
            size: 30,
          ),
          tooltip: "Criar nova lista",
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewListPage(),
              ),
            );
          },
        ),
        drawer: CustomDrawer(),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isloading) {
              return Center(
                child: Loading(),
              );
            }
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15),
                  height: 80,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Olá, ${model.userData["nome"].toString().split(" ")[0]}",
                        style: TextStyle(
                          color: Theme.of(context).cursorColor,
                          fontSize: 30,
                          fontFamily: 'Helvetica',
                        ),
                      ),
                      Text(
                        "O que vamos comprar hoje?",
                        style: TextStyle(
                          color: Theme.of(context).cursorColor,
                          fontSize: 20,
                          fontFamily: 'Helvetica',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Form(
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                fillColor: Colors.black12,
                                hintText: "Qual lista?",
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
                                setState(() => _searchLista = val);
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.filter_list,
                            size: 35,
                          ),
                          tooltip: "Filtros",
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      // color: Colors.black.withOpacity(0.05),
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: (_searchLista == null ||
                              _searchLista.trim() == "")
                          ? Firestore.instance.collection("listas").snapshots()
                          : Firestore.instance
                              .collection("listas")
                              .where("searchListas",
                                  arrayContains: _searchLista)
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
                                      leading: Icon(
                                        CustomIcons.shop,
                                        size: 45,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      title: Text(
                                        document["nomeLista"],
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 20,
                                          fontFamily: 'Helvetica',
                                        ),
                                      ),
                                      subtitle: Text(
                                        document["descricao"] == null ||
                                                document["descricao"] == ""
                                            ? "Sem descrição"
                                            : document["descricao"],
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .accentColor
                                              .withOpacity(0.7),
                                          fontSize: 14,
                                          fontFamily: 'Helvetica',
                                        ),
                                      ),
                                      onTap: () {},
                                    ),
                                  );
                                },
                              ).toList(),
                            );
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
