import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Models/UserModel.dart';
import 'package:shoplist/Views/AddItemPage.dart';
import 'package:shoplist/Views/HomePage.dart';
import 'package:shoplist/Views/HomeRecipePage.dart';
import 'package:shoplist/custom_icons_icons.dart';

class CustomDrawer extends StatefulWidget {
  final String userID;
  CustomDrawer({Key key, this.userID}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState(userID);
}

class _CustomDrawerState extends State<CustomDrawer> {
  final String userId;
  _CustomDrawerState(this.userId);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        if (model.isloading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Drawer(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    // color: Colors.blue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "Desenvolvido por: Grupo 1",
                        style: TextStyle(
                          color: Theme.of(context).cursorColor,
                          fontSize: 15,
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Assistência: Mestre Testador",
                        style: TextStyle(
                          color: Theme.of(context).cursorColor,
                          fontSize: 12,
                          fontFamily: 'Helvetica',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          CustomIcons.shop,
                          size: 80,
                          color: Theme.of(context).primaryColor,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Bem-vindo(a) ao\nShopList",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    height: 1,
                    color: Theme.of(context).cursorColor,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Theme.of(context).cursorColor,
                    ),
                    title: Text(
                      "Página Inicial",
                      style: TextStyle(
                        color: Theme.of(context).cursorColor,
                        fontSize: 15,
                        fontFamily: 'Helvetica',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onLongPress: null,
                    onTap: () async {
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
                  ListTile(
                    leading: Icon(
                      // Icons.list,
                      Icons.format_list_bulleted,
                      color: Theme.of(context).cursorColor,
                    ),
                    title: Text(
                      "Receitas",
                      style: TextStyle(
                        color: Theme.of(context).cursorColor,
                        fontSize: 15,
                        fontFamily: 'Helvetica',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onLongPress: null,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HomeRecipePage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.add_circle,
                      color: Theme.of(context).cursorColor,
                    ),
                    title: Text(
                      "Criar um novo item",
                      style: TextStyle(
                        color: Theme.of(context).cursorColor,
                        fontSize: 15,
                        fontFamily: 'Helvetica',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onLongPress: null,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddItemPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Colors.red,
                    ),
                    title: Text(
                      "Sair da conta",
                      style: TextStyle(
                        color: Theme.of(context).cursorColor,
                        fontSize: 15,
                        fontFamily: 'Helvetica',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onLongPress: null,
                    onTap: () {
                      model.signOut(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
