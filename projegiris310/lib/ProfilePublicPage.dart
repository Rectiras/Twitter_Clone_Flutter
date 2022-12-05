import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:projegiris310/home.dart';
import 'package:projegiris310/bookmark.dart';
import 'package:projegiris310/postCard.dart';
import 'CreateText.dart';
import 'analytics.dart';
import 'main.dart';
import 'editBio.dart';
import 'editPhoto.dart';
import 'settings.dart';
import 'userProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'databaseserviceprofile.dart';
import 'databaseService.dart';
import 'profilePage.dart';
import 'post.dart';
import 'searchUsername.dart' as yyy;

class ProfilePublicPage extends StatefulWidget {

  ProfilePublicPage({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _ProfilePublicPageState createState() => _ProfilePublicPageState();
}

class _ProfilePublicPageState extends State<ProfilePublicPage> {
  bool isFollowing = false ;
  int followerCount = 0;
  int followingCount = 0;


  List <Post> posts;

  UserProfile user;

  static FirebaseAnalytics  analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  //Profile Related Functions Start:
  getPostOfCurrentUser() async {
    print('buradayım ilk');
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('posts')
        .doc(yyy.globalFriendID).collection('user_posts')
        .orderBy('timestamp', descending: true).get();
    print('buradayım 0');
    print(snapshot.docs[1]);
    print('buradayım 1');
    List <Post> posts = snapshot.docs.map((e) => Post.fromDocument(e)).toList();
    print('buradayım 2');
    setState(() {
      this.posts = posts;
    });
  }

  buildTimeLine(){
/*    print(posts.length);*/
  getPostOfCurrentUser();
    if(posts == null){
      return Text('Loading');
    }
    else if (posts.isEmpty)
      return Text('no posts');
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('posts')
            .doc(yyy.globalFriendID).collection('user_posts')
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

  buildReportButton(){
    return buildButton2(text: 'Report User', function: handleReportUser);
  }

  buildProfileButton(){
    if(isFollowing){
      return buildButton(text: 'Unfollow', function: handleUnfollowUser) ;
    }
    else if(!isFollowing){
      return buildButton(text: 'Follow', function: handleFollowUser) ;
    }
  }

  handleReportUser(){
    ReportService().ReportedUserCollection
        .doc(yyy.globalFriendID)
        .collection('reporting')
        .doc(Globaluid)
        .set({
      "reportingUsername": myName,
      "reportingUserId": Globaluid,
      "userProfileImg": myImg,
      "reportedUserId": yyy.globalFriendID,
      "timestamp": timestamp,
    });

  }

  handleUnfollowUser(){
    setState(() {
      isFollowing = false;
    });

    //Make our user unfollow of the given user.
    FollowUnfollowService().FollowersCollection
        .doc(yyy.globalFriendID)
        .collection('userFollowers')
        .doc(Globaluid)
        .delete();

    //Delete that user from our user's following list.
    FollowUnfollowService().FollowingCollection
        .doc(Globaluid)
        .collection('userFollowing')
        .doc(yyy.globalFriendID)
        .delete();


    //Delete Notification Follow
    activityFeedRef
        .doc(yyy.globalFriendID)
        .collection('feedItems')
        .doc(Globaluid)
        .delete();
  }

  handleFollowUser(){
    setState(() {
      isFollowing = true;
    });

    //Make our user follower of the given user.
    FollowUnfollowService().FollowersCollection
    .doc(yyy.globalFriendID)
    .collection('userFollowers')
    .doc(Globaluid)
    .set({
    });

    //Insert that user to our user's following list.
    FollowUnfollowService().FollowingCollection
    .doc(Globaluid)
    .collection('userFollowing')
    .doc(yyy.globalFriendID)
    .set({
      'id' : yyy.globalFriendID
    });

    //Insert Notification Follow
    activityFeedRef
    .doc(yyy.globalFriendID)
    .collection('feedItems')
    .doc(Globaluid)
    .set({
      'type': 'follow',
      'commentData': '',
      'userId': Globaluid,
      'username': myName,
      'userProfileImg': yyy.globalImgurl,
      'timestamp': timestamp,
      'postId': ''
    });
  }
  Container buildButton2({String text, Function function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: TextButton(
        onPressed: function,
        child: Container(
          width: 200.0,
          height: 60.0,
          child: Text(
            text,
            style: TextStyle(
              color:Color.fromARGB(255, 0, 0, 0),
              height: 1.171875,
              fontSize: 18.0,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              //color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color.fromARGB(196, 196, 196, 196),
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
    );
  }

  Container buildButton({String text, Function function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: TextButton(
        onPressed: function,
        child: Container(
          width: 200.0,
          height: 60.0,
          child: Text(
            text,
            style: TextStyle(
              color: isFollowing ? Color.fromARGB(255, 0, 0, 0) : Colors.white,
              height: 1.171875,
              fontSize: 18.0,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              //color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isFollowing ? Color.fromARGB(196, 196, 196, 196) : Colors.blue,
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
    );
  }
  //Profile Related Functions End:

  @override
  void initState() {
    super.initState();
    getFollowers();
    getFollowing();
    checkIfFollowing();

    DatabaseServiceProfile myservice = new DatabaseServiceProfile();
    user = new UserProfile(username: yyy.globaluname, bio: yyy.globalBio,
        followers: followerCount, following: followingCount);
  }

  checkIfFollowing() async{
    DocumentSnapshot doc = await followersRef
        .doc(yyy.globalFriendID)
        .collection('userFollowers')
        .doc(Globaluid)
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  getFollowers() async{
    QuerySnapshot snapshot = (await followersRef
        .doc(yyy.globalFriendID)
        .collection('userFollowers')
        .get());
    setState(() {
      followerCount = snapshot.docs.length;
    });
  }

  getFollowing() async{
    QuerySnapshot snapshot = (await followingRef
        .doc(yyy.globalFriendID)
        .collection('userFollowing')
        .get());
    setState(() {
      followingCount = snapshot.docs.length;
    });
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
                    NetworkImage(yyy.globalImgurl),
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
                      yyy.globalBio
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
                                  '$followerCount',
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
                        onTap: () => print(yyy.globalFriendID), //Navigator.pushNamed(context, '/LoginPage'),//connect with followings page
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
                                  '$followingCount',
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
                    children: <Widget>[
                      buildProfileButton(),
                      ],
                  ),


                ],


              ),
              Column(
                children: <Widget>[
                  buildReportButton(),
                ],
              ),
            SizedBox( height:20.0,),
            SizedBox( height:20.0,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[
                RefreshIndicator(
                onRefresh: () =>  getPostOfCurrentUser(),
                child: buildTimeLine(),)
            ],
          ),
        ],
      ),
    ),
  ),//Bottom Navigation Bar will be here!!
);
  }
}
