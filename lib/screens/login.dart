import 'package:flutter/material.dart';
import 'package:validate/validate.dart';
import 'package:warehouse_mobile/data/db_helper.dart';
import 'package:warehouse_mobile/data/rest_ds.dart';
import 'package:warehouse_mobile/model/user.dart';
import 'package:warehouse_mobile/utils/shared_pref_util.dart';

class _LoginData {
  String email = '';
  String password = '';
}

class LoginScreenState extends State<LoginScreen> {
  BuildContext _ctx;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _LoginData _data = new _LoginData();

  RestDatasource api = new RestDatasource();

  @override
  Widget build(BuildContext context) {
    this._ctx = context;
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
      print('Performing API call with data: ' +
          this._data.email +
          " " +
          this._data.password);
      this.api.login(this._data.email, this._data.password).then((User user) {
        this.onLoginSuccess(user);
      }).catchError((Object error) => this.onLoginError(error.toString()));
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
    if (value.length < 3) {
      return "Password must be at least 3 characters";
    }

    return null;
  }

  void onLoginError(String errorText) {
    print("Login error:");
    print(errorText);
  }

  void onLoginSuccess(User user) {
    print("Login success");
    var db = new DatabaseHelper();
    db.saveUser(user);

    SharedPreferencesUtil.saveString(RestDatasource.TOKEN_KEY, user.token).then((void v) {
			Navigator.of(_ctx).pushReplacementNamed("/home");
		});
  }
}

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginScreenState();
  }
}
