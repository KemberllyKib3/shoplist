import 'package:flutter/material.dart';

class RecoverPassPage extends StatefulWidget {
  RecoverPassPage({Key key}) : super(key: key);

  @override
  _RecoverPassPageState createState() => _RecoverPassPageState();
}

class _RecoverPassPageState extends State<RecoverPassPage> {
  String _email;
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 35,
            color: Theme.of(context).cursorColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Recuperar senha",
          style: TextStyle(
            color: Theme.of(context).cursorColor,
            fontSize: 25,
            fontFamily: 'Helvetica',
            
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        children: <Widget>[
          Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Para recuperar sua senha, insira os dados abaixo. Em breve receberá um email para redefinir sua senha",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).cursorColor,
                    fontSize: 14,
                    fontFamily: 'Helvetica',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      fillColor: Colors.black12,
                      hintText: "Seu email de cadastro",
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
                    onChanged: (val) {
                      setState(() => _email = val);
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
                        fontFamily: 'Helvetica',
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
        ],
      ),
    ));
  }
}
