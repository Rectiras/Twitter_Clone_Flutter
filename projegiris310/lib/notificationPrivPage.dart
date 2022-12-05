import 'package:flutter/material.dart';
import 'package:projegiris310/colors.dart';
import 'package:projegiris310/objects/notification.dart';
import 'package:projegiris310/profilePage.dart';

import 'analytics.dart';
import 'objects/notification.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';


class NotificationPrivView extends StatefulWidget {
  NotificationPrivView({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;



  @override
  _NotificationPrivViewState createState() => _NotificationPrivViewState();
}

class _NotificationPrivViewState extends State<NotificationPrivView> {
  int postCount = 5;

  List <Post> posts = [
    Post(text: "hello world", name: 'tucan', PostImage: "assets/images/8981_f.jpg", ProfileImage: "assets/images/f1ac89bc5d020b542874dc2adbde5026113cebcb.png"),
    Post(text: "hello adsadsadsdsworld2", name: 'turan',PostImage: "assets/images/8981_f.jpg", ProfileImage: "assets/images/f1ac89bc5d020b542874dc2adbde5026113cebcb.png"), // 33 char allowed
    // 33 char allowed
     // 33 char allowed

  ];
  List <RequPost> requests = [
    RequPost(name: 'Sinovac',ProfileImage: "assets/images/df5220c4e4f7b65ac059f3a176394b9a5ff474ba.png" ),
  ];
  void buttonPressed(){
    setState((){
      postCount +=1;
    });
  }

  @override
  void initState(){
    super.initState();
    setCurrentScreen(widget.analytics, widget.observer, 'Notification Private Page', 'NotificationPrivatePageState');
  }

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: new AppBar(
        backgroundColor:Color.fromARGB(196, 196, 196, 196),
        title: new Text('Notifications'),
        elevation: 0.0,
      ),

      backgroundColor:  Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children:<Widget> [
                Icon(Icons.notifications, size: 40,),
              ],

            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Requests',
                  style: TextStyle(
                    fontSize: 20,
                  ),

                )
              ],
            ),
            Divider(
              color: Colors.black,
              height:40,
              thickness: 2,
            ),
            Column( // postların olduğu kısım
              children: requests.map((request1) => RequestsCard(
                request1:request1,
                delete: (){
                  setState(() {
                    posts.remove(request1);
                  });
                },
              )).toList(),
            ),
            SizedBox(height: 5,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20,
                  ),

                )
              ],
            ),
            Divider(
              color: Colors.black,
              height:40,
              thickness: 2,
            ),
            Column( // postların olduğu kısım
              children: posts.map((post) => PostCardNotification(
                post:post,
                delete: (){
                  setState(() {
                    posts.remove(post);
                  });
                },
              )).toList(),
            )
          ],
        ),

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black ,
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }
}