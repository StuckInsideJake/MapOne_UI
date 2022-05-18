import 'dart:convert';
import 'dart:html';
import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:map_one_interface/login.dart';
import 'package:map_one_interface/main.dart';
import 'package:http_requests/http_requests.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:map_one_interface/mainpage.dart';
import 'loginPage.dart';
import 'entry.dart';

class automatedSearchesPane extends StatefulWidget
{
  static String username = "", password = " ";


  // constructor
  automatedSearchesPane();


  _createAutoSearchesState createState() => _createAutoSearchesState();


}

class _createAutoSearchesState extends State<automatedSearchesPane> {
  var photoArr = ['assets/images/curiosity.jpeg', 'assets/images/venus.jpeg',
    'assets/images/mars.jpeg', 'assets/images/titan.jpeg',
    'assets/images/uranus.jpeg',
  ];


  Future createAutoSearch(String un, String pw, String kw, String fre)
  async
  {
    String resStr, returnStr;

    // get request
    var response = await http.get(Uri.parse("https://mapone-api.herokuapp.com/archive/?action=0&email_address=${un}&password=${pw}&keyword=${kw}&frequency=${fre}"));

    resStr = response.body;

    returnStr = strStripper(resStr);

    // store email_address
    //var decodedRes = json.decode(response.body).cast<Map<String,dynamic>>();

   // List<Entry> responseList = await decodedRes.map<Entry>((json)=>
     //   Entry.fromJson(json)).toList();

    // if responseCode flag is true return the
    // the response code, otherwise return data

    return returnStr;
  }

  // Function: _SSerrorMessage
  // Approach pops context on screen and pushes an AlertDialog box
  // with button to go back to prev menu and try again.
  Future<void> _freqErrorMessage() async {
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
                Text('Enter a valid frequency'),
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

  // Function: _SSerrorMessage
  // Approach pops context on screen and pushes an AlertDialog box
  // with button to go back to prev menu and try again.
  Future<void> _pwErrorMessage() async {
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
                Text('Enter a valid password'),
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


  //StrStripper
  // Strips the messages from the backend
  // and returns the string with desired keywords
  String strStripper(String response)
  {
    String returnStr = "";
    var match;
    int index = 0;

    match = response.allMatches("operation success");

    for(Match m in match)
    {
      returnStr = m[0]!;
      print(match);
    }


    return returnStr;
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




  @override
  Widget build(BuildContext context) {

    // allows the system to fetch the inputted text values
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _freqController = TextEditingController();
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
                    controller: _emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter email address"
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
                        labelText: "Enter password",
                      ),),)
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
                      controller: _freqController,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter frequency (Day, Biweek, Week or Month)",
                      ),),)
              ),

              RaisedButton(
                onPressed: ()
                async {
                  String email, password;
                  var responseStr;
                  email = _emailController.text;
                  password = _passwordController.text;
                  String keyword = _kwController.text;
                  String frequency = _freqController.text;


                  responseStr = await createAutoSearch(email, password, keyword, frequency);


                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => login("","")));

                    if(frequency != "Day" && frequency != "Week" && frequency != "Biweek" && frequency != "Month")
                      {
                        await _freqErrorMessage();
                      }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Text("Automate Searches"),
                ),
              ),
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Enter password, email address, freqency, and keyword ',

        child: Icon(Icons.info),
      ),
    );
  }
}
