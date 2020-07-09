import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ItemModel extends Model {
  bool isloading = false;

  // CRIAR UM NOVO ITEM
  void createItem(Map<String, dynamic> itemData) {
    isloading = true;
    notifyListeners();
  }

  // ATUALIZA O ITEM SE FOR FEITA ALGUMA ALTERAÇÃO
  void updateItem() {
    isloading = true;
    notifyListeners();
  }

  // COLOCAR PREÇO E QUANTIDADE
  void addPriceQntdItem() {}
}
