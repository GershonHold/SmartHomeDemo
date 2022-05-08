import 'package:flutter/material.dart';
import 'package:smarthome/src/page/login_page.dart';
import 'package:smarthome/src/page/root_app_page.dart';
import 'package:smarthome/util/SharedPreferencesUtil.dart';

void main() {
  runApp(RootAPP());
}
/// 根目录 Activity  ViewController
class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      home: LoginPage(),
    );
  }



}
