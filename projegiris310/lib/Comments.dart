import 'CreateText.dart';
import 'databaseService.dart';
import 'databaseserviceprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projegiris310/profilePage.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'postCard.dart';

int commentCount = 0;

class Comments extends StatefulWidget {
  final String pid;
  final String ownerId;
  final String imgUrl;

  Comments({
    this.pid,
    this.ownerId,
    this.imgUrl,
  });

  @override
  CommentsState createState() => CommentsState(
    pid: this.pid,
    ownerId: this.ownerId,
    imgUrl: this.imgUrl,
  );
}

class CommentsState extends State<Comments> {
  TextEditingController commentController = TextEditingController();
  final String pid;
  final String ownerId;
  final String imgUrl;

  CommentsState({
    this.pid,
    this.ownerId,
    this.imgUrl,
  });


  buildComments() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('comments')
            .doc(pid)
            .collection('comments')
            .orderBy("timestamp", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("There is no Comments");
          }
          List <Comment> comments = [];
          snapshot.data.docs.forEach((doc) {
            comments.add(Comment.fromDocument(doc));

          });
          return ListView(
            children: comments,

          );
        });
  }


  addComment() {
    DateTime timeX = DateTime.now();
    FirebaseFirestore.instance
        .collection("comments")
        .doc(pid)
        .collection("comments")
        .add({
          "username": myName,
          "comment": commentController.text,
          "timestamp": timeX,
          "avatarUrl": myImg,
          "userId": Globaluid,
    });
    bool isNotPostOwner = myName != ownerId;
    if (isNotPostOwner) {
      activityFeedRef
          .doc(ownerId)
          .collection("feedItems")
          .add({
        "type": "comment",
        "commentData": commentController.text,
        "timestamp": timeX,
        "username": myName,
        "userId": Globaluid,
        "userProfileImg": myImg,
        "postId": pid,
      });
    }
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        centerTitle: true,
        //automaticallyImplyLeading: false,
        //backgroundColor: Colors.black38,
        backgroundColor:Color.fromARGB(196, 196, 196, 196),
        /*actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pushNamed(context, '/feedPage'),
          ),
        ],*/
      ),
      body: Column(
        children: <Widget>[
         Expanded(child: buildComments()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(labelText: "Write a comment..."),
            ),
            trailing: OutlineButton(
              onPressed: addComment,
              borderSide: BorderSide.none,
              child: Text("Comment"),
            ),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;

  Comment({
    this.username,
    this.userId,
    this.avatarUrl,
    this.comment,
    this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      username: doc['username'],
      userId: doc['userId'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
      avatarUrl: doc['avatarUrl'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(myImg),
          //child: Text('sa'),
          ),
          subtitle: Text(timeago.format(timestamp.toDate())),
          ),
        Divider(),
      ],
    );
  }
}
