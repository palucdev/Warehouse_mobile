import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:validate/validate.dart';
import 'package:warehouse_mobile/data/db_client.dart';
import 'package:warehouse_mobile/data/rest_ds.dart';
import 'package:warehouse_mobile/model/user.dart';
import 'package:warehouse_mobile/services/navigation_service.dart';
import 'package:warehouse_mobile/utils/shared_pref_util.dart';

class _RegisterData {
	String email = '';
	String password = '';
	String name = '';
	num role = 0;
	num accType = 0;
}

class RegisterScreenState extends State<RegisterScreen> {

	BuildContext _ctx;

	final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
	_RegisterData _data = new _RegisterData();

	RestDatasource api = new RestDatasource();

  @override
  Widget build(BuildContext context) {
		this._ctx = context;
		final Size screenSize = MediaQuery.of(context).size;

		return new Scaffold(
			appBar: new AppBar(
				title: new Text('Register'),
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
						new TextFormField(
							decoration: new InputDecoration(
								hintText: 'John Smith',
								labelText: 'Enter your name'),
							validator: this._validateName,
							onSaved: (String value) {
								this._data.name = value;
							}),
						new Row(
							mainAxisAlignment: MainAxisAlignment.center,
							children: <Widget>[
								new Radio(value: 0, groupValue: this._data.role, onChanged: _handleRadioChange,),
								new Text('Staff', style: new TextStyle(fontSize: 16.0)),
								new Radio(value: 1, groupValue: this._data.role, onChanged: _handleRadioChange,),
								new Text('Manager', style: new TextStyle(fontSize: 16.0))
							],
						),
						new Container(
							width: screenSize.width,
							child: new RaisedButton(
								child: new Text(
									'Reqister',
									style: new TextStyle(color: Colors.white),
								),
								onPressed: _submit,
								color: Colors.blue,
							),
							margin: new EdgeInsets.only(top: 20.0),
						)
					]))));
  }

	void _handleRadioChange(num value) {
  	setState(() {
			this._data.role = value;
  	});
	}

  String _validateName(String value) {
		if (value.length < 3) {
			return "Name must be at least 3 characters";
		}

		return null;
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

	void _submit() {
  	print('Register submit');
		final form = _formKey.currentState;

		if (form.validate()) {
			form.save();

			this.api.register(this._data.email, this._data.password,
				this._data.name, this._data.role).then((User user) {
				this.onRegisterSuccess(user);
			}).catchError((Object error) => this.onRegisterError(error.toString()));
		} else {
			print('Register form invalid');
		}
	}

	void onRegisterError(String errorText) {
		print("Register error:");
		print(errorText);
	}

	void onRegisterSuccess(User user) {
		print("Register success");
		var db = new DatabaseClient();
		db.saveUser(user);

		SharedPreferencesUtil.saveToken(user.token).then((void v) {
			new NavigationService().navigateTo(NavigationRoutes.PRODUCTS, this._ctx);
		});
	}
}

class RegisterScreen extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return new RegisterScreenState();
	}
}