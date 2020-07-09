import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser; // DEFINICAO DO USUARIO DO FIREBASE
  Map<String, dynamic> userData = Map(); // ONDE FICAM OS DADOS DE EMAIL, NOME E CARGO

  bool isloading = false; // PARA CRIAR A TELA DE 'LOADING'

  // CRIAR UMA CONTA
  void signUp(@required Map<String, dynamic> userData, @required String pass, @required VoidCallback onSuccess, @required VoidCallback onFail) {
    isloading = true;
    notifyListeners();


  }
  // LOGAR QUANDO JA TEM CONTA
  void signIn(@required String email, @required String pass, @required VoidCallback onSuccess, @required VoidCallback onFail ) {
    isloading = true;
    notifyListeners();


  }
  // SAIR DA CONTA
  void signOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  // RECUPERAR A SENHA
  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  

}
