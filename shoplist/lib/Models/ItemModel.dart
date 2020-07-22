import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ItemModel extends Model {
  Firestore firestoreProvider;

  bool isloading = false;

  Map<String, dynamic> itemData = Map();

  // CRIAR UM NOVO ITEM
  void createItem(
      {@required Map<String, dynamic> itemData,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    try {
      Firestore.instance.collection("itens").add(itemData);
      onSuccess();
      notifyListeners();
    } catch (e) {
      onFail();
      notifyListeners();
    }
  }

  bool existeItemnNoBd(String nome) {
    // Future<QuerySnapshot> result;
    QuerySnapshot result;

    result = Firestore.instance
        .collection('itens')
        .where('nomeItem'.toLowerCase(), isEqualTo: nome.toLowerCase())
        .limit(1)
        .getDocuments()
        .then((value) => result = value)
        .catchError((e) {
      result = null;
    }) as QuerySnapshot;

    return (result == null) ? false : true;
  }

  setSearchParam(String nome) {
    List<String> splitList = nome.split(" ");
    List<String> indexList = [];

    for (int i = 0; i < splitList.length; i++) {
      for (int j = 1; j < splitList[i].length + 1; j++) {
        indexList.add(splitList[i].substring(0, j).toLowerCase());
      }
    }
    return indexList;
  }

  // ATUALIZA O ITEM SE FOR FEITA ALGUMA ALTERAÇÃO
  void updateItem() {
    isloading = true;
    notifyListeners();
  }

  // COLOCAR PREÇO E QUANTIDADE
  void addPriceQntdItem() {}
}
