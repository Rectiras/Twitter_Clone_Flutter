import 'package:firebase_auth/firebase_auth.dart';
import 'package:projegiris310/changeusername.dart';
import 'package:projegiris310/deactivatePage.dart';
import 'package:projegiris310/deleteaccount.dart';
import 'package:projegiris310/navigationPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projegiris310/passwordchange.dart';

import 'analytics.dart';
import 'databaseserviceprofile.dart';

class Settings extends StatefulWidget {
  Settings({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static FirebaseAnalytics  analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
  @override
  void initState(){
    super.initState();
    setCurrentScreen(widget.analytics, widget.observer, 'Settings Page', 'SettingsPageState');
  }
  Future<void> ChangePassword(String newPassword) async {
    User user = FirebaseAuth.instance.currentUser;
    user.updatePassword(newPassword).then((_){
      print("Successfully changed password");
    }).catchError((error){
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false ,
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        //centerTitle: true,
        elevation: 0.0,
        backgroundColor:Color.fromARGB(196, 196, 196, 196),
      ),

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 150.0,
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () {

                      Navigator.push(context, MaterialPageRoute(builder: (context) =>ChangeUsername(analytics: analytics,observer: observer,)));
                      //Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Change Username',
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

                SizedBox(width: 8.0,),


              ],
            ),
            SizedBox(height: 10,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () {

                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditPassword(analytics: analytics,observer: observer,)));
                      //Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Change Password',
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

                SizedBox(width: 8.0,),


              ],
            ),

            SizedBox(height: 10.0,),

            /*Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () {
                      setLogEvent(widget.analytics, widget.observer, 'Followings_are_updated', );
                      ScaffoldMessenger.of(context).
                      showSnackBar(SnackBar(content: Text('Updated')));

                      //Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        'Manage followings',
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

                SizedBox(width: 8.0,),

                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () {
                      setLogEvent(widget.analytics, widget.observer, 'Subscriptions_are_updated', );
                      ScaffoldMessenger.of(context).
                      showSnackBar(SnackBar(content: Text('Updated')));

                      //Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(
                        'Manage subscriptions',
                        //'as'
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
            ),*/

            SizedBox(height: 8.0,),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () {
                      DatabaseServiceProfile().setDeactivated(true);
                      Navigator.pop(context);
                      setLogEvent(widget.analytics, widget.observer, 'Account_is_deactivated', );
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => DeactivatePage(analytics: widget.analytics, observer: widget.observer),
                      ));
                      ScaffoldMessenger.of(context).
                      showSnackBar(SnackBar(content: Text('Deactivated')));

                      //Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Deactivate account',
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

                SizedBox(width: 8.0,),

                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => deleteaccount(analytics: analytics,observer: observer,)));
                      //Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Delete account',
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

            Container(
              height: 100.0,
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () {
                      _signOut();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      setLogEvent(widget.analytics, widget.observer, 'User_signed_out', );
                      ScaffoldMessenger.of(context).
                      showSnackBar(SnackBar(content: Text('Signing out')));


                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'Sign Out',
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
