

import 'dart:async';

import 'package:sqlscanner/src/bloc/validators.dart';
import 'package:sqlscanner/src/providers/db_provider.dart';

class ScansBloc with Validators{

  static final ScansBloc _singleton = new ScansBloc._internal(); 

  factory ScansBloc(){
    return _singleton;
  }
  ScansBloc._internal(){
    //Obtener los Scnas de la base de datos
    obtainScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream.transform(validateGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validateHttp);

  dispose() {
    _scansController?.close();
  }

  obtainScans() async {
    _scansController.sink.add( await DBProvider.db.getTodoScans());
  }

  addScan(ScanModel scan) async {
    await DBProvider.db.newScan(scan);
    obtainScans();
  }

  deleteScan(int id) async {
    await DBProvider.db.deleteScan(id);
    obtainScans();
  }

  deleteTodoScans() async {
    DBProvider.db.deleteScanAll();
    obtainScans();
  }

}