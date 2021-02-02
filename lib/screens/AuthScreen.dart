import 'dart:math';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/HTTPException.dart';
import '../Providers/Auth.dart';

enum AuthMode { SignUp, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white, Colors.blueGrey[200]],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0, 1])),
          ),
          Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              // physics: BouncingScrollPhysics(),
              child: Container(
                  height: deviceSize.height * 0.8,
                  width: deviceSize.width,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        padding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                        transform: Matrix4.rotationZ(-8 * pi / 180)
                      ..translate(-10.0),
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26.withOpacity(0.15),
                              blurRadius: 10)
                        ]),
                        child: Text(
                      'ProShop',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 50,
                      ),
                        ),
                      ),
                    AuthCard() 
                    ],
                  )
                ),
            )
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin {

  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  var _isLoading = false;
  final _passwordController = TextEditingController();
  Map<String, String> _authData = {'email': '', 'password': ''};
  AnimationController _controller;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, 
      duration: Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween<double>(
      begin: 0, 
      end: 1
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn
      )
    );

    // _heightAnimation.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // error flushbar
  void flushBar(String errorMessage) {
    Flushbar(
      message: errorMessage,
      icon: Icon(
        Icons.error,
        size: 28.0,
        color: Colors.white,
      ),
      borderRadius: 8,
      backgroundColor: Colors.red,
      margin: EdgeInsets.all(8),
      duration: Duration(seconds: 2),
    ).show(context);
  }

  //  when submitting the form
  Future <void> submit() async {
    String errorMessage;

    if (!_formKey.currentState.validate()) {
      // invalid
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'], 
          _authData['password']
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'], 
          _authData['password']
        );
      }
    } on HttpException catch (error) {
      if(error.toString().contains('EMAIL_EXISTS'))
        errorMessage = "An account with this email address already exists";
      else if(error.toString().contains('INVALID_EMAIL'))
        errorMessage = "This is not a valid email";
      else if(error.toString().contains('EMAIL_NOT_FOUND'))
        errorMessage = "Could not find that email address";
      else if(error.toString().contains('INVALID_PASSWORD'))
        errorMessage = "Invalid Password";
      else
        errorMessage = "Authentication Failed";

      flushBar(errorMessage);

    } catch (_) {
      errorMessage = "Something went wrong when authenticating you. Please try again later";
      flushBar(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  // swap between login and signup
  void _switchAuthMode() {
    setState(() {
      if (_authMode == AuthMode.Login) {
        _authMode = AuthMode.SignUp;
        _controller.forward();
      } else {
        _authMode = AuthMode.Login;
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black38.withOpacity(0.25), blurRadius: 10)
          ]),
      height: _authMode == AuthMode.Login ? 340 : 400,
      // height: _heightAnimation.value.height,
      // constraints: BoxConstraints(minHeight: _heightAnimation.value.height),
      child: Container(
        width: deviceSize.width * 0.8,
        padding: EdgeInsets.only(top: 20, right: 20, left: 20, bottom:13),
        child: Form(  
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [ 
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) { 
                      return 'Invalid Email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Please Enter a valid password';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                if (_authMode == AuthMode.SignUp)
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: TextFormField(
                      enabled: _authMode == AuthMode.SignUp,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Confirm Password'),
                      validator: _authMode == AuthMode.SignUp
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            }
                          : null,
                    ),
                  ),
                SizedBox(
                  height: 30,
                ),
                if (_isLoading)
                  Container(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  )
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.SignUp ? 'Sign Up' : 'Log In'),
                    onPressed: submit,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  ),
                FlatButton(
                    onPressed: _switchAuthMode,
                    child: Text(
                      '${_authMode == AuthMode.Login ? 'Sign Up' : 'Log In'} Instead',
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textColor: Theme.of(context).primaryColor)
              ],
          ),
          ),
      ) 
    );
  }
}
