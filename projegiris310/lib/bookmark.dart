import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import 'analytics.dart';

class Bookmark extends StatefulWidget {
  Bookmark({Key key, this.title, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  final String title;

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}
class _BookmarkPageState extends State<Bookmark>{

  @override
  void initState(){
    super.initState();
    setCurrentScreen(widget.analytics, widget.observer, 'Bookmark Page', 'BookmarkPageState');
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        //title: Text("Sample"),
        title: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.body1,
            children: [
              TextSpan(text: '',
                style: TextStyle(
                  height: 1.171875,
                  fontSize: 17.0,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 0, 0, 0),
                  /* letterSpacing: 0.0, */
                ),
              ),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Icon(
                    Icons.bookmark,
                    size: 50.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,

        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 40.0,),
                Image.asset('assets/images/3e804269cf1c595944ca50f13e6da642b1cd9d69.png'),
                SizedBox(height: 10.0,),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.thumb_up,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),

                    //SizedBox(width: 5.0),

                    IconButton(
                      icon: Icon(
                        Icons.thumb_down,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),

                    IconButton(
                      icon: Icon(
                        Icons.comment,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),

                    IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),

                    IconButton(
                      icon: Icon(
                        Icons.bookmark,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),

                Image.asset('assets/images/2cd8fa7dc931430009904aec8d9ecc9badaf954c.png'),
                SizedBox(height: 10.0,),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.thumb_up,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),

                    //SizedBox(width: 5.0),

                    IconButton(
                      icon: Icon(
                        Icons.thumb_down,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),

                    IconButton(
                      icon: Icon(
                        Icons.comment,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),

                    IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),

                    IconButton(
                      icon: Icon(
                        Icons.bookmark,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),


                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
