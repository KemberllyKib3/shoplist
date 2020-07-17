import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Models/UserModel.dart';
import 'package:shoplist/Views/SignInPage.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //text field state
  String _email, _password, _firstName;
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
                                "Olá! Cadastre-se para\ncontinuar.",
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
                                    hintText: "Nome",
                                    hintStyle: TextStyle(
                                      color: Colors.black26,
                                      fontSize: 20,
                                      fontFamily: 'Open Sans',
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  // validator: (val) => val.isEmpty
                                  //     ? 'Digite um nome válido.'
                                  //     : null,

                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return "Este campo não pode ser vazio.";
                                    } else {
                                      return null;
                                    }
                                  },

                                  onChanged: (val) {
                                    setState(() => _firstName = val);
                                  },
                                ),
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
                                  // validator: (val) => val.isEmpty
                                  //     ? 'Este campo não pode ser vazio.'
                                  //     : null,

                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return "Este campo não pode ser vazio.";
                                    }
                                    if (!val.contains("@")) {
                                      return "Digite um email válido.";
                                    } else {
                                      return null;
                                    }
                                  },
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
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: MaterialButton(
                                  elevation: 3,
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    "CADASTRAR",
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
                                      Map<String, dynamic> userData = {
                                        "nome": _firstName,
                                        "email": _email,
                                        "cargo": "user",
                                      };
                                      model.signUp(
                                        userData: userData,
                                        pass: _password,
                                        onSuccess: _onSuccess,
                                        onFail: _onFail,
                                      );
                                    }
                                  },
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
                                        "Cadastrar com google",
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
                                    "Já possui conta?",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Open Sans',
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SignInPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Faça Login",
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
    Navigator.of(context).pop();
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao criar sua conta!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
