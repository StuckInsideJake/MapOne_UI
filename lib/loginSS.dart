import 'dart:convert';
import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:map_one_interface/main.dart';
import 'package:http_requests/http_requests.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:map_one_interface/mainpage.dart';

import 'AutomatedSearchesPage.dart';
import 'loginPage.dart';

class loginSSPane extends StatefulWidget
{
  static String Username="", Password="";
  // constructor
  loginSSPane(String username, String password)
     {
      Username = username;
      Password = password;
     }

  _createAccState createState() => _createAccState();


}

class _createAccState extends State<loginSSPane> {
  var photoArr = ['assets/images/curiosity.jpeg', 'assets/images/venus.jpeg',
    'assets/images/mars.jpeg', 'assets/images/titan.jpeg',
    'assets/images/uranus.jpeg',
  ];


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

  // Function: _SSerrorMessage
  // Approach pops context on screen and pushes an AlertDialog box
  // with button to go back to prev menu and try again.
  Future<void> _SSerrorMessage() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Invalid request'),
                Text('Please try again'),
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

  // Function: createUser
  // Approach: takes in username/email and password as a string and passes it into
  //get request
  Future loginUser(String email, String password, String keyword)
  async
  {
    // output flag
    bool testFlg = true;

    int responseCode = 0;

    // get request
    var response =
    await http.get(
        Uri.parse("https://mapone-api.herokuapp.com/user/?action=1&email_address=${email}&password=${password}&search_keyword=${keyword}"));

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
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _kwController = TextEditingController();

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
                        MaterialPageRoute(builder: (context) => login("","")));
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
                      controller: _kwController,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter keyword",
                      ),),)
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
                        labelText: "Enter email",
                      ),),)
              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter password",
                      ),),)
              ),

              RaisedButton(
                onPressed: ()
                async {
                  String email, password, keyword;
                  var responseCode;
                  email = _emailController.text;
                  password = _passwordController.text;
                  keyword = _kwController.text;

                  responseCode = await loginUser(email, password, keyword);

                  print(responseCode);

                  if(responseCode == 200)
                  {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => autoSearchPage(keyword)));
                  }
                  if(responseCode != 200)
                  {
                   await _SSerrorMessage();
                  }

                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Text("Access Search"),
                ),
              ),
            ],
          ),
        )
    );
  }
}
