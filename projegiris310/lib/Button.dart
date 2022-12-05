import 'package:flutter/material.dart';
import 'colors.dart';
import 'navigationPage.dart';


class Button extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      height: 45,
      margin: EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
          color: AppColors.headingColor,
          borderRadius: BorderRadius.circular(0)
      ),
      child: Center(
        child: OutlinedButton(
          child:Text(
            "Login",
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: 21,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          onPressed: () {

            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Logging in')));
            Navigator.pushNamed(context, '/navigationPage');
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 170.0),
            //EdgeInsets.only(left: 172, right: 172, top: 15, bottom: 15)
          ),

        ),
      ),
    );
  }
}