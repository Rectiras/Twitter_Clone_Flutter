
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:projegiris310/databaseserviceprofile.dart';
import 'package:projegiris310/profilePage.dart';

import 'analytics.dart';


class EditBio extends StatefulWidget {
  EditBio({Key key, this.title, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  final String title;

  @override
  _EditBioState createState() => _EditBioState();
}

class _EditBioState extends State<EditBio> {
  final _formKey = GlobalKey<FormState>();
  String bio;
  int attemptCount;
  final int MAX_LINES = 5;

  @override
  void initState() {
    super.initState();
    setCurrentScreen(widget.analytics, widget.observer, 'Edit Bio Page', 'EditBioPageState');
    //print('initState is called');
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
                      hintText: 'Write your bio',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                    ),
                    keyboardType: TextInputType.text,

                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please fill you bio';
                      }

                      return null;
                    },

                    onSaved: (String value) {
                      bio = value;
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
                       // setState(() {
                        //  attemptCount += 1; //attemptCount++;
                        //});

                        DatabaseServiceProfile().setBio(bio);
                        setState(() {
                          myBio = bio;
                        });

                        setLogEvent(widget.analytics, widget.observer, 'Bio_is_Updated', );
                        ScaffoldMessenger.of(context).
                        showSnackBar(SnackBar(content: Text('Updated')));

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


