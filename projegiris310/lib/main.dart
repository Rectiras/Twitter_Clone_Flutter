import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';


import 'package:projegiris310/SignUp.dart';
import 'package:projegiris310/deactivatePage.dart';
import 'package:projegiris310/feedPage.dart';
import 'package:projegiris310/navigationPage.dart';
import 'package:projegiris310/passwordchange.dart';
import 'package:projegiris310/searchPage.dart';
import 'package:projegiris310/settings.dart';
import 'package:projegiris310/welcome.dart';
import 'package:projegiris310/welcome2.dart';
import 'package:projegiris310/profilePage.dart';
import 'Comments.dart';
import 'LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'changeusername.dart';
import 'notificationPage.dart';
import 'notificationPrivPage.dart';
import 'package:projegiris310/home.dart';
import 'navigationPage.dart';
import 'ProfilePublicPage.dart';
import 'ProfilePrivPage.dart';
import 'ProfilePublicNotFollowedPage.dart';


SharedPreferences prefs;
int initScreen;
String privacy;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  //await prefs.setInt("initScreen",0);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  //The crashlytics work on other pages too as it detects when any part of project crashes.

  initScreen = await prefs.getInt("initScreen");
  privacy = await prefs.getString('privacy');
  privacyStatus = privacy;
  print('initScreen $initScreen');
  print('privacy $privacy');
  //FirebaseCrashlytics.instance.crash(); //This is the Crash try out part
  runApp(MyApp());

}
class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static FirebaseAnalytics  analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
   return new MaterialApp(
     navigatorObservers: <NavigatorObserver> [observer],
     debugShowCheckedModeBanner: false,
     initialRoute: initScreen == 0 || initScreen == null

         ? "/welcome"
         : "/welcome2",

     routes: {
       //'/': (context) => SplashScreen(),
       '/welcome': (context) => Welcome(analytics: analytics,observer: observer,),
       '/welcome2' : (context) => Welcome2(analytics: analytics,observer: observer,),
       '/LoginPage': (context) => LoginPage(analytics: analytics,observer: observer,),
       '/SignUp': (context) => SignUp(analytics: analytics,observer: observer, ),
       '/profile' : (context) => ProfilePage(analytics: analytics,observer: observer, ),
       '/notificationPub': (context) => NotificationView(analytics: analytics,observer: observer, ),
       '/notificationPriv' : (context) => NotificationPrivView(analytics: analytics,observer: observer, ),
       '/searchPage' : (context) => SearchPage(analytics: analytics,observer: observer, ),
       '/feedPage' : (context) => FeedPage(analytics: analytics,observer: observer, ),
       '/navigationPage' : (context) => NavigationPage(analytics: analytics,observer: observer, ),
       '/settingsPage': (context) => Settings(analytics: analytics,observer: observer, ),
       '/passwordChange': (context) => EditPassword(analytics: analytics,observer: observer, ),
       '/changeusername': (context) => ChangeUsername(analytics: analytics,observer: observer, ),
       '/ProfilePublicPage': (context) => ProfilePublicPage(analytics: analytics,observer: observer, ),
       '/ProfilePrivPage': (context) => ProfilePrivPage(analytics: analytics,observer: observer, ),
       '/ProfilePublicNotFollowedPage': (context) => ProfilePublicNotFollowedPage(analytics: analytics,observer: observer, ),
       '/Comments': (context) => Comments(),
       '/deactivatePage': (context) => DeactivatePage(analytics: analytics, observer: observer),
     },
      home: Home(analytics: analytics, observer: observer),
   );
  }
}






