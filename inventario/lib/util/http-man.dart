import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inventario/config-man.dart';
import 'package:inventario/data/category.dart';
import 'package:inventario/data/olap.dart';
import 'package:inventario/data/product.dart';
import 'package:inventario/data/report.dart';
import 'package:inventario/data/sell.dart';
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

      List<Product> products = [];

      try{
        var resp = await http.get(Config.getAPIurl('/get_products'));
        var json = resp.statusCode == 200 ? jsonDecode(resp.body) : null;


        if(json==null || json.length == 0){
            return products;
        }

        for (var val in json) {

            products.add(Product(
                val["id_product"], 
                val["prod_name"], 
                val["categ_name"],             
                val["prod_image"], 
                val["prod_price"]
            ));
        }
      }catch(err){      }

      return products;
  } 

  static Future<List<Category>> getCategories() async{
     
      List<Category> categories = [];

      try{
        var resp = await http.get(Config.getAPIurl('/get_categories'));
        var json = resp.statusCode == 200 ? jsonDecode(resp.body) : null;

        if(json==null || json.length == 0){
            return categories;
        }

        for (var val in json) {
            categories.add(Category(
              val["id_category"],
              val["categ_name"]
             ));
        }
      }catch(err){}

      return categories;
  }

  static Future<List<Supplier>> getSuppliers() async {
      
      List<Supplier> suppliers = [];

      try{
        var resp = await http.get(Config.getAPIurl('/get_suppliers'));
        var json = resp.statusCode == 200 ? jsonDecode(resp.body) : null;

        if(json==null || json.length == 0){
            return suppliers;
        }

        for (var val in json) {
            suppliers.add(Supplier(
                val["id_supplier"], 
                val["sup_name"],
                val["person_name"], 
                val["person_lastname"], 
                val["email"],
                val["phone"], 
                val["sup_nit"]
              ));
        }
      }catch(err){}

      return suppliers;
  }


  static Future<dynamic> insert_product(int id, String prod, String? image, num price, int category) async{
      var reqResp;

      try{
        var resp = await http.post(Config.getAPIurl('/upsert_product'),
            headers: {
                "content-type": "application/json"
            },
            body: jsonEncode({
            "prod_id": id, 
            "prod": prod,
            "image": image,
            "price": price,
            "category": category
          }));
        var json = resp.statusCode == 200 ? jsonDecode(resp.body) : null;
    
        if(json == null || json.length == 0){
            return null;
        }
        reqResp = json;
    }catch(err){}

    return reqResp;
  }

    static Future<dynamic> insert_category(int id, String cat) async{

      var reqResp;

      try{
        var resp = await http.post(Config.getAPIurl('/upsert_category'),
          headers: {
            "content-type": "application/json"
          },
          body: jsonEncode({
            "id_category": id, 
            "category": cat,
          }));

        var json = resp.statusCode == 200 ? jsonDecode(resp.body) : null;
      
        if(json == null || json.length == 0){
            return null;
        }
        reqResp = json;
    }catch(err){}
    return reqResp;
  }

  static Future<dynamic> insert_supplier(int id, String sup, String nit, String rep, String rep2, String phone, String mail) async{

      var reqResp;

      try{
        var resp = await http.post(Config.getAPIurl('/upsert_supplier'),
          headers: {
            "content-type": "application/json"
          },
          body: jsonEncode({
              "sup_id": id,
              "sup_name": sup,
              "sup_nit": nit,
              "rep_name": rep,
              "rep_surname": rep2,
              "rep_phone": phone,
              "rep_mail": mail,
          }));

        var json = resp.statusCode == 200 ? jsonDecode(resp.body) : null;
      
        if(json == null || json.length == 0){
            return null;
        }
        reqResp = json;

    }catch(err){}

    return reqResp;
  }


  static Future<List<Report>> reportProducts() async{
      List<Report> reportes = [];

      try{
        var resp = await http.get(Config.getAPIurl('/report_products'));
        var json = resp.statusCode == 200 ? jsonDecode(resp.body) : null;

        if(json==null || json.length == 0){
            return reportes;
        }

        for(var el in json){
            reportes.add(Report(el["id_product"], el["prod_name"], el["existencias"]));
        }

      }catch(err){      }

      return reportes;
  } 

static Future<List<Report>> reportCategories() async{
      List<Report> reportes = [];

      try{
        var resp = await http.get(Config.getAPIurl('/report_categories'));
        var json = resp.statusCode == 200 ? jsonDecode(resp.body) : null;

        if(json==null || json.length == 0){
            return reportes;
        }

        for(var el in json){
            reportes.add(Report(el["id"], el["categoria"], el["cantidad"]));
        }

      }catch(err){      }

      return reportes;
  } 


  static Future<List<Olap>> olapMovements() async{
        List<Olap> olap = [];

        try{
          var resp = await http.get(Config.getAPIurl('/get_olap'));
          var json = resp.statusCode == 200 ? jsonDecode(resp.body) : null;

          if(json==null || json.length == 0){
              return olap;
          }

          for(var el in json){
              olap.add(Olap(el["producto"], 
                el["categoria"], 
                DateTime.parse(el["fecha"]), 
                el["tipo"], 
                el["cantidad"], 
                el["total"]
              ));
          }

        }catch(err){     print(err); }

        return olap;
    } 



 static Future<List<Sell>> sellsByDay() async{
        List<Sell> sells = [];

        try{
          var resp = await http.get(Config.getAPIurl('/get_sells'));
          var json = resp.statusCode == 200 ? jsonDecode(resp.body) : null;

          if(json==null || json.length == 0){
              return sells;
          }

          for(var el in json){
              sells.add(Sell(
                  DateTime.parse(el["fecha"]), 
                  el["tipo"], 
                  el["cantidad"], 
                  el["total"]
              ));
          }

        }catch(err){     print(err); }

        return sells;
    } 
}
