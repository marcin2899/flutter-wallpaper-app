import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/main.dart';
import 'package:wallpaper_app/model.dart';
import 'package:wallpaper_app/categoryScreen.dart';
import 'wallpaperViewScreen.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavouritesTab extends StatefulWidget {
  @override
  FavouritesTabState createState() => FavouritesTabState();
}

class FavouritesTabState extends State<FavouritesTab> {
  static var db;
  static List<Map<String, dynamic>> favList;

  Future<void> openDb() async {
    db = openDatabase(
      join(await getDatabasesPath(), 'fav_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE ids(id INTEGER PRIMARY KEY)",
        );
      },
      version: 1,
    );
  }

  Future<List<int>> loadFav() async {
    await openDb();

    Database database = await db;
    List<Map<String, dynamic>> maps = await database.query('ids');
    return List.generate(maps.length, (i) {
      favList = maps;
      return maps[i]['id'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadFav(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return Container(
              color: BackgroundColor.backgroundColor,
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverToBoxAdapter(
                      child: Container(
                        height: 45,
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Favourites",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SliverPadding(
                    padding: EdgeInsets.all(10),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 0.7,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/wallpaperViewScreen',
                                    arguments: snapshot.data[index]);
                                setState(() => WallpaperViewScreenState
                                    .setWallpaperMenuPos = 2.5);
                              },
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: FavouritesTabTile(index),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: snapshot.data.length,
                      ),
                    ),
                  ),
                ],
              ));
        } else {
          return Container(
            child: Text("snapshot has no data"),
          );
        }
      },
    );
  }
}

class FavouritesTabTile extends StatefulWidget {
  int index;
  FavouritesTabTile(int index) {
    this.index = index;
  }
  @override
  _FavouritesTabTileState createState() => _FavouritesTabTileState(index);
}

class _FavouritesTabTileState extends State<FavouritesTabTile> {
  int index;
  _FavouritesTabTileState(int index) {
    this.index = index;
  }
  static FirebaseStorage storagee = FirebaseStorage(app: null);
  static StorageReference storageReff = storagee.ref().child("Temp");
  final databaseReference = Firestore.instance;

  static Future<String> getUrl(int index) async {
    String number = FavouritesTabState.favList[index]['id'].toString();
    //print("getting url, index: " + index.toString());
    String url = await storageReff.child("Temp$number.jpg").getDownloadURL();
    //print("got url, index: " + index.toString());
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUrl(index),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return ClipRRect(
            borderRadius: new BorderRadius.circular(8),
            child: CachedNetworkImage(imageUrl: snapshot.data, fit: BoxFit.cover)
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
