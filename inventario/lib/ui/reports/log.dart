import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventario/data/olap.dart';
import 'package:inventario/data/report.dart';
import 'package:inventario/data/sell.dart';
import 'package:inventario/data/supplier.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../data/log.dart';
import '../../util/http-man.dart';
import '../widgets/common.dart';


class LogMenu extends StatefulWidget{
  const LogMenu({Key? key}) : super(key: key);

  @override
  LogMenuState createState() => LogMenuState();
}

class LogMenuState extends State<LogMenu>{
  bool loaded = false;
  List<Log> logs = [];

  @override
  void initState() {
    super.initState();
    loadFields();
  }

  @override
  Widget build(BuildContext context) {

    final DateFormat formatter = DateFormat('dd-MM-yyyy');

    return Scaffold(
            appBar: AppBar(
                title: const Text("Bitácora (Logs)"),
                backgroundColor: Colors.blueAccent,
            ),
            body: loaded ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: 
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CustomTable(
                  const ['Id', 'Tabla', 'Acción', 'Usuario', 'Fecha'], 
                  20, logs.map((e){
                      return createRow(['${e.id}', e.table, e.action, e.user, formatter.format(e.date.toLocal())]);
                  }).toList()),
              )) : const LoadingScreen(),
      );
  }

  void loadFields() async{
      var log = await HttpMan.getLogs();
      logs.clear();
      logs.addAll(log);
      setState(() {
          loaded = true;
      });
  }
}
