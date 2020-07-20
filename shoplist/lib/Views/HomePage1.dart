import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoplist/Views/NewListPage.dart';
import 'package:shoplist/Views/ShowListPage.dart';

class HomePage1 extends StatefulWidget {
  final String userID;
  HomePage1({Key key, @required this.userID}) : super(key: key);
  @override
  _HomePage1State createState() => _HomePage1State(this.userID);
}

class _HomePage1State extends State<HomePage1> {
  final String userId;
  _HomePage1State(this.userId);

  String _searchLista;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                size: 35,
              ),
              onPressed: () {},
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.person,
                  size: 35,
                ),
                onPressed: () {},
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.add),
            tooltip: "Criar nova lista",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewListPage(),
                ),
              );
            },
          ),
          body: Column(
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
                      "Olá, Fulano",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 30,
                        fontFamily: 'Open Sans',
                      ),
                    ),
                    Text(
                      "O que vamos comprar hoje?",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 20,
                        fontFamily: 'Open Sans',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                height: 80,
                color: Colors.white,
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
                                fontFamily: 'Open Sans',
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
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: (_searchLista == null || _searchLista.trim() == "")
                        ? Firestore.instance
                            .collection("listas")
                            .where("dono", isEqualTo: userId)
                            .snapshots()
                        : Firestore.instance
                            .collection("listas")
                            .where("dono", isEqualTo: userId)
                            .where("searchListas", arrayContains: _searchLista)
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
                                  title: Text(document["nomeLista"]),
                                  onTap: () {
                                    print(document.documentID.toString());
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ShowListPage(
                                            listName: document["nomeLista"]
                                                .toString(),
                                            listID:
                                                document.documentID.toString(),
                                          ),
                                        ));
                                  },
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
          )),
    );
  }
}
