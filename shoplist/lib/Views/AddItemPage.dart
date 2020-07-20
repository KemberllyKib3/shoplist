import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Models/ItemModel.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:shoplist/utils/Loading.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Criar novo item",
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
      body: ScopedModelDescendant<ItemModel>(
        builder: (context, child, model) {
          if (model.isloading) {
            return Center(
              child: Loading(),
            );
          }
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        fillColor: Colors.black12,
                        hintText: "Nome do item",
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
                          ? 'Este campo não pode estar vazio.'
                          : null,
                      onChanged: (val) {
                        setState(() => _nomeItem = val);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: DropDownFormField(
                      required: true,
                      validator: (value) =>
                          value.isEmpty ? "Você precisa escolher um" : null,
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
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: DropDownFormField(
                      required: true,
                      validator: (value) =>
                          value.isEmpty ? "Você precisa escolher um" : null,
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
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: MaterialButton(
                      elevation: 3,
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "SALVAR NOVO ITEM",
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
