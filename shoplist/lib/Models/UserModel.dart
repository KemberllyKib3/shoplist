import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoplist/Views/SignInPage.dart';

// class User {
//   final String uid;

//   User({this.uid});
// }

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;

  // DEFINICAO DO USUARIO DO FIREBASE
  FirebaseUser firebaseUser;

  // ONDE FICAM OS DADOS DE EMAIL, NOME E CARGO
  Map<String, dynamic> userData = Map();

  // PARA CRIAR A TELA DE 'LOADING'
  bool isloading = false; // PARA CRIAR A TELA DE 'LOADING'

  // CRIAR UMA CONTA
  void signUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    isloading = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
      email: userData["email"],
      password: pass,
    )
        .then((user) async {
      firebaseUser = user.user;
      await _saveUserData(userData);

      onSuccess();
      isloading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isloading = false;
      notifyListeners();
    });
  }

  // LOGAR QUANDO JA TEM CONTA
  void signIn(
      {@required String email,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isloading = true;
    notifyListeners();

    try {
      _auth
          .signInWithEmailAndPassword(email: email, password: pass)
          .then((user) async {
        firebaseUser = user.user;
        await _loadCurrentUser();

        onSuccess();

        isloading = false;
        notifyListeners();
      });
    } catch (e) {
      onFail();
      isloading = false;
      notifyListeners();
    }
  }

  // SAIR DA CONTA
  void signOut(context) async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SignInPage(),
      ),
    );
  }

  // RECUPERAR A SENHA
  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  Future<Null> _loadCurrentUser() async {
    // if (firebaseUser != null) firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      firebaseUser = await _auth.currentUser();
      if (userData["nome"] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .get();
        userData = docUser.data;
        notifyListeners();
      }
    }
  }
}
