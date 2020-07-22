import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Models/UserModel.dart';
import 'package:shoplist/Views/NewListPage.dart';
import 'package:shoplist/Views/UserPage.dart';
import 'package:shoplist/Views/ListPage.dart';
import 'package:shoplist/custom_icons_icons.dart';
import 'package:shoplist/utils/CustomDrawer.dart';
import 'package:shoplist/utils/Loading.dart';

class HomePage extends StatefulWidget {
  final String userID;
  HomePage({Key key, @required this.userID}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState(this.userID);
}

class _HomePageState extends State<HomePage> {
  final String userId;
  _HomePageState(this.userId);

  String _searchLista;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
              tooltip: "Página do Usuário",
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
        drawer: CustomDrawer(userID: userId),
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
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Form(
                      child: Row(
                        children: <Widget>[
                          Flexible(
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
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: StreamBuilder<QuerySnapshot>(
                      stream:
                          (_searchLista == null || _searchLista.trim() == "")
                              ? Firestore.instance
                                  .collection("listas")
                                  .where("dono", isEqualTo: userId)
                                  .orderBy("data", descending: true)
                                  .snapshots()
                              : Firestore.instance
                                  .collection("listas")
                                  .where("dono", isEqualTo: userId)
                                  .where("searchListas",
                                      arrayContains: _searchLista)
                                  .orderBy("data", descending: true)
                                  .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError)
                          return Text("Erro: ${snapshot.error}");
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return ListTile(
                              title: Text(
                                "Você ainda não possui nenhuma lista.",
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
                                      builder: (context) => NewListPage(),
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
                                          fontSize: 15,
                                          fontFamily: 'Helvetica',
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ListPage(
                                              listName: document["nomeLista"]
                                                  .toString(),
                                              listID: document.documentID
                                                  .toString(),
                                            ),
                                          ),
                                        );
                                      },
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
