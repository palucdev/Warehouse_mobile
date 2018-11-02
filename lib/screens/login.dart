import 'package:flutter/material.dart';

class _LoginData {
  String email = '';
  String password = '';
}

class LoginScreenState extends State<LoginScreen> {
  BuildContext _ctx;

  final GlobalKey<FormState>_formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery
        .of(context)
        .size;

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Login'),
        ),
        body: new Container(
            padding: new EdgeInsets.all(20.0),
            child: new Form(
                key: this._formKey,
                child: new ListView(
                    children: <Widget>[
                      new TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: new InputDecoration(
                              hintText: 'example@domain.com',
                              labelText: 'E-mail Address'
                          )
                      ),
                      new TextFormField(
                          obscureText: true,
                          decoration: new InputDecoration(
                              hintText: 'Password',
                              labelText: 'Enter your password'
                          )
                      ),
                      new Container(
                          width: screenSize.width,
                          child: new RaisedButton(
                              child: new Text(
                                  'Login',
                                  style: new TextStyle(
                                    color: Colors.white
                                  ),
                              ),
                            onPressed: _submit,
                            color: Colors.blue,
                          ),
                        margin: new EdgeInsets.only(top: 20.0),
                      )
                    ]
                )
            )
        )
    );
  }

  void _submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      print("submit success");
    }
  }

  String _isUserEmailValid(String val) {
    //TODO email validation <3
    //return error strings for certain validation errors
    //if everything is ok, return null
    return null;
  }
}

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginScreenState();
  }
}
