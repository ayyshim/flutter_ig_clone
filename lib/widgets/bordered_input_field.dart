import 'package:flutter/material.dart';

class BorderedInputField extends StatelessWidget {

  final String placeholder;
  final Function validator;
  final Function onChanged;
  final TextInputType textInputType;
  final bool isPassword;

  const BorderedInputField({Key key,@required this.placeholder, this.validator, @required this.onChanged, this.textInputType = TextInputType.text, this.isPassword = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: this.isPassword,
      style: TextStyle(
          fontSize: 16.0,
          color: Colors.black54
      ),
      validator: this.validator ?? (value) {return null;},
      onChanged: this.onChanged,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          hintText: this.placeholder,
          hintStyle: TextStyle(
              color: Colors.black38
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.black12
              )
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.black12
              )
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.red
              )
          ),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.red
              )
          )
      ),
    );
  }
}
