import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:projegiris310/colors.dart';

class InputField extends StatefulWidget{
  @override
  _InputFieldState createState() => _InputFieldState();

}

class _InputFieldState extends State<InputField> {
  String mail;
  String pass;
  final _formalKey2 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return Form(key: _formalKey2, child:

    Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: AppColors.primary)
            ),
          ),
          child: TextFormField(
              decoration: InputDecoration(
                  hintText: "Enter your email",
                  hintStyle: TextStyle(color: AppColors.textColor),
                  border: InputBorder.none
              ),
              keyboardType: TextInputType.emailAddress,
              // ignore: missing_return
              validator: (value){
                if(value.isEmpty){
                  return 'Please enter your email';

                }
                if(!EmailValidator.validate(value)){
                  return 'The email address is not valid';

                }
                return null;
              },
              onSaved: (String value) {
                mail= value;
              }

          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: AppColors.primary)
            ),
          ),
          child: TextFormField(
              decoration: InputDecoration(
                  hintText: "Enter your password",
                  hintStyle: TextStyle(color: AppColors.textColor),
                  border: InputBorder.none
              ),
              keyboardType: TextInputType.text,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              validator: (value) {
                if(value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onSaved: (String value) {
                mail= value;
              }

          ),
        ),
      ],
    ),
    );
  }
}