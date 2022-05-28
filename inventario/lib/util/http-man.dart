import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inventario/config-man.dart';
import 'package:inventario/data/category.dart';
import 'package:inventario/data/product.dart';
import 'package:inventario/data/supplier.dart';
import 'package:inventario/data/user.dart';

class HttpMan {

  HttpMan._();

  static Future<User?> performLogin(String user, String pass) async {

    try{
      var resp = await http.post(Config.getAPIurl('/login'),
        body: {"username": user, "password": pass});

      var json = resp.statusCode == 200 ? jsonDecode(resp.body) : null;

      if(json == null || json.length == 0){
          return null;
      }
      return User(json[0]["id_staff"], json[0]["staff_login"]);
    // ignore: empty_catches
    }catch(err){}
    
    return null;
  }

  static Future<List<Product>> getProducts() async{
      return [];
  } 

  static Future<List<Category>> getCategories() async{
      return [];
  }

  static Future<List<Supplier>> getSuppliers() async {
      return [];
  }
}
