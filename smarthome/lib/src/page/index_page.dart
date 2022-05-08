import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/SqfliteManager.dart';
import 'equipment_page.dart';
import 'mine_main_page.dart';

///用户登录后的主页，是加载设备主页EquipmentPage和个人中心主页MineMainPage的中间Page
class IndexPage extends StatefulWidget {
  final String usrName;

  IndexPage(this.usrName);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<IndexPage> {
  //当前选中的标识
  int _currentIndex = 0;

  PageController _pageController = new PageController();
  String jsonStringFromSqlite = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: PageView(
          controller: _pageController,
          //设置不可左右滑动
          physics: NeverScrollableScrollPhysics(),
          children: [
            //
            EquipmentPage(widget.usrName),
            //个人中心页面
            MineMainPage(widget.usrName),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        //当前选中的Item 默认为 0
        currentIndex: _currentIndex,
        //点击回调
        onTap: (int value) {
          setState(() {
            _currentIndex = value;
            _pageController.jumpToPage(value);
          });
        },
        //显示文字
        type: BottomNavigationBarType.fixed,
        //选中的颜色
        selectedItemColor: Colors.redAccent,
        //未选中颜色
        unselectedItemColor: Colors.blueGrey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "我的设备"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "个人中心"),
        ],
      ),
    );
  }
}
