import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Models/ListModel.dart';
import 'package:shoplist/utils/Loading.dart';

class NewListPage extends StatefulWidget {
  NewListPage({Key key}) : super(key: key);

  @override
  _NewListPageState createState() => _NewListPageState();
}

class _NewListPageState extends State<NewListPage> {
  final _formKey = new GlobalKey<FormState>();
  String _nomeLista, _descLista;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
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
                child: Loading(),
              );
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: Text(
                    //     "Crie sua nova Lista",
                    //     textAlign: TextAlign.left,
                    //     style: TextStyle(
                    //       color: Theme.of(context).cursorColor,
                    //       fontSize: 20,
                    //       fontFamily: 'Helvetica',
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    // ),
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
                      padding: EdgeInsets.only(top: 5),
                      child: MaterialButton(
                        elevation: 3,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "CRIAR NOVA LISTA",
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
                          print(_descLista);
                          print(_nomeLista);
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
}
