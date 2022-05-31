import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inventario/config-man.dart';
import 'package:inventario/data/category.dart';
import 'package:inventario/data/log.dart';
import 'package:inventario/data/olap.dart';
import 'package:inventario/data/product.dart';
import 'package:inventario/data/report.dart';
import 'package:inventario/data/sell.dart';
import 'package:inventario/data/supplier.dart';
import 'package:inventario/data/user.dart';

class HttpMan {

    HttpMan._();

    static Future<dynamic> _createDeleteRequest(String endpoint, Map<String, dynamic> body) async{
        dynamic reqResp;
        try{
          var resp = await http.delete(Config.getAPIurl(endpoint),      
                headers: {
                    "content-type": "application/json"
                },
                body: jsonEncode(body)
            );  
            var json = resp.statusCode == 200 ? jsonDecode(resp.body) : null;
            if(json == null || json.length == 0){
                return null;
            }
            reqResp = json;
        }catch(err){
            print(err);
        }
        return reqResp;
    }

    static Future<dynamic> _createPostRequest(String endpoint, Map<String, dynamic> body) async{
          dynamic reqResp;
          try{
              var resp = await http.post(Config.getAPIurl(endpoint), 
                headers: {
                    "content-type": "application/json"
                },
                body: jsonEncode(body)
              );
              var json = resp.statusCode == 200 ? jsonDecode(resp.body) : null;
              if(json == null || json.length == 0){
                  return null;
              }
              reqResp = json;

          }catch(err){
              print(err);
          }
          
          return reqResp;
    }

    static Future<dynamic> _createGetRequest(String endpoint) async{
      dynamic reqResp;

      try{
            var resp = await http.get(Config.getAPIurl(endpoint));
            var json = resp.statusCode == 200 ? jsonDecode(resp.body) : null;


            if(json==null || json.length == 0){
                return null;
            }
            reqResp = json;
          }catch(err){ print(err); }

      return reqResp;
    }

  //CALLS.
    static Future<User?> performLogin(String user, String pass) async {
        var login = await _createPostRequest('/login', {
            "username": user,
            "password": pass,
        });

        if(login==null){
            return null;
        }

        return User(login[0]["id_staff"], login[0]["person_group"], login[0]["staff_login"]);
    }

    static Future<String> performBackup() async {
        var resp = await _createPostRequest('/backup', {});
        if(resp == null){
            return "ERROR";
        }
        return resp["log"];
    }

    static Future<List<Product>> getProducts() async {
        final List<Product> products = [];
        var resp = await _createGetRequest('/get_products');
        if(resp == null){
            return products;
        }
        for (var val in resp) {
            products.add(Product(
                val["id_product"], 
                val["prod_name"], 
                val["categ_name"],             
                val["prod_image"], 
                val["prod_price"]
            ));
          }
        return products;
    }

    static Future<List<Category>> getCategories() async {
        final List<Category> categories = [];
        var resp = await _createGetRequest('/get_categories');
        if(resp == null){
            return categories;
        }
        for (var val in resp) {
            categories.add(Category(
                val["id_category"],
                val["categ_name"]
            ));
          }
        return categories;
    }

    static Future<List<Log>> getLogs() async {
        final List<Log> logs = [];
        var resp = await _createGetRequest('/get_logs');
        if(resp == null){
            return logs;
        }
        for (var val in resp) {
            logs.add(Log(
              val["id_log"], 
              val["log_table"], 
              val["log_action"], 
              val["log_user"], 
              DateTime.parse(val["log_date"])
            ));
          }
        return logs;
    }


    static Future<List<Supplier>> getSuppliers() async {
        final List<Supplier> suppliers = [];
        var resp = await _createGetRequest('/get_suppliers');
        if(resp == null){
            return suppliers;
        }
        for (var val in resp) {
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
        return suppliers;
    }

    static Future<dynamic> insertProduct(int id, String prod, String? image, 
        num price, int category) async{

        var resp = _createPostRequest('/upsert_product',{
              "prod_id": id, 
              "prod": prod,
              "image": image,
              "price": price,
              "category": category
        });
        return resp;
    }

    static Future<dynamic> insertCategory(int id, String cat) async{
        var resp = _createPostRequest('/upsert_category',{
              "id_category": id, 
              "category": cat,
        });

        return resp;
    }

    static Future<dynamic> insertSupplier(int id, String sup, String nit, 
        String rep, String rep2, String phone, String mail) async{
          
          var resp = _createPostRequest('/upsert_supplier', {
                "sup_id": id,
                "sup_name": sup,
                "sup_nit": nit,
                "rep_name": rep,
                "rep_surname": rep2,
                "rep_phone": phone,
                "rep_mail": mail,
          });

        return resp;
    }

    static Future<List<Report>> reportProducts() async{
        List<Report> reportes = [];

        var resp = await _createGetRequest('/report_products');
        
        if(resp == null){
            return reportes;
        }

        for(var el in resp){
            reportes.add(Report(el["id_product"], el["prod_name"], el["existencias"]));
        }

        return reportes;
    } 

    static Future<List<Report>> reportCategories() async{
        List<Report> reportes = [];

        var resp = await _createGetRequest('/report_categories');

        if(resp == null){
            return reportes;
        }

        for(var el in resp){
              reportes.add(Report(el["id"], el["categoria"], el["cantidad"]));
        }

        return reportes;
    } 

    static Future<List<Olap>> olapMovements() async{
        List<Olap> olap = [];

        var resp = await _createGetRequest('/get_olap');

        if(resp == null){
            return olap;
        }

        for(var el in resp){
              olap.add(Olap(el["producto"], 
                el["categoria"], 
                DateTime.parse(el["fecha"]), 
                el["tipo"], 
                el["cantidad"], 
                el["total"]
              ));
          }

        return olap;
   } 

  static Future<List<Sell>> sellsByDay() async{
        List<Sell> sells = [];
        var resp = await _createGetRequest('/get_sells');
        if(resp == null){
            return sells;
        }
        for(var el in resp){
              sells.add(Sell(
                  DateTime.parse(el["fecha"]), 
                  el["tipo"], 
                  el["cantidad"], 
                  el["total"]
              ));
        }
        return sells;
    }

    static Future<void> deleteCategory(int catId) async{
        var resp = await _createDeleteRequest('/delete_category', 
        {"category_id": catId});
    }

    static Future<void> deleteProduct(int product) async{
        var resp = await _createDeleteRequest('/delete_product', 
        {"product_id": product});
    }

    static Future<void> deleteSupplier(int idSupp) async{
        var resp = await _createDeleteRequest('/delete_supplier', 
        {"supplier_id": idSupp});
    }
  }