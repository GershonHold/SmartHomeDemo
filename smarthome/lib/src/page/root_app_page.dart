import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/SharedPreferencesUtil.dart';
import 'login_page.dart';

class RootAPP extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RootAPPState();
  }
}

class _RootAPPState extends State {
  String currentKeepPwdName = "";
  String PwdFromSP = "";

  @override
  Widget build(BuildContext context) {
    initFromSP();
    return MaterialApp(
      home: LoginPage(),
    );
  }

  initFromSP() async {
    currentKeepPwdName = await SharedPreferencesUtils.getSPData(
        "current_keep_pwd"); //获得当前保存密码的用户名

    PwdFromSP =
        await SharedPreferencesUtils.getSPData("pwd_$currentKeepPwdName");
  }
}
