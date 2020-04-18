import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sqlscanner/src/bloc/scan_bloc.dart';
import 'package:sqlscanner/src/models/scan_model.dart';
import 'package:sqlscanner/src/utils/utils.dart' as utils;


class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final scansBloc = new ScansBloc();
  @override
  Widget build(BuildContext context) {

  scansBloc.obtainScans();

    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStream,
      builder: (BuildContext context, AsyncSnapshot <List<ScanModel>> snapshot) {
        if ( !snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } 
        final scans = snapshot.data;
        if(scans.length == 0) {
          return Center(child: FlatButton(child: Text('No hay Información',), onPressed: () => print(scans) ,));
        }
        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (BuildContext context, i ){ 
            return Dismissible(
              key: UniqueKey(),
              background: Container(color: Colors.red,),
              onDismissed: ( direction ) => scansBloc.deleteScan(scans[i].id),
              child: ListTile(
                leading: Icon(Feather.map, color: Colors.deepPurple,),
                title: Text(scans[i].valor),
                subtitle: Text('ID: ${scans[i].id}'),
                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                onTap: () => utils.openScan(context,  scans[i]),
              ),
            );
          },
        );
      },
    );
  }
}