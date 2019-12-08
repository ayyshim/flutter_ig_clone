import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/auth_repositories.dart';
import 'package:instagram_clone/widgets/bordered_input_field.dart';
import 'package:instagram_clone/widgets/progress_dialog.dart';

class RegisterScreen extends StatefulWidget {

  static final String id = "register_screen";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  
  String _email = "", _password = "", _full_name = "";
  
  final AuthRepository _authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.blue[600],
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Instagram Clone",
          style: TextStyle(
            fontFamily: "Billabong",
            color: Colors.black
          ),),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("Register an account for free.",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 14,),
              BorderedInputField(
                placeholder: "Email address",
                onChanged: (email) {
                  setState(() {
                    _email = email;
                  });
                },
                validator: (email) {return null;},
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(height: 14,),
              BorderedInputField(
                placeholder: "Full name",
                onChanged: (full_name) {
                  setState(() {
                    _full_name = full_name;
                  });
                },
                validator: (full_name) {return null;},
                textInputType: TextInputType.visiblePassword,
              ),
              SizedBox(height: 14,),
              BorderedInputField(
                isPassword: true,
                placeholder: "Password",
                onChanged: (password) {
                  setState(() {
                    _password = password;
                  });
                },
                validator: (password) {return null;},
              ),
              SizedBox(height: 14,),
              Container(
                width: double.infinity,
                child: FlatButton(
                  onPressed: () {
                    if(_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      register();
                    }
                  },
                  padding: EdgeInsets.all(16),
                  color: Colors.blue[600],
                  child: Text("Create",
                    style: TextStyle(
                        fontSize: 15
                    ),),
                  textColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  register() async{
    showDialog(context: context,  builder: (BuildContext context) => ProgressDialog(title: "Creating an account... ",));

    final res = await _authRepository.register(_email, _password, _full_name);
    Navigator.pop(context);

    if(res is User) {
      Navigator.pop(context);
    } else {
      if(res is PlatformException) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(res.message),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          )
        );
      }
    }
  }

}
