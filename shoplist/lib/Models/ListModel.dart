import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Models/ItemModel.dart';
import 'package:shoplist/Models/UserModel.dart';

class ListModel extends Model {
  UserModel user;
  ItemModel itens;
  bool isloading = false;
  ListModel(this.user, this.itens);

  // CRIAR UMA NOVA LISTA
  void criarLista(Map<String, dynamic> listData, dynamic onSuccess(String oi),
      VoidCallback onFail) async {
    isloading = true;
    notifyListeners();
    try {
      Firestore.instance
          .collection("listas")
          .add(listData)
          .then((docRef) => {
                onSuccess(docRef.documentID.toString()),
                Firestore.instance
                    .collection("listas")
                    .document(docRef.documentID)
                    .collection("itens")
                    .buildArguments(),
              });

      isloading = false;
      notifyListeners();
    } catch (e) {
      onFail();
      isloading = false;
      notifyListeners();
    }
  }

  //Excluir lista
  void excluirLista(String listID) {
    try {
      Firestore.instance.collection("listas").document(listID).delete();
      Firestore.instance
          .collection("listas")
          .document(listID)
          .collection("itens");
    } catch (e) {}
  }

  void removerItemDaLista(String listID, String itemID) {
    try {
      Firestore.instance
          .collection("listas")
          .document(listID)
          .collection("itens")
          .document(itemID)
          .delete();
    } catch (e) {}
  }

  // CARREGAR LISTAS DA NUVEM E SALVAR NO LOCAL
  Future<List<QuerySnapshot>> carregarListas() async {
    isloading = true;
    notifyListeners();
    return Firestore.instance.collection("listas").snapshots().toList();
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
