import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:projegiris310/LoginPage.dart';
import 'package:projegiris310/profilePage.dart';
import 'package:projegiris310/settings.dart';
import 'package:projegiris310/LoginPage.dart';
import 'analytics.dart';
import 'databaseserviceprofile.dart';
import 'notificationPage.dart';
import 'postCard.dart';
import 'searchPage.dart';
import 'settings.dart';
import 'profilePage.dart';
import 'feedPage.dart';
import 'package:projegiris310/postCreation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';

class NavigationPage extends StatefulWidget {
  NavigationPage({Key key, this.title, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  final String title;


  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  static FirebaseAnalytics  analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);


  int _currentIndex = 0;

  final List<Widget> screens = [
    FeedPage(analytics: analytics,observer: observer,),
    SearchPage(analytics: analytics,observer: observer,),
    Settings(analytics: analytics,observer: observer,),
    ProfilePage(analytics: analytics,observer: observer,),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = LoginPage();

  @override
  void initState(){
    super.initState();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    DatabaseServiceProfile myservice = new DatabaseServiceProfile();
    myservice.getUserName2();
    myservice.getPrivacy();
    myservice.getBio();
    myservice.getImage();
    setCurrentScreen(widget.analytics, widget.observer, 'Navigation Page', 'NavigationPageState');
  }

  Widget build(BuildContext context) {

    return new Scaffold(
      body: PageStorage(
        child: screens[_currentIndex],
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black ,
        child: Icon(Icons.add),
        onPressed: () {
          //  Navigator.push(context, MaterialPageRoute(builder: (context) => EditPhoto())); // Edit profile picture page button
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => PostCreation(),
          ));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Feeds',
            backgroundColor: Colors.blueAccent,

          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            backgroundColor: Colors.teal,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.redAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.amber,
          ),
        ],
        currentIndex: _currentIndex,
        onTap:(index){
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
