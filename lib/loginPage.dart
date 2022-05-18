import 'dart:convert';
import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:map_one_interface/createaccount.dart';
import 'package:map_one_interface/main.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:map_one_interface/mainpage.dart';

import 'AutomateSearches.dart';
import 'changePassword.dart';
import 'getfilter.dart';
import 'getquery.dart';
import 'login.dart';
import 'loginSS.dart';

class login extends StatefulWidget
{
 static String username = "", password = "";
  // constructor
  login(String Username, String Password)
     {
       username = Username;
       password = Password;
     }

  _loginState createState() => _loginState();


}

class _loginState extends State<login>
{
  var photoArr = ['assets/images/curiosity.jpeg', 'assets/images/venus.jpeg',
    'assets/images/mars.jpeg', 'assets/images/titan.jpeg',
    'assets/images/uranus.jpeg',  ];

  // function: randomly selects a planetImage from photoArr
  // approach: randomly selects an index no larger than the length
  // of the arr
  randomlySelectPlanetImage(arr)
  {
    String returnStr;
    int maxInt = arr.length;
    int randomInt = Random().nextInt(maxInt);

    returnStr = arr[randomInt];

    return returnStr;
  }


  // Function: createUser
  // Approach: takes in username/email and password as a string and passes it into
  //get request
  Future createUser(String email, String password)
  async
  {
    // output flag
    bool testFlg = true;

    int responseCode = 0;

    // get request
    var response =
    await http.get(
        Uri.parse("https://mapone-api.herokuapp.com/user/?action=0&email_address=${email}&password=${password}"));

    responseCode = response.statusCode;

    if(testFlg == true)
    {
      print(responseCode);
    }


    return responseCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Bar,
        automaticallyImplyLeading: false,
        actions: [

          IconButton(
            onPressed:
                ()
            {
              // in order to change view, first the current
              // rendered context must be popped and then the
              // new one must be pushed onto the build stack
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder:
                  (context) => login(""," ") ));

            },
            icon:HomeIcon,
          ),
          IconButton( icon: Icon(Icons.vpn_key_outlined),
            onPressed:
                ()
            {
              // in order to change view, first the current
              // rendered context must be popped and then the
              // new one must be pushed onto the build stack
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder:
                  (context) => login("","") ));
            },

          ),
          IconButton( icon: Icon(Icons.search),
            onPressed:
                ()
            {
              // in order to change view, first the current
              // rendered context must be popped and then the
              // new one must be pushed onto the build stack
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder:
                  (context) => queryPane()));
            },
          ),
          IconButton( icon: Icon(Icons.filter_alt_rounded),
            onPressed:
                ()
            {
              // in order to change view, first the current
              // rendered context must be popped and then the
              // new one must be pushed onto the build stack
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder:
                  (context) => filterPane()));
            },
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
                  alignment: Alignment(0.0,2.5),
                ),
              ),
            ),


            InkWell(
              onTap: ()
              {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) =>loginPane()));
              },
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
                elevation: 2.0,

                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 25,horizontal: 100),
                    child: Text("Login",style: TextStyle(
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w300
                    ),)),
              ),
            ),

            InkWell(
              onTap: ()
              {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) =>createAcc()));
              },
              child:
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
                elevation: 2.0,

                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 25,horizontal: 100),
                    child: Text("Create Account",style: TextStyle(
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w300
                    ),)),
              ),
            ),
            InkWell(
              onTap: ()
              {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) =>mainpage()));
              },
              child:
              Card(
                  margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
                  elevation: 2.0,
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 25,horizontal: 100),
                      child: Text("Continue as Guest",style: TextStyle(
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w300
                      ),))
              ),

            ),
            InkWell(
              onTap: ()
              {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => automatedSearchesPane()));
              },
              child:
              Card(
                  margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
                  elevation: 2.0,
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 25,horizontal: 100),
                      child: Text("Automate Searches",style: TextStyle(
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w300
                      ),))
              ),

            ),
            InkWell(
              onTap: ()
              {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => loginSSPane(login.username, login.password)));
              },
              child:
              Card(
                  margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
                  elevation: 2.0,
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 25,horizontal: 100),
                      child: Text("Access Automated Searches",style: TextStyle(
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w300
                      ),))
              ),

            ),
            InkWell(
              onTap: ()
              {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) =>pwChangePane()));
              },
              child:
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
                elevation: 2.0,

                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 25,horizontal: 100),
                    child: Text("Change Password",style: TextStyle(
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w300
                    ),)),
              ),
            ),
          ],
          //],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Account Management',

        child: Icon(Icons.info),
      ),
    );}

}