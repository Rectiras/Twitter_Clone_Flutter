import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:projegiris310/colors.dart';
import 'package:projegiris310/home.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:projegiris310/colors.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:email_validator/email_validator.dart';


import 'Button.dart';
import 'InputWrapper.dart';
import 'analytics.dart';
import 'databaseserviceprofile.dart';

class LoginPage extends StatefulWidget{

  LoginPage({Key key, this.analytics, this.observer}) : super(key:key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String _message = '';
  String mail;
  String pass;

  void setMessage (String msg){
    setState(() {
      _message = msg;
      print(_message);
    });
  }


  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future <void> loginUser() async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: mail, password: pass);
      Globaluid = userCredential.user.uid;
      DatabaseServiceProfile databaseServiceProfile = DatabaseServiceProfile();
      bool isDeactivated = await databaseServiceProfile.getDeactivated();

      if (isDeactivated) {
        Navigator.pushNamed(context, '/deactivatePage');
      }
      else {
        Navigator.pushNamed(context, '/navigationPage');
      }
    } on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found'){
          setMessage('User is not found');
      }
      else if(e.code == 'wrong-password'){
          setMessage('Please check your password');
      }
      print('nothing');
    }
    print(mail);
    print(pass);
    print(Globaluid);
  }
  @override
  void initState(){
    super.initState();
    setCurrentScreen(widget.analytics, widget.observer, 'Login Page', 'LoginPageState');
    auth.authStateChanges().listen((User user) {
      if(user == null)
        {
          print('user is signed out');
        }
      else
        {
          //Navigator.pushNamed(context, '/navigationPage');
          print('user is signed in');
        }
    });
  }
  
  @override
  Widget build(BuildContext context){
    final _formalKey2 = GlobalKey<FormState>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFD1D1D6),
        title: Text(
          'Login',
          style: TextStyle(
              letterSpacing: -1,
              color: Color(0xFF757575),
              fontSize: 20
          ),
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
        child: Column(
          children: <Widget> [
            SizedBox(height: 60),

            Expanded(child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 16,),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.headingColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Form(key: _formalKey2, child:

                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: AppColors.primary)
                              ),
                            ),
                            child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Enter your email",
                                    hintStyle: TextStyle(color: AppColors.textColor),
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
                                  bottom: BorderSide(color: AppColors.primary)
                              ),
                            ),
                            child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Enter your password",
                                    hintStyle: TextStyle(color: AppColors.textColor),
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
                                  return null;
                                },
                                onSaved: (String value) {
                                  pass= value;
                                }
                            ),
                          ),
                        ],
                      ),
                      ),
                    ),
                    SizedBox(height: 16,),
                    Text(
                      "Forgot Password",
                      style: TextStyle(color: Color(0xFF757575)),
                    ),
                    SizedBox(height: 16,),
                    Container(
                      height: 45,
                      margin: EdgeInsets.symmetric(horizontal: 0),
                      decoration: BoxDecoration(
                          color: AppColors.headingColor,
                          borderRadius: BorderRadius.circular(0)
                      ),
                      child: Center(
                        child: OutlinedButton(
                          child:Text(
                            "Login",
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          onPressed: () {
                            if(_formalKey2.currentState.validate()) {
                              _formalKey2.currentState.save();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                  SnackBar(content: Text('Logging in')));
                              loginUser();
                              //Navigator.pushNamed(context, '/navigationPage');
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 170.0),
                            //EdgeInsets.only(left: 172, right: 172, top: 15, bottom: 15)
                          ),
                        ),
                      ),
                    ),
                    Text(
                      _message,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),

            )),
            InkWell(
              onTap: () {
                signInWithGoogle();
              },
              child: Ink(

                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(Icons.android), // <-- Use 'Image.asset(...)' here
                      SizedBox(width: 8),
                      Text('Login with Google'),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      //bottomNavigationBar: Home(),
    );
  }
}
