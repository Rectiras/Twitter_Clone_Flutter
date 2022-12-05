import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
/*  final String postId;*/
  final String pid;
  final String ownerId;
  final String username;
  final String description;
  final String imgUrl;
  final Timestamp timestamp;
  final Map likes;
  final dynamic dislikes;
/*  final dynamic likes;*/
  Post({
/*    this.postId,*/
  this.pid,
  this.timestamp,
    this.imgUrl,
    this.ownerId,
    this.username,
    this.description,
    this.dislikes,
    this.likes,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      pid: doc['pid'],
      timestamp: doc['timestamp'],
      imgUrl: doc['imgurl'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      description: doc['text'],
      dislikes: doc['dislikes'],
      likes: doc['likes'],
    );
  }
}

//import 'dart:developer';


//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:uuid/uuid.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//class PostService extends Service {
  //String postId = Uuid().v4();
  //FirebaseAuth auth = FirebaseAuth.instance;
//}

//upload(String text, String location) async{
  //String link = await uploadImage(posts, image);
  //DocumentSnapshot doc = await usersRef.doc(firebaseAuth.currentUser.uid).get();
  //user = UserModel.fromJson(doc.data());
  //var ref = postRef.doc();
  //ref.set({
    //"id": ref.id,
    //"postId": ref.id,
    //"username": users.username,
    //"ownerId": firebaseAuth.currentUser.uid,
    //"mediaUrl": link,
    //"description": description ?? "",
    //"location": location ?? "Wooble",
    //"timestamp": Timestamp.now(),
  //}).catchError((e) {
    //print(e);
  //});
//}


