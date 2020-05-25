import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wallpaper_app/categoryScreen.dart';
import 'package:wallpaper_app/favouritesTab.dart';
import 'package:wallpaper_app/wallpaperViewScreen.dart';
import 'package:wallpaper_app/categories.dart';
import 'package:wallpaper_app/model.dart';
import 'package:wallpaper_app/openSourceLicenses.dart';
import 'package:wallpaper_app/optionsMenu.dart';
import 'package:wallpaper_app/wallpaperGrid.dart';
import 'package:wallpaper_app/featuredScroll.dart';
import 'package:wallpaper_app/bottomBar.dart';

// void main() => runApp(MyApp());
class CustomImageCache extends WidgetsFlutterBinding {
  @override
  ImageCache createImageCache() {
    ImageCache imageCache = super.createImageCache();
    // Set your image cache size
    imageCache.maximumSizeBytes = 1024 * 1024 * 400; // 400 MB
    return imageCache;
  }
}

void main() async {
  try {CustomImageCache();}
  on Exception catch(e) {
    print(e);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallpapers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Open Sans',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'Wallpapers'),
        '/wallpaperViewScreen': (context) => WallpaperViewScreen(),
        '/categoryScreen': (context) => CategoryScreen(),
        '/optionsMenu': (context) => OptionsMenu(),
        '/openSourceLicenses': (context) => OpenSourceLicenses(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static double mainScrollPosition = 1;
  static final mainController =
      PageController(initialPage: 1, viewportFraction: 0.999);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BackgroundColor.backgroundColor,
        body: SafeArea(
          child: Center(
            child: Stack(children: <Widget>[
              NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (notification is ScrollUpdateNotification) {
                    MainScrollPosition.position = mainController.page;
                  }
                },
                child: PageView(
                  controller: mainController,
                  children: <Widget>[
                    CategoriesScreen(),
                    WallpaperGrid(),
                    FavouritesTab(),
                  ],
                ),
              ),
              BottomBar(),
            ]),
          ),
        ));
  }
}
