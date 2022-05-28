import 'package:flutter/material.dart';

import '../../data/product.dart';
import '../widgets/common.dart';
import 'menu-product.dart';



class ProdList extends StatefulWidget{

  const ProdList( {Key? key}) : super(key: key);

  @override
  ProdListState createState() => ProdListState();
}


class ProdListState extends State<ProdList>{

  List<Product> prodList = [], filtered = [];

  @override
  void initState() {
    for (var i=0; i < 10; i ++){
        prodList.add(Product(i, "test $i", "categoria", "", 100));
    }
    filtered = prodList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.blueAccent,
          bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: SearchWidget("Buscar producto", (text) =>
                      setState(() {
                          filtered = prodList
                              .where((element) => matchProd(text, element))
                              .toList();
                      })
                )),
        ),

        body: Column(
            children: [
                Expanded(
                  child: ListView.builder(itemBuilder: (context, index){
                    Product prod = filtered[index~/2];
                    return index.isOdd ? const Divider() :
                    buildListTile(context, Icons.shopping_cart_rounded, prod);
                  }, itemCount: filtered.length*2),
                )
            ],
        )
    );
  }

  ListTile buildListTile(context, leadingIcon, Product product) {

    String cat = product.category ?? 'Sin categoría';

    return ListTile(
        leading: const CircleAvatar(
            backgroundColor: Colors.white,
            //backgroundImage: img == null ? const NetworkImage('') : NetworkImage(img),
            backgroundImage: AssetImage('assets/add_img.png'),
            radius: 25
        ),
        title: Text(product.name),
        subtitle: Text(cat),
        trailing: const Icon(Icons.arrow_forward_ios_sharp),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>
              ProdMenu(product.id))).then(
                (value) => setState(() {
                  filtered = prodList;
          }))
    );
  }

  bool matchProd(String search, Product prod){
      return prod.name.toLowerCase().contains(search);
  }
}