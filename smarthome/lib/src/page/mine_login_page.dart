import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MineLoginPage extends StatefulWidget {
  @override
  _MineLoginPageState createState() => _MineLoginPageState();
}

class _MineLoginPageState extends State<MineLoginPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Color(0XffCDDEEC),
      ),
      child: Scaffold(
        //填充布局
        body: Container(
            width: double.infinity,
            height: double.infinity,
            child: buildStack()),
      ),
    );
  }

  Stack buildStack() {
    return Stack(
      children: [
        Positioned.fill(child: buildBackgroundWidget()),
      ],
    );
  }

  Container buildBackgroundWidget() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Colors.lightBlueAccent.withOpacity(0.3),
            Colors.blue.withOpacity(0.3),
          ])),
    );
  }
}
