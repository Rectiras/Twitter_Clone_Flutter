import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:projegiris310/databaseserviceprofile.dart';
import 'package:projegiris310/profilePage.dart';
import 'analytics.dart';
import 'ProfilePublicPage.dart';
import 'ProfilePrivPage.dart';
import 'ProfilePublicNotFollowedPage.dart';

String globaluname;
String globalBio;
String globalImgurl;
String globalPrivacyChecker;
String globalFriendID;

class searchUsername extends StatefulWidget {
  searchUsername({Key key, this.title, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;


  final String title;

  @override
  _searchUsernameState createState() => _searchUsernameState();
}

// ignore: camel_case_types
class _searchUsernameState extends State<searchUsername> {
  static FirebaseAnalytics  analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);


  bool isReplay = false;

  final SearchBarController<Post> _searchBarController = SearchBarController();
  Future<List<Post>> _getALlPosts(String text) async {
    await Future.delayed(Duration(seconds: text.length == 4 ? 10 : 1));
    List<Post> posts = [];
    DatabaseServiceProfile databaseService = new DatabaseServiceProfile();
    QuerySnapshot searchQuery;
    await databaseService.getUserByUserName(text).then((val){
      searchQuery = val;
      print(val);
      print(searchQuery.docs.length);
      print('1.length');
    });
    int i;
    int length = searchQuery.docs.length;
    print(length);
    print('2.length');
    for(i = 0; i< length; i++){
      posts.add(Post(searchQuery.docs[i].get('username')));
      print(i);
      print('index bu');
      print(searchQuery.docs[i].get('username'));
    }
    // DatabaseService myservice = DatabaseService();
    //Query users = myservice.getUserByUserName(text)
    if (isReplay) return [Post("Replaying !")];
    //if (text.length == 4) throw Error();
    //if (text.length == 5) return [Post('ahahah'),Post('muuhahaha'),Post('agucu')];
    //if (text.length == 6) return [Post('ahahah'),Post('muuhahaha'),Post('agucu')];
    return posts;

  }

  Future<void> decide(String username) async {
    QuerySnapshot searchUserQuery;
    globaluname = username;
    await DatabaseServiceProfile().searchUserByUserName(username).then((val){
      searchUserQuery = val;
      print(val);
      globalBio=searchUserQuery.docs[0].get('bio');
      globalImgurl=searchUserQuery.docs[0].get('imgurl');
      globalPrivacyChecker=searchUserQuery.docs[0].get('privacy');
      globalFriendID=searchUserQuery.docs[0].get('uid');

      if (globalPrivacyChecker == 'private') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePrivPage(analytics: analytics,observer: observer,)));
      }
      else if (globalPrivacyChecker == 'public') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePublicPage(analytics: analytics,observer: observer,)));
      }

    });
  }

  @override
  void initState(){
    super.initState();
    setCurrentScreen(widget.analytics, widget.observer, 'Search Username Page', 'SearchUsernamePageState');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Icon(
          Icons.search,
          size: 30.0,
          color: Colors.black,
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor:Color.fromARGB(196, 196, 196, 196),
      ),

      body: SafeArea(
        child: SearchBar<Post>(
          minimumChars: 1,
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          onSearch: _getALlPosts,
          searchBarController: _searchBarController,
          cancellationWidget: Text("Cancel"),
          emptyWidget: Text("empty"),
          hintText: 'Please search user',
          //indexedScaledTileBuilder: (int index) => ScaledTile.count(1, index.isEven ? 2 : 1),
          header: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("sort"),
                onPressed: () {
                  _searchBarController.sortList((Post a, Post b) {
                    return a.body.compareTo(b.body);
                  });
                },
              ),
              RaisedButton(
                child: Text("Desort"),
                onPressed: () {
                  _searchBarController.removeSort();
                },
              ),
              RaisedButton(
                child: Text("Replay"),
                onPressed: () {
                  isReplay = !isReplay;
                  _searchBarController.replayLastSearch();
                },
              ),
            ],
          ),
          onCancelled: () {
            print("Cancelled triggered");
          },
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          crossAxisCount: 1,
          onItemFound: (Post post, int index) {
            return GestureDetector(
              onTap: () => decide(post.body),
              //onTap: () => Navigator.pushNamed(context, '/ProfilePublicNotFollowedPage'),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Text(post.body[0].toUpperCase()),
                    backgroundColor: Color.fromARGB(196, 196, 196, 196),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    color: Colors.white38,
                    child:
                    Text(post.body),

                    //ListTile(
                    // title: Text(post.body),
                    // isThreeLine: true,
                    // subtitle: Text(post.body),
                    //  onTap: () {
                    //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => Detail()));
                    //  },
                    //),
                  ),
                ],
              ),
              //onTap: (){
              //print('ahaha');
              //},
            );
          },
        ),
      ),
    );
  }
}

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Text("Detail"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),

    );
  }
}

class Post {

  final String body;

  Post(this.body);
}