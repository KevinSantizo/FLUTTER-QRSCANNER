import 'package:flutter/material.dart';
import 'package:sqlscanner/src/pages/deploy_map.dart';
import 'package:sqlscanner/src/pages/home_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: HomePage(),
      initialRoute: 'home-page',
      routes: {
        'home-page' : (BuildContext context) => HomePage(),
        'deploy-maps-page' : (BuildContext context) => MapaPage(),

      },
      theme: ThemeData(
        primaryColor: Colors.deepPurple
      ),
    );
  }
}