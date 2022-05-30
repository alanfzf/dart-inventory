import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Util {
  
  Util._();


  static returnToMenu(BuildContext context){
      Navigator.of(context).popUntil((route) => route.isFirst);
  }

  static void showSnack(BuildContext ctx, String txt) =>
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(txt), duration: const Duration(milliseconds: 1000)));

  static void popDialog(BuildContext cx) =>
      Navigator.of(cx, rootNavigator: true).pop();

  static void showLoading(BuildContext ctx, String msg) {
    showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
            content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [const CircularProgressIndicator(), Text(msg)],
        ));
      },
    );
  }

  static Future<void> showAlert(BuildContext ctx, String msg) async {
    await showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: const Text('Alerta'),
            content: Text(msg),
            actions: [
              TextButton(onPressed: 
              () => popDialog(ctx), child: const Text('Ok')
              )],
          );
        });
  }

  static Future<bool> showNoYesDialog(BuildContext ctx, String msg) async {
    bool val = await showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(true),
              child: const Text('Si'),
            ),
          ],
        );
      },
    );
    return val;
  }

  static Future<int?> showInputDialog(BuildContext ctx) async {
    String data = await showDialog(
        context: ctx,
        builder: (context) {
          TextEditingController controller = TextEditingController();
          return AlertDialog(
            title: const Text('Ingrese los datos'),
            content: TextFormField(
              autofocus: true,
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(''),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context, rootNavigator: true)
                    .pop(controller.text),
                child: const Text('Confirmar'),
              ),
            ],
          );
        });
    return int.tryParse(data);
  }

  static void redirect(BuildContext ctx, StatefulWidget land) =>
      Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => land));
}
