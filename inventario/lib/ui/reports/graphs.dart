import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventario/data/olap.dart';
import 'package:inventario/data/report.dart';
import 'package:inventario/data/sell.dart';
import 'package:inventario/data/supplier.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../util/http-man.dart';
import '../widgets/common.dart';


class GraphsMenu extends StatefulWidget{
  const GraphsMenu({Key? key}) : super(key: key);

  @override
  GraphsMenuState createState() => GraphsMenuState();
}

class GraphsMenuState extends State<GraphsMenu>{
  bool loaded = false;
  final List<Sell> compras = [], ventas = [];
  final DateTime now = DateTime.now(); 

  @override
  void initState() {
    super.initState();
    loadFields();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
            appBar: AppBar(
                title: const Text("Graficas"),
                backgroundColor: Colors.blueAccent,
            ),
            body: SfCartesianChart(
              title: ChartTitle(text: 'Datos'),
              legend: Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(
                enable: true
                ),
              zoomPanBehavior: ZoomPanBehavior(
                enablePanning: true,
              ),
              // enableAxisAnimation: true,
              primaryXAxis: DateTimeAxis(
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  dateFormat: DateFormat('dd-MM-yyyy'),
                  intervalType: DateTimeIntervalType.days,
                  // interval: 1,
                  maximumLabels: 100,
                  autoScrollingMode: AutoScrollingMode.start,
                  autoScrollingDelta: 4,

              ),
              primaryYAxis: NumericAxis(minimum: 0),

              series:[
                ColumnSeries<Sell, DateTime>(
                    name: 'Ventas',
                    dataSource: ventas,
                    xValueMapper: (Sell data, _) => data.sell,
                    yValueMapper: (Sell data, _) => data.cantidad,
                    dataLabelSettings: const DataLabelSettings(isVisible: false),
                    enableTooltip: true
                ),
               ColumnSeries<Sell, DateTime>(
                    name: 'Compras',
                    dataSource: compras,
                    xValueMapper: (Sell data, _) => data.sell,
                    yValueMapper: (Sell data, _) => data.cantidad,
                    dataLabelSettings: const DataLabelSettings(isVisible: false),
                    enableTooltip: true
                ),
              ]),
      );
  }



  void loadFields() async{

      var olapMovements =await HttpMan.sellsByDay();
      var list = olapMovements.where((ol) => ol.tipo == 'COMPRA').toList();
      var list2 = olapMovements.where((ol) => ol.tipo == 'VENTA').toList();

      setState(() {
          compras.addAll(list);
          ventas.addAll(list2);
          loaded = true;
      });
  }

}
