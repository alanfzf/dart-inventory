import 'package:flutter/material.dart';
import 'package:inventario/data/user.dart';

import '../../util/util.dart';
import 'login.dart';

import '../products/product-list.dart';
import '../products/menu-product.dart';

import '../categories/category-list.dart';
import '../categories/menu-category.dart';

import '../suppliers/supplier-list.dart';
import '../suppliers/menu-suppliers.dart';


class Home extends StatefulWidget{

  final User user;
  const Home(this.user, {Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home>{


  @override
  void initState() {
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    var divider = const Divider(thickness: 1);
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.blueAccent, toolbarHeight: 70),
        drawer: Drawer(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blueAccent),
                  child: Text("Menú principal", style:
                  TextStyle(color: Colors.white, fontSize: 25))
              ),

              //productos
              TileMenu(Icons.archive, "Agregar producto",
                      ()=> Util.redirect(context, const ProdMenu(-1))),

              TileMenu(Icons.search, "Buscar productos",
                      () => Util.redirect(context, const ProdList())),

              //categorias
              divider,
              TileMenu(Icons.category, "Agregar categoria",
                      () => Util.redirect(context, const CatMenu(-1))),

              TileMenu(Icons.search, "Buscar categorías",
                      () => Util.redirect(context, const CatList())),

              //proveedores
              divider,
              TileMenu(Icons.person_add, "Agregar proveedor",
                      () => Util.redirect(context, const SupMenu(-1))),

              TileMenu(Icons.person_search_rounded, "Buscar proveedores",
                      () => Util.redirect(context, const SupList())),

              //otras opcioens
              divider,
              TileMenu(Icons.settings, "Opciones", () { }),
              TileMenu(Icons.logout, "Cerrar sesión",
                      () => Util.redirect(context, const Login()))

            ],
          ),
        ),
        body: Column(
            children: [
              Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 50),
                      child: Container(
                          height: 75,
                          width: 325,
                          color: Colors.blueAccent,
                          child: Center(
                            child: Text(
                                "Bienvenido @${widget.user.username.toUpperCase()}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold
                                )),
                          )
                      ),
                    ),
                  ],
              ),

              Wrap(
                spacing: 25,
                runSpacing: 30,
                children: const [
                  TileMain("Movimientos", Icons.attach_money),
                  TileMain("Reportes", Icons.analytics),
                  TileMain("Bitacora", Icons.wysiwyg),
                  TileMain("Acerca de", Icons.help),
                ])
            ])
    );
  }

}

//widgets
class TileMain extends StatelessWidget{

  final String text;
  final IconData icon;

  const TileMain(this.text, this.icon, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: Ink(
        height: 160,
        width: 160,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
                Icon(icon,
                  color: Colors.blueAccent, size: 50),
                Text(text, style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  fontWeight: FontWeight.bold
                )),
            ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(3)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 4,
                  offset: const Offset(0, 3)
              )
            ]
        ),
      ),
    );
  }
}



class TileMenu extends StatelessWidget{
      final IconData icon;
      final String text;
      final VoidCallback onTap;

      const TileMenu(this.icon, this.text,
          this.onTap, {Key? key}) : super(key: key);

      @override
      Widget build(BuildContext context) {
        return InkWell(
            onTap: onTap,
            child: SizedBox(height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                    Padding(padding: const EdgeInsets.all(12.0),
                      child: Icon(icon),
                    ),
                    Padding(padding: const EdgeInsets.all(8.0),
                        child: Text(text))
                    ])
                ])
          ));
    }
  }

