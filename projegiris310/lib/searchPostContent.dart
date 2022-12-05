import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:projegiris310/profilePage.dart';

import 'analytics.dart';
import 'databaseserviceprofile.dart';



class searchPostContent extends StatefulWidget {
  searchPostContent({Key key, this.title, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;


  final String title;

  @override
  _searchPostContentState createState() => _searchPostContentState();
}

// ignore: camel_case_types
class _searchPostContentState extends State<searchPostContent> {
  final SearchBarController<Post> _searchBarController = SearchBarController();
  bool isReplay = false;
  Future<List<Post>> _getALlPosts(String text) async {
    await Future.delayed(Duration(seconds: text.length == 4 ? 10 : 1));
    List<Post> posts = [];
    DatabaseServiceProfile databaseService = new DatabaseServiceProfile();
    QuerySnapshot searchQuery;
    await databaseService.getPostByContent(text).then((val){
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
      posts.add(Post(searchQuery.docs[i].get('text')));
      print(i);
      print('index bu');
      print(searchQuery.docs[i].get('username'));
    }


    if (isReplay) return [Post("Replaying body")];
    //if (text.length == 5) throw Error();
    //if (text.length == 6) return [];
    return posts ;

  }
  @override
  void initState(){
    super.initState();
    setCurrentScreen(widget.analytics, widget.observer, 'Search Post Content Page', 'SearchPostContentPageState');
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
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          onSearch: _getALlPosts,
          searchBarController: _searchBarController,
          cancellationWidget: Text("Cancel"),
          emptyWidget: Text("empty"),
          hintText: 'Please search post content',
          indexedScaledTileBuilder: (int index) => ScaledTile.count(1, index.isEven ? 2 : 1),
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
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 2,
          onItemFound: (Post post, int index) {
            return Container(
              color: Colors.lightBlue,
              child: ListTile(
                isThreeLine: true,
                subtitle: Text(post.body),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Detail()));
                },
              ),
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