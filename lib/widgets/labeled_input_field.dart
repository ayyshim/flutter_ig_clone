import 'package:flutter/material.dart';

class LabeledInputField extends StatelessWidget {

  final String label;
  final String initalValue;
  final Function validator;
  final Function onChanged;
  final TextInputType textInputType;

  const LabeledInputField({Key key, @required this.label, this.validator, @required this.onChanged, this.textInputType = TextInputType.text, this.initalValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 14,
            fontWeight: FontWeight.w400
          ),
        ),
        TextFormField(
          initialValue: initalValue,
          maxLines: null,
          validator: validator ?? (value) {return null;},
          keyboardType: textInputType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: "",
            errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                color: Colors.redAccent,
                width: 0.7
              )
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey[300],
                width: 0.7
              )
            ),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey[300],
                    width: 0.7
                )
            ),
          ),
        ),
      ],
    );
  }
}
