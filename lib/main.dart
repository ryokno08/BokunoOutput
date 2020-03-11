import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';





void main() => runApp(MyApp());





class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: <String, WidgetBuilder>{
        '/home': (_) => new MyHomePage(),
        '/new': (_) => new NewBook(),
        '/read': (_) => new ReadBook(),
      },
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}





class Book {
  final String name;
  final String content;

  Book(this.name, this.content);

  Book.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        content = json['content'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'content': content,
      };
}





class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}





class _MyHomePageState extends State<MyHomePage> {

  void push(String name,{String s}){
    Navigator.pushNamed(context, name);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,


          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(50.0),
              child:
                Text("OutPutBox", style: TextStyle
                  (fontSize: 54.0,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 5.5,
                  ),
                ),
            ),

            Padding(
              padding: EdgeInsets.all(20.0),
              child:
                SizedBox(
                  height: 65.0,
                  width: 200.0,
                  child:
                    RaisedButton(
                      child: Text("New", style: TextStyle(fontSize: 20.0) ),
                      color: Colors.orange,
                      textColor: Colors.white,
                      onPressed: () {
                        push('/new');
                      },
                    ),
                ),
            ),

            Padding(
              padding: EdgeInsets.all(30.0),
              child:
                SizedBox(
                  height: 65.0,
                  width: 200.0,
                  child:
                    RaisedButton(
                      child: Text("Read", style: TextStyle(fontSize: 20.0) ),
                      color: Colors.orange,
                      textColor: Colors.white,
                      onPressed: () {
                        push('/read');
                      },
                    ),
                ),
            ),
          ],
        ),
      )
    );
  }
}





class NewBook extends StatefulWidget {
  @override
  _NewBookPageState createState() => new _NewBookPageState();
}





class _NewBookPageState extends State<NewBook>{

  StreamController<dynamic> _controller = StreamController<dynamic>.broadcast();
  var _nameController = TextEditingController();
  var _valueController = TextEditingController();

  List<Map<String, dynamic>> bookData = new List<Map<String, dynamic>>();
  List<String> bookId = new List<String>();

  Color wasWritten(){
    if(_nameController.text.isEmpty || _valueController.text.isEmpty){
      return Colors.grey;
    }else{
      return Colors.orange;
    }
  }

  void push(String name,{String s}){
    if(_nameController.text.isNotEmpty && _valueController.text.isNotEmpty) {
      Navigator.pushNamed(context, name);
    }
  }

  void pop(){
    Navigator.pop(context);
  }

  setString(String key, String value) async {
    final SharedPreferences data = await SharedPreferences.getInstance();
    await data.setString(key, value);
  }
  setStringList(String key, List<String> value) async {
    final SharedPreferences data = await SharedPreferences.getInstance();
    await data.setStringList(key, value);
  }

  getString(String key) async {
    final SharedPreferences data = await SharedPreferences.getInstance();
    return data.getString(key);
  }
  getStringList(String key) async {
    final SharedPreferences data = await SharedPreferences.getInstance();
    return data.getStringList(key);
  }
  removeString(String key) async {
    final SharedPreferences data = await SharedPreferences.getInstance();
    data.remove(key);
  }
  removeStringList(String key) async{
    final SharedPreferences data = await SharedPreferences.getInstance();
    data.remove(key);
  }

  void save() async{

     bookId = await getStringList("id") ?? new List<String>( );

    for(int i=0; i<bookId.length; i++) {
      String jsonData = await getString(bookId[i]) ?? "{\"name\": \"\",\"content\": \"\"}";
      bookData.add( json.decode( jsonData ) );
    }

    String newId = randomId( );
    bookId.add( newId );


    Book newBookData = new Book( _nameController.text, _valueController.text );
    bookData.add( newBookData.toJson( ) );
    await setString( newId, json.encode( newBookData ) );

  }



  String _random(){
    String _randomId = new Random().nextInt(999999).toString();
    if(_randomId.length != 6){
      while(_randomId.length != 6){
        _randomId = "0"+_randomId;
      }
    }

    return _randomId;
  }



  String randomId(){

    String random = _random();
    String newBookId = "book-" + random;

    if(bookId != null) {
      if (bookId.indexOf( newBookId ) != -1) {
        while (bookId.indexOf( newBookId ) != -1) {
          random = _random( );
          newBookId = "book-" + random;
        }
      }
    }

    return newBookId;
  }



  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: const Text("New"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child:
            Column(
                mainAxisSize: MainAxisSize.min,

                children: <Widget>[
                  Column(

                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 40.0),
                        child:
                          Text("Name", style: TextStyle(fontSize: 28.0),),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(60.0, 10.0, 60.0, 70.0),
                        child:
                          TextField(
                            style: TextStyle(fontSize: 20.5),
                            controller: _nameController,
                          ),
                      ),
                    ]
                  ),

                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child:
                          Text("Anything", style: TextStyle(fontSize: 28.0),),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(50.0, 25.0, 50.0, 70.0),
                        child:
                          new Container(
                            decoration: new BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child:
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child:
                                  TextField(
                                    controller: _valueController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                  ),
                              ),
                          ),
                      ),
                    ]
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 50.0),
                    child:

                      SizedBox(
                        height: 55.0,
                        width: 150.0,
                        child:

                          RaisedButton(
                            elevation: 16.0,
                            child:
                              Text("ADD", style: TextStyle(fontSize: 18.0),),
                              color: wasWritten(),
                              onPressed: () async {
                                await save();
                                push( '/read' );
                              }

                          ),
                      ),
                  )
                ],
              ),
        )
      )
    );
  }
}





class ReadBook extends StatefulWidget {
  @override

  _ReadBookPageState createState() => new _ReadBookPageState();

}





class _ReadBookPageState extends State<ReadBook>{


  StreamController<dynamic> _controller = StreamController<dynamic>.broadcast();


  List<Map<String, dynamic>> bookData = new List<Map<String, dynamic>>();
  List<String> bookId = new List<String>();

  setString(String key, String value) async {
    final SharedPreferences data = await SharedPreferences.getInstance();
    data.setString(key, value);
  }
  setStringList(String key, List<String> value) async {
    final SharedPreferences data = await SharedPreferences.getInstance();
    data.setStringList(key, value);
  }

  getString(String key) async {
    final SharedPreferences data = await SharedPreferences.getInstance();
    return data.getString(key);
  }
  getStringList(String key) async {
    final SharedPreferences data = await SharedPreferences.getInstance();
    return data.getStringList(key);
  }

  void pop(){
    Navigator.pop(context);
  }

  void load() async{
    bookId = await getStringList("id") ?? new List<String>();
    print("r"+bookId.length.toString());

    for(int i=0; i<bookId.length; i++) {
      String jsonData = await getString(bookId[i]) ?? "{\"name\": \"\",\"content\": \"\"}";
      bookData.add(json.decode(jsonData));
    }

    _controller.add(bookId);
    _controller.add(bookData);
  }


  @override
  Widget build(BuildContext context) {

    setState(() {
      load();
    });


    return Scaffold(
      appBar: AppBar(title: Text("List Test"),),
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.data == null) {
            return Center(
              child: Text( "Loading.." ),
            );

          } else {
            if(bookId.isEmpty) {
              return Center(child: Text("No Data."));
            }else{
              return new ListView.builder(
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: Column(
                      children: <Widget>[
                        Text( bookData[index]["name"] ),
                        Text( bookData[index]["content"] ),
                      ],
                    ),
                  );
                },
                itemCount: bookId.length,
              );
            }
          }
        }
      ),
    );
  }
}
