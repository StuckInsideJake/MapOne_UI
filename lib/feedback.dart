import 'dart:convert';
import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:map_one_interface/main.dart';
import 'package:http_requests/http_requests.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'mainpage.dart';
import 'loginPage.dart';
import 'feedbackSubmit.dart';


class feedback extends StatefulWidget
{
  const feedback({Key? key, required this.entryID}): super(key:key);

  final String entryID;

  @override
  _feedbackState createState() => _feedbackState();
}

class _feedbackState extends State<feedback>
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

  // store feedback, makes get request to backend API
  // add entry
  Future leaveFeedback(String? validate_map, String? validate_data, String feedback)
  async
  {
    // get request
    var response = await http.get(
        Uri.parse("https://mapone-api.herokuapp.com/entry/?action=3&entry_id=${widget.entryID}&validate_map=${validate_map}&validate_data=${validate_data}&feedback=${feedback}")
    );

    // return HTTP response code
    return response.statusCode;
  }

  // menu items and error messages variables
  String? dropdownValueOne, dropdownValueTwo;

  String? get errorTextOne {
    if (dropdownValueOne == null) {
      return '*Required Field';
    }
    return null;
  }

  String? get errorTextTwo {
    if (dropdownValueTwo == null) {
      return '*Required Field';
    }
    return null;
  }

  @override
  Widget build(BuildContext context)
  {
    // allows the system to fetch the inputted text values
    TextEditingController _feedbackController = TextEditingController();

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
                    MaterialPageRoute(builder: (context) => login("",""))
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
              SizedBox(height: 15),

              // dropdown menu for valid or invalid publication
              Container(
                  height: 70,
                  width: 250,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        labelText: 'Contains Planetary Map',
                        errorText: errorTextOne
                    ),
                    value: dropdownValueOne,
                    isExpanded: true,
                    items: ['Yes', 'No'].map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (changedValue){
                      dropdownValueOne = changedValue;
                      setState((){
                        dropdownValueOne;
                      });
                    },
                  )
              ),
              SizedBox(height: 10),

              // dropdown menu for valid or invalid publication
              Container(
                  height: 70,
                  width: 250,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        labelText: 'Correct Source Data',
                        errorText: errorTextTwo
                    ),
                    value: dropdownValueTwo,
                    isExpanded: true,
                    items: ['Yes', 'No'].map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (changedValue){
                      dropdownValueTwo = changedValue;
                      setState((){
                        dropdownValueTwo;
                      });
                    },
                  )
              ),

              // submission button
              Container(
                width: 700,
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                  child: TextField(
                    maxLines: 10,
                    controller: _feedbackController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Comment"
                    ),
                  ),
                ),
              ),
              RaisedButton(onPressed: () async
              {
                String? validate_map, validate_data, feedback;
                var responseCode;
                feedback = _feedbackController.text;
                validate_map = dropdownValueOne;
                validate_data = dropdownValueTwo;

                // map and data feedback provided
                if(!(validate_map == null || validate_data == null))
                {
                  // make API request
                  responseCode = await leaveFeedback(validate_map, validate_data, feedback);

                  // if successful operation
                  if(responseCode == 200)
                  {
                    // redirect to submission success page
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => feedbackSubmit())
                    );
                  }
                }

              },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Text("Submit Feedback"),
                ),
              ),
            ],
          ),
        )
    );
  }
}
