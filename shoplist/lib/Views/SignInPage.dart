import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Models/UserModel.dart';
import 'package:shoplist/Views/HomePage.dart';
import 'package:shoplist/Views/HomePage1.dart';
import 'package:shoplist/Views/RecoverPassPage.dart';
import 'package:shoplist/Views/SignUpPage.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //text field state
  String _email, _password;
  bool _visibility = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isloading)
              return Center(
                child: CircularProgressIndicator(),
              );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(
                        Icons.store,
                        size: 100,
                        color: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                    decoration: BoxDecoration(),
                    child: ListView(
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                "Olá! Faça login para\ncontinuar.",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                  fontFamily: 'Open Sans',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    fillColor: Colors.black12,
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                      color: Colors.black26,
                                      fontSize: 20,
                                      fontFamily: 'Open Sans',
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  validator: (val) => val.isEmpty
                                      ? 'Digite um email válido.'
                                      : null,
                                  onChanged: (val) {
                                    setState(() => _email = val);
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: TextFormField(
                                  obscureText: _visibility,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        icon: _visibility
                                            ? Icon(Icons.visibility_off)
                                            : Icon(Icons.visibility),
                                        onPressed: () {
                                          setState(() {
                                            _visibility = !_visibility;
                                          });
                                        }),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    hintText: "Senha",
                                    hintStyle: TextStyle(
                                      color: Colors.black26,
                                      fontSize: 20,
                                      fontFamily: 'Open Sans',
                                    ),
                                  ),
                                  validator: (val) => val.length < 8
                                      ? 'Escolha uma senha com pelo menos 8 caracteres'
                                      : null,
                                  onChanged: (val) {
                                    setState(() => _password = val);
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: MaterialButton(
                                  elevation: 3,
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    "ENTRAR",
                                    style: TextStyle(
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
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      model.signIn(
                                        email: _email,
                                        pass: _password,
                                        onSuccess: _onSuccess,
                                        onFail: _onFail,
                                      );
                                    }
                                  },
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => RecoverPassPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Esqueci minha senha",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Open Sans',
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Divider(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(" ou "),
                                  Expanded(
                                    child: Divider(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),

                              // Divider(
                              //   height: 10,
                              //   color: Colors.black87,
                              // ),
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: MaterialButton(
                                  elevation: 3,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      // Icon(Icons.group_work),
                                      Text(
                                        "Entrar com google",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Open Sans',
                                        ),
                                      ),
                                    ],
                                  ),
                                  height: 50,
                                  textColor: Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                // padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                                child: MaterialButton(
                                  elevation: 3,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      // Icon(Icons.visibility_off),
                                      Text(
                                        "Entrar como visitante",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Open Sans',
                                        ),
                                      ),
                                    ],
                                  ),
                                  height: 50,
                                  textColor: Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Novo por aqui?",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Open Sans',
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SignUpPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Cadastre-se",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(0),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
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

  void _onSuccess() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage1(),
      ),
    );
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao entrar!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
