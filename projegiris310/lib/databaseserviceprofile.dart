import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projegiris310/post.dart';
import 'databaseService.dart';

String Globaluid= '';
String myName='loading';
String myBio='loading';
String myPrivacy='';
String myImg='loading';
String myPost='asdasd';
bool isDeactivated = false;
int postCount ;

final usersRef = FirebaseFirestore.instance.collection('users');
final CollectionReference activityFeedRef = FirebaseFirestore.instance.collection('feed');
final DateTime timestamp2 = DateTime.now();
final CollectionReference followersRef = FirebaseFirestore.instance.collection('followers');
final CollectionReference followingRef = FirebaseFirestore.instance.collection('following');
final CollectionReference timelineRef = FirebaseFirestore.instance.collection('timeline');

class DatabaseServiceProfile{
  Future<bool> getDeactivated() async {
    print(Globaluid);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Globaluid)
        .get()
        .then((value) {
      isDeactivated = value.data()['deactivated'];

    });
    return isDeactivated;
  }
  Future<void> setDeactivated(bool status) async {
    print(Globaluid);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Globaluid)
        .update({'deactivated': status})
        .then((value) => print("Updated"))
        .catchError((error) => {
      print("Failed to update user: $error")},
    );
  }



  Future<String> getUserName2() async {
    print(Globaluid);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Globaluid)
        .get()
        .then((value) {
        myName = value.data()['username'].toString();

    });
    return myName;
  }


  Future<String> getBio() async {
    print(Globaluid);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Globaluid)
        .get()
        .then((value) {
      myBio = value.data()['bio'].toString();

    });
    return myBio;
  }
  Future<void> setBio(String status) async {
    print(Globaluid);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Globaluid)
        .update({'bio': status})
        .then((value) => print("Bio Updated"))
        .catchError((error) => {
      print("Failed to update user: $error")},
    );
  }
  Future<void> setUsername(String status) async {
    print(Globaluid);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Globaluid)
        .update({'username': status})
        .then((value) => print("username Updated"))
        .catchError((error) => {
      print("Failed to update user: $error")},
    );
  }

  Future<void> setImage(String status) async {
    print(Globaluid);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Globaluid)
        .update({'imgurl': status})
        .then((value) => print("img Updated"))
        .catchError((error) => {
      print("Failed to update user: $error")},
    );
  }
  Future<String> getImage() async {
    print(Globaluid);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Globaluid)
        .get()
        .then((value) {
      myImg = value.data()['imgurl'].toString();


    });
    return myBio;
  }
  Future<void> setPrivacy(String status) async {
    print(Globaluid);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Globaluid)
        .update({'privacy': status})
        .then((value) => print("Privacy Updated"))
        .catchError((error) => {
          print("Failed to update user: $error")},
          );
  }
  Future<String> getPrivacy() async {
    print(Globaluid);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Globaluid)
        .get()
        .then((value) {
      myPrivacy = value.data()['privacy'].toString();
    });
    return myPrivacy;
  }
  searchUserByUserName(String username) async {
    //return await FirebaseFirestore.instance.collection('users').where('username',isEqualTo: username).get();
    //FirebaseFirestore.instance.collection('users').doc(Globaluid).collection('')
    return await FirebaseFirestore.instance.collection('users').
    where('username', isEqualTo: username).get();
  }
  getUserByUserName(String username) async {
    //return await FirebaseFirestore.instance.collection('users').where('username',isEqualTo: username).get();
    //FirebaseFirestore.instance.collection('users').doc(Globaluid).collection('')
    return await FirebaseFirestore.instance.collection('users').
    where('username', isGreaterThanOrEqualTo: username).where('username',isLessThanOrEqualTo: username+ '\uF7FF').get();
  }
  getUserByLocation(String location) async {
    //return await FirebaseFirestore.instance.collection('users').where('username',isEqualTo: username).get();
    return await FirebaseFirestore.instance.collection('users').
    where('location', isGreaterThanOrEqualTo: location).where('location',isLessThanOrEqualTo:location+ '\uF7FF').get();
  }
  getPostByLocation(String location) async {
    //return await FirebaseFirestore.instance.collection('users').where('username',isEqualTo: username).get();
    return await FirebaseFirestore.instance.collection('posts').
    where('location', isGreaterThanOrEqualTo: location).where('location',isLessThanOrEqualTo:location+ '\uF7FF').get();
  }
  getPostByTopic(String topic) async {
    //return await FirebaseFirestore.instance.collection('users').where('username',isEqualTo: username).get();
    return await FirebaseFirestore.instance.collection('posts').
    where('topic', isGreaterThanOrEqualTo: topic).where('topic',isLessThanOrEqualTo:topic+ '\uF7FF').get();
  }
  getPostByContent(String content) async {
    //return await FirebaseFirestore.instance.collection('users').where('username',isEqualTo: username).get();
    return await FirebaseFirestore.instance.collection('posts').doc().collection('user_posts').
    where('text', isGreaterThanOrEqualTo: content).where('text',isLessThanOrEqualTo:content+ '\uF7FF').get();
  }
}
class GetUserName extends StatelessWidget {
  final String documentId;

  GetUserName(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Text("Full Name: ${data['full_name']} ${data['last_name']}");
        }

        return Text("loading");
      },
    );
  }
}