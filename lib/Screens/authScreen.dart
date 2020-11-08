import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/authProvider.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
//        title: Text("SLOT"),
        title: Image.network(
          "https://slot.ng/wp-content/uploads/2019/04/logo-icon.png", // d image link
          fit: BoxFit.cover, // we make our image have css cover attribute
          color: Colors.white,
          width: 70,
        ),
      ),
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            child: Image.asset(
              "lib/assets/images/background.jpg",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            /*   decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),*/
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  /*Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      // we use this to transform and rotate the container
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        // bcos '.translate()' will return void and 'transform' doesnt want void value, we use double dot so the translate can apply its transformation but then return the result of the previous function i.e. rotationZ.. Another way of achieve ds is using d code in line 13 & 14... ds is called "cascade operator"
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'SLOT.ng',
                        style: TextStyle(
                          color: Theme.of(context).accentTextTheme.title.color,
                          fontSize: 50,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),*/
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  //To start with animation we declare animationController which we will use to start d animation
  AnimationController _controller;
/*  //we then define wat we want to animate (we animating d size of the form).. ds will b used to change the animation value overtime
  Animation<Size> _heightAnimation;*/
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    //vsync : - d widget to watch and wait for its visibility b4 d animation kicks off.. ds is bind to 'this' (ds widget) using the 'SingleTickerProviderStateMixin'
    //duration : - d length of time ds animation should last
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    // Here we setup our opacity animation configuration to start from transparent (0.0 opacity) to fully visible
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
/*    // Tween takes a size with begin and end to define d size change from start and end
    _heightAnimation = Tween<Size>(
            begin: Size(double.infinity, 260), end: Size(double.infinity, 320))
        //animate defined how the animation will happen taken d defined _controller property
        // curve defined the type of animation/transition e.g. Curves.linear, Curves.easeIn, bounceIn, bounceOut etc
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));*/

    // we add a listener to update the state so the entire widget rebuilds ( ds is not performant bcos we sud only rebuild d form container we want to control its height)
    // we are changing ds to our Animated builder
    // _heightAnimation.addListener(() => setState(() {}));
  }

  // we dispose the animation listener
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  //alert dialog for http error handling
  void _showErrorDialog(String message) {
    Platform.isIOS
        ? showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
                  title: Text(
                    "An Error Occurred",
                    textAlign: TextAlign.center,
                  ),
                  content: Text(message),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Okay"),
                    )
                  ],
                ))
        : AlertDialog(
            title: Text(
              "An Error Occurred",
              textAlign: TextAlign.center,
            ),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Okay"),
              )
            ],
          );
  }

  Future _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    //try to perform d sign/register operation
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<AuthProvider>(context)
            .signIn(_authData['email'], _authData['password']);
        // on successful sign-in, we navigate user to the productOverviewScreen
        Navigator.of(context).pushNamed("/shop");
      } else {
        await Provider.of<AuthProvider>(context)
            .signUp(_authData['email'], _authData['password']);
        // on successful sign-in, we navigate user to the productOverviewScreen
        Navigator.of(context).pushNamed("/shop");
        // Sign user up
      }
    }
    // if we get error thrown from our custom http exception i.e. from firebase
    on HttpException catch (error) {
      var errorMessage = "Authentication Failed!";
      if (error.toString().contains("EMAIL_EXISTS")) {
        errorMessage = "Email Already In Use";
      } else if (error.toString().contains("INVALID_EMAIL")) {
        errorMessage = "Email Is Invalid";
      } else if (error.toString().contains("WEAK_PASSWORD")) {
        errorMessage = "Password Too Weak";
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "Password Is Invalid";
      }
      _showErrorDialog(errorMessage);
    }
    // other error not handled by our custom exception handler
    catch (error) {
      const errorMessage =
          "Could Not Authenticate You. Please Try Again Later!";
      _showErrorDialog(errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      //when we switch our form mode from login to signUp mode, we run the animation so it increases the height from 260 to 320
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      //when we switch back to login, ds time we want to reverse the animation so we move from 320 back to 260
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true, // ds set the input type to password ****
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                /*
                // Without Animation
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true, // ds set the input type to password ****
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                  ),*/
                // With Animation : - We wrap our confirm password field inside an AnimatedContainer so we are able to achieve the same condition of when to show the field and when to hide which we previously used 'if (_authMode == AuthMode.Signup)' to achieve
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  // d constraints is applied to define when ds container will show so when we are in login mode, d height is 0 which means its totally hidden
                  constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.Login ? 0 : 60,
                      maxHeight: _authMode == AuthMode.Login ? 0 : 120),
                  curve: Curves.easeIn,
                  //Animation 1
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    // Animation 2
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.Signup,
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        obscureText:
                            true, // ds set the input type to password ****
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize
                      .shrinkWrap, // shrinks the button to look smaller and nicer
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
