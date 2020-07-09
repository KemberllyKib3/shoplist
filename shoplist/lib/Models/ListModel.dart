import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ListModel extends Model {
  bool isloading = false;

  // CRIAR UMA NOVA LISTA
  void criarLista(
    Map<String, dynamic> listData,
    VoidCallback onSuccess,
    VoidCallback onFail,
  ) {
    isloading = true;
    notifyListeners();
  }

  // CARREGAR LISTAS DA NUVEM E SALVAR NO LOCAL
  void carregarNuvemListas() {
    isloading = true;
    notifyListeners();
  }

  // CARREGAR LISTAS DO BD LOCAL
  void carregarLocalListas() {
    isloading = true;
    notifyListeners();
  }

  // ATUALIZA AS MUDANCAS NA LISTA E JOGA NO BD LOCAL
  void atualizarListas() {
    isloading = true;
    notifyListeners();
  }

  // VERIFICA SE TEM LISTA NO LOCAL DIFERENTE DA NUVEM
  bool verifyUpdate() {
    isloading = true;
    notifyListeners();
    return true;
  }
}
