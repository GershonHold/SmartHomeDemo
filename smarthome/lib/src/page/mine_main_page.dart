import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smarthome/src/page/setting_page.dart';
import 'package:smarthome/util/SharedPreferencesUtil.dart';

import '../../util/NavigatorUtils.dart';
import 'login_page.dart';
import 'mine_login_page.dart';

/// 代码清单
///个人中心页面
class MineMainPage extends StatefulWidget {
//传参
  String usrName;

  MineMainPage(this.usrName);

  @override
  _MineMainPageState createState() => _MineMainPageState();
}

class _MineMainPageState extends State<MineMainPage> {
  @override
  void initState() {
    super.initState();
    //Stream 监听
    //用来远程通知当前页面刷新 目前在登录页面有使用
    // loginStreamController.stream.listen((event) {
    setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    //设置状态栏

    return Scaffold(
        appBar: AppBar(
          leading: Text(''),
          title: Text("个人中心"),
          centerTitle: true,
          actions: [
            //右上角的设置按钮
            buildSettingButton(this.context)
          ],
        ),
        body: ListView(
          children: <Widget>[
            _topHeader(),
          ],
        ));
  }

  IconButton buildSettingButton(BuildContext context) {

    return IconButton(
      icon: Icon(Icons.settings_applications_outlined),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return SettingPage(widget.usrName);
        }));
      },
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

  //注意这里buildMainBody方法要像login_page的check方法一样要写为async方法
  buildMainBody(String usrName) {
    //根据usrName是否为空 判断用户是否已登录
    if (usrName != "") {
      //构建已登录的页面
      return MineLoginPage();
    } else {
      //未登录则跳转登录界面
      return LoginPage();
    }
  }

  Widget _topHeader() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.blueGrey, //亮粉色
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: height * 0.1),
            width: width * 0.3,
            height: height * 0.3,
            alignment: Alignment.center,
            child: ClipOval(
              //圆形的头像
              child: Image.asset("assets/images/icon.jpg"),
            ),
          ),
          //头像下面的文字，为了好看也是嵌套一个Container
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(widget.usrName,
                style: TextStyle(fontSize: 20, color: Colors.black54)),
          )
        ],
      ),
    );
  }

// @override
// void dispose() {
//   loginStreamController.close();
//   super.dispose();
// }
// }
}
