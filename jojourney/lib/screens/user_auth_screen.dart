
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jojourney/models/https_exception.dart';
import 'package:jojourney/providers/users_provider.dart';
import 'package:provider/provider.dart';
import '../screens/tabs_screen.dart';

class UserAuth extends StatefulWidget {
  static const String userAuthRoute = '/userAuth';
  @override
  _UserAuthState createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  var isLogIn = false;
  var isLoading = false;
  var formKey = GlobalKey<FormState>();
  String name;
  String email;
  String password;
  String userType;
  var userNameNode = FocusNode();
  var passNode = FocusNode();

  void showErrDialog(String errMessage) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errMessage),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Dismiss'))
            ],
          );
        });
  }

  Future<void> formAuth() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      setState(() {
        isLoading = true;
      });

      try {
        if (isLogIn) {
          await Provider.of<UserProvider>(context, listen: false)
              .authenticate(name, email, password, 'signInWithPassword');

          Navigator.of(context).pushReplacementNamed(TabsScreen.tabsRoute);
        } else {
          await Provider.of<UserProvider>(context, listen: false)
              .authenticate(name, email, password, 'signUp');
          Navigator.of(context).pushReplacementNamed(TabsScreen.tabsRoute);
        }
      } on HttpsExceptions catch (error) {
        var errorMessage = 'Authentication Failed';

        if (error.toString().contains('EMAIL_EXISTS')) {
          errorMessage = 'This Email is Already in use';
        } else if (error.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'This is not a valid email address';
        } else if (error.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'This Password is Weak';
        } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Email Not Found';
        } else if (error.toString().contains('INVALID_PASSWORD')) {
          errorMessage = 'Email or Password is incorrect';
        }
        showErrDialog(errorMessage);
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(229, 204, 255, 1),
        resizeToAvoidBottomInset: false,
        body: Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 70),
            margin: EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/jojourneylogo.png',
                          height: 50,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'JoJourney',
                          style: TextStyle(fontSize: 30, color: Colors.black54),
                        ),
                      ]),
                ),
                Expanded(
                  flex: 3,
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            key: ValueKey('Email'),
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              icon: Icon(Icons.email_outlined),
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            textInputAction: TextInputAction.next,
                            focusNode: userNameNode,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (!value.contains('@'))
                                return 'Please enter a valid email address';
                              else
                                return null;
                            },
                            onSaved: (val) {
                              email = val;
                            },
                          ),
                          if (!isLogIn)
                            TextFormField(
                              key: ValueKey('UserName'),
                              focusNode: passNode,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  labelText: 'User Name',
                                  icon: Icon(Icons.person),
                                  fillColor: Colors.white),
                              validator: (value) {
                                if (value.length < 5)
                                  return 'Please enter a user name with more than 4 characters';
                                else
                                  return null;
                              },
                              onSaved: (val) {
                                name = val;
                              },
                            ),
                          TextFormField(
                            key: ValueKey('Password'),
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                icon: Icon(Icons.lock),
                                fillColor: Colors.white),
                            obscureText: true,
                            validator: (value) {
                              if (value.length < 8)
                                return 'Please enter a minimum of 8 characters';
                              else
                                return null;
                            },
                            onSaved: (val) {
                              password = val;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isLogIn = !isLogIn;
                              });
                            },
                            child: isLogIn
                                ? Text('Click here to create a new account !')
                                : Text(
                                    'Already have an account? click here to Login!'),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.black)),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                  TabsScreen.tabsRoute,
                                  arguments: 'guest');
                            },
                            icon: Icon(Icons.exit_to_app_outlined),
                            label: Text('Continue as a guest'),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.black)),
                          ),
                          ElevatedButton(
                            onPressed: formAuth,
                            child: isLoading
                                ? SizedBox(
                                    child: CircularProgressIndicator(),
                                    height: 15,
                                    width: 15,
                                  )
                                : (isLogIn ? Text('Login') : Text('Signup')),
                            style: ButtonStyle(
                              minimumSize:
                                  MaterialStateProperty.all(Size(120, 35)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              )),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black38),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )));
  }
}
