import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:projegiris310/home.dart';
import 'package:projegiris310/bookmark.dart';
import 'analytics.dart';
import 'main.dart';
import 'editBio.dart';
import 'editPhoto.dart';
import 'searchUsername.dart';
import 'settings.dart';
import 'userProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'databaseserviceprofile.dart';


class ProfilePublicNotFollowedPage extends StatefulWidget {

  ProfilePublicNotFollowedPage({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _ProfilePublicNotFollowedPageState createState() => _ProfilePublicNotFollowedPageState();
}

class _ProfilePublicNotFollowedPageState extends State<ProfilePublicNotFollowedPage> {
  static FirebaseAnalytics  analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);


  UserProfile user;
  @override
  void initState() {
    super.initState();
    DatabaseServiceProfile myservice = new DatabaseServiceProfile();
    user = new UserProfile(username: globaluname, bio: globalBio,
        followers: 56, following: 1278, locations: 24);
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      appBar: new AppBar(
        backgroundColor:Color.fromARGB(196, 196, 196, 196),
        title: new Text('Profile'),
        elevation: 0.0,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 0.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: //AssetImage('assets/images/748688d7b0223fa6714f4dfee4050154a8a0fd9f.png'),
                    NetworkImage(globalImgurl),
                    radius: 70.0,
                  ),
                  SizedBox(width: 30,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '@' + user.username,
                        //'@janedoe',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,

                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox( height:20.0,),
              Column(
                children: <Widget>[
                  Text(
                    //'Sabancı University - Computer Science Wanderlust 🌍',
                    globalBio
                  ),
                ],
              ),
              SizedBox( height:20.0,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/SignUp'),//connect with followers page
                        child: Container(
                          width: 153.0,
                          height: 69.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                          ),


                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Container(
                              color: Color.fromARGB(196, 196, 196, 196),
                              child: Center(
                                child: Text(
                                  '''566''',
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    height: 1.171875,
                                    fontSize: 18.0,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 0, 0, 0),

                                    /* letterSpacing: 0.0, */
                                  ),
                                ),
                              ),
                            ),
                          ),



                        ),
                      ),
                      SizedBox( height:10.0,),
                      Text(
                        '''Followers''',
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          height: 1.171875,
                          fontSize: 18.0,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 0, 0, 0),

                          /* letterSpacing: 0.0, */
                        ),
                      ),

                    ],
                  ),
                  SizedBox(width: 16,),
                  SizedBox(width: 16,),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/LoginPage'),//connect with followings page
                        child: Container(
                          width: 153.0,
                          height: 69.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Container(
                              color: Color.fromARGB(196, 196, 196, 196),
                              child: Center(
                                child: Text(
                                  '''1278''',
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    height: 1.171875,
                                    fontSize: 18.0,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 0, 0, 0),

                                    /* letterSpacing: 0.0, */
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox( height:10.0,),
                      Text(
                        '''Following''',
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          height: 1.171875,
                          fontSize: 18.0,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 0, 0, 0),

                          /* letterSpacing: 0.0, */
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox( height:20.0,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/SignUp'),//follow unfollow button
                        child: Container(
                          width: 153.0,
                          height: 69.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                          ),

                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Container(
                              color: Color.fromARGB(196, 196, 196, 196),
                              child: Center(
                                child: Text(
                                  '''Follow''',
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    height: 1.171875,
                                    fontSize: 18.0,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 255, 255, 255),

                                    /* letterSpacing: 0.0, */
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],

              ),
              SizedBox( height:20.0,),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 350.00,
                    height: 230.00,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: ExactAssetImage('assets/images/53a6b7fc3ab7fa9fb90d8da26f47282fd42414cf.png'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  SizedBox( height:15.0,),
                  Container(
                    width: 350.00,
                    height: 230.00,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: ExactAssetImage('assets/images/ea543d4a83f5ccc6f95009b77100981a8f0557e6.png'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  SizedBox( height:15.0,),
                  Container(
                    width: 350.00,
                    height: 230.00,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: ExactAssetImage('assets/images/fe3901ed2c5304afe5578b99e5f22dd975c82dfa.png'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  SizedBox( height:15.0,),
                  Container(
                    width: 350.00,
                    height: 230.00,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: ExactAssetImage('assets/images/8cd72352b7a4d79a640dc425860f59baffd23d82.png'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      //Bottom Navigation Bar will be here!!

    );
  }
}