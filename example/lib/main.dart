import 'package:flutter/material.dart';
import 'package:locally/locally.dart';

import 'send_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Locally Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Locally Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController message = TextEditingController();

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  showMessage() {
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Locally(
          context: context,
          title: title.text,
          body: message.text,
          pageRoute: MaterialPageRoute(builder: ( context ) =>
              SecondScreen(title: title.text, message: message.text,)));
    }
  }

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showMessage();
        },
      ),
      body: Center(
       
        child: Form(
          key: _formKey,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20),
                child: TextFormField(
                  controller: title,
                  validator: (v){
                    return v.isEmpty ? 'Enter title' : null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Title',
                    labelText: 'Title'
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: TextFormField(
                  controller: message,
                  validator: (v){
                    return v.isEmpty ? 'Enter message body' : null;
                  },
                  decoration: InputDecoration(
                      hintText: 'Message',
                      labelText: 'Message'
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
