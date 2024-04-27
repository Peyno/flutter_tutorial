import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromRGBO(41, 41, 41, 0), 
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 
  final controller = PageController(initialPage: 0); 

  @override
  Widget build(BuildContext context) {
  
    return  Scaffold(
     
      body: PageView(
        controller: controller,
        children: const [
          DetailPage(headline: 'Heute'), 
          DetailPage(headline: 'Gestern'),
      ],)
    );
  }
}








class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.headline});

  final String headline; 

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 48, 0.0, 32),
        child: Column(children: [
          Text(widget.headline, style: const TextStyle(fontSize: 48.0, color: Colors.white)),
            const TrackingElement(color: Color.fromARGB(255, 250, 242, 0), iconData: Icons.directions_run, unit: 'm', max : 5000),
            const TrackingElement(color: Color.fromARGB(255, 50, 0, 250), iconData: Icons.local_drink, unit: 'ml', max: 3000), 
            const TrackingElement(color: Color.fromARGB(255, 250, 0, 204), iconData: Icons.fastfood,unit : 'kcal', max: 1800), 
        ],)
     
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


















class TrackingElement extends StatefulWidget {
  const TrackingElement({super.key, required this.color, required this.iconData, required this.unit, required this.max});

  final Color color; 
  final IconData iconData; 
  final String unit; 
  final double max; 

  @override
  State<TrackingElement> createState() => _TrackingElementState();
}

class _TrackingElementState extends State<TrackingElement> {
  final  Future<SharedPreferences> _prefs = SharedPreferences.getInstance(); 

  double _progress = 0; 
  int _counter = 0; 
  var now =  DateTime.now(); 
  String _storageKey = ''; 

    void _incrementCounter() async{
      setState(() {
        _counter += 200; 
        _progress = _counter / widget.max; 
      });
      (await _prefs).setInt(_storageKey, _counter); 
    }


    @override
    void initState()  {
      super.initState(); 
      _storageKey = '${now.year}-${now.month}-${now.day}_${widget.unit}'; 

      _prefs.then((prefs){
        _counter = prefs.getInt(_storageKey) ?? 0; 
      }); 
    }

  @override
  Widget build(BuildContext context) {
    
   
    return InkWell(
      onTap: _incrementCounter ,
      child: Column(
       
         
          children:  <Widget>[
             Padding(
              padding:  EdgeInsetsDirectional.fromSTEB(32, 64, 32, 24),
            child :Row(children: <Widget>[
            Icon(widget.iconData, color: Colors.white70, size: 50,),
              Text(
                
             _counter.toString() + ' / ${widget.max.toInt()} ' + widget.unit,
              style:  const TextStyle(color: Colors.white70, fontSize: 32)
            ),
            ],),
            
            ),
            LinearProgressIndicator(
              value: _progress, 
              color: widget.color,  
              backgroundColor: Colors.white,
              minHeight: 12,
              )
              
          ],
        ),) ;
        
  }
}