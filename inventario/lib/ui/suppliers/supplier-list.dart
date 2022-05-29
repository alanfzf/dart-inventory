import 'package:flutter/material.dart';

import '../../util/http-man.dart';
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

  bool loaded = false;
  List<Supplier> supList = [], filtered = [];

  @override
  void initState() {
    super.initState();
    loadSuppliers();
  }

  @override
  Widget build(BuildContext context) {
      var divider = const Divider(thickness: 1);

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
        body: loaded ? Column(
            children: [
                Expanded(
                  child: ListView.builder(itemBuilder: (context, index){
                    Supplier sup = filtered[index~/2];
                    return index.isOdd ? divider:
                    buildListTile(context, Icons.shopping_cart_rounded, sup);
                  }, itemCount: filtered.length*2),
                )
            ],
        ) : const LoadingScreen()
    );
  }

  ListTile buildListTile(ctx, leadIcon, Supplier sup) {
    return ListTile(
        leading: const CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/supplier.png'),
            radius: 25
        ),
        title: Text(sup.name),
        subtitle: Text("Id: ${sup.id}"),
        trailing: const Icon(Icons.arrow_forward_ios_sharp),
        onTap: () => Navigator.push(ctx, MaterialPageRoute(builder:
            (context) => SupMenu(sup.id, sup)))
            .then((value) => setState(() {
                  setState(() => loaded = false);
                  loadSuppliers();
          }))
    );
  }

  Future<void> loadSuppliers() async{
      var list = await HttpMan.getSuppliers();
      supList.clear();
      filtered.clear();
      supList.addAll(list);
      filtered.addAll(list);
      setState(() => loaded = true);
  }


  bool matchSupp(String search, Product prod){
      return prod.name.toLowerCase().contains(search);
  }
}