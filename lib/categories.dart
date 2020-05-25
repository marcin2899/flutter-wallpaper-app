import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'categoryScreen.dart';
import 'package:wallpaper_app/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        key: new PageStorageKey('CategoriesKey'),
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
                    "Categories",
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
            padding: EdgeInsets.fromLTRB(10, 10, 10, 80),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 15,
              childAspectRatio: 0.85,
              children: <Widget>[
                Category("Amoled"),
                Category("Gradient"),
                Category("Landscapes"),
                Category("Minimalist"),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Category extends StatefulWidget {
  String category;

  Category(String category) {
    this.category = category;
  }

  @override
  _CategoryState createState() => _CategoryState(category);
}

class _CategoryState extends State<Category> {
  String category;

  _CategoryState(String category) {
    this.category = category;
  }

  static FirebaseStorage storage = FirebaseStorage(app: null);
  static StorageReference storageRef = storage.ref().child("Categories");
  String _url;

  Future<String> _getImage() async {
    String u = await storageRef.child("$category.jpg").getDownloadURL();
    return u;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getImage(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/categoryScreen',
                  arguments: category,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 12,
                      child: Container(
                        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: ClipRRect(
                            borderRadius: new BorderRadius.circular(2),
                            child: CachedNetworkImage(imageUrl: snapshot.data, fit: BoxFit.cover)),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "$category",
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    )
                  ],
                ),
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
        });

    // return GestureDetector(
    //   onTap: () {
    //     Navigator.pushNamed(
    //       context,
    //       '/categoryScreen',
    //       arguments: category,
    //     );
    //   },
    //   child: Container(
    //     decoration: BoxDecoration(
    //         color: Colors.white,
    //         boxShadow: [
    //           BoxShadow(
    //             color: Color.fromRGBO(0, 0, 0, 0.2),
    //             offset: Offset(0, 1),
    //             blurRadius: 2,
    //           ),
    //         ],
    //         borderRadius: BorderRadius.circular(8)),
    //     child: Column(
    //       children: <Widget>[
    //         Expanded(
    //           flex: 12,
    //           child: Container(
    //             margin: EdgeInsets.only(top: 15, left: 15, right: 15),
    //             color: Colors.red,
    //           ),
    //         ),
    //         Expanded(
    //           flex: 2,
    //           child: Container(
    //             alignment: Alignment.center,
    //             child: Text(
    //               "$category",
    //               maxLines: 1,
    //                overflow: TextOverflow.clip,
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
