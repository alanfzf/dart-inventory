import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventario/data/category.dart';

import '../../util//http-man.dart';
import '../../util/api-util.dart';
import '../../data/product.dart';
import '../../util/util.dart';
import '../widgets/common.dart';


final select = Category(-1, "Selecciona una categoría");


class ProdMenu extends StatefulWidget{
    final int prodId;
    final Product? product; 

    const ProdMenu(this.prodId, this.product, {Key? key}) : super(key: key);

    @override
    ProdMenuState createState() => ProdMenuState();
}

class ProdMenuState extends State<ProdMenu>{

  int idProd = -1;
  bool loaded = false;
  File? img;
  Category selectedCat = select;
  ImageProvider imgProv = const AssetImage('assets/add_img_alt.png');
  List<Category> categories = [select];  
  List<TextEditingController> texts = List.generate(2,(i)=>TextEditingController());

  @override
  void initState() {
    idProd = widget.prodId;
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
                        backgroundColor: Colors.blueAccent,
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
                        InputDropdown(selectedCat, loaded, (val) => setState(() {
                                // category = val;
                                if(val != null){
                                    selectedCat = val;
                                }
                            }) , categories.map((e)=> DropdownMenuItem(
                              value: e, child: Text(e.category))).toList()
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


  void loadFields() async{

    var prod = widget.product;
    var cats = await HttpMan.getCategories();
    categories.addAll(cats);

    if(prod != null){
      var url = prod.url;
      texts[0].text = prod.name;
      texts[1].text = '${prod.price}';

      if(url != null){
        imgProv = NetworkImage(url);
      }
      var prodCat = categories.firstWhere(
        (e) => e.category == prod.category, 
        orElse: ()=>select
      );
      selectedCat = prodCat;
    }
    //cargar la pagina.
    setState(() => loaded = true);
  }


  void deleteProd() async{
      if(idProd == -1){
          for (var element in texts) { element.clear(); }
          return;
      }
    Util.showLoading(context, 'Eliminando producto...');
    await HttpMan.deleteProduct(idProd);
    Util.popDialog(context);
    Util.returnToMenu(context);
  }


  void saveProduct() async {

        var name = texts[0].text.trim();
        var price = num.tryParse(texts[1].text) ?? 0;
        var imgUrl = widget.product?.url;
        var imgFile = img;
        var catid = selectedCat.id;

        if(name.isEmpty || price < 0){
            Util.showAlert(context, 'Verifica los datos ingresados por favor');
            return;
        }
        Util.showLoading(context, 'Guardando producto...');
        //start saving product.
        if(imgFile != null){
            imgUrl = await ApiUtil.uploadImage(imgFile);
        }

        var resp = await HttpMan.insertProduct(
          idProd, name, imgUrl, price, catid
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
              setState(() => idProd = genid);
          }
        }
  }
}

