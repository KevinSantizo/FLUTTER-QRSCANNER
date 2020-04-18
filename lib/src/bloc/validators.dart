
import 'dart:async';

import 'package:sqlscanner/src/models/scan_model.dart';

class Validators {

  final validateGeo = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: ( scans, sink ) {

      final geoScans = scans.where((s) => s.tipo =='geo' ).toList();
      sink.add(geoScans);

    } 
  );
  
  final validateHttp = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: ( scans, sink ) {

      final geoScans = scans.where((s) => s.tipo =='http' ).toList();
      sink.add(geoScans);

    } 
  );
}