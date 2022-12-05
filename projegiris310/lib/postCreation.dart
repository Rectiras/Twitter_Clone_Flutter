import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projegiris310/CreateText.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:projegiris310/databaseService.dart';
import 'package:projegiris310/styles.dart';
import 'InputWrapper.dart';
import 'colors.dart';

class PostCreation extends StatelessWidget {
  const PostCreation({Key key,this.analytics, this.observer}) : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false ,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        //title: Text("Sample"),
        title: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.body1,
            children: [
              TextSpan(text: '',
                style: TextStyle(
                  height: 1.171875,
                  fontSize: 17.0,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 0, 0, 0),
                  /* letterSpacing: 0.0, */
                ),
              ),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Icon(
                    Icons.add_circle_outlined,
                    size: 50.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,

        elevation: 0.0,
        backgroundColor: Colors.white,
      ),

      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [
                SizedBox(height: 40.0),

                OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => CreateText(analytics: analytics,observer: observer,),
                    ));},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Share Text',
                          style: TextStyle(
                            height: 1.171875,
                            fontSize: 25.0,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),

                        SizedBox(width: 40.0,),

                        Icon(
                          Icons.text_fields,
                          size: 35.0,
                          color: Colors.black,
                        ),

                      ],
                    ),

                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.grey[500],
                  ),
                ),

                SizedBox(height: 40.0),

                OutlinedButton(
                  onPressed: () {
                    //TODO: Implement Share Video
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Share Video',
                          style: TextStyle(
                            height: 1.171875,
                            fontSize: 25.0,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),

                        SizedBox(width: 20.0,),

                        Icon(
                          Icons.video_label,
                          size: 35.0,
                          color: Colors.black,
                        ),

                      ],
                    ),

                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.grey[500],
                  ),
                ),

                SizedBox(height: 40.0),

                OutlinedButton(
                  onPressed: () {
                    //TODO: Implement Share Photo
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Share Photo',
                          style: TextStyle(
                            height: 1.171875,
                            fontSize: 25.0,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),

                        SizedBox(width: 20.0,),

                        Icon(
                          Icons.photo,
                          size: 35.0,
                          color: Colors.black,
                        ),

                      ],
                    ),

                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.grey[500],
                  ),
                ),

              ],
          ),
        ],
      ),
    );
  }
}