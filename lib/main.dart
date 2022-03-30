import 'dart:io';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:flutter/cupertino.dart';
import 'dart:html' as html;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:async_builder/async_builder.dart';
import 'package:map_one_interface/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'entry.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher_web/url_launcher_web.dart';
import 'loginPage.dart';


// Global variables and constants
Icon SearchIcon = const Icon(Icons.search);
Icon FaceIcon = const Icon(Icons.face);
Icon HomeIcon = const Icon(Icons.home);
Widget Bar = const Text(" MapOne ");

List<String> logger = [];



// setting list to a string then spliting it into a new list on the main to call
// overflows for some reason
  // String entryIdArr = backEndCalls(entryIdArr) as String;
 //List EntryIdArr = entryIdArr.split(',');


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
           label: Container(
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
                   overflow: TextOverflow.clip, softWrap: true )
           ),
         ),
         GridColumn(columnName: "Author(s)",
           width: 70,
           label: Container(
               padding: EdgeInsets.all(8),
               alignment: Alignment.center,
               child: Text("Author(s)",
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

  class _MapOneHomePageState extends State<MapOneHomePage> {

  @override
  Widget build(BuildContext context)
     {
       // allows selection of text data populated from the api
      final DataGridController _dataGridController = DataGridController();


      return SafeArea(child:

        Scaffold( appBar:
        AppBar(
          title: Bar,
          automaticallyImplyLeading: false,
          actions:
          [
            IconButton( icon: SearchIcon,
            onPressed: () {
              setState(() {
                if(SearchIcon.icon == Icons.search)
                  {
                   SearchIcon = const Icon(Icons.cancel);
                   Bar = const ListTile(leading:
                   Icon(
                     Icons.search,
                     color: Colors.white,
                     size: 28
                   ));
                  }
                else
                  {
                   SearchIcon = const Icon(Icons.search);
                   Bar = const Text("Search");
                  }
              });
        } ),
            // button for user page
            IconButton( icon: Icon(Icons.face),
              onPressed: (){
               setState(() {
                 Navigator.pop(context);
                 Navigator.push(context, MaterialPageRoute(builder:
                     (context) => user() ));
               });
              },
          ),
           IconButton(
               icon: Icon(Icons.home),
               onPressed: (){
                 setState(() {
                   Navigator.pop(context);
                   Navigator.push(context, MaterialPageRoute(builder: (context) => MapOne() ));
                 });
               }
           ),
            IconButton(
                icon: Icon(Icons.vpn_key_outlined),
                onPressed: (){
                  setState(() {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => login() ));
                  });
                }
            ),
          ],

        ),

        body:
        Row(mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [

          Column(mainAxisAlignment: MainAxisAlignment.start,

          children: [

            ElevatedButton(
              child: Text('Export all Publications to csv'),
              onPressed: () {

                // verify data is not null
                if(logger!= null)
                  {
                    int length = logger.length, index = 0;

                    String loopStr = '';


                    while(index < length-1)
                      {
                        loopStr += logger.elementAt(index);
                        index++;
                      }

                    if(loopStr != null)
                      {
                        downloadFile("mapone.csv", loopStr);
                      }

                  }

              }),],),

          Expanded( child: FittedBox(fit: BoxFit.contain,
            child:  FutureBuilder(
              future: getEntryDataSource(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
                return snapshot.hasData
                    ? SfDataGrid(key: key ,source: snapshot.data, columns: getColumns(),
                  selectionMode: SelectionMode.single,
                )
                    : Center(child: CircularProgressIndicator(strokeWidth: 3,));
              },
            ),
          ),),

        ],),
        ),
      );
     }
}