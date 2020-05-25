import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpaper_app/main.dart';
import 'model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wallpaper_app/favouritesTab.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class WallpaperViewScreen extends StatefulWidget {
  @override
  WallpaperViewScreenState createState() => WallpaperViewScreenState();
}

class WallpaperViewScreenState extends State<WallpaperViewScreen> {
  static FirebaseStorage storage = FirebaseStorage(app: null);
  static StorageReference storageRef = storage.ref().child("Wallpapers");
  static double setWallpaperMenuPos = 2.5;

  Icon favIcon = Icon(Icons.favorite_border);

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: BackgroundColor.backgroundColor,
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                setWallpaperMenuPos = 2.5;
              });
            },
            child: BackgroundImage(index),
          ),
          Align(
            alignment: Alignment(0.87, -0.88),
            child: FavouriteButton(index),
          ),
          Align(
            /*Back Button*/
            alignment: Alignment(-0.87, -0.88),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                setWallpaperMenuPos = 2.5;
              },
              child: Container(
                height: 47,
                width: 47,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(0, 2),
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Icon(
                  Icons.arrow_back,
                  // /size: 30,
                  //color: Color.fromRGBO(140, 140, 140, 1),
                ),
                alignment: Alignment.center,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.91),
            child: GestureDetector(
              onTap: () {
                setState(() => setWallpaperMenuPos = 1);
              },
              child: Container(
                  height: 47,
                  width: 160,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.15),
                        offset: Offset(0, 4),
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Container(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.done,
                              color: Color.fromRGBO(0, 104, 231, 1),
                            )),
                      ),
                      Expanded(
                          flex: 10,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Set wallpaper",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(0, 104, 231, 1),
                                  fontSize: 16),
                            ),
                          )),
                    ],
                  )),
            ),
          ),
          SetWallpaperMenu()
        ],
      ),
    );
  }
}

class BackgroundImage extends StatefulWidget {
  int _index;

  BackgroundImage(index) {
    this._index = index;
  }

  @override
  BackgroundImageState createState() => BackgroundImageState(_index);
}

class BackgroundImageState extends State<BackgroundImage> {
  static FirebaseStorage storage = FirebaseStorage(app: null);
  static StorageReference storageRef = storage.ref().child("Wallpapers");
  static String urlF;
  int _n;

  Future<String> _getImage() async {
    String u = await storageRef.child("Wall$_n").getDownloadURL();
    urlF = u;
    return u;
  }

  BackgroundImageState(index) {
    _n = index;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getImage(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Stack(
            children: <Widget>[
              Center(
                child: SizedBox(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                  width: 40,
                  height: 40,
                ),
              ),
              Container(
                width: percentageWidth(100, context),
                child: CachedNetworkImage(
                    imageUrl: snapshot.data, fit: BoxFit.cover),
              )
            ],
          );
        } else {
          return Center(
            child: SizedBox(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
              ),
              width: 40,
              height: 40,
            ),
          );
        }
      },
    );
  }
}

class SetWallpaperMenu extends StatefulWidget {
  @override
  _SetWallpaperMenuState createState() => _SetWallpaperMenuState();
}

class _SetWallpaperMenuState extends State<SetWallpaperMenu> {
  static const platform =
      const MethodChannel("com.marcinkonwiak.minimalbackgrounds/wallpaper");

  Future<void> _setWallpaper(int wallpaperType) async {
    var file =
        await DefaultCacheManager().getSingleFile(BackgroundImageState.urlF);
    try {
      final int result = await platform
          .invokeMethod('setWallpaper', [file.path, wallpaperType]);
      resultMessage = "Wallpaper set";
    } on PlatformException catch (e) {
      resultMessage = "Failed to set wallpaper";
      //print("Failed to set wallpaper: ${e.message}");
    }
  }

  static String resultMessage;

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
        alignment: Alignment(0, WallpaperViewScreenState.setWallpaperMenuPos),
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.15),
                offset: Offset(0, -2),
                blurRadius: 5,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Material(
                          color: Colors.white,
                          child: Center(
                            child: Ink(
                              height: 60,
                              width: 60,
                              decoration: const ShapeDecoration(
                                color: Color.fromRGBO(232, 239, 253, 1),
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.home),
                                color: Colors.black,
                                onPressed: () async {
                                  await _setWallpaper(1);
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          Color.fromRGBO(51, 51, 51, 1),
                                      duration: Duration(seconds: 3),
                                      content: (Container(
                                        alignment: Alignment.centerLeft,
                                        height: 20,
                                        child: Text(
                                          resultMessage,
                                        ),
                                      )),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 90,
                        margin: EdgeInsets.only(top: 3),
                        child: Text(
                          "Homescreen",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Material(
                          color: Colors.white,
                          child: Center(
                            child: Ink(
                              height: 60,
                              width: 60,
                              decoration: const ShapeDecoration(
                                color: Color.fromRGBO(232, 239, 253, 1),
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.lock_outline),
                                color: Colors.black,
                                onPressed: () async {
                                  await _setWallpaper(2);
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          Color.fromRGBO(51, 51, 51, 1),
                                      duration: Duration(seconds: 3),
                                      content: (Container(
                                        alignment: Alignment.centerLeft,
                                        height: 20,
                                        child: Text(
                                          resultMessage,
                                        ),
                                      )),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 90,
                        margin: EdgeInsets.only(top: 3),
                        child: Text(
                          "Lockscreen",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Material(
                          color: Colors.white,
                          child: Center(
                            child: Ink(
                              height: 60,
                              width: 60,
                              decoration: const ShapeDecoration(
                                color: Color.fromRGBO(190, 209, 253, 0.8),
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.smartphone),
                                color: Colors.black,
                                onPressed: () async {
                                  await _setWallpaper(3);
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          Color.fromRGBO(51, 51, 51, 1),
                                      duration: Duration(seconds: 3),
                                      content: (Container(
                                        alignment: Alignment.centerLeft,
                                        height: 20,
                                        child: Text(
                                          resultMessage,
                                        ),
                                      )),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 90,
                        margin: EdgeInsets.only(top: 3),
                        child: Text(
                          "Both",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

class FavouriteButton extends StatefulWidget {
  int i;
  FavouriteButton(int index) {
    i = index;
  }

  @override
  _FavouriteButtonState createState() => _FavouriteButtonState(i);
}

class _FavouriteButtonState extends State<FavouriteButton> {
  int index;
  _FavouriteButtonState(int i) {
    index = i;
  }

  Future<void> insertWallToFav(int index) async {
    final Database database = await FavouritesTabState.db;

    await database.insert(
      'ids',
      FavouritesWalls(id: index).toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> deleteFromFav(int index) async {
    final Database database = await FavouritesTabState.db;

    await database.delete(
      'ids',
      where: "id = ?",
      whereArgs: [index],
    );
  }

  Future<bool> checkIfExists() async {
    final Database database = await FavouritesTabState.db;
    bool exists = false;
    var queryResult =
        await database.rawQuery('SELECT id FROM ids WHERE id = $index');
    queryResult.isNotEmpty ? exists = true : exists = false;
    return exists;
  }

  Color favColor = Colors.black;
  IconData favIcon = Icons.favorite_border;
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkIfExists(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true) {
            favColor = Color.fromRGBO(30, 130, 255, 1);
            favIcon = Icons.favorite;
            isFav = true;
            return GestureDetector(
              onTap: () {
                deleteFromFav(index);
                setState(() {});
              },
              child: Container(
                height: 47,
                width: 47,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(0, 2),
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Icon(
                  favIcon,
                  //size: percentageHeight(3.75, context),
                  color: favColor,
                ),
              ),
            );
          } else if (snapshot.data == false) {
            favColor = Colors.black;
            favIcon = Icons.favorite_border;

            return GestureDetector(
              onTap: () {
                insertWallToFav(index);
                setState(() {});
              },
              child: Container(
                height: 47,
                width: 47,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(0, 2),
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Icon(
                  favIcon,
                  //size: percentageHeight(3.75, context),
                  color: favColor,
                ),
              ),
            );
          }
        } else {
          return Container(
            width: 0.0,
            height: 0.0,
          );
        }
      },
    );
  }
}
