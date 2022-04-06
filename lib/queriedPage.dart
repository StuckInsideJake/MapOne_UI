import 'dart:convert';
import 'dart:html';
import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:map_one_interface/main.dart';
import 'package:http_requests/http_requests.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'entry.dart';
import 'dart:html' as html;
import 'loginPage.dart';

class query extends StatefulWidget
{
  String keyword = " ";

  // constructor
  // Must accept a keyword parameter
  query(String inKeyword)
     {
       this.keyword = inKeyword;
     }

  _queryState createState() => _queryState();


}


// Function: getApiEntries
Future QueryApiEntries(String keyword)
async
{
  // get request
  var response = await http.get(Uri.parse("https://mapone-api.herokuapp.com/entry/?action=1&keyword=${keyword}"));

  // store
  var decodedRes = json.decode(response.body).cast<Map<String,dynamic>>();

  List<Entry> responseList = await decodedRes.map<Entry>((json)=>
      Entry.fromJson(json)).toList();

  return responseList;
}

void downloadFile(String fileName, String content)
{

  html.AnchorElement anchorElement =  new html.AnchorElement(href: fileName);
  anchorElement.appendText(content);

  anchorElement.download = fileName;
  anchorElement.click();
}

Future<EntryDataGridSource> getEntryDataSource(keyword) async
{
  var entryList = await QueryApiEntries(keyword);

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

class _queryState extends State<query>
{
  get keyword => keyword;


  @override
  Widget build(BuildContext context) {
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
                  title: TextField( decoration: InputDecoration(
                      hintText: 'type in journal name...',
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontStyle: FontStyle.italic)));
                  border: InputBorder.none;
                  style: TextStyle(color: Colors.grey);

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
                content: Text('Hello, I am a Material Banner'),
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
              //in order to change view, first the current
              // rendered context must be popped and then the
              // new one must be pushed onto the build stack
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder:
                  (context) => MapOne() ));

            },
            icon:HomeIcon,
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
        ], // Actions
        centerTitle: true,
      ),
      body: SafeArea(
        child:
        Expanded( child: FittedBox(fit: BoxFit.contain,
          child:  FutureBuilder(
            future: getEntryDataSource(keyword),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
              return snapshot.hasData
                  ? SfDataGrid(key: key ,source: snapshot.data, columns: getColumns(),
                selectionMode: SelectionMode.single,
              )
                  : Center(child: CircularProgressIndicator(strokeWidth: 3,));
            },
          ),
        ),),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Results returned from query',

        child: Icon(Icons.info),
      ),

    );}

}
