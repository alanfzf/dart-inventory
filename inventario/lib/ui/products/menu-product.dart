import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventario/data/product.dart';

import '../../util/api-util.dart';
import '../../util/util.dart';
import '../widgets/common.dart';


class ProdMenu extends StatefulWidget{
    final int prod;
    const ProdMenu(this.prod, {Key? key}) : super(key: key);

    @override
    ProdMenuState createState() => ProdMenuState();
}

class ProdMenuState extends State<ProdMenu>{

  int idProd = -1;
  File? img;
  Product? product;
  ImageProvider imgProv = const AssetImage('assets/add_img.png');
  List<TextEditingController> texts = List.generate(2,(i)=>TextEditingController());

  @override
  void initState() {
    idProd = widget.prod;
    product = null;
    img = null;
    super.initState();
    loadFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(backgroundColor: Colors.blueAccent, actions: [
                IconButton(icon: const Icon(
                    Icons.delete, color: Colors.white
                ), onPressed: deleteProd)
          ]),
          body: SingleChildScrollView(
            reverse: true,
            primary: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 16),
              child: Center(
                child: Wrap(
                      direction: Axis.vertical,
                      spacing: 25,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        //fix: https://github.com/flutter/flutter/issues/42901#issuecomment-708050484
                        CircleAvatar(
                        radius: 60,
                        backgroundImage:  imgProv,
                        child: Material(
                          shape: const CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => ImagePicker()
                                .pickImage(source: ImageSource.gallery)
                                .then((value) => setState(() {
                                    if(value != null){
                                        imgProv = FileImage(
                                            img = File(value.path));
                                    }
                                })
                              ),
                          ),
                        )),

                        InputData('ID: $idProd', null, false),
                        InputData("Nombre del producto:", texts[0], true),
                        InputDropdown(null, (val) => setState(() {
                                // category = val;
                            }),const []
                            /*categories.map((String value) =>
                                DropdownMenuItem(
                                    value: value,
                                    child: Text(value)
                                )
                            ).toList()*/
                        ),
                        InputNumeric("Precio de venta:", texts[1], false),
                        CustomButton("Guardar", Colors.blueAccent, 300, 50, saveProduct)
                      ],
                ),
              ),
            ),
          ),
      );
  }


  void loadFields(){
    Product? prod = product;
    if(prod != null){
      var url = prod.url;
      texts[0].text = prod.name;
      texts[1].text = prod.price as String;
      if(url != null){
        imgProv = NetworkImage(url);
      }
    }
  }


  void deleteProd(){
      if(idProd == -1){
          for (var element in texts) { element.clear(); }
          return;
      }
      Util.showLoading(context, 'Eliminando producto...');
      Util.popDialog(context);
  }


  void saveProduct() async {

        var name = texts[0].text.trim();
        var price = double.tryParse(texts[1].text) ?? 0;
        var imgUrl = product?.url;
        var imgFile = img;

        if(name.isEmpty || price < 0){
            Util.showAlert(context, 'Verifica los datos ingresados por favor');
            return;
        }
        Util.showLoading(context, 'Guardando producto...');
        //start saving product.
        if(imgFile != null){
            imgUrl = await ApiUtil.uploadImage(imgFile);
        }
        Util.popDialog(context);
        FocusManager.instance.primaryFocus?.unfocus();
  }
}

