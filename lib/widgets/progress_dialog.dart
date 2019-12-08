import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {

  final String title;

  const ProgressDialog({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4)
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircularProgressIndicator(
            ),
            SizedBox(width: 20,),
            Expanded(
              child: Text(
                this.title, style: TextStyle(
                fontSize: 14,
                color: Colors.black54
              ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
