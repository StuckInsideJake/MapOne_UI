import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:async_builder/async_builder.dart';
import 'package:map_one_interface/mainpage.dart';
import 'package:map_one_interface/queriedPage.dart';
import 'package:map_one_interface/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'createaccount.dart';
import 'entry.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'login.dart';
import 'loginPage.dart';


// Global variables and constants
Icon SearchIcon = const Icon(Icons.search);
Icon FaceIcon = const Icon(Icons.face);
Icon HomeIcon = const Icon(Icons.home);
Widget Bar = const Text(" MapOne ");

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
           GridColumn(columnName: "Entry ID",
           width: 70,
           label:
           Container(
               padding: EdgeInsets.all(8),
               alignment: Alignment.center,
               child: Text("Entry ID",
                   overflow: TextOverflow.clip, softWrap: true )
           ),

         ),
         GridColumn(columnName: "Body ",
           width: 70,
           label: Container(
               padding: EdgeInsets.all(8),
               alignment: Alignment.center,
               child: Text("Body",
                   overflow: TextOverflow.clip, softWrap: true )
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
         GridColumn(columnName: "Publication Date",
           width: 70,
           label: Container(
               padding: EdgeInsets.all(8),
               alignment: Alignment.center,
               child: Text("Publication Date",
                   overflow: TextOverflow.visible, softWrap: true )
           ),
         ),
         GridColumn(columnName: "Author",
           width: 70,
           label: Container(
               padding: EdgeInsets.all(8),
               alignment: Alignment.center,
               child: Text("Author",
                   overflow: TextOverflow.clip, softWrap: true )
           ),
         ),
         GridColumn(columnName: "URL",
           width: 150,
           label: Container(
               padding: EdgeInsets.all(8),
               alignment: Alignment.center,
               child: Text("URL",
                   overflow: TextOverflow.clip, softWrap: true )
           ),
         ),
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
             Container(
               child: Text(row.getCells()[0].value.toString(),
               overflow: TextOverflow.visible,
               ),
               alignment: Alignment.center,
               padding: EdgeInsets.all(8.0),
             ),
             Container(
               child: Text(row.getCells()[1].value.toString(),
                 overflow: TextOverflow.visible,
               ),
               alignment: Alignment.center,
               padding: EdgeInsets.all(8.0),
             ),
             Container(
               child: Text(row.getCells()[2].value.toString(),
                 overflow: TextOverflow.visible,
               ),
               alignment: Alignment.center,
               padding: EdgeInsets.all(8.0),
             ),
             Container(
               child: Text(row.getCells()[3].value.toString(),
                 overflow: TextOverflow.visible,
               ),
               alignment: Alignment.center,
               padding: EdgeInsets.all(8.0),
             ),
             Container(
               child: Text(row.getCells()[4].value.toString(),
                 overflow: TextOverflow.visible,
               ),
               alignment: Alignment.center,
               padding: EdgeInsets.all(8.0),
             ),
             Container(
               child: GestureDetector
                (
                 // allows text to
                 onTap: ()=>html.window.open(row.getCells()[5].value.toString(), "new tab"),
                 child: Text(row.getCells()[5].value.toString(),
                  style: TextStyle(color: Colors.blueAccent),
                  overflow: TextOverflow.visible,
                ),
                ),
               alignment: Alignment.center,

               ),
             // call in data logger here
           ] );
         }

       // allows row access
       List<DataGridRow> get rows => dataGridRows;

       void buildDataGridRow()
         {
          dataGridRows = entryList.map<DataGridRow>((dataGridRow){
            return DataGridRow(cells: [
              DataGridCell(columnName: 'entryID', value: dataGridRow.entry_id),
              DataGridCell(columnName: 'Body', value: dataGridRow.map_body),
              DataGridCell(columnName: 'Title', value: dataGridRow.article_title),
              DataGridCell(columnName: 'Publication date', value: dataGridRow.publication_date),
              DataGridCell(columnName: 'Publication Authors', value: dataGridRow.author_list),
              DataGridCell(columnName: 'URL', value: dataGridRow.source_link),
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
      title: 'MapOne',
      theme: ThemeData.dark(),
      home: MapOneHomePage(title:'MapOne Demo'),
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
  String title = "Map One Alpha";
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
                            (context) => query(searchKW)
                            ));
                           }

                   }
                   else
                   {
                     SearchIcon = const Icon(Icons.search);
                     Bar = const Text("Enter your query");
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
                     (context) => MapOne() ));

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
                     (context) => login() ));

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
                 height: 60,
               ),
               SizedBox(
                 height: 10,
               ),

               SizedBox(
                 height: 10,
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
                         padding: EdgeInsets.symmetric(vertical: 12,horizontal: 30),
                         child: Text("Login as Guest",style: TextStyle(
                             letterSpacing: 2.0,
                             fontWeight: FontWeight.w300
                         ),))
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
                       padding: EdgeInsets.symmetric(vertical: 12,horizontal: 30),
                       child: Text("Login with account",style: TextStyle(
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
                       padding: EdgeInsets.symmetric(vertical: 12,horizontal: 30),
                       child: Text("Create Account",style: TextStyle(
                           letterSpacing: 2.0,
                           fontWeight: FontWeight.w300
                       ),)),
                 ),
               ),

               SizedBox(
                 height: 15,
               ),

             ],
             //],
           ),
         ),
         floatingActionButton: FloatingActionButton(
           onPressed: null,
           tooltip: 'Account management',

           child: Icon(Icons.info),
         ),

       );

       }




     }
