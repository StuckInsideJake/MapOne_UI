import 'dart:convert';
import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:map_one_interface/main.dart';
import 'package:http_requests/http_requests.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:map_one_interface/mainpage.dart';

import 'loginPage.dart';

class loginPane extends StatefulWidget
{

  // constructor
  loginPane();

  _createAccState createState() => _createAccState();


}

class _createAccState extends State<loginPane> {
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

  // Function: createUser
  // Approach: takes in username/email and password as a string and passes it into
  //get request
  Future loginUser(String email, String password)
  async
  {
    // output flag
    bool testFlg = true;

    int responseCode = 0;

    // get request
    var response =
    await http.get(
        Uri.parse("https://mapone-api.herokuapp.com/user/?action=1&email_address=${email}&password=${password}"));

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
                    (context) => MapOne()));
              },
              icon: HomeIcon,
            ),
            IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => login()));
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
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Please enter Your email"
                    ),),),

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
                        labelText: "Please enter your password",
                      ),),)
              ),

              RaisedButton(
                onPressed: ()
                async {
                  String email, password;
                  var responseCode;
                  email = _emailController.text;
                  password = _passwordController.text;

                  responseCode = await loginUser(email, password);

                  print(responseCode);

                  if(responseCode == 200)
                  {

                    print("User successfully logged in!!");

                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => mainpage()));
                  }

                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Text("Login"),
                ),
              ),


            ],
          ),
        )
    );
  }
}