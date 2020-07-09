import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoplist/Models/UserModel.dart';
import 'package:shoplist/Views/Authenticate/Authenticate.dart';
import 'package:shoplist/Views/HomePage.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    //mostra home para usuarios logados ou tela de logar kkk
    if (user == null) {
      return Authenticate();
    } else {
      return HomePage();
    }
  }
}
