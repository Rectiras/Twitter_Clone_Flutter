import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projegiris310/colors.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'CreateText.dart';
import 'databaseService.dart';
import 'databaseserviceprofile.dart';
import 'post.dart';
import 'package:flutter/material.dart';
import 'Comments.dart';

bool isLiked;

bool showHeart;


class PostCard extends StatefulWidget {
  final Post mypost;
  const PostCard({Key key, this.mypost}) : super(key: key);
  @override
  _PostCardState createState() => _PostCardState();
}
final ValueNotifier<String> _changeinpp = ValueNotifier<String>(myImg);

/*Future <void> getInfos() async{
  DatabaseServiceProfile myservice = new DatabaseServiceProfile();
  //myservice.getUsername();
  await myservice.getUserName2();
  await myservice.getPrivacy();
  await myservice.getBio();
  await myservice.getImage();
}*/
class _PostCardState extends State<PostCard> {
  @override
  int likeCount=0;

  void initState() {
    super.initState();

    DatabaseServiceProfile myservice = new DatabaseServiceProfile();
    likeCount = getLikeCount(widget.mypost.likes);
    //commentCount = getCommentCount(widget.mypost.comments);
    //myservice.getUsername();
    /*getInfos();*/
    bool isNotPostOwner = myName != widget.mypost.ownerId;
  }
  int getLikeCount(likes) {
    // if no likes, return 0
    if (likes == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    likes.values.forEach((val) {
      if (val == true) {
        print(val);
        print('ashjdgjhasdghjkadsghjadsghjkdsaghjkadsghjasdkdghjkasdgsakhjadghjskadghjsdghjsakdjsaghkadsghjadghjsk');

        count += 1;
      }
    });
    return count;
  }

  handleLikePost() {
    bool _isLiked = widget.mypost.likes[Globaluid] == true;
    if (_isLiked) {
      FirebaseFirestore.instance.collection('posts')
          .doc( widget.mypost.ownerId)
          .collection('user_posts')
          .doc(widget.mypost.pid)
          .update({'likes.$Globaluid': false});
      removeLikeFromActivityFeed();
      setState(() {
        likeCount -= 1;
        isLiked = false;
        widget.mypost.likes[Globaluid] = false;
      });
    } else if (!_isLiked) {
      FirebaseFirestore.instance.collection('posts')
          .doc(widget.mypost.ownerId)
          .collection('user_posts')
          .doc(widget.mypost.pid)
          .update({'likes.$Globaluid': true});

      addLikeToActivityFeed();

      print('burda miyim');
      setState(() {
        likeCount += 1;
        isLiked = true;
        widget.mypost.likes[Globaluid] = true;
        showHeart = true;
      });
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  void addLikeToActivityFeed() {
    DateTime timeY = DateTime.now();
    bool isNotPostOwner = myName != widget.mypost.ownerId;
    if (isNotPostOwner) {
      activityFeedRef
          .doc(widget.mypost.ownerId)
          .collection("feedItems")
          .doc(widget.mypost.pid)
          .set({
        "type": "like",
        "commentData": "",
        "username": myName,
        "userId": Globaluid,
        "userProfileImg": myImg,
        "postId": widget.mypost.pid,
        "timestamp": timeY,
      });
    }
}

  void removeLikeFromActivityFeed() {

    bool isNotPostOwner = myName != widget.mypost.ownerId;
    if (isNotPostOwner) {
      activityFeedRef
          .doc(widget.mypost.ownerId)
          .collection("feedItems")
          .doc(widget.mypost.pid)
          .get().then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }
    /* snapshot.docs.map((doc) => Post)*/
  void commentButton(){
    print("Comment works");
  }

  void likeButton(){
    print("Like works");
  }

  void dislikeButton(){
    print("Dislike works");
  }

  void bookmarkButton(){
    print("Bookmark works");
  }

  void handleDeletePost() {
    bool isNotPostOwner = myName != widget.mypost.ownerId;

    bool otherUser = myName != widget.mypost.username;

    if (isNotPostOwner) {
      PostService().PostCollection
          .doc(Globaluid)
          .collection('user_posts')
          .doc(widget.mypost.pid)
          .delete();
    }
    if(otherUser){
      ReportService().ReportedPostCollection
          .doc(widget.mypost.pid)
          .collection('reporting')
          .doc(Globaluid)
          .set({
        "reportingUsername": myName,
        "reportingUserId": Globaluid,
        "userProfileImg": myImg,
        "reportedPostId": widget.mypost.pid,
        "timestamp": timestamp,
      });
    }

  }
  Widget build(BuildContext context) {
/*    FutureBuilder(
        future: usersRef.doc(Globaluid).get(),
    builder: (context, snapshot) {*/
/*    if (!snapshot.hasData) {
      return Text('ehe');
    }*/
    /*User user = User.(snapshot.data);*/
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.blueGrey,
          border: Border(bottom: BorderSide())),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: //AssetImage('assets/images/748688d7b0223fa6714f4dfee4050154a8a0fd9f.png'),
            NetworkImage(widget.mypost.imgUrl),
            radius: 20.0,
          ),

          postContent(widget.mypost),
        ],
      ),
    );
/*  }
  );*/
}
Widget postContent(Post mypost){
  return Flexible(
    child: Container(
      margin: EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(

            children: <Widget>[

              Text(mypost.username,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              Container(
                margin: EdgeInsets.only(left: 5.0),
                child: Text( timeago.format(mypost.timestamp.toDate()) ,
                    style: TextStyle(color: Colors.grey[400])),
              )
            ],
          ),
          Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Text(mypost.description, style: TextStyle(color: Colors.white))),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GestureDetector(
                       onTap:() => //Navigator.pushNamed(context, "/Comments"),

                        showComments(
                          context,
                          pid: widget.mypost.pid,
                          ownerId: widget.mypost.ownerId,
                          //imgUrl: imgUrl,
                        ),


                        child: Icon(Icons.message, color: Colors.white)),

                    Container(
                      margin: EdgeInsets.only(left: 3.0),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                        onDoubleTap:() => PostService().resharePost(mypost.pid, mypost.username, mypost.description,),
                        child: Icon(Icons.repeat, color: Colors.white)),
                    Container(
                      margin: EdgeInsets.only(left: 3.0),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                        onDoubleTap:() => handleLikePost(),
                        child: Icon(Icons.favorite_border, color: Colors.white)),
                    Container(
                      margin: EdgeInsets.only(left: 3.0),
                      child: Text('$likeCount',
                          style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                        onDoubleTap:() => handleDeletePost(),
                        child: Icon(Icons.dangerous, color: Colors.white)),
                    Container(
                      margin: EdgeInsets.only(left: 3.0),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
}
/*String getTimeDifferenceFromNow(String dateTime) {
  *//*Duration difference = DateTime.now().difference(dateTime);*//*
*//*  if (difference.inSeconds < 5) {
    return "Just now";
  } else if (difference.inMinutes < 1) {
    return "${difference.inSeconds}s ago";
  } else if (difference.inHours < 1) {
    return "${difference.inMinutes}m ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours}h ago";
  } else {
    return "${difference.inDays}d ago";
  }*//*
}*/
class _UserNameAndEmail extends StatefulWidget {
  const _UserNameAndEmail({Key key}) : super(key: key);

  @override
  __UserNameAndEmailState createState() => __UserNameAndEmailState();
}

class __UserNameAndEmailState extends State<_UserNameAndEmail> {/////////////////////NAME
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(myName),
          //Text(Post.userEmail),
        ],
      ),
    );
  }
}

class _UserImage extends StatefulWidget {/////////////////////////////IMAGE
  const _UserImage({Key key}) : super(key: key);

  @override
  __UserImageState createState() => __UserImageState();
}
class __UserImageState extends State<_UserImage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: CircleAvatar(
        backgroundImage: NetworkImage(myImg),
      ),
    );
  }
}

void showComments(BuildContext context, {String pid, String ownerId, String imgUrl}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {

    return Comments(
      pid: pid,
      ownerId: ownerId,
      imgUrl: imgUrl,

  );
  }));


}
void showNumber(BuildContext context, {String pid, String ownerId, String imgUrl}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {

    return Comments(
      pid: pid,
      ownerId: ownerId,
      imgUrl: imgUrl,

    );
  }));


}

