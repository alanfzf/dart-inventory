import 'package:flutter/material.dart';
import 'package:inventario/data/category.dart';

import '../../util/http-man.dart';
import '../../../ui/widgets/common.dart';
import '../../../util/util.dart';


class CatMenu extends StatefulWidget{
  final int catId;
  final Category? category;

  const CatMenu(this.catId,this.category, {Key? key}) : super(key: key);

  @override
  CatMenuState createState() => CatMenuState();
}

class CatMenuState extends State<CatMenu>{
  int catId = -1;
  TextEditingController text = TextEditingController();

  @override
  void initState() {
    catId = widget.catId;
    super.initState();
    loadFields();
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
                InputData("Nombre de la categoria:", text, true),
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
      text.clear();
      return;
    }
    Util.showLoading(context, 'Eliminando producto...');
    Util.popDialog(context);
  }


  void saveCat() async {

    String cat = text.text;

    if(cat.isEmpty){
      Util.showAlert(context, "Por favor verifica los campos");
      return;
    }

    Util.showLoading(context, 'Guardando producto...');

    var resp = await HttpMan.insert_category(catId, cat);

    Util.popDialog(context);
    FocusManager.instance.primaryFocus?.unfocus();

    if(resp != null){
        var message = resp["response"];
        var genid = resp["gen_id"];

        if(message != 'OK'){
            Util.showAlert(context, message);
        }else{
            Util.showSnack(context, 'Guardado exitoso...');
        }

        if(genid != null){
            setState(() => catId = genid);
        }
      }
  }


  void loadFields() {
    var cat = widget.category;
    if(cat != null){
        text.text = cat.category;
    }
  }
}
