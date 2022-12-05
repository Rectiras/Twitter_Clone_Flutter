
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projegiris310/databaseserviceprofile.dart';

import 'analytics.dart';

class EditPhoto extends StatefulWidget {
  EditPhoto({Key key, this.title, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  final String title;

  @override
  _EditPhotoState createState() => _EditPhotoState();
}
class _EditPhotoState extends State<EditPhoto>{
  File _imageFile;
  String url;
  final picker = ImagePicker();
  Future PickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }
  Future uploadImageToFirebase(BuildContext context) async{
    String Filename = _imageFile.path;
    print( 'burasi neden gelmedi lan consoleda'+_imageFile.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('profileimages/$Filename');
    await storage.ref().child('profileimages/$Filename').putFile(_imageFile).whenComplete(() async
    {
      url = await ref.getDownloadURL();
    }).catchError((onError)
    {
      print(onError);
    });
    print(url);

    /*
    await storage.ref().child('profileimages/$Filename').putFile(_imageFile).snapshot.ref.getDownloadURL().then((value){
      //print('done: $value');

      url = value;
      print('my url' + url);

    });*/
    print('bekledik');
    DatabaseServiceProfile().setImage(url);
    DatabaseServiceProfile().getImage();
    setState(() {
      myImg = url;
    });

  }
  @override
  void initState(){
    super.initState();
    setCurrentScreen(widget.analytics, widget.observer, 'Edit Photo Page', 'EditPhotoPageState');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
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
                    Icons.edit,
                    size: 35.0,
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

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
           /* IconButton(
              icon: Image.asset('assets/images/748688d7b0223fa6714f4dfee4050154a8a0fd9f.png'),
              iconSize: 400.0,
              onPressed: () {}
            ),*/
            Stack(
              children: [
                Container(
                  height: 350,
                  margin: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: _imageFile != null ? Image.file(_imageFile)
                        : FlatButton(onPressed: PickImage, child: Icon( Icons.add_a_photo, size:50)),
                  ),
                )
              ],
            ),

            SizedBox(height: 50.0,),

            uploadImageButton (context),

            /*Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () {

                      setLogEvent(widget.analytics, widget.observer, 'Profile_Picture_is_Updated', );
                      ScaffoldMessenger.of(context).
                      showSnackBar(SnackBar(content: Text('Updated')));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        'Change Picture',
                        style: TextStyle(
                          height: 1.171875,
                          fontSize: 17.0,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      //backgroundColor: AppColors.primary,
                      backgroundColor: Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),*/



          ],
        ),
      ),
    );
  }
  Widget uploadImageButton (BuildContext context){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: OutlinedButton(
            onPressed: () {
              uploadImageToFirebase(context);
              setLogEvent(widget.analytics, widget.observer, 'Profile_Picture_is_Updated', );
              ScaffoldMessenger.of(context).
              showSnackBar(SnackBar(content: Text('Updated')));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'Change Picture',
                style: TextStyle(
                  height: 1.171875,
                  fontSize: 17.0,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            style: OutlinedButton.styleFrom(
              //backgroundColor: AppColors.primary,
              backgroundColor: Colors.grey[500],
            ),
          ),
        ),
      ],
    );
  }
}
