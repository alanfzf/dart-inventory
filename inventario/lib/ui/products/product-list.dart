import 'package:flutter/material.dart';

import '../../util/http-man.dart';
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
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }


  @override
  Widget build(BuildContext context) {

    var divider = const Divider(thickness: 1);


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

        body: loaded ? Column(
            children: [
                Expanded(
                  child: ListView.builder(itemBuilder: (context, index){
                    Product prod = filtered[index~/2];
                    return index.isOdd ? divider:
                    buildListTile(context, Icons.shopping_cart_rounded, prod);
                  }, itemCount: filtered.length*2),
                )
            ],
        ) : const LoadingScreen()
    );
  }

  ListTile buildListTile(context, leadingIcon, Product product) {
    String cat = product.category ?? 'Sin categoría';
    return ListTile(
        leading: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: getImage(product.url),
            radius: 25
        ),
        title: Text(product.name),
        subtitle: Text(cat),
        trailing: const Icon(Icons.arrow_forward_ios_sharp),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>
              ProdMenu(product.id, product))).then(
                (value) => setState(() {
                  setState(() => loaded = false);
                  loadProducts();
          }))
    );
  }

  bool matchProd(String search, Product prod){
      return prod.name.toLowerCase().contains(search);
  }

  ImageProvider getImage(String? url){
      var img = url;
      if(img == null){
          return const AssetImage('assets/add_img.png');
      }
      return NetworkImage(img);
  }

  Future<void> loadProducts() async{
      var list = await HttpMan.getProducts();
      prodList.clear();
      filtered.clear();
      prodList.addAll(list);
      filtered.addAll(list);
      setState(() => loaded = true);
  }
}