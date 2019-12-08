import 'package:flutter/material.dart';

class FeedsScreen extends StatefulWidget {

  final String uid;

  const FeedsScreen({Key key, this.uid}) : super(key: key);

  @override
  _FeedsScreenState createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Tab"),
    );
  }
}
