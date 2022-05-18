import 'dart:convert';
import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:map_one_interface/main.dart';
import 'package:http_requests/http_requests.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'mainpage.dart';
import 'feedback.dart';
import 'loginPage.dart';

// feedback submission page constructor
class feedbackSubmit extends StatefulWidget
{
  feedbackSubmit();
  _feedbackSubmitState createState() => _feedbackSubmitState();
}

// feedback submission page class
class _feedbackSubmitState extends State<feedbackSubmit>
{
  // display planetary images
  // NOTE: used throughout the website
  var photoArr = [
    'assets/images/curiosity.jpeg',
    'assets/images/venus.jpeg',
    'assets/images/mars.jpeg',
    'assets/images/titan.jpeg',
    'assets/images/uranus.jpeg'
  ];

  randomlySelectPlanetImage(arr)
  {
    String returnStr;
    int maxInt = arr.length;
    int randomInt = Random().nextInt(maxInt);

    returnStr = arr[randomInt];

    return returnStr;
  }

  @override
  Widget build(BuildContext context)
  {
    // show menu
    return Scaffold(
        appBar: AppBar(
          title: Bar,
          automaticallyImplyLeading: false,
          actions: [

            IconButton (onPressed: ()
            {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => login(" "," "))
              );
            },
                icon: HomeIcon
            ),
            IconButton (icon: Icon(Icons.arrow_back), onPressed: ()
            {
              setState( ()
              {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => login("", ""))
                );
              }
              );
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

              // show submission success
              Container(
                  alignment: Alignment.center,
                  height: 200,
                  width: double.infinity,
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(30),
                  child: Text("Thank you for your feedback.",
                      style: TextStyle(fontSize: 30)
                  )
              ),
              RaisedButton(onPressed: () async
              {
                // redirect to submission success page
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => mainpage())
                );
              },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Text("Go Back to Main Page"),
                ),
              ),
            ],
          ),
        )
    );
  }
}
