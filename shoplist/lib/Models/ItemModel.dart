import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class ItemModel extends Model {
  bool isloading = false;

  Map<String, dynamic> itemData = Map();

  // CRIAR UM NOVO ITEM
  void createItem(Map<String, dynamic> itemData) {
    if (existeItem(itemData["nomeItem"])) {
      updateItem();
    } else {
      Firestore.instance.collection("itens").add(itemData);
    }
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

  // PROCURA ITENS
  Future<void> searchItens(String nome) async {
    List<DocumentSnapshot> documentList = (await Firestore.instance
            .collection("itens")
            // .document(await firestoreProvider getUid())
            .document()
            .collection("nomeItem")
            .where("nomeItem", arrayContains: nome)
            .getDocuments())
        .documents;
  }

  setSearchParam(String nome) {
    List<String> nomeSearchList = List();
    String temp = "";
    for (int i = 0; i < nome.length; i++) {
      temp = temp + nome[i];
      nomeSearchList.add(temp);
    }
    return nomeSearchList;
  }

  // ATUALIZA O ITEM SE FOR FEITA ALGUMA ALTERAÇÃO
  void updateItem() {
    isloading = true;
    notifyListeners();
  }

  // COLOCAR PREÇO E QUANTIDADE
  void addPriceQntdItem() {}
}
