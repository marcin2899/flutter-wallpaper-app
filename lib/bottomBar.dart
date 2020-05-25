import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wallpaper_app/main.dart';
import 'package:wallpaper_app/model.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  void onButtonTapped(int i) {
    MyHomePageState.mainController.animateToPage(i,
        duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
  }

  Timer stateTimer;
  double previousPosition;

  @override
  void initState() {
    super.initState();
    previousPosition = MainScrollPosition.position;
    stateTimer = Timer.periodic(Duration(milliseconds: 16), (Timer t) {
      if ((MainScrollPosition.position - previousPosition).abs() > 0.001) {
        setState(() {
          previousPosition = MainScrollPosition.position;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        alignment: Alignment.center,
        height: 60,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 0),
              blurRadius: 1,
            )
          ],
          color: Color.fromRGBO(253, 253, 253, 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () => onButtonTapped(0),
                child: Container(
                  color: Color.fromRGBO(255, 255, 255, 0),
                  height: 60,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(),
                      Icon(
                        Icons.dashboard,
                        size: 27,
                        color: Color.fromRGBO(
                          ((((MainScrollPosition.position)*157).abs()).toInt()).clamp(0, 157),
                          ((((MainScrollPosition.position)*53).abs()+104).toInt()).clamp(0, 157),
                          ((-((MainScrollPosition.position)*74).abs()+231).toInt()).clamp(157, 255),
                          1
                           ),
                      ),
                      Text(
                        "Categories",
                        textScaleFactor:
                            ((-(MainScrollPosition.position * 2).abs()) + 1),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Color.fromRGBO(0,104,231,1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () => onButtonTapped(1),
                child: Container(
                  color: Color.fromRGBO(255, 187, 0, 0),
                  height: 60,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(),
                      Icon(
                        Icons.wallpaper,
                        size: 27,
                        color: Color.fromRGBO(
                          ((((MainScrollPosition.position-1)*157).abs()).toInt()).clamp(0, 157),
                          ((((MainScrollPosition.position-1)*53).abs()+104).toInt()).clamp(0, 157),
                          ((-((MainScrollPosition.position-1)*74).abs()+231).toInt()).clamp(157, 255),
                          1
                           ),
                        //color: Color.fromRGBO(0, 0, 0, (-((MainScrollPosition.position-1).abs()/2)+1).clamp(0.55, 1.0)),
                      ),
                      Text(
                        "Wallpapers",
                        textScaleFactor:
                            (-((MainScrollPosition.position * 2) - 2).abs()) +
                                1,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Color.fromRGBO(0,104,231,1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () => onButtonTapped(2),
                child: Container(
                  color: Color.fromRGBO(255, 255, 255, 0),
                  height: 60,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(),
                      Icon(
                        Icons.favorite,
                        size: 27,
                        color: Color.fromRGBO(
                          ((((MainScrollPosition.position-2)*157).abs()).toInt()).clamp(0, 157),
                          ((((MainScrollPosition.position-2)*53).abs()+104).toInt()).clamp(0, 157),
                          ((-((MainScrollPosition.position-2)*74).abs()+231).toInt()).clamp(157, 255),
                          1
                           ),
                      ),
                      Text(
                        "Favourites",
                        textScaleFactor:
                            (-((MainScrollPosition.position * 2) - 4).abs()) +
                                1,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Color.fromRGBO(0,104,231,1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
