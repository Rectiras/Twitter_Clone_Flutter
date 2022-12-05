import 'package:flutter/material.dart';

class UserProfile {
  String username;
  String bio;
  int followers;
  int locations;
  int following;

  //UserProfile({this.followers, this.following, this.locations});
  UserProfile({String username, String bio, int followers, int following, int locations}) {
    this.username = username;
    this.bio = bio;
    this.followers = followers;
    this.following = following;
    this.locations = locations;
  }
}
