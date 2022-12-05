import 'package:flutter/material.dart';
import 'package:projegiris310/colors.dart';

class Header extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Center(
            child: Text(
              "Login Page",
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}