import 'package:flutter/material.dart';


import '../../data/supplier.dart';
import '../../data/product.dart';
import '../widgets/common.dart';
import 'menu-suppliers.dart';



class SupList extends StatefulWidget{
    const SupList( {Key? key}) : super(key: key);

    @override
    SupListState createState() => SupListState();
}

class SupListState extends State<SupList>{

  List<Supplier> prodList = [], filtered = [];

  @override
  void initState() {
    /*asignamos los productos cargados
    a la lista filtrada*/
    filtered = prodList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.blueAccent, bottom:
        PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: SearchWidget("Buscar proveedor", (text){
                    setState(() {
                      //filtrar
                  });
                }
              )
          )
        ),
        body: Column(
            children: [
                Expanded(
                  child: ListView.builder(itemBuilder: (context, index){
                    Supplier sup = filtered[index~/2];
                    return index.isOdd ? const Divider() :
                    buildListTile(context, Icons.shopping_cart_rounded, sup);
                  }, itemCount: filtered.length*2),
                )
            ],
        )
    );
  }

  ListTile buildListTile(ctx, leadIcon, Supplier sup) {

    return ListTile(
        leading: const CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/add_img.png'),
            radius: 25
        ),
        title: Text(sup.provider),
        subtitle: Text("Id: ${sup.id}"),
        trailing: const Icon(Icons.arrow_forward_ios_sharp),
        onTap: () => Navigator.push(ctx, MaterialPageRoute(builder:
            (context) => SupMenu(sup.id)))
            .then((value) => setState(() {
                  //prodList = PData.getProducts().values.toList();
                  filtered = prodList;
          }))
    );
  }


  bool matchSupp(String search, Product prod){
      return prod.name.toLowerCase().contains(search);
  }
}