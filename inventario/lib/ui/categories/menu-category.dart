import 'package:flutter/material.dart';

import '../../../ui/widgets/common.dart';
import '../../../util/util.dart';


class CatMenu extends StatefulWidget{
  final int catId;
  const CatMenu(this.catId, {Key? key}) : super(key: key);

  @override
  CatMenuState createState() => CatMenuState();
}

class CatMenuState extends State<CatMenu>{
  int catId = -1;
  List<TextEditingController> texts = List.generate(
      3, (i) => TextEditingController()
  );

  @override
  void initState() {
    catId = widget.catId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueAccent, actions: [
        IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: deleteCat
        )
      ]),
      body: SingleChildScrollView(
        reverse: true,
        primary: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Center(
            child: Wrap(
              direction: Axis.vertical,
              spacing: 25,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                InputData('ID: $catId', null, false),
                InputData("Nombre de la categoria:", texts[0], true),
                CustomButton("Guardar", Colors.blueAccent, 300, 50, saveCat)
              ],
            ),
          ),
        ),
      ),
    );
  }


  void deleteCat(){
    if(catId == -1){
      cleanText();
      Util.showSnack(context, 'Campos limpiados');
      return;
    }
    Util.showLoading(context, 'Eliminando producto...');
    Util.popDialog(context);
  }


  void saveCat() async {
    Util.showLoading(context, 'Guardando producto...');
    Util.popDialog(context);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void cleanText(){
      for(var element in texts){
          element.clear();
      }
  }
}
