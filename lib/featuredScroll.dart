import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:wallpaper_app/wallpaperViewScreen.dart';

class FeaturedScroll extends StatefulWidget {
  @override
  _FeaturedScrollState createState() => _FeaturedScrollState();
}

class _FeaturedScrollState extends State<FeaturedScroll> {
  static FirebaseStorage storage = FirebaseStorage(app: null);
  static StorageReference storageRef = storage.ref();
  static StorageReference firstRef = storageRef.child('Featured/featured1');
  static StorageReference secondRef =
      storageRef.child('Featured/featured2');
  static StorageReference thirdRef = storageRef.child('Featured/featured3');
  static double pageS = 1;

  static String _url1, _url2, _url3;

  Future<String> _getFileUrl(StorageReference sr) async {
    String _url = await sr.getDownloadURL();
    return _url;
  }

  _FeaturedScrollState() {
    _getFileUrl(firstRef).then((val) => setState(() {
          _url1 = val;
        }));
    _getFileUrl(secondRef).then((val) => setState(() {
          _url2 = val;
        }));
    _getFileUrl(thirdRef).then((val) => setState(() {
          _url3 = val;
        }));
  }

  static final controller =
      PageController(initialPage: 1, viewportFraction: 0.65);
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollUpdateNotification) {
          setState(() {
            pageS = controller.page;
          });
        }
      },
      child: PageView(
        physics: BouncingScrollPhysics(),
        key: PageStorageKey('FeaturedKey'),
        controller: controller,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/wallpaperViewScreen',
                  arguments: 15);
              setState(
                  () => WallpaperViewScreenState.setWallpaperMenuPos = 2.5);
            },
            child: AnimatedContainer(
                margin: EdgeInsets.all(
                    (((pageS.abs() * 0.3)).clamp(0.0, 1.0) * 110)
                        .clamp(10.0, 100.0)),
                duration: Duration(milliseconds: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Color.fromRGBO(0, 0, 0, 0.25),
                  //     offset: Offset(0, 2),
                  //     blurRadius: 3,
                  //   )
                  // ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: (_url1 != null)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(imageUrl: _url1, fit: BoxFit.cover))
                        //Image.network(_url1, fit: BoxFit.cover))
                    : null),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/wallpaperViewScreen',
                  arguments: 26);
              setState(
                  () => WallpaperViewScreenState.setWallpaperMenuPos = 2.5);
            },
            child: AnimatedContainer(
                duration: Duration(milliseconds: 16),
                margin: EdgeInsets.all(
                    ((((pageS - 1).abs() * 0.3)).clamp(0.0, 1.0) * 110)
                        .clamp(10.0, 100.0)),
                decoration: BoxDecoration(
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Color.fromRGBO(0, 0, 0, 0.25),
                  //     offset: Offset(0, 2),
                  //     blurRadius: 3,
                  //   )
                  // ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: (_url2 != null)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(imageUrl: _url2, fit: BoxFit.cover))
                    : null),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/wallpaperViewScreen',
                  arguments: 30);
              setState(
                  () => WallpaperViewScreenState.setWallpaperMenuPos = 2.5);
            },
            child: AnimatedContainer(
                duration: Duration(milliseconds: 16),
                margin: EdgeInsets.all(
                    ((((pageS - 2).abs() * 0.3)).clamp(0.0, 1.0) * 110)
                        .clamp(10.0, 100.0)),
                decoration: BoxDecoration(
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Color.fromRGBO(0, 0, 0, 0.25),
                  //     offset: Offset(0, 2),
                  //     blurRadius: 3,
                  //   )
                  // ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: (_url3 != null)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(imageUrl: _url1, fit: BoxFit.cover))
                    : null),
          ),
        ],
      ),
    );
  }
}
