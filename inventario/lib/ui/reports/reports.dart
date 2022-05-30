import 'package:flutter/material.dart';
import 'package:inventario/data/report.dart';
import 'package:inventario/data/supplier.dart';

import '../../util/http-man.dart';
import '../widgets/common.dart';


class ReportsMenu extends StatefulWidget{
  const ReportsMenu({Key? key}) : super(key: key);

  @override
  ReportsMenuState createState() => ReportsMenuState();
}

class ReportsMenuState extends State<ReportsMenu>{
  bool loaded = false;
  List<Report> products = [];
  List<Report> cats = [];

  @override
  void initState() {
    super.initState();
    loadFields();
  }

  @override
  Widget build(BuildContext context) {

    const spacer = SizedBox(height: 20);

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueAccent),
      body: loaded ? SingleChildScrollView(
        primary: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 30),
          child: Center(
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 40,
              runSpacing: 50,
              crossAxisAlignment: WrapCrossAlignment.center,
              
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    createTitle('Productos:'),
                    spacer,
                    CustomTable(const ['Id', 'Producto', 'Existencias'], 30, 
                    products.map((e) {
                        String text = e.text;
                        text = text.length > 16 ? text.substring(0, 16)+".." : text;
                        return createRow(['${e.id}', text, '${e.value}']);
                    }).toList()),
                ],),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    createTitle('Categorías:'),
                    spacer,
                    CustomTable(const ['Id', 'Categoría', 'Productos'], 30, 
                    cats.map((e){
                        return createRow(['${e.id}', e.text, '${e.value}']);
                    }).toList()),
                ]),
                  
              ],
            ),
          ),
        ),
      ) : const LoadingScreen(),
    );
  }



  void loadFields() async{
      var list = await HttpMan.reportProducts();
      var list2 = await HttpMan.reportCategories();

      products.clear();
      cats.clear();  
      setState(() {
            loaded = true;
            cats.addAll(list2);
            products.addAll(list);
      });
  }
}
