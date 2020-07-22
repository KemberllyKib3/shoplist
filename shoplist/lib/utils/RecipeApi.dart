class RecipesApi {
  List<Receitas> receitas;

  RecipesApi({this.receitas});

  RecipesApi.fromJson(Map<String, dynamic> json) {
    if (json['receitas'] != null) {
      receitas = new List<Receitas>();
      json['receitas'].forEach((v) {
        receitas.add(new Receitas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.receitas != null) {
      data['receitas'] = this.receitas.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Receitas {
  String receita;
  String ingredientes;
  IngredientesBase ingredientesBase;
  String modoPreparo;
  String linkImagem;

  Receitas(
      {this.receita,
      this.ingredientes,
      this.ingredientesBase,
      this.modoPreparo,
      this.linkImagem});

  Receitas.fromJson(Map<String, dynamic> json) {
    receita = json['receita'];
    ingredientes = json['ingredientes'];
    ingredientesBase = json['ingredientesBase'] != null
        ? new IngredientesBase.fromJson(json['ingredientesBase'])
        : null;
    modoPreparo = json['modoPreparo'];
    linkImagem = json['link_imagem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['receita'] = this.receita;
    data['ingredientes'] = this.ingredientes;
    if (this.ingredientesBase != null) {
      data['ingredientesBase'] = this.ingredientesBase.toJson();
    }
    data['modoPreparo'] = this.modoPreparo;
    data['link_imagem'] = this.linkImagem;
    return data;
  }
}

class IngredientesBase {
  String s0;
  String s1;
  String s2;
  String s3;
  String s4;

  IngredientesBase({this.s0, this.s1, this.s2, this.s3, this.s4});

  IngredientesBase.fromJson(Map<String, dynamic> json) {
    s0 = json['0'];
    s1 = json['1'];
    s2 = json['2'];
    s3 = json['3'];
    s4 = json['4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['0'] = this.s0;
    data['1'] = this.s1;
    data['2'] = this.s2;
    data['3'] = this.s3;
    data['4'] = this.s4;
    return data;
  }
}
