import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:projegiris310/databaseService.dart';
import 'package:projegiris310/styles.dart';
import 'InputWrapper.dart';
import 'analytics.dart';
import 'colors.dart';
import 'databaseserviceprofile.dart';

DateTime timestamp = DateTime.now();

class CreateText extends StatefulWidget {
  CreateText({Key key, this.title, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  final String title;

  @override
  _CreateTextState createState() => _CreateTextState();
}

class _CreateTextState extends State<CreateText> {
  final _formKey = GlobalKey<FormState>();
  String text;
  String Pid;
  String displayName = myName;
  int attemptCount;
  final int MAX_LINES = 5;
  FirebaseAuth auth = FirebaseAuth.instance;



  void initState() {
    super.initState();
    timestamp = DateTime.now();
    setCurrentScreen(widget.analytics, widget.observer, 'Create Text Page', 'CreateTextState');
    //print('initState is called');
    DatabaseServiceProfile myservice = new DatabaseServiceProfile();
    myservice.getUserName2();
    attemptCount = 0;
    //getData();
  }




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
                    Icons.edit,
                    size: 35.0,
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

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 100.0),

            Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.only(right: 10, left: 10),
                height: MAX_LINES * 30.0,
                child: TextFormField(
                    maxLines: MAX_LINES,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Share your text',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                    ),
                    keyboardType: TextInputType.text,

                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please fill your text';
                      }

                      return null;
                    },

                    onSaved: (String value) {
                      text = value;
                    }

                ),
              ),
            ),

            SizedBox(height: 100.0),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save(); // run onSaved() functions
                        //showAlertDialog('Action', 'Button clicked');
                        PostService().createPostData(displayName, text);
                        setState(() {
                          attemptCount += 1; //attemptCount++;
                        });


                        setLogEvent(widget.analytics, widget.observer, 'Text_Post_Created', );
                        ScaffoldMessenger.of(context).
                        showSnackBar(SnackBar(content: Text('Text Post Created')));

                        Navigator.pop(context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          height: 1.171875,
                          fontSize: 17.0,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),

                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      //backgroundColor: AppColors.primary,
                      backgroundColor: Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}