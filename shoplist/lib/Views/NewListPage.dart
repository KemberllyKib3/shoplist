import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Models/ListModel.dart';
import 'package:shoplist/Views/ListPage.dart';

class NewListPage extends StatefulWidget {
  NewListPage({Key key}) : super(key: key);

  @override
  _NewListPageState createState() => _NewListPageState();
}

class _NewListPageState extends State<NewListPage> {
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _nomeLista, _descLista;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Criar nova lista",
            style: TextStyle(
              color: Theme.of(context).cursorColor,
              fontSize: 25,
              fontFamily: 'Helvetica',
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 35,
              color: Theme.of(context).cursorColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: ScopedModelDescendant<ListModel>(
          builder: (context, child, model) {
            if (model.isloading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "É fácil criar uma nova lista, preencha os campos abaixo e aperte em criar.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Theme.of(context).cursorColor,
                        fontSize: 15,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: Colors.black12,
                          hintText: "Nome da lista",
                          hintStyle: TextStyle(
                            color: Colors.black26,
                            fontSize: 20,
                            fontFamily: 'Helvetica',
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (val) => val.isEmpty
                            ? 'Este campo não pode ser vazio'
                            : null,
                        onChanged: (val) {
                          setState(() => _nomeLista = val);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: TextFormField(
                        maxLines: 2,
                        maxLength: 70,
                        decoration: InputDecoration(
                          fillColor: Colors.black12,
                          hintText: "Descrição(opcional)",
                          hintStyle: TextStyle(
                            color: Colors.black26,
                            fontSize: 20,
                            fontFamily: 'Helvetica',
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (val) => val.length > 70
                            ? 'Permitido apenas 70 caracteres.'
                            : null,
                        onChanged: (val) {
                          setState(() => _descLista = val);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: MaterialButton(
                        elevation: 3,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "CRIAR LISTA",
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
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            FirebaseUser user =
                                await _firebaseAuth.currentUser();
                            Map<String, dynamic> listData = {
                              "dono": user.uid.toString(),
                              "nomeLista": _nomeLista,
                              "descricao": _descLista,
                              "data": new DateTime.now(),
                              "searchListas": model.setSearchParam(_nomeLista),
                            };
                            model.criarLista(
                              listData,
                              _onSuccess,
                              _onFail,
                            );
                            // setState(
                            //   () {
                            //     //_nomeLista = "";
                            //     //_descLista = "";
                            //   });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ignore: invalid_required_positional_param
  dynamic _onSuccess(@required String id) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Lista criada, aguarde..."),
        backgroundColor: Colors.lightGreen,
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ListPage(
          listName: _nomeLista,
          listID: id,
        ),
      ),
    );
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao salvar lista!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
