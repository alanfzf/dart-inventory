import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventario/data/supplier.dart';

import '../../data/olap.dart';
import '../../util/http-man.dart';
import '../widgets/common.dart';


class MovementsMenu extends StatefulWidget{
  const MovementsMenu({Key? key}) : super(key: key);

  @override
  MovementsMenuState createState() => MovementsMenuState();
}

class MovementsMenuState extends State<MovementsMenu>{

  final List<Olap> olaps = [];
  bool loaded = false;
  @override
  void initState() {
    super.initState();
    loadFields();
  }

  @override
  Widget build(BuildContext context) {

    const spacer = SizedBox(height: 20);
    final DateFormat formatter = DateFormat('dd-MM-yyyy');

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueAccent),
      body: loaded ? SingleChildScrollView(
        reverse: true,
        primary: false,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30, left: 30, right: 30),
            child:        
               Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  createTitle('Movimientos:'),
                  spacer,
                  CustomTable(const ['Producto', 'Categoria', 'Tipo', 'Fecha', 'Cantidad', 'Total'], 15, 
                    olaps.map((e){



                        return createRow([e.prod, e.cat, e.tipo, 
                        formatter.format(e.date.toLocal()), '${e.cantidad}', 
                        '${e.total}']);
                    }).toList()
                  ),
                ]),
          ),
        ),
      ) : const LoadingScreen(),
    );
  }



  void loadFields() async{
      var olapMovements = await HttpMan.olapMovements();

      olaps.clear();
      olaps.addAll(olapMovements);

      setState(() {
          loaded = true;        
      });
  }
}
