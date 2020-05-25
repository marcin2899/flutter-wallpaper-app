import 'package:flutter/material.dart';

class OptionsMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Info",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: <Widget>[
          Divider(),
          RaisedButton(
            elevation: 0,
            color: Colors.white,
            onPressed: () {Navigator.pushNamed(
                                    context,
                                    '/openSourceLicenses',
                                  );},
            child: Container(
              alignment: Alignment.centerLeft,
              height: 60,
              child: const Text(
                'Open Source Licenses',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
