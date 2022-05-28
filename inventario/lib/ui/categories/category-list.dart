import 'package:flutter/material.dart';


import '../widgets/common.dart';
import '../../../data/category.dart';
import 'menu-category.dart';




class CatList extends StatefulWidget{

  const CatList({Key? key}) : super(key: key);


  @override
  CatListState createState() => CatListState();
}

class CatListState extends State<CatList>{

  List<Category> catList = [Category(1, 'ropa')], filtered = [];

  @override
  void initState() {
    filtered = catList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.blueAccent, bottom:
        PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: SearchWidget("Buscar categoría", (text) =>
              setState(() {
                filtered = catList.where((e) => matchCat(text, e)).toList();
              })
            )
        )
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(itemBuilder: (context, index){
                Category prod = filtered[index~/2];
                return index.isOdd ? const Divider() :
                buildListTile(context, Icons.shopping_cart_rounded, prod);
              }, itemCount: filtered.length*2),
            )
          ],
        )
    );
  }

  ListTile buildListTile(context, leadingIcon, Category cat) {



    return ListTile(
        leading: const CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/add_img.png'),
            radius: 25
        ),
        title: Text(cat.category),
        subtitle: Text("ID: ${cat.id}"),
        trailing: const Icon(Icons.arrow_forward_ios_sharp),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder:
            (context) => CatMenu(cat.id))).then((value) => setState(() {
                  filtered = catList;
         }))
    );
  }


  bool matchCat(String search, Category cat){
    return cat.category.toLowerCase().contains(search.toLowerCase());
  }
}