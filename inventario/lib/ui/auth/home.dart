import 'package:flutter/material.dart';
import 'package:inventario/data/user.dart';
import 'package:inventario/ui/reports/graphs.dart';
import 'package:inventario/ui/reports/log.dart';
import 'package:inventario/util/groups.dart';
import 'package:inventario/util/http-man.dart';

import '../../util/util.dart';
import 'login.dart';

import '../products/product-list.dart';
import '../products/menu-product.dart';

import '../categories/category-list.dart';
import '../categories/menu-category.dart';

import '../suppliers/supplier-list.dart';
import '../suppliers/menu-suppliers.dart';

import '../reports/reports.dart';
import '../reports/movements.dart';


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
               DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.blueAccent),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    const Text("Menú principal", style:TextStyle(color: Colors.white, fontSize: 25)),
                    Text("(Modo ${Groups.getGroupName(widget.user.group)})", style: const TextStyle(color: Colors.white, fontSize: 15)),
                  ])
              ),

              //productos
              getTileMenu(Icons.archive, "Agregar producto",
                      ()=> Util.redirect(context, const ProdMenu(-1, null)),
                      permission: Permission.empleado),

              getTileMenu(Icons.search, "Buscar productos",
                      () => Util.redirect(context, const ProdList()),
                      permission: Permission.empleado),

              //categorias
              divider,
              getTileMenu(Icons.category, "Agregar categoria",
                      () => Util.redirect(context, const CatMenu(-1, null)),
                      permission: Permission.empleado),

              getTileMenu(Icons.search, "Buscar categorías",
                      () => Util.redirect(context, const CatList()),
                      permission: Permission.empleado),

              //proveedores
              divider,
              getTileMenu(Icons.person_add, "Agregar proveedor",
                      () => Util.redirect(context, const SupMenu(-1, null)),
                      permission: Permission.empleado),

              getTileMenu(Icons.person_search_rounded, "Buscar proveedores",
                      () => Util.redirect(context, const SupList()), 
                      permission: Permission.empleado),

              //otras opcioens
              divider,
              getTileMenu(Icons.restore, "Generar backup", generarBackup, 
                  permission: Permission.administrador
               ),
              getTileMenu(Icons.logout, "Cerrar sesión",
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
                children: [
                  getTile(Icons.attach_money, "Movimientos", 
                    ()=>  Util.redirect(context, const MovementsMenu()),
                    permission: Permission.finanzas
                  ),

                  getTile(Icons.analytics, "Reportes", 
                      ()=> Util.redirect(context, const ReportsMenu()),
                  ),
          
                  getTile(Icons.bar_chart, "Graficas", 
                    ()=> Util.redirect(context, const GraphsMenu()),
                    permission: Permission.finanzas
                  ),

                  getTile(Icons.wysiwyg, "Bitacora", 
                    ()=> Util.redirect(context, const LogMenu()),
                    permission: Permission.administrador
                  ),


                  getTile(Icons.help, "Acerca de", 
                  ()=> Util.showAlert(context, 
                      "Nombre: Alan David González López\n" 
                      "Carné: 4090-19-4713\n"
                      "Curso: Base de datos II"
                  )),
                ])
            ])
    );
  }

  Future<void> generarBackup() async{
      var op = await Util.showNoYesDialog(context, "Deseas generar el backup?");
      if(op){
          Util.showLoading(context, "Generando backup....");
          var resp = await HttpMan.performBackup();
          Util.popDialog(context);
          Util.popDialog(context);
          Util.showSnack(context, resp);
      }
  }

  
  InkWell getTile(IconData icon, String text, VoidCallback action, {Permission? permission}){
      return InkWell(
      onTap: (){
          if(permission != null && !Groups.hasPermission(widget.user.group, permission)){
              Util.showSnack(context, "No tienes permiso para acceder!");
              return;
          }
          action();
      },
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


  InkWell getTileMenu(IconData icon, String text, VoidCallback action, {Permission? permission}){
      return InkWell(
            onTap: (){

                if(permission != null && !Groups.hasPermission(widget.user.group, permission)){
                    Util.popDialog(context);
                    Util.showSnack(context, "No tienes permiso para acceder!");
                    return;
                }

                action();
            },
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