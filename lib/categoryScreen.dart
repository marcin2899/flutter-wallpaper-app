import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/model.dart';
import 'wallpaperViewScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class CategoryScreen extends StatefulWidget {
  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  static FirebaseStorage storage = FirebaseStorage(app: null);
  static StorageReference storageRef = storage.ref().child("Temp");
  final databaseReference = Firestore.instance;

  static Future<String> getUrl(int index) async {
    String url = await storageRef
        .child("Temp${categoryArray[index]}.jpg")
        .getDownloadURL();
    return url;
  }

  Future<List> _getCategoryArray(String category) async {
    DocumentReference docRef =
        databaseReference.collection("Collections").document("$category");
    DocumentSnapshot getRef = await docRef.get();
    setCategoryArray(getRef["id"]);
    return getRef["id"];
  }

  void setCategoryArray(List array) {
    categoryArray = array;
  }

  static var categoryArray;

  @override
  Widget build(BuildContext context) {
    final categoryName = ModalRoute.of(context).settings.arguments;
    return FutureBuilder<List>(
        future: _getCategoryArray(categoryName),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: BackgroundColor.backgroundColor,
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverAppBar(
                    iconTheme: IconThemeData(
                      color: Colors.black,
                    ),
                    backgroundColor: BackgroundColor.backgroundColor,
                    centerTitle: true,
                    title: Text(
                      "$categoryName",
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
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
                                    arguments: categoryArray[index]);
                                setState(() => WallpaperViewScreenState
                                    .setWallpaperMenuPos = 2.5);
                              },
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: CategoryScreenTile(index),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: categoryArray.length,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Container(
                width: percentageWidth(100, context),
                color: BackgroundColor.backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    AppBar(
                      elevation: 0,
                      backgroundColor: BackgroundColor.backgroundColor,
                      iconTheme: IconThemeData(
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: percentageHeight(25, context)),
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.black,
                        size: percentageHeight(20, context),
                      ),
                    ),
                    Material(
                      child: Text(
                        'Error Loading Images',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          backgroundColor: BackgroundColor.backgroundColor,
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Container(
                width: percentageWidth(100, context),
                color: BackgroundColor.backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: percentageHeight(6, context),
                      width: percentageWidth(6, context),
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}

class CategoryScreenTile extends StatefulWidget {
  int index;

  CategoryScreenTile(int index) {
    this.index = index;
  }

  @override
  _CategoryScreenTileState createState() => _CategoryScreenTileState(index);
}

class _CategoryScreenTileState extends State<CategoryScreenTile> {
  int index;

  _CategoryScreenTileState(int index) {
    this.index = index;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: CategoryScreenState.getUrl(index),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return ClipRRect(
            borderRadius: new BorderRadius.circular(8),
            child: CachedNetworkImage(imageUrl: snapshot.data, fit: BoxFit.cover)
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 40,
                ),
                Material(
                  child: Text(
                    'Error Loading Images',
                    style: TextStyle(
                      fontSize: percentageHeight(2.5, context),
                      color: Colors.red,
                      backgroundColor: Colors.white,
                    ),
                    maxLines: 3,
                  ),
                ),
              ],
            ),
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
