import 'package:flutter/material.dart';

import 'config-man.dart';
import 'ui/auth/login.dart';


void main(){
  WidgetsFlutterBinding.ensureInitialized();
  Config.initialize().whenComplete(() =>
      runApp(const MaterialApp(
          debugShowCheckedModeBanner: false, home: Login()
      ))
  );
}

