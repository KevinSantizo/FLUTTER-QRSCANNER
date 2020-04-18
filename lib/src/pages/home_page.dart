import 'dart:io';

import 'package:flutter/material.dart';

import 'package:sqlscanner/src/bloc/scan_bloc.dart';
import 'package:sqlscanner/src/models/scan_model.dart';
import 'package:sqlscanner/src/pages/directions_page.dart';
import 'package:sqlscanner/src/pages/maps_page.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:sqlscanner/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(),
      body: _callPage(currentIndex),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        backgroundColor: Colors.deepPurple
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.deleteTodoScans,
          )
        ],
      ),
    );
  }

 Widget _bottomNavigationBar() {
   return BottomNavigationBar(
     currentIndex: currentIndex,
     onTap:(index){
       setState(() {
         currentIndex = index;
       });
     },
     items: [
       BottomNavigationBarItem(
         icon: Icon(Icons.map),
         title: Text('Maps')
       ),
       BottomNavigationBarItem(
         icon: Icon(Icons.branding_watermark),
         title: Text('Directions')
       ),
     ],
   );
 }

 Widget _callPage( int actualPage) {

   switch (actualPage){
     case 0 : return MapsPage();
     case 1 : return DirectionsPage();

     default: 
      return MapsPage();
   }
 }

  _scanQR(BuildContext context) async {
    // https://dribbble.com/
    // geo:14.876253773663358,-92.07192793330081

    String futureString;
    
    try {
      futureString = await BarcodeScanner.scan();
    } catch (e) {
      futureString = e.toString();
    }
    
    print('Future String: $futureString');
    if ( futureString != null ) {
      
      final scan = ScanModel( valor: futureString );
      scansBloc.addScan(scan);

      if( Platform.isIOS ) {

        Future.delayed(Duration(milliseconds: 750), () {
          utils.openScan(context, scan);
        });

      } else {
        utils.openScan(context, scan);
      }    
    }
  }
}