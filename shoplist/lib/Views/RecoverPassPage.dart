import 'package:flutter/material.dart';

class RecoverPassPage extends StatefulWidget {
  RecoverPassPage({Key key}) : super(key: key);

  @override
  _RecoverPassPageState createState() => _RecoverPassPageState();
}

class _RecoverPassPageState extends State<RecoverPassPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Recuperar Senha"),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Para recuperar sua senha,\ninsira os dados abaixo",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontFamily: 'Open Sans',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    fillColor: Colors.black12,
                    hintText: "Seu email de cadastro",
                    hintStyle: TextStyle(
                      color: Colors.black26,
                      fontSize: 20,
                      fontFamily: 'Open Sans',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (val) =>
                      val.isEmpty ? 'Digite um email válido.' : null,
                  onChanged: (val) {
                    // setState(() => _email = val);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: MaterialButton(
                  elevation: 3,
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    "RECUPERAR SENHA",
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
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
