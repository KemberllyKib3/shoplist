// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shoplist/Models/UserModel.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   //create user object based on FirebaseUser
//   UserModel _userFromFirebaseUser(FirebaseUser user) {
//     return user != null ? UserModel(uid: user.uid) : null;
//   }

//   //auth change user stream
//   Stream<UserModel> get user {
//     return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
//   }

//   //sign in anon
//   Future signInAnon() async {
//     try {
//       AuthResult result = await _auth.signInAnonymously();
//       FirebaseUser user = result.user;
//       return _userFromFirebaseUser(user);
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }

//   //criar conta
//   Future signUP(String email, String password) async {
//     try {
//       AuthResult result = await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       FirebaseUser user = result.user;
//       return _userFromFirebaseUser(user);
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }

//   //logar
//   Future signIn(String email, String password) async {
//     try {
//       AuthResult result = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       FirebaseUser user = result.user;
//       return _userFromFirebaseUser(user);
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }

//   //sair da conta
//   Future signOut() async {
//     try {
//       return await _auth.signOut();
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }

//   //recuperar senha
// }
