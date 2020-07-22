import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Carregando",
            style: TextStyle(
              color: Theme.of(context).cursorColor,
              fontSize: 20,
              fontFamily: 'Helvetica',
            ),
          ),
        ),
      ],
    );
  }
}
