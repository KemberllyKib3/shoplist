import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Models/UserModel.dart';
import 'package:shoplist/Views/RecoverPassPage.dart';
import 'package:shoplist/utils/Loading.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _email, _nome = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 35,
                color: Theme.of(context).cursorColor,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              if (model.isloading) {
                return Center(
                  child: Loading(),
                );
              }
              return Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Theme.of(context).cursorColor.withOpacity(0.12),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 100,
                            color: Theme.of(context).cursorColor,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person_outline),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: null,
                                tooltip: "Editar",
                              ),
                              fillColor: Colors.black12,
                              hintText: "Seu nome",
                              hintStyle: TextStyle(
                                color: Colors.black26,
                                fontSize: 20,
                                fontFamily: 'Helvetica',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            validator: (val) => val.length < 3
                                ? 'Digite um nome válido.'
                                : null,
                            onSaved: (val) {
                              setState(() => _nome = val);
                            },
                            initialValue: model.userData["nome"],
                            readOnly: true,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.alternate_email),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: null,
                                tooltip: "Editar",
                              ),
                              fillColor: Colors.black12,
                              hintText: "Seu email",
                              hintStyle: TextStyle(
                                color: Colors.black26,
                                fontSize: 20,
                                fontFamily: 'Helvetica',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            validator: (val) =>
                                val.isEmpty ? 'Digite um email válido.' : null,
                            onSaved: (val) {
                              setState(() => _email = val);
                            },
                            initialValue: model.userData["email"],
                            readOnly: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: TextFormField(
                            
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.help_outline),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => RecoverPassPage(),
                                    ),
                                  );
                                },
                                tooltip: "Esqueci minha senha",
                              ),
                              fillColor: Colors.black12,
                              hintText: "Sua senha",
                              hintStyle: TextStyle(
                                color: Colors.black26,
                                fontSize: 20,
                                fontFamily: 'Helvetica',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            obscureText: true,
                            initialValue: "senha",
                            readOnly: true,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: MaterialButton(
                            elevation: 3,
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              "SALVAR DADOS",
                              style: TextStyle(
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
                              print(_nome);
                              print(_email);

                              _disponibility();
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }

  // void _onSuccess() {
  //   _scaffoldKey.currentState.showSnackBar(
  //     SnackBar(
  //       content: Text("Usuário atualizado!"),
  //       backgroundColor: Colors.lightGreen,
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  //   // Navigator.of(context).pop();
  // }

  // void _onFail() {
  //   _scaffoldKey.currentState.showSnackBar(
  //     SnackBar(
  //       content: Text("Falha ao atualizar usuário!"),
  //       backgroundColor: Colors.redAccent,
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  // }

  void _disponibility() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Não disponível nesta versão"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
