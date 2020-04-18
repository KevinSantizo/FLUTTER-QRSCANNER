import 'package:flutter/material.dart';
import 'package:sqlscanner/src/bloc/scan_bloc.dart';
import 'package:sqlscanner/src/models/scan_model.dart';
import 'package:sqlscanner/src/utils/utils.dart' as utils;


class DirectionsPage extends StatefulWidget {
  @override
  _DirectionsPageState createState() => _DirectionsPageState();
}

class _DirectionsPageState extends State<DirectionsPage> {
  final scansBloc = new ScansBloc();
  @override
  Widget build(BuildContext context) {

  scansBloc.obtainScans();

    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStreamHttp,
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
                leading: Icon(Icons.cloud_queue, color: Colors.deepPurple,),
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