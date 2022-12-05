import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projegiris310/analytics.dart';

import 'databaseserviceprofile.dart';
import 'settings.dart';

class DeactivatePage extends StatefulWidget {
  const DeactivatePage({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _DeactivatePageState createState() => _DeactivatePageState();
}

class _DeactivatePageState extends State<DeactivatePage> {
  static FirebaseAnalytics  analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

    @override
    void initState() {
      super.initState();
      setCurrentScreen(widget.analytics, widget.observer, 'Deactivate Page', 'DeactivatePageState');
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deactivate Page'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 200),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () {
                    DatabaseServiceProfile().setDeactivated(false);
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Settings(analytics: widget.analytics, observer: widget.observer),
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'Activate',
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


          SizedBox(height: 50.0,),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _signOut();
                    Navigator.pop(context);
                    //Navigator.pop(context);
                    setLogEvent(widget.analytics, widget.observer, 'Account_is_activated',);
                    ScaffoldMessenger.of(context).
                    showSnackBar(SnackBar(content: Text('Activated')));


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

    );
  }

}
