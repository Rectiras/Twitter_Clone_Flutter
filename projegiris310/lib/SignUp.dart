import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:projegiris310/LoginPage.dart';
import 'package:projegiris310/databaseService.dart';
import 'package:projegiris310/styles.dart';
import 'InputWrapper.dart';
import 'colors.dart';

class SignUp extends  StatefulWidget{
  const SignUp({Key key, this.analytics, this.observer}) : super(key:key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _SignUpState createState() => _SignUpState();
}


class _SignUpState extends State<SignUp> {
  String mail;
  String pass;
  String pass2;
  String displayName;
  String uid;
  String bio;
  String url;
  int count = 0;
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  Future<void> SignUp() async {
    try {
      Navigator.pushNamed(context, '/LoginPage');
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: mail, password: pass,);
      //User({this.uid, this.displayName, this.mail, this.pass, this.bio, this.url});
      User user = userCredential.user;
      await DatabaseService(uid: user.uid).createUserData(user.email, this.displayName,this.bio, this.url,);

      print(userCredential.toString());
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      if(e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('This email address is already in use!')));
      }
      else if(e.code == 'weak-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Weak password, add uppercase, lowercase, digit, special character, emoji, etc.')));
      }
    }
  }



  Future<void> showAlertDialog(String title, String message) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, //User must tap button
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(message),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
  void initState() {
    super.initState();

    auth.authStateChanges().listen((User user) {
      if(user == null) {
        print('User is signed out');
      }
      else {
        print('User is signed in');
      }
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: BackButton(
            color: Colors.white

        ),
        backgroundColor: Color(0xFFD1D1D6),
        title: Text(
          'SIGN UP',
          style: kAppBarTitleTextStyle,
        ),
        centerTitle: true,

      ),
      body: Container(

        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, colors:[
            AppColors.secondary,
            AppColors.addition,
          ]),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            SizedBox(height: 60),

            Expanded(child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),

                  ),
                ),
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 16,),
                      Container(

                        decoration: BoxDecoration(
                            color: AppColors.headingColor,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(

                          children:<Widget> [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: AppColors.primary),
                                ),
                              ),
                              child: TextFormField(
                                  decoration: InputDecoration(
                                      hintText: 'Enter your email',
                                      hintStyle: hintTextStyle,
                                      border: InputBorder.none
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  // ignore: missing_return
                                  validator: (value){
                                    if(value.isEmpty){
                                      return 'Please enter your email';

                                    }
                                    if(!EmailValidator.validate(value)){
                                      return 'The email address is not valid';

                                    }
                                    return null;
                                  },
                                  onSaved: (String value) {
                                    mail= value;
                                  }




                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: AppColors.primary),
                                ),
                              ),
                              child: TextFormField(
                                  decoration: InputDecoration(
                                      hintText: 'Enter your user name',
                                      hintStyle: hintTextStyle,
                                      border: InputBorder.none
                                  ),
                                  keyboardType: TextInputType.text,

                                  enableSuggestions: false,
                                  autocorrect: false,
                                  // ignore: missing_return
                                  validator: (value){
                                    if(value.isEmpty){
                                      return 'Please enter user name';
                                    }
                                    if(value.length < 2){
                                      return 'The user name is too short';

                                    }
                                    return null;
                                  },
                                  onSaved: (String value) {
                                    displayName = value;
                                  }




                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: AppColors.primary)
                                ),
                              ),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: 'Enter your password',
                                    hintStyle: hintTextStyle,
                                    border: InputBorder.none
                                ),
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                validator: (value) {
                                  if(value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if(value.length < 8) {
                                    return 'Password must be at least 8 characters';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  pass = value;
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: AppColors.primary)
                                ),
                              ),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Enter your password again',
                                  hintStyle: hintTextStyle,
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                validator: (value) {
                                  if(value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if(value.length < 8) {
                                    return 'Password must be at least 8 characters';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  pass2 = value;
                                },
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.zero,

                              height: 50,
                              margin: EdgeInsets.zero,
                              decoration: BoxDecoration(

                                color: AppColors.headingColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),

                              child:OutlinedButton(
                                onPressed: () {

                                  if(_formKey.currentState.validate()) {
                                    _formKey.currentState.save();


                                    if(pass != pass2) {
                                      showAlertDialog("Error", 'Passwords must match');
                                    }


                                    else {
                                      SignUp();



                                    }
                                    //
                                    print(mail);
                                    setState(() {
                                      count += 1;
                                    });


                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: AppColors.secondary,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 145.0),
                                  //EdgeInsets.only(left: 135, right: 135, top: 12, bottom: 12)

                                ), child: Text("Register",
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.5,
                                ),


                              ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            ),
            ),
          ],
        ),
      ),
    );

  }
}
