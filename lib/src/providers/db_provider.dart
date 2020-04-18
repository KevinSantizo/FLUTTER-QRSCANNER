import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqlscanner/src/models/scan_model.dart';
export 'package:sqlscanner/src/models/scan_model.dart';

class DBProvider {

  static Database _dataBase;
  static final DBProvider db  = DBProvider._();

  DBProvider._();

  Future <Database> get database async {

    if (_dataBase != null) return _dataBase;
      _dataBase = await initDB();
      return _dataBase;
    
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'ScansDB.db');
    return await  openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: ( Database db, int version ) async {
        await db.execute(
          'CREATE TABLE Scans ('
            'id INTEGER PRIMARY KEY,'
            'tipo TEXT,'
            'valor TEXT'
          ')'
        );
      }
    );
  }

  // CREATE Registers Data Base
  //Forma 1
  newScanRaw( ScanModel newScan ) async {
    
    final db = await database;
    final response = await db.rawInsert(
      "INERT Into Scans (id, tipo, valor) "
      "VALUES ( ${ newScan.id }, '${ newScan.tipo }', '${ newScan.valor }' )"
    ); 
    return response;
  
  }

  //Forma 2
  newScan(ScanModel newScan) async {
    
    final db = await database;
    final response = await db.insert('Scans', newScan.toJson());
    return response;
  
  }

  //SELECT - Data Base Information

  Future<ScanModel> getScanId(int id) async {

    final db = await database;
    final response = await db.query('Scans', where: 'id = ?', whereArgs: [id] );
    return response.isNotEmpty ? ScanModel.fromJson(response.first) : null;
  
  }

  Future<List<ScanModel>> getTodoScans() async {

    final db = await database;
    final response = await db.query('Scans');
    List<ScanModel> list = response.isNotEmpty 
                                  ? response.map( (c) => ScanModel.fromJson(c) ).toList()
                                  : [];
    return list;

  }

   Future<List<ScanModel>> getTodoScansByType(String type) async {

    final db = await database;
    final response = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$type' ");
    List<ScanModel> list = response.isNotEmpty 
                                  ? response.map( (c) => ScanModel.fromJson(c) ).toList()
                                  : [];
    return list;

  }


  //Update Registers

  Future<int> updateScan( ScanModel newScan ) async {

    final db = await database;
    final response = await db.update('Scans', newScan.toJson(), where: 'id = ?', whereArgs: [newScan.id] );
    return response;    
  
  }

  //Delete Registers

  Future<int> deleteScan( int id ) async {

    final db = await database;
    final response = await db.delete('Scans', where: 'id = ?', whereArgs: [id] );
    return response;

  }


  Future<int> deleteScanAll() async {

    final db = await database;
    final response = await db.rawDelete('DELETE FROM Scans');
    return response;

  }
 
}