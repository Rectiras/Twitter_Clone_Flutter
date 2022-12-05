import 'package:flutter/material.dart';
import 'package:projegiris310/searchLocation.dart';
import 'package:projegiris310/searchUsername.dart';
import 'package:projegiris310/searchPostContent.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';

import 'analytics.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}
class _SettingsPageState extends State<SearchPage>{
  static FirebaseAnalytics  analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  void initState(){
    super.initState();
    setCurrentScreen(widget.analytics, widget.observer, 'Search Page', 'SearchPageState');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor:Color.fromARGB(196, 196, 196, 196),
      ),
      body: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
            SizedBox(height: 100.0),

            OutlinedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => searchUsername(analytics: analytics,observer: observer,),
                ));},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      size: 30.0,
                      color: Colors.black,
                    ),

                    SizedBox(width: 30.0,),

                    Text(
                      'Username',
                      style: TextStyle(
                        height: 1.171875,
                        fontSize: 20.0,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),

                  ],
                ),

              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.grey[500],
              ),
            ),

            SizedBox(height: 30.0),

            OutlinedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => searchLocation(analytics: analytics,observer: observer,),
                ));},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      size: 30.0,
                      color: Colors.black,
                    ),

                    Text(
                      'Location',
                      style: TextStyle(
                        height: 1.171875,
                        fontSize: 20.0,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),

                    SizedBox(width: 30.0,),

                  ],
                ),

              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.grey[500],
              ),
            ),

            SizedBox(height: 30.0),

            OutlinedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => searchPostContent(analytics: analytics,observer: observer,),
                ));},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Row(
                  children: <Widget>[

                    Icon(
                      Icons.search,
                      size: 30.0,
                      color: Colors.black,
                    ),

                    Text(
                      'Post Content',
                      style: TextStyle(
                        height: 1.171875,
                        fontSize: 20.0,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),

                    SizedBox(width: 30.0),

                  ],
                ),

              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.grey[500],
              ),
            ),

            SizedBox(height: 30.0),

          ],
        ),
      ],
    ),
    );
  }
}
