import 'package:flutter/material.dart';
import 'package:projegiris310/Button.dart';
import 'package:projegiris310/colors.dart';
import 'InputField.dart';

class InputWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          SizedBox(height: 16,),
          Container(
            decoration: BoxDecoration(
              color: AppColors.headingColor,
              borderRadius: BorderRadius.circular(10)
            ),
            child: InputField(),
          ),
          SizedBox(height: 16,),
          Text(
            "Forgot Password",
            style: TextStyle(color: Color(0xFF757575)),
          ),
          SizedBox(height: 16,),
          Button(
          )
        ],
      ),
    );
  }
}