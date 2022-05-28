import 'package:flutter/material.dart';

import '../../util/util.dart';
import '../widgets/common.dart';


class SupMenu extends StatefulWidget{
  final int provId;
  const SupMenu(this.provId, {Key? key}) : super(key: key);

  @override
  SupMenuState createState() => SupMenuState();
}

class SupMenuState extends State<SupMenu>{
  int idProv = -1;
  List<TextEditingController> texts = List.generate(
      6, (i) => TextEditingController()
  );

  @override
  void initState() {
    idProv = widget.provId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueAccent, actions: [
        IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: deleteSupplier
        )
      ]),
      body: SingleChildScrollView(
        reverse: true,
        primary: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: Center(
            child: Wrap(
              direction: Axis.vertical,
              spacing: 25,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const SizedBox(width: 300, height: 10),
                InputData('ID: $idProv', null, false),
                InputData("Nombre del proveedor:", texts[0], true),
                InputData("NIT del proveedor:", texts[1], true),
                InputData("Nombre del representante:", texts[2], true),
                InputData("Apellidos del representante:", texts[3], true),
                InputData("Teléfono:", texts[4], true),
                InputData("Correo electrónico:", texts[5], true),
                CustomButton("Guardar", Colors.blueAccent, 300, 50, saveSupplier)
              ],
            ),
          ),
        ),
      ),
    );
  }


  void deleteSupplier(){
    if(idProv == -1){
      cleanText();
      Util.showSnack(context, 'Campos limpiados');
      return;
    }
    Util.showLoading(context, 'Eliminando producto...');
    /*
      DBMan.delProduct(idProd).then((value){
        Util.popDialog(context);
          if(!value){
            Util.showSnack(context, "Ha ocurrido un error");
            return;
          }
          PData.removeProd(idProd);
        Util.showAlert(context, "Producto eliminado correctamente").
          whenComplete(() =>
              Navigator.of(context).popUntil((route) => route.isFirst));
      });
       */
  }


  void saveSupplier() async {
    Util.showLoading(context, 'Guardando producto...');
    Util.popDialog(context);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void loadData() async{

  }

  void cleanText(){
      for(var element in texts){element.clear();}
  }
}
