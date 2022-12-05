import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:projegiris310/home.dart';
import 'package:projegiris310/bookmark.dart';
import 'package:projegiris310/postCard.dart';
import 'analytics.dart';
import 'main.dart';
import 'editBio.dart';
import 'editPhoto.dart';
import 'settings.dart';
import 'post.dart';
import 'userProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'databaseserviceprofile.dart';


class ProfilePage extends StatefulWidget {

  ProfilePage({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}
String privacyStatus;
String mytempbio;
String mytempname;



final ValueNotifier<String> _changeinpp = ValueNotifier<String>(myImg);


class _ProfilePageState extends State<ProfilePage> {
  static FirebaseAnalytics  analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  List <Post> posts;

  int userFollowerCount = 0;
  int userFollowingCount = 0;

  UserProfile user;
  @override
  void initState() {
    super.initState();
    getUserFollower();
    getUserFollowing();

    setCurrentScreen(widget.analytics, widget.observer, 'Profile Page', 'ProfilePageState');
    DatabaseServiceProfile myservice = new DatabaseServiceProfile();
    //myservice.getUsername();
    getInfos();
    print(myImg);
    privacyStatus = myPrivacy;
    //print('initState is called');
    user = new UserProfile(username: myName, bio: myBio,
        followers: userFollowerCount, following: userFollowingCount);
    if (privacyStatus == null) {
      prefs.setString("privacy",'private');
      privacyStatus = 'private';
      DatabaseServiceProfile().setPrivacy('private');

    }
    else if (privacyStatus == 'private') {
      prefs.setString("privacy",'private');
      privacyStatus = 'private';
    }
    else if (privacyStatus == 'public') {
      prefs.setString("privacy",'public');
      privacyStatus = 'public';
    }
  }
  getUserFollower() async{
    QuerySnapshot snapshot = (await followersRef
        .doc(Globaluid)
        .collection('userFollowers')
        .get());
    setState(() {
      userFollowerCount = snapshot.docs.length;
    });
  }

  getUserFollowing() async{
    QuerySnapshot snapshot = (await followingRef
        .doc(Globaluid)
        .collection('userFollowing')
        .get());
    setState(() {
      userFollowingCount = snapshot.docs.length;
    });
  }


  Future <void> getInfos() async{
    DatabaseServiceProfile myservice = new DatabaseServiceProfile();
    //myservice.getUsername();
      getPostOfCurrentUser();
     await myservice.getUserName2();
     await myservice.getPrivacy();
     await myservice.getBio();
     await myservice.getImage();
  }
  void changeStateOfPrivacy() {
    setState(() {
      if(privacyStatus == 'public') {
        prefs.setString("privacy",'private');
        privacyStatus = 'private';
        DatabaseServiceProfile().setPrivacy('private');
      }
      else {
        prefs.setString("privacy",'public');
        privacyStatus = 'public';
        DatabaseServiceProfile().setPrivacy('public');
      }
    });
  }
  getPostOfCurrentUser() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('posts')
        .doc(Globaluid).collection('user_posts')
        .orderBy('timestamp', descending: true).get();
    List <Post> posts = snapshot.docs.map((e) => Post.fromDocument(e)).toList();
    setState(() {
      this.posts = posts;
    });
  }
  getResharedPostOfCurrentUser() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('resharedPosts')
        .doc(Globaluid)
        .collection('user_reshared')
        .orderBy('timestamp', descending: true).get();
    print(snapshot.docs[1]);
    List <Post> posts = snapshot.docs.map((e) => Post.fromDocument(e)).toList();
    setState(() {
      this.posts = posts;
    });
  }

  buildTimeLine(){
/*    print(posts.length);*/
  //getPostOfCurrentUser();
    if(posts == null){
      return Text('Loading');
    }
    else if (posts.isEmpty)
      return Text('no posts');
    return FutureBuilder(

        future: FirebaseFirestore.instance.collection('posts')
            .doc(Globaluid).collection('user_posts')
            .orderBy('timestamp', descending: true).get(),
        builder: (context, snapshot) {
          return ListView.builder(
            shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
                print('feedpagede burdayim');
                print(posts[index].description);
                return PostCard(mypost: posts[index],);
              }
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(

      appBar: new AppBar(
        backgroundColor:Color.fromARGB(196, 196, 196, 196),
        title: new Text('Profile'),
        centerTitle: true,
        elevation: 0.0,
        automaticallyImplyLeading: false,
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
                        NetworkImage(myImg),
                        radius: 70.0,
                     ),
                    SizedBox(width: 30,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: <Widget>[
                        Text(
                          '@' + user.username,
                          //'@janedoe',
                          style: TextStyle(
                            height: 1.171875,
                            fontSize: 18.0,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 0, 0, 0),
                            /* letterSpacing: 0.0, */
                          ),
                           ),
                        SizedBox( height:20.0,),
                        GestureDetector(
                          //onTap: () => Navigator.pushNamed(context, '/SignUp'),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EditPhoto(analytics: analytics,observer: observer,)));// Edit profile picture page button
                          },
                          child: Container(
                            width: 150.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                            ),

                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Container(
                                color: Color.fromARGB(196, 196, 196, 196),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      style: Theme.of(context).textTheme.body1,
                                      children: [
                                        TextSpan(text: 'Edit Profile Pic',
                                          style: TextStyle(
                                            height: 1.171875,
                                            fontSize: 15.0,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            /* letterSpacing: 0.0, */
                                          ),
                                        ),
                                        WidgetSpan(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                            child: Icon(Icons.edit,
                                              size: 18.0,),
                                          ),
                                        ),
                                      ],
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
                      children: <Widget>[
                        Text(
                          //'Sabancı University - Computer Science Wanderlust 🌍',
                            myBio
                        ),
                      ],

                    ),

                    SizedBox( height:10.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/SignUp'),////followers page Button
                              child: Container(
                                width: 165.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),


                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    color: Color.fromARGB(196, 196, 196, 196),
                                    child: Center(
                                      child: Text(
                                        //'''566''',
                                        '$userFollowerCount',
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
                            SizedBox( height:5.0,),
                            Text(
                              '''Followers''',
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                height: 1.171875,
                                fontSize: 15.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 0, 0, 0),

                                /* letterSpacing: 0.0, */
                              ),
                            ),

                          ],
                        ),
                        SizedBox(width: 16,),
                        /*Column(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/SignUp'),//subscribed locations page button
                              child: Container(
                                width: 100.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),

                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    color: Color.fromARGB(196, 196, 196, 196),
                                    child: Center(
                                      child: Text(
                                        //'''24''',
                                        '${user.locations}',
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
                            SizedBox( height:5.0,),
                            Text(
                              '''Locations''',
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                height: 1.171875,
                                fontSize: 15.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 0, 0, 0),

                                /* letterSpacing: 0.0, */
                              ),
                            ),
                          ],
                        ),*/
                        SizedBox(width: 16,),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/LoginPage'),//followings page Button
                              child: Container(
                                width: 165.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    color: Color.fromARGB(196, 196, 196, 196),
                                    child: Center(
                                      child: Text(
                                        //'''1278''',
                                        '$userFollowingCount',
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
                            SizedBox( height:5.0,),
                            Text(
                              '''Following''',
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                height: 1.171875,
                                fontSize: 15.0,
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
                    SizedBox( height:30.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        //SizedBox(width: 16,),
                        Column(
                          children: [
                            GestureDetector(
                              //onTap: () => Navigator.pushNamed(context, '/editBio', arguments: '1'),
                              //onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditBio())),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => EditBio(analytics: analytics,observer: observer,))); //Edit Bio Page button
                              },
                              child: Container(
                                width: 165.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),

                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    color: Color.fromARGB(196, 196, 196, 196),
                                    child: Center(
                                      child: RichText(
                                        text: TextSpan(
                                          style: Theme.of(context).textTheme.body1,
                                          children: [
                                            TextSpan(text: 'Edit Bio',
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
                                                child: Icon(Icons.edit,
                                                  size: 20.0,),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 16,),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: changeStateOfPrivacy,//Account privacy page button
                              child: Container(
                                width: 165.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),

                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    color: Color.fromARGB(196, 196, 196, 196),
                                    child: Center(
                                      child: Text(
                                        'Privacy: ${privacyStatus}',
                                        overflow: TextOverflow.visible,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          height: 1.171875,
                                          fontSize: 17.0,
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
                          ],
                        ),
                      ],

                    ),
                    SizedBox( height:10.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Column(
                          children: [
                            GestureDetector(
                              onTap: (){
                                if(privacyStatus == 'public')
                                  Navigator.pushNamed(context, '/notificationPub');
                                else
                                  Navigator.pushNamed(context, '/notificationPriv');
                              },
                      //() => Navigator.pushNamed(context, '/SignUp'),//follow unfollow button
                              child: Container(
                                width: 165.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),

                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    color: Color.fromARGB(196, 196, 196, 196),
                                    child: Center(
                                      child: RichText(
                                        text: TextSpan(
                                          style: Theme.of(context).textTheme.body1,
                                          children: [
                                            TextSpan(text: 'Share ',
                                              style: TextStyle(
                                                height: 1.171875,
                                                fontSize: 20.0,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromARGB(255, 0, 0, 0),
                                                /* letterSpacing: 0.0, */
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Icon(Icons.add_to_photos_rounded,
                                                  size: 25.0,),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 16,),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Bookmark(analytics: analytics,observer: observer,))); //Edit Bio Page button
                              },
                              child: Container(
                                width: 165.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),

                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    color: Color.fromARGB(196, 196, 196, 196),
                                    child: Center(
                                        child: RichText(
                                          text: TextSpan(
                                            style: Theme.of(context).textTheme.body1,
                                            children: [
                                              TextSpan(text: 'Bookmarks ',
                                                style: TextStyle(
                                                  height: 1.171875,
                                                  fontSize: 18.0,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w400,
                                                  color: Color.fromARGB(255, 0, 0, 0),
                                                  /* letterSpacing: 0.0, */
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                  child: Icon(Icons.bookmarks,
                                                    size: 25.0,),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
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
                    SizedBox( height:20.0,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RefreshIndicator(
                          onRefresh: () => getPostOfCurrentUser(),
                          child: buildTimeLine(),)
                      ],
                    ),
                  ],
                ),

        ),

      ),


    );
  }
}