import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as syspaths;

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, BuildContext ctx) submitFn;
  final bool isLoading;

  AuthForm(this.submitFn, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  var _userEmail = '';
  var _userPassword = '';

  List<String> listOfLabs = ['Lab1', 'Lab2', 'Lab3'];
  var _labName = '';

  void _trySubmit() async {
    final bool isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = File('${appDir.path}/Lab.txt');
    filename.writeAsString('$_labName');
    print('Saved Lab name: $_labName');

    //  Send values to firebase for authentication...
    widget.submitFn(_userEmail.trim(), _userPassword.trim(), context);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_usernameFocusNode);
                    },
                    decoration: InputDecoration(labelText: 'Email address'),
                    validator: (value) {
                      if (!value.contains('@')) {
                        return 'Please provide a valid email containing \'@\'!';
                      } else if (value.isEmpty) {
                        return 'Please enter your email!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    focusNode: _passwordFocusNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Please enter a valid password with at least 7 characters!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Card(child: Text('Please select your location'),),
                      DropdownButton<String>(
                        value: _labName.isEmpty ? null : _labName,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        underline: Container(
                          height: 2,
                          color: Theme.of(context).accentColor,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            _labName = newValue;
                          });
                        },
                        items: listOfLabs
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text('Login'),
                      onPressed: _labName.isEmpty ? null : _trySubmit,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
