
import 'package:flutter/material.dart';
import 'package:projegiris310/databaseService.dart';
import 'package:projegiris310/deactivatePage.dart';
import 'package:projegiris310/post.dart';
import 'package:projegiris310/profilePage.dart';
import 'analytics.dart';
import 'databaseserviceprofile.dart';
import 'postCard.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projegiris310/databaseService.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class FeedPage extends StatefulWidget {
  FeedPage({Key key, this.title, this.analytics, this.observer, this.currentUser}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  FirebaseAuth auth = FirebaseAuth.instance;

  final usersRef = FirebaseFirestore.instance.collection('users');

  final User currentUser;




  final String title;

  @override

  _FeedPageState createState() => _FeedPageState();
}


class _FeedPageState extends State<FeedPage> {
  List <Post> posts;

  @override
  void initState(){
    super.initState();
    getPostOfCurrentUser();
    setCurrentScreen(widget.analytics, widget.observer, 'Feed Page', 'FeedPageState');
  }
  getFeedPage() async {
    QuerySnapshot denemequery = await FirebaseFirestore.instance.collection('following').doc(Globaluid).collection('userFollowing').get();
    for(int i = 0 ; i < denemequery.docs.length ; i++)
      {
        QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('posts')
            .doc(denemequery.docs[i].get('id').toString()).collection('user_posts')
            .orderBy('timestamp', descending: false)
            .get();
        List<Post> posts= snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
        setState(() {
          for(int i = 0; i < posts.length; i++) /////////// her bir follow için o kişinin postlarını alıp listeye ekliyoruz
          {
            this.posts.add(posts[i]) ;
          }
          this.posts.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          this.posts = this.posts.reversed.toList();
        });
      }
    int j;

  }

  getPostOfCurrentUser() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('posts')
        .doc(Globaluid).collection('user_posts')
        .orderBy('timestamp', descending: true).get();
    List <Post> posts = snapshot.docs.map((e) => Post.fromDocument(e)).toList();
    setState(() {
      this.posts = posts;
    });
    getFeedPage();
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
          padding: const EdgeInsets.all(8),
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            print('feedpagede burdayim');
            print(posts[index].description);
          return PostCard(mypost: posts[index]);
          }
          );
        }
    );
    }

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Feeds'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        //backgroundColor: Colors.black38,
        backgroundColor:Color.fromARGB(196, 196, 196, 196),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () {},
          ),

          IconButton(
            icon: Icon(
              Icons.mail_outline,
              color: Colors.white,
            ),
            onPressed: () {},
          ),

          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/notificationPub');
              /*if (privacyStatus == 'public') {
                Navigator.pushNamed(context, '/notificationPub');
              }
              else {
                Navigator.pushNamed(context, '/notificationPriv');
              }*/
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => getPostOfCurrentUser(),
        child: buildTimeLine(),

        /*SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return  PostCard();
                    },
                ),
              ],
            ),
          ),
        ),*/
      ),
      );
  }
}
