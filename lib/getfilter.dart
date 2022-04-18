import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'filterpage.dart';
import 'queriedPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'loginPage.dart';
import 'main.dart';
import 'mainpage.dart';

class filterPane extends StatefulWidget
{

  // constructor
  filterPane();

  _filterPageState createState() => _filterPageState();


}

class _filterPageState extends State<filterPane> {
  var photoArr = ['assets/images/curiosity.jpeg', 'assets/images/venus.jpeg',
    'assets/images/mars.jpeg', 'assets/images/titan.jpeg',
    'assets/images/uranus.jpeg',
  ];

  // function: validateQuery()
  // approach: takes in keyword, and gets response code from it.
  Future validateFilter(String start, String end)
  async
  {
    var response = await http.get(Uri.parse("https://mapone-api.herokuapp.com/entry/?action=2&first_year=${start}&second_year=${end}"));

    return response.statusCode;
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
  Widget build(BuildContext context)
  {
    // allows the system to fetch the inputted text values
    TextEditingController _startController = TextEditingController();
    TextEditingController _endController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: Bar,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed:
                  ()
              {
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
                      controller: _startController,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "range start",
                      ),),)
              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    child: TextField(
                      controller: _endController,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "range end",
                      ),),)
              ),
              RaisedButton(
                onPressed: ()
                async {
                  String start, end;
                  var responseCode;

                  start = _startController.text;
                  end = _endController.text;


                  responseCode = await validateFilter(start, end);
                  print(responseCode);


                  // validate request as successful prior to
                  // pushing requested searches into a table.
                  if(responseCode == 200)
                  {
                    print("Valid filter!");
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => filter(start, end)));
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Text("Filter"),
                ),
              ),
            ],
          ),
        )
    );
  }
}