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
                backgroundImage: AssetImage('assets/add_img_alt.png'),
              ),
            ),
            const SizedBox(width: 300, height: 10),
            const Text("Iniciar Sesión",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                )),
            LineInput("Ingresa tu usuario", user, false),
            LineInput("Ingresa tu clave", pass, true),
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


