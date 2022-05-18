import 'dart:convert';
import 'dart:html';
import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:map_one_interface/main.dart';
import 'package:http_requests/http_requests.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:map_one_interface/user.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'entry.dart';
import 'dart:html' as html;
import 'getfilter.dart';
import 'getquery.dart';
import 'loginPage.dart';
import 'feedback.dart';
import 'main.dart';
import 'navigation.dart';

class filter extends StatefulWidget
{
  static String start = " ";
  static String end = " ";

  // constructor
  // Must accept start and end dates for filter
  filter(inStart, inEnd)
  {
    start =  inStart;
    end = inEnd;
  }

  _filterState createState() => _filterState();


}

// Function: getApiEntries
// Parameters: keyword, boolean flag
// that determines return value
Future filterApiEntries(String start, String end,  bool responseCodeFlag)
async
{
  // get request
  var response = await http.get(Uri.parse("https://mapone-api.herokuapp.com/entry/?action=2&first_year=${start}&second_year=${end}"));

  // store
  var decodedRes = json.decode(response.body).cast<Map<String,dynamic>>();

  List<Entry> responseList = await decodedRes.map<Entry>((json)=>
      Entry.fromJson(json)).toList();

  // if responseCode flag is true return the
  // the response code, otherwise return data
  if(responseCodeFlag == true)
  {
    return response.statusCode;
  }

  return responseList;
}

void downloadFile(String fileName, String content)
{

  html.AnchorElement anchorElement =  new html.AnchorElement(href: fileName);
  anchorElement.appendText(content);

  anchorElement.download = fileName;
  anchorElement.click();
}

Future<EntryDataGridSource> getEntryDataSource(start, end) async
{
  bool getDataflag = false;
  var entryList = await filterApiEntries(start,end, getDataflag);

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

    // Feedback button column
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
    ] );
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

class _filterState extends State<filter>
{

  String st = filter.start;
  String ed = filter.end;

  @override
  Widget build(BuildContext context)
  {
    return SafeArea(
      child:
      Scaffold(
        appBar:
        AppBar(
          title: Bar,
          automaticallyImplyLeading: false,
          actions:
          [
            // button for user page
            IconButton( icon: Icon(Icons.face),
              onPressed: (){
                setState(() {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) => login("","")));
                });
              },
            ),
            IconButton(
                icon: Icon(Icons.home),
                onPressed: (){
                  setState(() {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => login("","") ));
                  });
                }
            ),
            IconButton(
              icon: Icon(Icons.vpn_key_outlined),
              onPressed: (){
                setState(() {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => login("", " ")));
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                setState(() {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => queryPane()));
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.filter_alt_rounded),
              onPressed: (){
                setState(() {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) => filterPane()));
                });
              },
            ),
          ],

        ),

        body:
        Row(mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                    child: Text('Export to CSV'),
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
                future: getEntryDataSource(st,ed),
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
