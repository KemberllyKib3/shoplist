import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shoplist/Views/SignInPage.dart';
import 'package:shoplist/custom_icons_icons.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 5),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SignInPage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 60,
                      child: Icon(
                        CustomIcons.shop,
                        size: 75,
                        color: Theme.of(context).primaryColor,
                      ),
                      backgroundColor: Colors.white.withOpacity(0.9),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Shop",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                color: Theme.of(context).cursorColor,
                                offset: Offset(2, 2),
                              )
                            ],
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'Helvetica',
                          ),
                        ),
                        Text(
                          "List",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                color: Theme.of(context).cursorColor,
                                offset: Offset(2, 2),
                              )
                            ],
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'Helvetica',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        "Desenvolvido por:\nGrupo 1",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
