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
      @required VoidCallback onFail}) async {

    QuerySnapshot teste = await Firestore.instance
        .collection("itens")
        .where("nomeItem".toLowerCase(), isEqualTo: itemData["nomeItem"].toString().toLowerCase())
        .getDocuments();

    if (teste.documents.isEmpty) {
      Firestore.instance.collection("itens").add(itemData);
      onSuccess();
      notifyListeners();
    } else {
      onFail();
      notifyListeners();
    }
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
}
