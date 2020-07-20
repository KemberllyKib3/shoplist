import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class ItemModel extends Model {
  Firestore firestoreProvider;

  bool isloading = false;

  Map<String, dynamic> itemData = Map();

  // CRIAR UM NOVO ITEM
  void createItem(Map<String, dynamic> itemData) {
    // if (existeItem(itemData["nomeItem"])) {
    //   updateItem();
    // } else {
    //   Firestore.instance.collection("itens").add(itemData);
    // }
    Firestore.instance.collection("itens").add(itemData);
    notifyListeners();
  }

  bool existeItem(String nome) {
    if (Firestore.instance
            .collection("itens")
            .where("nomeItem".toLowerCase(), isEqualTo: nome.toLowerCase())
            .getDocuments() !=
        null) return true;
    return false;
  }

  setSearchParam(String nome) {
    List<String> splitList = nome.split(" ");
    List<String> indexList = [];

    for (int i = 0; i < splitList.length; i++) {
      for (int j = 1; j < splitList[i].length + 1; j++) {
        indexList.add(splitList[i].substring(0, j).toLowerCase());
      }
    }
    print(indexList);

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
