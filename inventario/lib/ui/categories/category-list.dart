import 'package:flutter/material.dart';


import '../../../data/category.dart';
import '../../util/http-man.dart';
import '../widgets/common.dart';
import 'menu-category.dart';




class CatList extends StatefulWidget{

  const CatList({Key? key}) : super(key: key);


  @override
  CatListState createState() => CatListState();
}

class CatListState extends State<CatList>{

  List<Category> catList = [], filtered = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    var divider = const Divider(thickness: 1);

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
        body: loaded ? Column(
          children: [
            Expanded(
              child: ListView.builder(itemBuilder: (context, index){
                Category prod = filtered[index~/2];
                return index.isOdd ? divider :
                buildListTile(context, Icons.shopping_cart_rounded, prod);
              }, itemCount: filtered.length*2),
            )]
        ) : const LoadingScreen()
    );
  }

  ListTile buildListTile(context, leadingIcon, Category cat) {
    return ListTile(
        leading: const CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/category.png'),
            radius: 25
        ),
        title: Text(cat.category),
        subtitle: Text("ID: ${cat.id}"),
        trailing: const Icon(Icons.arrow_forward_ios_sharp),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder:
            (context) => CatMenu(cat.id, cat)))
            .then((value) => setState(() {
                setState(() => loaded = false);
                loadCategories();
         }))
    );
  }

  bool matchCat(String search, Category cat){
    return cat.category.toLowerCase().contains(search.toLowerCase());
  }

  Future<void> loadCategories() async{
      var list = await HttpMan.getCategories();
      catList.clear();
      filtered.clear();
      catList.addAll(list);
      filtered.addAll(list);
      setState(() => loaded = true);
  }
}