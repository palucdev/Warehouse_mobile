import 'package:flutter/material.dart';
import 'package:validate/validate.dart';

class _LoginData {
  String email = '';
  String password = '';
}

class LoginScreenState extends State<LoginScreen> {
  BuildContext _ctx;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _LoginData _data = new _LoginData();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Login'),
        ),
        body: new Container(
            padding: new EdgeInsets.all(20.0),
            child: new Form(
                key: this._formKey,
                child: new ListView(children: <Widget>[
                  new TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: new InputDecoration(
                        hintText: 'example@domain.com',
                        labelText: 'E-mail Address'),
                    validator: this._validateEmail,
                    onSaved: (String value) {
                      this._data.email = value;
                    },
                  ),
                  new TextFormField(
                      obscureText: true,
                      decoration: new InputDecoration(
                          hintText: 'Password',
                          labelText: 'Enter your password'),
                      validator: this._validatePassword,
                      onSaved: (String value) {
                        this._data.password = value;
                      }),
                  new Container(
                    width: screenSize.width,
                    child: new RaisedButton(
                      child: new Text(
                        'Login',
                        style: new TextStyle(color: Colors.white),
                      ),
                      onPressed: _submit,
                      color: Colors.blue,
                    ),
                    margin: new EdgeInsets.only(top: 20.0),
                  )
                ]))));
  }

  void _submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      print("submit success");
    }
  }

  String _validateEmail(String value) {
    try {
      Validate.isEmail(value);
    } catch (e) {
      return "Email address must be valid (like example@gmail.com)";
    }

    return null;
  }

  String _validatePassword(String value) {
    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }

    return null;
  }
}

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginScreenState();
  }
}
