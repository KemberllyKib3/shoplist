import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Models/ItemModel.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

class AddItemPage extends StatefulWidget {
  AddItemPage({Key key}) : super(key: key);

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  String _unidadeMedida;
  String _categoria;
  String _nomeItem;

  final _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar novo item"),
      ),
      body: ScopedModelDescendant<ItemModel>(
        builder: (context, child, model) {
          if (model.isloading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _nomeItem = value;
                      });
                    },
                    decoration: InputDecoration(hintText: "Nome do item"),
                  ),
                  DropDownFormField(
                    hintText: "Selecione uma categoria",
                    titleText: "Categoria",
                    value: _categoria,
                    onSaved: (value) {
                      setState(() {
                        _categoria = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _categoria = value;
                      });
                    },
                    dataSource: [
                      {
                        "display": "Alimentos",
                        "value": "Alimentos",
                      },
                      {
                        "display": "Limpeza",
                        "value": "Limpeza",
                      },
                      {
                        "display": "Higiene",
                        "value": "Higiene",
                      },
                      {
                        "display": "Outros",
                        "value": "Outros",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
                  DropDownFormField(
                    hintText: "Selecione uma unidade",
                    titleText: "Unidade de Medida",
                    value: _unidadeMedida,
                    onSaved: (value) {
                      setState(() {
                        _unidadeMedida = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _unidadeMedida = value;
                      });
                    },
                    dataSource: [
                      {
                        "display": "Kg",
                        "value": "Kg",
                      },
                      {
                        "display": "g",
                        "value": "g",
                      },
                      {
                        "display": "L",
                        "value": "L",
                      },
                      {
                        "display": "Pacote",
                        "value": "Pacote",
                      },
                      {
                        "display": "Caixa",
                        "value": "Caixa",
                      },
                      {
                        "display": "ml",
                        "value": "ml",
                      },
                      {
                        "display": "Fardo",
                        "value": "Fardo",
                      },
                      {
                        "display": "un",
                        "value": "un",
                      },
                      {
                        "display": "dz",
                        "value": "dz",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
                  RaisedButton(
                    child: Text("Salvar novo item"),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        Map<String, dynamic> itemData = {
                          "nomeItem": _nomeItem,
                          "categoria": _categoria,
                          "unidadeMedida": _unidadeMedida,
                          "searchItens": model.setSearchParam(_nomeItem),
                        };
                        model.createItem(itemData);
                        setState(() {
                          _unidadeMedida = "";
                          _categoria = "";
                          _nomeItem = "";
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
