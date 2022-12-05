import 'package:cloud_firestore/cloud_firestore.dart';
import 'databaseserviceprofile.dart';
import 'CreateText.dart';


class DatabaseService{

  final String uid;
  DatabaseService({this.uid});
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');//doc(this.uid).collection("post");


  Future<void> createUserData(String mail, String displayName, String bio, String url,) async{
    return await userCollection.doc(uid).set({
      'email': mail,
      'username': displayName,
      'bio': 'Bio: ',
      'imgurl': url,
      'privacy': 'private',
      'uid': uid,
      'deactivated': false,
    });
  }
  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }
}
class PostService {

  final String Pid;

  PostService({this.Pid});

  final CollectionReference PostCollection = FirebaseFirestore.instance.collection('posts');
  final CollectionReference commentsRef = FirebaseFirestore.instance.collection('comments');
  //final CollectionReference reshareRef = FirebaseFirestore.instance.collection('resharedPosts');

  Future<void> createPostData(String displayName,String text) async {
    String Pid2 = PostCollection.doc(Globaluid,).collection('user_posts').doc().id;
    return await PostCollection.doc(Globaluid,).collection('user_posts').doc(Pid2).set({
      'pid' :Pid2,
      'imgurl': myImg,
      'username': displayName,
      'text': text,
      'timestamp': timestamp,
      'likes': {},
      'ownerId': Globaluid,
      'dislikes': {},
      'comments': {},
      'reshared': 'false',
    });
  }

  Future<void> resharePost(String originalPid, String displayName, String text,) async {
    DateTime newtime = DateTime.now();
    String Pid3 = PostCollection.doc(Globaluid).collection('user_posts').doc().id;
    return await PostCollection.doc(Globaluid).collection('user_posts').doc(Pid3).set({

      'pid': Pid3,
      'imgurl': myImg,
      'username': myName,
      'text': 'Reshared from ' +displayName + ':\n' +text,
      'timestamp': newtime,
      'likes': {},
      'ownerId': Globaluid,
      'dislikes': {},
      'comments': {},
      'reshared': 'true',
    });
  }
}




class FollowUnfollowService{
  final CollectionReference FollowersCollection = FirebaseFirestore.instance.collection('followers');
  final CollectionReference FollowingCollection = FirebaseFirestore.instance.collection('following');
}

class ReportService{
  final CollectionReference ReportedUserCollection = FirebaseFirestore.instance.collection('reporteduser');

  final CollectionReference ReportedPostCollection = FirebaseFirestore.instance.collection('reportedpost');
}

class TimelineService{
  final CollectionReference TimelineCollection = FirebaseFirestore.instance.collection('timeline');

}

