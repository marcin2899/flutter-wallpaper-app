import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/featuredScroll.dart';
import 'package:wallpaper_app/model.dart';
import 'wallpaperViewScreen.dart';
import 'dart:async';

class WallpaperGrid extends StatefulWidget {
  @override
  _WallpaperGridState createState() => _WallpaperGridState();
}

class _WallpaperGridState extends State<WallpaperGrid> {
  final databaseReference = Firestore.instance;

  Future<int> _getAmount() async {
    DocumentReference docRef =
        databaseReference.collection("Wallpapers").document('WallpaperInfo');
    DocumentSnapshot getRef = await docRef.get();
    return getRef["amount"];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getAmount(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              Expanded(
                child: CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  key: PageStorageKey('NewKey'),
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Container(
                        height: 45,
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: percentageWidth(10, context),
                            ),
                            Text(
                              "Wallpapers",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              width: percentageWidth(10, context),
                              child: IconButton(
                                icon: Icon(Icons.help_outline),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/optionsMenu',
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.2),
                              offset: Offset(0, 1),
                              blurRadius: 2,
                            )
                          ],
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              alignment: Alignment(-0.92, 0),
                              child: Text(
                                "Featured",
                                textScaleFactor: 1.2,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            Container(
                              // width: percentageWidth(1, context),
                              height: percentageHeight(35, context),
                              child: FeaturedScroll(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        alignment: Alignment(-0.92, 0.5),
                        height: 40,
                        child: Text(
                          "Lastest",
                          textScaleFactor: 1.2,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700]),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 80),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20.0,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: 0.6,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/wallpaperViewScreen',
                                    arguments: snapshot.data - index);
                                setState(() => WallpaperViewScreenState
                                    .setWallpaperMenuPos = 2.5);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Color.fromRGBO(0, 0, 0, 0.9),
                                    //     offset: Offset(0, 0),
                                    //     spreadRadius: 0.5,
                                    //   )
                                    // ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Stack(
                                  children: <Widget>[
                                    Center(
                                      child: SizedBox(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Colors.black),
                                        ),
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                  child: WallpaperGridTile(
                                                      snapshot.data - index)),
                                            ],
                                          ),
                                          flex: 9,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: snapshot.data,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return Center(
          child: SizedBox(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
            ),
            width: 40,
            height: 40,
          ),
        );
      },
    );
  }
}

class WallpaperGridTile extends StatefulWidget {
  int _index = 0;

  WallpaperGridTile(index) {
    this._index = index;
  }

  @override
  _WallpaperGridTileState createState() => _WallpaperGridTileState(_index);
}

class _WallpaperGridTileState extends State<WallpaperGridTile> {
  static FirebaseStorage storage = FirebaseStorage(app: null);
  static StorageReference storageRef = storage.ref().child("Temp");
  String _url;
  int _n;

  Future<String> _getImage() async {
    String u = await storageRef.child("Temp$_n.jpg").getDownloadURL();
    return u;
  }

  _WallpaperGridTileState(index) {
    _n = index;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getImage(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return ClipRRect(
            borderRadius: new BorderRadius.circular(8),
            child: CachedNetworkImage(imageUrl: snapshot.data, fit: BoxFit.cover),
            //  Image.network(snapshot.data, fit: BoxFit.cover)
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
