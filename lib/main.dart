import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vacheck/pages/data.dart';
import 'package:vacheck/pages/graph.dart';
import 'package:vacheck/pages/home_page.dart';
import 'package:vacheck/shared/nav.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<MyApp> {
  var _selectedIndex = 0;
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vacheck',
      navigatorKey: navigatorKey,
      initialRoute:'nav',
      routes:{
        'nav': (context) => Nav(),
        'data': (context) => Data(),
        'home': (context) => HomePage(),
        'chart': (context) => Chart()
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.red[400],
        textTheme: GoogleFonts.ralewayTextTheme(
          Theme.of(context).textTheme
        )
      ),
    );
  }
}
