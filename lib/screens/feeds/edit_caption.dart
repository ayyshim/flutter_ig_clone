import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/database_repositories.dart';
import 'package:instagram_clone/widgets/labeled_input_field.dart';
import 'package:instagram_clone/widgets/progress_dialog.dart';

class EditCaptionScreen extends StatefulWidget {

  final Post post;

  const EditCaptionScreen({Key key, this.post}) : super(key: key);

  @override
  _EditCaptionScreenState createState() => _EditCaptionScreenState();
}

class _EditCaptionScreenState extends State<EditCaptionScreen> {

  String caption = "";

  final DatabaseRepository _databaseRepository = DatabaseRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      caption = widget.post.caption;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        title: Text("Edit caption",
          style: TextStyle(
            color: Colors.grey[900]
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.grey[900],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Edit",
              style: TextStyle(
                fontWeight: FontWeight.w600
              ),
            ),
            onPressed: () {
              _edit();
            },
            textColor: Colors.blue[600],
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(16),
        child: LabeledInputField(
          textInputType: TextInputType.multiline,
          initalValue: caption,
          label: "Caption",
          onChanged: (_caption) {
            setState(() {
              caption = _caption;
            });
          },
        ),
      ),
    );
  }

  _edit() async {
    if(widget.post.caption == caption) {
      Navigator.pop(context);
    } else {
      showDialog(context: context,
        builder: (_) => ProgressDialog(
          title: "Editing caption...",
        )
      );
      await _databaseRepository.editCaption(pid: widget.post.id, caption: caption);
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }
}
