import 'package:flutter/material.dart';

double percentageHeight(double percentage, context) {
  return MediaQuery.of(context).size.height / 100 * percentage;
}

double percentageWidth(double percentage, context) {
  return MediaQuery.of(context).size.height / 100 * percentage;
}

class FavouritesWalls {
  final int id;

  FavouritesWalls({this.id});

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
    };
  }
}

class BackgroundColor {
  static Color backgroundColor = Color.fromRGBO(250, 252, 252, 1);
}

class MainScrollPosition {
  static double position = 1.0;
}