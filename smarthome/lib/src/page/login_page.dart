import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import '../../util/SharedPreferencesUtil.dart';
import '../../util/FlutterToastUtil.dart';
import 'index_page.dart';

///默认加载显示的首页面
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool KeepPwdChecked = false;
  String currentKeepPwdName = "";
  String PwdFromSP = "";
  var _textPasswordEditingController = new TextEditingController();
  var _textAccountEditingController = new TextEditingController();
  bool isfirstLogin = false;

  @override
  Widget build(BuildContext context) {
    initFromSP();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            //第一层 背景图片
            buildFunction1(),
            //第二层 高斯模糊
            buildFunction3(),
            //第三层 logo
            buildFunction2(),
            //第四层 登录输入层
            buildFunction4(),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  //buildFunction1的作用是设置登录界面背景图片
  buildFunction1() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Positioned.fill(
      child: Image.asset(
        //注意一定要这样写，写成"/assets/images/launch_image.png"是不对的
        "assets/images/launch_image.png", width: width,
        height: height,
        fit: BoxFit.fill,
      ),
    );
  }

  buildFunction2() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Positioned(
      top: height / 6,
      left: 0,
      right: 0,
      child: Image.asset(
        "assets/images/logo.png", width: width / 10,
        height:
            height / 10, //注意一定要这样写，写成"/assets/images/loginbackground.png"是不对的
      ),
    );
  }

  buildFunction3() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          color: Colors.white.withOpacity(0.4),
        ),
      ),
    );
  }

  buildFunction4() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Positioned.fill(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            child: TextField(
              //controler的另一种写法
              // controller: TextEditingController.fromValue(TextEditingValue(
              // text:currentKeepPwdName)),
              controller: _textAccountEditingController,
              decoration: const InputDecoration(
                hintText: "请输入用户名",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(33)),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 300,
            child: TextField(
              controller: _textPasswordEditingController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "请输入密码",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(33)),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundCheckBox(
                  size: 20,
                  checkedWidget: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 10,
                  ),
                  checkedColor: Color(0xFF3C78FF),
                  uncheckedColor: Color(0x003C78FF),
                  border: Border.all(color: getCheckBoxBorderColor(), width: 1),
                  isChecked: KeepPwdChecked,
                  onTap: (selected) {
                    KeepPwdChecked = selected!;
                    setState(() {});
                  }),
              Text("记住密码"),
            ],
          ),
          SizedBox(
            width: 300,
            height: 48,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(33)),
              child: ElevatedButton(
                onPressed: () {
                  String name;
                  String password;

                  if (_textAccountEditingController.text.length < 1) {
                    FlutterToastUtil flutterToastUtil = new FlutterToastUtil();
                    flutterToastUtil.showErrorToast("账号为空！");
                  }
                  if (_textPasswordEditingController.text.length < 1) {
                    FlutterToastUtil flutterToastUtil = new FlutterToastUtil();
                    flutterToastUtil.showErrorToast("密码为空！");
                  }
                  if (_textAccountEditingController.text.length > 1 &&
                      _textPasswordEditingController.text.length > 1) {
                    name = _textAccountEditingController.text;
                    password = _textPasswordEditingController.text;

                    check(name, password);
                  }
                },
                child: const Text("登录"),
              ),
            ),
          )
        ],
      ),
    );
  }

  initFromSP() async {

    isfirstLogin = (await SharedPreferencesUtils.keyContained("current_keep_pwd"))==true?false:true;

    if(!isfirstLogin){
      currentKeepPwdName = await SharedPreferencesUtils.getSPData("current_keep_pwd");
    }
    PwdFromSP =
        await SharedPreferencesUtils.getSPData("pwd_$currentKeepPwdName");

    if(!isfirstLogin&&currentKeepPwdName!=""){
      _textAccountEditingController.value = TextEditingValue(
          text: currentKeepPwdName);
          // selection: TextSelection.fromPosition(TextPosition(
          //     affinity: TextAffinity.downstream,
          //     offset: currentKeepPwdName.length)));

      _textPasswordEditingController.value = TextEditingValue(
          text: PwdFromSP);
          // selection: TextSelection.fromPosition(TextPosition(
          //     affinity: TextAffinity.downstream, offset: PwdFromSP.length)));
    }
    }


  //进行登陆验证
  check(String name, String password) async {
    String spUsrName =
    await SharedPreferencesUtils.getSPData("usr_$name"); //延迟执行后赋值
    String spPassword =
    await SharedPreferencesUtils.getSPData("pwd_$name"); //延迟执行后赋值


    if ((spUsrName == name && spPassword == password)) {
      FlutterToastUtil flutterToastUtil = new FlutterToastUtil();
      flutterToastUtil.showCorrectToast("登陆成功！");

      // NavigatorUtils.pushPage(context: context, targPage: IndexPage());
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return IndexPage(name);
      }));

      //记住密码处理逻辑
      SharedPreferencesUtils.setSPData(
          "keep_pwd_$name", KeepPwdChecked == true ? true : false);
      SharedPreferencesUtils.setSPData(
          "current_keep_pwd", KeepPwdChecked == true ? name : "");
    } else if (isfirstLogin) {
      FlutterToastUtil flutterToastUtil = new FlutterToastUtil();
      flutterToastUtil.showErrorToast("账号不存在，已为您自动注册！请保管好该账号和密码！");
      //第一次登录的账号 自动添加到记录中
      SharedPreferencesUtils.setSPData("usr_$name", name);
      SharedPreferencesUtils.setSPData("pwd_$name", password);
      SharedPreferencesUtils.setSPData(
          "keep_pwd_$name", KeepPwdChecked == true ? true : false);
      SharedPreferencesUtils.setSPData(
          "current_keep_pwd", KeepPwdChecked == true ? name : "");
    } else {
      FlutterToastUtil flutterToastUtil = new FlutterToastUtil();
      flutterToastUtil.showErrorToast("登陆失败！密码错误");
    }
  }

  //根据用户是否选中记住密码设置CheckBox不同颜色
  getCheckBoxBorderColor() {
    if (KeepPwdChecked) {
      return const Color(0xFF3C78FF);
    } else {
      return const Color(0xFFD1D1D1);
    }
  }

}
