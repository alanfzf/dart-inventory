import 'package:flutter/material.dart';
//custom imports
import '../../util/http-man.dart';
import '../../util/util.dart';
import '../widgets/common.dart';
import 'home.dart';

TextEditingController user = TextEditingController(),
pass = TextEditingController();

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        primary: false,
        reverse: true,
        child: Wrap(
          direction: Axis.vertical,
          spacing: 25,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 75.0,
                backgroundImage: AssetImage('assets/add_img.png'),
              ),
            ),
            const SizedBox(width: 300, height: 10),
            const Text("Iniciar Sesión",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                )),
            InputData("Ingresa tu usuario", user, false),
            InputData("Ingresa tu clave", pass, true),
            CustomButton("Acceder", Colors.blueAccent, 300, 50, doLogin),
          ],
        ),
      ),
    ));
  }

  //funcs

  Future<void> doLogin() async{
    FocusManager.instance.primaryFocus?.unfocus();
    Util.showLoading(context, "Iniciando sesión...");
    var staff = await HttpMan.performLogin(user.text.trim(), pass.text.trim());

    Util.popDialog(context);

    if(staff == null){
      Util.showSnack(context, "Usuario o clave incorrecta");
      return;
    }

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: 
      (ctx) => Home(staff)), (rt) => false);
  }
}

class InputData extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool pass;

  const InputData(this.hint, this.controller, this.pass, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 70,
        width: 350,
        child: TextField(
            obscureText: pass,
            controller: controller,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey.shade400),
              hintText: hint,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300)),
            )
        ));
  }
}
