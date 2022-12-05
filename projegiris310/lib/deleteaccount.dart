
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projegiris310/databaseserviceprofile.dart';
import 'package:projegiris310/profilePage.dart';

import 'analytics.dart';


class deleteaccount extends StatefulWidget {
  deleteaccount({Key key, this.title, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  final String title;

  @override
  _deleteaccountState createState() => _deleteaccountState();
}

class _deleteaccountState extends State<deleteaccount> {
  static FirebaseAnalytics  analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  final _formKey3 = GlobalKey<FormState>();
  String bio;
  int attemptCount;
  final int MAX_LINES = 5;
  String myemail;
  String myoldpass;
  String mynewpass;
  @override
  void initState() {
    super.initState();
    setCurrentScreen(widget.analytics, widget.observer, 'Delete Account Page', 'deleteaccountState');
    //print('initState is called');
    attemptCount = 0;
    //getData();
  }
  Future<void> Deleteaccount(String email,String oldPassword) async {
    User user = FirebaseAuth.instance.currentUser;
    AuthCredential credential = EmailAuthProvider.credential(email: email, password: oldPassword);
    await user.reauthenticateWithCredential(credential);
    FirebaseFirestore.instance.collection('users').doc(Globaluid).delete();
    user.delete();
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
            SizedBox(height: 50.0),
            Container(
              margin: const EdgeInsets.only(right: 10, left: 10),
              height: 60,
              child: Text('Are you sure to delete your account ?'),
            ),

            Form(
              key: _formKey3,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10, left: 10),
                    height: 60,
                    child: TextFormField(
                        maxLines: MAX_LINES,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Write your email',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          ),
                        ),
                        keyboardType: TextInputType.text,

                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please fill you email';
                          }

                          return null;
                        },

                        onSaved: (String value) {
                          myemail = value;
                        }

                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    margin: const EdgeInsets.only(right: 10, left: 10),
                    height: 60,
                    child: TextFormField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Write your old password',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          ),
                        ),
                        keyboardType: TextInputType.text,

                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please fill you old password';
                          }

                          return null;
                        },

                        onSaved: (String value) {
                          myoldpass = value;
                        }

                    ),
                  ),
                  SizedBox(height: 30,),
                ],
              ),
            ),



            SizedBox(height: 50.0),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () {
                      if (_formKey3.currentState.validate()) {
                        _formKey3.currentState.save(); // run onSaved() functions
                        //showAlertDialog('Action', 'Button clicked');
                        // setState(() {
                        //  attemptCount += 1; //attemptCount++;
                        //});

                        Deleteaccount(myemail,myoldpass);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        setLogEvent(widget.analytics, widget.observer, 'Account_is_Deleted', );
                        ScaffoldMessenger.of(context).
                        showSnackBar(SnackBar(content: Text('Deleted')));
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


