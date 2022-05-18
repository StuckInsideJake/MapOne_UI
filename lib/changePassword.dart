import 'dart:convert';
import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:map_one_interface/main.dart';
import 'package:http_requests/http_requests.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:map_one_interface/mainpage.dart';

import 'loginPage.dart';

class pwChangePane extends StatefulWidget
{

  // constructor
  pwChangePane();

  _changepwState createState() => _changepwState();


}

class _changepwState extends State<pwChangePane>
{

  var photoArr = ['assets/images/curiosity.jpeg', 'assets/images/venus.jpeg',
    'assets/images/mars.jpeg', 'assets/images/titan.jpeg',
    'assets/images/uranus.jpeg',
  ];



  // Function: _errorMessage
  // Approach pops context on screen and pushes an AlertDialog box
  // with button to go back to prev menu and try again.
  Future<void> _CPerrorMessage() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Incorrect email address or password'),
                Text('Password must be at least 8 characters long,'
                    ' and contain at least 1 special character and 1 number'
                    ''),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              // user must tap this to exit alertDialog
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  // function: randomly selects a planetImage from photoArr
  // approach: randomly selects an index no larger than the length
  // of the arr
  randomlySelectPlanetImage(arr) {
    String returnStr;
    int maxInt = arr.length;
    int randomInt = Random().nextInt(maxInt);

    returnStr = arr[randomInt];

    return returnStr;
  }

  // Function: createUser
  // Approach: takes in username/email and password as a string and passes it into
  //get request
  Future ChangeUserPassword(String email, String password, String passwordVerification)
  async
  {
    // output flag
    bool testFlg = true;

    int responseCode = 0;

    // get request
    var response =
    await http.get(
        Uri.parse("https://mapone-api.herokuapp.com/user/?action=2&email_address=${email}&password=${password}&new_password=${passwordVerification}"));

    responseCode = response.statusCode;

    if(testFlg == true)
    {
      print(responseCode);
    }


    return responseCode;
  }

  // Function: GetEmail
  // Fetches email
  //
  @override
  Widget build(BuildContext context) {
    // allows the system to fetch the inputted text values
    TextEditingController _pwController = TextEditingController();
    TextEditingController _pwvController = TextEditingController();
    TextEditingController _emailController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: Bar,
          automaticallyImplyLeading: false,
          actions: [

            IconButton(
              onPressed:
                  () {
                //in order to change view, first the current
                // rendered context must be popped and then the
                // new one must be pushed onto the build stack
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder:
                    (context) => login("","")));
              },
              icon: HomeIcon,
            ),
            IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => login("", "")));
                  });
                }
            ),
          ], // Actions
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(randomlySelectPlanetImage(photoArr)),
                        fit: BoxFit.fitWidth
                    )
                ),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  child: Container(
                    alignment: Alignment(0.0, 2.5),
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    child: TextField(
                      controller: _emailController,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter email address",
                      ),),)
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: TextField(
                    controller: _pwController,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter old password"
                    ),),),

              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    child: TextField(
                      controller: _pwvController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter new password",
                      ),),)
              ),
              RaisedButton(
                onPressed: ()
                async {
                  String email, password, passwordVerification;
                  var responseCode;
                  email = _emailController.text;
                  password = _pwController.text;
                  passwordVerification = _pwvController.text;

                  responseCode = await ChangeUserPassword(email, password, passwordVerification);

                  if(responseCode == 200)
                  {
                    print("User successfully changed pw!!");
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => mainpage()));
                  }
                  if(password.length < 8 || passwordVerification.length < 8 )
                  {
                    _CPerrorMessage();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Text("Change Password"),
                ),
              ),
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Password must be 8 characters long and contain at least 1 special char and 1 number',
        child: Icon(Icons.info),
      ),
    );
  }
}
