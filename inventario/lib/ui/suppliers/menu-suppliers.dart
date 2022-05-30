import 'package:flutter/material.dart';
import 'package:inventario/data/supplier.dart';

import '../../util/http-man.dart';
import '../../util/util.dart';
import '../widgets/common.dart';


class SupMenu extends StatefulWidget{
  final int provId;
  final Supplier? supplier;
  const SupMenu(this.provId, this.supplier, {Key? key}) : super(key: key);

  @override
  SupMenuState createState() => SupMenuState();
}

class SupMenuState extends State<SupMenu>{
  int idProv = -1;

  List<TextEditingController> texts = List.generate(6, (i) => TextEditingController());

  @override
  void initState() {
    idProv = widget.provId;
    super.initState();
    loadFields();
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


  void deleteSupplier() async{
      if(idProv == -1){
        cleanText();
        Util.showSnack(context, 'Campos limpiados');
        return;
      }
      Util.showLoading(context, 'Eliminando proveedor...');
      await HttpMan.deleteSupplier(idProv);
      Util.popDialog(context);
      Util.returnToMenu(context);
  }


  void saveSupplier() async {
      if(fieldsAreEmpty()){
          Util.showAlert(context, "Verifica todos los campos por favor");
          return;
      }
      Util.showLoading(context, 'Guardando producto...');
      var resp = await HttpMan.insertSupplier(idProv, 
          texts[0].text, //nombre
          texts[1].text, //nit
          texts[2].text, texts[3].text, //representante
          texts[4].text, texts[5].text //contacto.
      );

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
            setState(() => idProv = genid);
        }
      }
    }

  void loadFields(){

      Supplier? sup = widget.supplier;
      if(sup != null){
          texts[0].text = sup.name;
          texts[1].text = sup.nit;
          texts[2].text = sup.repName;
          texts[3].text = sup.repLast;
          texts[4].text = sup.phone;
          texts[5].text = sup.email;
      }
  }

  bool fieldsAreEmpty(){
    var empty = texts.map((e) => e.text.isEmpty).firstWhere((element) => element, orElse: () => false);
    return empty;
  }

  void cleanText(){
      for(var element in texts){element.clear();}
  }
}
