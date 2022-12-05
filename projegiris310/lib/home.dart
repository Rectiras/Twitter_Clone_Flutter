import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:projegiris310/LoginPage.dart';
import 'package:projegiris310/editPhoto.dart';
import 'package:projegiris310/profilePage.dart';
import 'package:projegiris310/settings.dart';
import 'package:projegiris310/notificationPage.dart';
import 'searchLocation.dart';
import 'navigationPage.dart';

class Home extends StatefulWidget {
  const Home({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
  }
}
