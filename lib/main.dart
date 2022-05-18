import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:async_builder/async_builder.dart';
import 'package:map_one_interface/getquery.dart';
import 'package:map_one_interface/mainpage.dart';
import 'package:map_one_interface/queriedPage.dart';
import 'package:map_one_interface/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'changePassword.dart';
import 'createaccount.dart';
import 'entry.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'login.dart';
import 'loginPage.dart';
import 'navigation.dart';
import 'feedback.dart';

// Global variables and constants
Icon SearchIcon = const Icon(Icons.search);
Icon FaceIcon = const Icon(Icons.face);
Icon HomeIcon = const Icon(Icons.home);
Widget Bar = const Text(" MapONE: One System for All Planetary Map Sources ");

List<String> logger = [];

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



final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();


    void downloadFile(String fileName, String content)
           {

            html.AnchorElement anchorElement =  new html.AnchorElement(href: fileName);

            anchorElement.appendText(content);

            anchorElement.download = fileName;

            anchorElement.click();
           }

    Future<EntryDataGridSource> getEntryDataSource() async
          {
           var entryList = await getApiEntries();

           return EntryDataGridSource(entryList);
          }


    List<GridColumn> getColumns()
         {
           List<GridColumn> columns;
           columns = <GridColumn>[
             GridColumn(columnName: "Source Name",
               width: 150,
               label:
               Container(
                   padding: EdgeInsets.all(8),
                   alignment: Alignment.center,
                   child: Text("Source Name",
                       overflow: TextOverflow.visible, softWrap: true )
               ),
             ),
             GridColumn(columnName: "Source Link",
               width: 150,
               label: Container(
                   padding: EdgeInsets.all(8),
                   alignment: Alignment.center,
                   child: Text("Source Link",
                       overflow: TextOverflow.visible, softWrap: true )
               ),
             ),
             GridColumn(columnName: "Map Body",
               width: 150,
               label: Container(
                   padding: EdgeInsets.all(8),
                   alignment: Alignment.center,
                   child: Text("Map Body",
                       overflow: TextOverflow.visible, softWrap: true )
               ),
             ),
             GridColumn(columnName: "Article Title",
               width: 150,
               label: Container(
                   padding: EdgeInsets.all(8),
                   alignment: Alignment.center,
                   child: Text("Article Title",
                       overflow: TextOverflow.visible, softWrap: true )
               ),
             ),
             GridColumn(columnName: "Author",
               width: 150,
               label: Container(
                   padding: EdgeInsets.all(8),
                   alignment: Alignment.center,
                   child: Text("Author",
                       overflow: TextOverflow.visible, softWrap: true )
               ),
             ),
             GridColumn(columnName: "Publication Date",
               width: 150,
               label: Container(
                   padding: EdgeInsets.all(8),
                   alignment: Alignment.center,
                   child: Text("Publication Date",
                       overflow: TextOverflow.visible, softWrap: true )
               ),
             ),
             GridColumn(columnName: "",
               width: 150,
               label: Container(
                   padding: EdgeInsets.all(8),
                   alignment: Alignment.center,
                   child: Text("")
               ),
             )
       ];
       return columns;
      }

    // Function: getApiEntries
    Future getApiEntries()
    async
    {
      // get request
      var response = await http.get(Uri.parse("https://mapone-api.herokuapp.com/entry/?action=0"));

      // store
      var decodedRes = json.decode(response.body).cast<Map<String,dynamic>>();

      List<Entry> responseList = await decodedRes.map<Entry>((json)=>
          Entry.fromJson(json)).toList();

      return responseList;
    }

   class EntryDataGridSource extends DataGridSource
      {

        EntryDataGridSource(this.entryList)
         {
          buildDataGridRow();
         }

        late List<DataGridRow> dataGridRows;
        late List<Entry> entryList;

        @override
        DataGridRowAdapter? buildRow(DataGridRow row)
         {

           logger.add(row.getCells()[1].value.toString());
           logger.add(row.getCells()[2].value.toString());
           logger.add(row.getCells()[3].value.toString());
           logger.add(row.getCells()[4].value.toString());
           logger.add(row.getCells()[5].value.toString());

           return DataGridRowAdapter(cells: [
             // Source Name
             Container(
               child: Text(row.getCells()[0].value.toString(),
                 overflow: TextOverflow.visible,
               ),
               alignment: Alignment.center,
               padding: EdgeInsets.all(8.0),
             ),

             // Source Link
             Container(
               child: GestureDetector
                 (
                 // allows text to
                 onTap: ()=>html.window.open(row.getCells()[1].value.toString(), "new tab"),
                 child: Text(row.getCells()[1].value.toString(),
                   style: TextStyle(color: Colors.blueAccent),
                   overflow: TextOverflow.visible,
                 ),
               ),
               alignment: Alignment.center,

             ),

             // Map Body
             Container(
               child: Text(row.getCells()[2].value.toString(),
                 overflow: TextOverflow.visible,
               ),
               alignment: Alignment.center,
               padding: EdgeInsets.all(8.0),
             ),

             // Article Title
             Container(
               child: Text(row.getCells()[3].value.toString(),
                 overflow: TextOverflow.visible,
               ),
               alignment: Alignment.center,
               padding: EdgeInsets.all(8.0),
             ),

             // Author
             Container(
               child: Text(row.getCells()[4].value.toString(),
                 overflow: TextOverflow.visible,
               ),
               alignment: Alignment.center,
               padding: EdgeInsets.all(8.0),
             ),

             // Publication Date
             Container(
               child: Text(row.getCells()[5].value.toString(),
                 overflow: TextOverflow.visible,
               ),
               alignment: Alignment.center,
               padding: EdgeInsets.all(8.0),
             ),

             // Feedback button
             Container(
                 child: Center(
                     child: GestureDetector(
                         onTap: () {
                           Navigator.pop(NavigationService.navigatorKey.currentContext!);
                           Navigator.push(
                               NavigationService.navigatorKey.currentContext!,
                               MaterialPageRoute(builder: (context) => feedback(entryID: row.getCells()[6].value.toString()))
                           );
                         },
                         child: Container(
                             height: 20,
                             width: 60,
                             decoration: BoxDecoration(
                               color: Colors.grey.shade800,
                               boxShadow: [
                                 BoxShadow(
                                     color: Colors.grey.shade700,
                                     spreadRadius: 1,
                                     blurRadius: 0.5
                                 )
                               ],
                             ),
                             child: Center(
                                 child: Text(
                                     "Submit Feedback",
                                     style: TextStyle(
                                         color: Colors.white,
                                         fontSize: 6
                                     )
                                 )
                             )
                         )
                     )
                 )
             )
           ]);
         }

       // allows row access
       List<DataGridRow> get rows => dataGridRows;

       void buildDataGridRow()
         {
          dataGridRows = entryList.map<DataGridRow>((dataGridRow){
            return DataGridRow(cells: [
              DataGridCell(columnName: 'Source Name', value: dataGridRow.source_name),
              DataGridCell(columnName: 'Source Link', value: dataGridRow.source_link),
              DataGridCell(columnName: 'Map Body', value: dataGridRow.map_body),
              DataGridCell(columnName: 'Article Title', value: dataGridRow.article_title),
              DataGridCell(columnName: 'Author', value: dataGridRow.author_list),
              DataGridCell(columnName: 'Publication Date', value: dataGridRow.publication_date),
              DataGridCell(columnName: "", value: dataGridRow.entry_id)
            ]);
            }).toList(growable: false);
          }

      }



void main() {
  runApp(MapOne());
}

class MapOne extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MapONE: One System for All Planetary Map Sources',
      theme: ThemeData.dark(),
      home: MapOneHomePage(title:'MapONE: One System for All Planetary Map Sources'),
      navigatorKey: NavigationService.navigatorKey,
    );
  }
}

class MapOneHomePage extends StatefulWidget {

  // init constructor
  MapOneHomePage({Key? key, inData, required this.title}) : super(key: key);

  // empty constructor
  MapOneHomePage2()
    {

    }

  @override
  String title = "MapONE: One System for All Planetary Map Sources";
  _MapOneHomePageState createState() => _MapOneHomePageState();


}

  class _MapOneHomePageState extends State<MapOneHomePage>

  {

  @override
  Widget build(BuildContext context)
     {
       TextEditingController _searchController = TextEditingController();
       String searchKW;

       return Scaffold(
         appBar: AppBar(
           title: Bar,
           automaticallyImplyLeading: false,
           actions: [
             IconButton(
               onPressed: () {
                 setState(() {

                   if(SearchIcon.icon == Icons.search)
                   {
                         SearchIcon = const Icon(Icons.cancel);
                         Bar = const ListTile(
                         leading: Icon(
                             Icons.search,
                             color: Colors.white,
                             size: 28));
                         TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                              hintText: 'type in journal name...',
                              hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontStyle: FontStyle.italic)));

                         searchKW = _searchController.text;

                         if(searchKW != null)
                           {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder:
                            (context) => queryPane()
                            ));
                           }

                   }
                   else
                   {
                     SearchIcon = const Icon(Icons.search);
                     Bar = const Text("Search by keyword or map body");
                   }
                 });
               },
               icon: SearchIcon,
             ),
             IconButton(
               onPressed:
                   ()
               {
                 const MaterialBanner(
                   padding: EdgeInsets.all(20),
                   content: Text(''),
                   leading: Icon(Icons.agriculture_outlined),
                   backgroundColor: Colors.green,
                   actions: <Widget>[
                     TextButton(
                       onPressed: null,
                       child: Text('DISMISS'),
                     ),
                   ],
                 );
               },
               icon: FaceIcon,
             ),
             IconButton(
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
                     (context) => login("", "") ));
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
               SizedBox(
                 height: 10,
               ),
               SizedBox(
                 height: 10,
               ),

               SizedBox(
                 height: 100,
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
                   Navigator.push(context, MaterialPageRoute(builder: (context) =>pwChangePane()));
                 },
                 child:
                 Card(
                   margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
                   elevation: 2.0,

                   child: Padding(
                       padding: EdgeInsets.symmetric(vertical: 25,horizontal: 100),
                       child: Text("Forgot Password",style: TextStyle(
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
           tooltip: 'Welcome to MapOne! To get started, login, create an account or continue as guest',

           child: Icon(Icons.info),
         ),

       );
       }
     }
