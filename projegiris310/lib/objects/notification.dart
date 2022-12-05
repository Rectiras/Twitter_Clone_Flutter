import 'package:projegiris310/colors.dart';
import 'package:flutter/material.dart';
class Post {
  String text;
  String name;
  String ProfileImage;
  String PostImage;

  Post({this.text, this.name, this.ProfileImage, this.PostImage});
}
class RequPost {
  String text = 'Wants to follow you';
  String name;
  String ProfileImage;

  RequPost({this.name, this.ProfileImage,});
}
//Post myPost = Post( text: "Hi guys, that's my first post btw");

class PostCardNotification extends StatelessWidget {
  final Post post;
  final Function delete;
  PostCardNotification({this.post, this.delete});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      color: Color.fromARGB(200, 196, 196, 196),
      child: Padding(
        padding: EdgeInsets.all(1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(
                          post.ProfileImage
                      ),radius: 25,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(post.name,style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),),
                      ],
                    ),
                    SizedBox(height: 8,),
                    Row(
                      children: [
                        Text(post.text,style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),),
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(
                          post.PostImage
                      ),radius: 25,
                    ),
                  ],
                )

              ],
            )

          ],

        ),
      ),
    );
  }
}

class RequestsCard extends StatelessWidget {
  final RequPost request1;
  final Function delete;
  RequestsCard({this.request1, this.delete});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
      color: Color.fromARGB(200, 196, 196, 196),
      child: Padding(
        padding: EdgeInsets.all(1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(
                          request1.ProfileImage
                      ),radius: 25,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(request1.name,style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),),
                      ],
                    ),
                    SizedBox(height: 8,),
                    Row(
                      children: [
                        Text(request1.text,style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),),
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [

                         FloatingActionButton(
                          onPressed: () {},
                          child: Icon(Icons.check_box_outlined,color: Colors.black,
                          ),
                          backgroundColor: AppColors.primary,
                        ),
                        FloatingActionButton(
                          onPressed: () {},
                          child: Icon(Icons.delete,color: Colors.black,
                          ),
                          backgroundColor: AppColors.primary,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}

