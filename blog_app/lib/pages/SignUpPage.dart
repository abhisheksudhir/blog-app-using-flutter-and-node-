import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:blog_app/NetworkHandler.dart';
import 'package:blog_app/pages/HomePage.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/sign-up';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorText;
  String errorTextUser;
  String errorTextEmail;
  bool validate = false;
  bool circular = false;
  final storage = new FlutterSecureStorage();
  // final _usernameFocusNode = FocusNode();
  // final _emailFocusNode = FocusNode();
  // final _passwordFocusNode = FocusNode();

  // @override
  // void dispose() {
  //   // _usernameFocusNode.dispose();
  //   // _emailFocusNode.dispose();
  //   // _passwordFocusNode.dispose();
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          // height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.green[200]],
              begin: const FractionalOffset(0.0, 1.0),
              end: const FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.repeated,
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _globalkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sign up with email",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  usernameTextField(),
                  emailTextField(),
                  passwordTextField(),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        circular = true;
                      });
                      await checkUserAndEmail();
                      // if (networkErr) {
                      //   showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return AlertDialog(
                      //         title: Text("Error"),
                      //         content: Text("Network Error."),
                      //         actions: <Widget>[
                      //           FlatButton(
                      //             child: new Text("Cancel"),
                      //             onPressed: () {
                      //               Navigator.of(context).pop();
                      //             },
                      //           ),
                      //         ],
                      //       );
                      //     },
                      //   );
                      //   setState(() {
                      //     circular = false;
                      //   });
                      // }
                      if (_globalkey.currentState.validate() && validate) {
                        // we send data to rest api server
                        Map<String, String> data = {
                          "username": _usernameController.text,
                          "email": _emailController.text,
                          "password": _passwordController.text,
                        };
                        print(data);
                        var responseRegister =
                            await networkHandler.post("/user/register", data);
                        if (responseRegister == null) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Some eror occured. Please try later',
                              ),
                              duration: Duration(
                                seconds: 2,
                              ),
                            ),
                          );
                          setState(() {
                            validate = false;
                            circular = false;
                          });
                        } else if (responseRegister.statusCode == 200 ||
                            responseRegister.statusCode == 201) {
                          Map<String, String> data = {
                            "username": _usernameController.text,
                            "password": _passwordController.text,
                          };
                          var response =
                              await networkHandler.post("/user/login", data);
                          if (response == null) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Some eror occured. Please try later',
                                ),
                                duration: Duration(
                                  seconds: 2,
                                ),
                              ),
                            );
                            setState(() {
                              validate = false;
                              circular = false;
                            });
                          } else if (response.statusCode == 200 ||
                              response.statusCode == 201) {
                            Map<String, dynamic> output =
                                json.decode(response.body);
                            print(output["token"]);
                            await storage.write(
                              key: "token",
                              value: output["token"],
                            );
                            await storage.write(
                              key: "username",
                              value: data["username"],
                            );
                            setState(() {
                              validate = true;
                              circular = false;
                            });
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                HomePage.routeName, (route) => false);
                          } else {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Netwok Error',
                                ),
                                duration: Duration(
                                  seconds: 2,
                                ),
                              ),
                            );
                          }
                        }

                        setState(() {
                          circular = false;
                        });
                      } else {
                        setState(() {
                          circular = false;
                        });
                      }
                    },
                    child: circular
                        ? CircularProgressIndicator()
                        : Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xff00A86B),
                            ),
                            child: Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  checkUserAndEmail() async {
    if (_usernameController.text.length == 0 ||
        (_emailController.text.length == 0 ||
            !_emailController.text.contains("@"))) {
      setState(() {
        // circular = false;
        validate = false;
        errorTextUser = _usernameController.text.length == 0
            ? "Username can't be empty"
            : null;
        errorTextEmail = _emailController.text.length == 0
            ? "Email can't be empty"
            : (!_emailController.text.contains("@")
                ? "Email is Invalid"
                : null);
      });
    } else {
      var response = await networkHandler
          .get("/user/checkusername/${_usernameController.text}");
      var response1 =
          await networkHandler.get("/user/checkemail/${_emailController.text}");
      if (response == null || response1 == null) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Some eror occured. Please try later',
            ),
            duration: Duration(
              seconds: 2,
            ),
          ),
        );
        setState(() {
          circular = false;
        });
      } else if (response["Status"] || response1["Status"]) {
        setState(() {
          // circular = false;
          // networkErr = false;
          validate = false;
          errorTextUser = response["Status"] ? "Username already taken" : null;
          errorTextEmail = response1["Status"] ? "Email already taken" : null;
        });
      } else {
        setState(() {
          // circular = false;
          // networkErr = false;
          validate = true;
        });
      }
    }
  }

  Widget usernameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
      child: Column(
        children: [
          Text("Username"),
          TextFormField(
            controller: _usernameController,
            // focusNode: _usernameFocusNode,
            textInputAction: TextInputAction.next,
            // onFieldSubmitted: (_) {
            //   FocusScope.of(context).requestFocus(_emailFocusNode);
            // },
            decoration: InputDecoration(
              errorText: validate ? null : errorTextUser,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget emailTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
      child: Column(
        children: [
          Text("Email"),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            // focusNode: _emailFocusNode,
            textInputAction: TextInputAction.next,
            // onFieldSubmitted: (_) {
            //   FocusScope.of(context).requestFocus(_passwordFocusNode);
            // },
            // validator: (value) {
            //   if (value.isEmpty) return "Email can't be empty";
            //   if (!value.contains("@")) return "Email is Invalid";
            //   return null;
            // },
            decoration: InputDecoration(
              errorText: validate ? null : errorTextEmail,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget passwordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
      child: Column(
        children: [
          Text("Password"),
          TextFormField(
            controller: _passwordController,
            // focusNode: _passwordFocusNode,
            validator: (value) {
              if (value.isEmpty) return "Password can't be empty";
              if (value.length < 8) return "Password lenght must have >=8";
              return null;
            },
            obscureText: vis,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    vis = !vis;
                  });
                },
              ),
              helperText: "Password length should have >=8",
              helperStyle: TextStyle(
                fontSize: 14,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
