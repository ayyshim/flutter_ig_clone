import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {

  final String uid;

  const NotificationScreen({Key key, this.uid}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Text("Notification Screen ${widget.uid}");
  }
}
