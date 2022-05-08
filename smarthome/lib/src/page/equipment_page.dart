import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../util/SqfliteManager.dart';
import '../model/equipmentsModel.dart';

///设备管理页
class EquipmentPage extends StatefulWidget {
  //从IndexPage传参过来
  String usrName;
  EquipmentPage(this.usrName);

  @override
  _EquipmentPageState createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  late List<Equipment> equipMentsList = [];

  bool isNoEquiment = true;
  String jsonStringFromSqlite = '';
  //TextEditingController
  var cupertinoEquipmentNameControler = new TextEditingController();
  var cupertinoEquipmentTypeControler = new TextEditingController();
  //对话框的TextEditingController
  var cupertinoEditEquipmentNameControler = new TextEditingController();
  var cupertinoEditEquipmentTypeControler = new TextEditingController();
  var cupertinoEditEquipmentStatusControler = new TextEditingController();

  final StreamController _streamController = StreamController();
  String showEquipmentPattenSelectedValue = "显示所有设备";

  @override
  Widget build(BuildContext context) {

    initSqliteEquiment(widget.usrName);
    showEquiments(jsonStringFromSqlite);

    return Scaffold(
      appBar: AppBar(
        leading: Text(''),
        title: Text("我的设备"),
        centerTitle: true,
        actions: [buildSwitchButton(this.context)],
      ),
      body: Center(
        child: StreamBuilder(
          stream: _streamController.stream,
          initialData: getbody(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return getbody();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addEquipmentDialog,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  getbody() {
    return ListView.builder(
      itemCount: equipMentsList.length,
      itemBuilder: (BuildContext context, int position) {
        return getItem(
            equipMentsList[position], position, equipMentsList.length);
      },
    );
  }

  Widget getItem(Equipment equipment, int position, int itemCount) {
    bool equipmentIsOn = equipment.equipmentStatus == 1;

    List<Color> _color = [];
    for (; itemCount > 0; itemCount--) {
      _color.add(Colors.white38);
    }
    return ElevatedButton(
        style: (ButtonStyle(
          shape: MaterialStateProperty.all(BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(0))), //圆角弧度
        )),
        // margin: EdgeInsets.all(1.0),
        child: Row(children: <Widget>[
          Expanded(
              child: Container(
                  margin: EdgeInsets.only(left: 8.0),
                  height: 100.0,
                  // color: _color[position],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        equipment.equipmentName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                        maxLines: 1,
                      ),
                      Text(
                        '设备类型：' + equipment.equipmentType,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: <Widget>[
                            Text('状态:'),
                            Row(children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: equipmentIsOn
                                        ? Colors.green
                                        : Colors.red,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(equipmentIsOn ? "开启" : "关闭"),
                            ]),
                          ],
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Colors.black38))),
                      )
                    ],
                  ))),
        ]),
        //item 点击事件
        onPressed: () {
          initEditEquipmentDialog(equipment.equipmentName,
              equipment.equipmentType, equipment.equipmentStatus);
          editEquipmentDialog(equipment.equipmentName, position);
          setState(() {
            if (_color[position] == Colors.white38) {
              _color[position] = Colors.white;
            } else {
              _color[position] = Colors.white38;
            }
          });
        },
        //item 长按事件
        onLongPress: () {
          initEditEquipmentDialog(equipment.equipmentName,
              equipment.equipmentType, equipment.equipmentStatus);
          editEquipmentDialog(equipment.equipmentName, position);
          setState(() {
            if (_color[position] == Colors.white38) {
              _color[position] = Colors.white;
            } else {
              _color[position] = Colors.white38;
            }
          });
        });
  }

  Future<EquimentsModel?> showEquiments(String jsonStringFromSqlite) async {

    //
    query_data(widget.usrName);

    final jsonResponse = await json.decode(jsonStringFromSqlite);
    EquimentsModel equimentsModel = await EquimentsModel.fromJson(jsonResponse);
    equipMentsList = await equimentsModel.equipments;

    if(showEquipmentPattenSelectedValue=="显示已开启设备"){
      for(int index = 0;index<equipMentsList.length;index++){
        if(equipMentsList[index].equipmentStatus==0){
          equipMentsList.removeAt(index);
        }
      }
    }


    return equimentsModel;
  }

  //初始化Sqlite数据库的方法
  Future initSqliteEquiment(String usrName) async {
    SqfliteManager sqfliteManager = await SqfliteManager.getInstance();
    List<Map<String, dynamic>> value = await sqfliteManager
        .queryData(widget.usrName) as List<Map<String, dynamic>>;
    isNoEquiment = value.length < 1 ? true : false;

    if (isNoEquiment) {
      var value = {
        'id': 1,
        "usr_name": usrName,
        "json_string": '{\"usrName\":\"' + usrName + '\",\"equipments\":[]}'
      };
      sqfliteManager.insertData(value);
    }
  }

  //更新设备信息的方法  更新设备信息后写入数据库
  Future update_equipment(String usrName, String jsonString) async {
    SqfliteManager sqfliteManager = await SqfliteManager.getInstance();

    var value = {'json_string': jsonString};

    await sqfliteManager.updateData(value, usrName);
  }

  //添加设备信息的方法  添加设备信息后写入数据库
  Future add_equipment(String usrName, String jsonString, String equipmentName,
      String equipmentType, int equipmentStatus) async {
    SqfliteManager sqfliteManager = await SqfliteManager.getInstance();

    if (jsonString.substring(0, jsonString.length - 2).endsWith("[")) {
      jsonString = jsonString.replaceRange(
          jsonString.length - 2,
          jsonString.length,
          '{\"equipmentName\":\"' +
              equipmentName +
              '\",\"equipmentType\":\"' +
              equipmentType +
              '\",\"equipmentStatus\":' +
              equipmentStatus.toString() +
              '}]}');
      var value = {'json_string': jsonString};
      await sqfliteManager.updateData(value, usrName);
    } else {
      jsonString = jsonString.replaceRange(
          jsonString.length - 2,
          jsonString.length,
          ',{\"equipmentName\":\"' +
              equipmentName +
              '\",\"equipmentType\":\"' +
              equipmentType +
              '\",\"equipmentStatus\":' +
              equipmentStatus.toString() +
              '}]}');
      var value = {'json_string': jsonString};
      await sqfliteManager.updateData(value, usrName);
    }
  }

  //根据用户名查找数据库中是否有该用户的记录
  // 如果有，说明该用户已经初始化或者添加有设备了，置isNoEquiment为false
  Future query_data(String usrName) async {
    SqfliteManager sqfliteManager = await SqfliteManager.getInstance();
    List<Map<String, dynamic>> value = List.from(
        await sqfliteManager.queryData(usrName) as List<Map<String, dynamic>>);
    isNoEquiment = value.length < 1 ? true : false;
    String dataListStringFromSqlite = value.toString();

    if (!isNoEquiment) {
      jsonStringFromSqlite = dataListStringFromSqlite.substring(
          dataListStringFromSqlite.lastIndexOf("json_string:") + 12,
          dataListStringFromSqlite.length - 2);
    }
  }

  //添加设备的代码逻辑
  Future<dynamic> addEquipmentDialog() async {
    showCupertinoDialog(
        context: this.context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('添加设备'),
            content: Card(
              elevation: 0.0,
              child: Column(
                children: <Widget>[
                  Text('设备名称'),
                  CupertinoTextField(
                      controller: cupertinoEquipmentNameControler,
                      placeholder: '请输入设备名称', // 输入提示
                      decoration: BoxDecoration(
                        // 文本框装饰
                        color: Colors.white38,
                        // 文本框颜色
                        // border: Border.all(color: Colors.blueAccent, width: 1), // 输入框边框
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        // 输入框圆角设置
                        boxShadow: [BoxShadow(offset: Offset(0, 0))], //装饰阴影
                      )),
                  Text('设备类型'),
                  CupertinoTextField(
                      controller: cupertinoEquipmentTypeControler,
                      placeholder: '请输入设备类型', // 输入提示
                      decoration: BoxDecoration(
                        // 文本框装饰
                        color: Colors.white38,
                        // 文本框颜色
                        // border: Border.all(color: Colors.blueAccent, width: 1), // 输入框边框
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        // 输入框圆角设置
                        boxShadow: [BoxShadow(offset: Offset(0, 0))], //装饰阴影
                      )),
                  Text('设备状态'),
                  CupertinoTextField(
                      enabled: false,
                      placeholder: '0', // 输入提示
                      decoration: BoxDecoration(
                        // 文本框装饰
                        color: Colors.white38,
                        // 文本框颜色
                        // border: Border.all(color: Colors.blueAccent, width: 1), // 输入框边框
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        // 输入框圆角设置
                        boxShadow: [BoxShadow(offset: Offset(0, 0))], //装饰阴影
                      )),
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {});
                },
                child: Text('取消'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                  add_equipment(
                      widget.usrName,
                      jsonStringFromSqlite,
                      cupertinoEquipmentNameControler.text,
                      cupertinoEquipmentTypeControler.text,
                      0);
                  setState(() {});
                  // initSqliteEquiment();
                  // query_data(widget.usrName);
                  // showEquiments(widget.usrName);
                },
                child: Text('确定'),
              ),
            ],
          );
        });
  }

  //编辑设备详细信息的对话框
  Future<dynamic> editEquipmentDialog(
      String equipmentName, int position) async {
    await showCupertinoDialog(
        context: this.context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('管理' + equipmentName),
            content: Card(
              elevation: 0.0,
              child: Column(
                children: <Widget>[
                  Text('设备名称'),
                  CupertinoTextField(
                      controller: cupertinoEditEquipmentNameControler,
                      placeholder: '请输入设备名称', // 输入提示
                      decoration: BoxDecoration(
                        // 文本框装饰
                        color: Colors.white38,
                        // 文本框颜色
                        // border: Border.all(color: Colors.blueAccent, width: 1), // 输入框边框
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        // 输入框圆角设置
                        boxShadow: [BoxShadow(offset: Offset(0, 0))], //装饰阴影
                      )),
                  Text('设备类型'),
                  CupertinoTextField(
                      controller: cupertinoEditEquipmentTypeControler,
                      placeholder: '请输入设备类型', // 输入提示
                      decoration: BoxDecoration(
                        // 文本框装饰
                        color: Colors.white38,
                        // 文本框颜色
                        // border: Border.all(color: Colors.blueAccent, width: 1), // 输入框边框
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        // 输入框圆角设置
                        boxShadow: [BoxShadow(offset: Offset(0, 0))], //装饰阴影
                      )),
                  Text('设备状态'),
                  CupertinoTextField(
                      controller: cupertinoEditEquipmentStatusControler,
                      decoration: BoxDecoration(
                        // 文本框装饰
                        color: Colors.white38,
                        // 文本框颜色
                        // border: Border.all(color: Colors.blueAccent, width: 1), // 输入框边框
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        // 输入框圆角设置
                        boxShadow: [BoxShadow(offset: Offset(0, 0))], //装饰阴影
                      )),
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {});
                },
                child: Text('取消'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Equipment newEquipment = new Equipment(
                      equipmentName: cupertinoEditEquipmentNameControler.text,
                      equipmentType: cupertinoEditEquipmentTypeControler.text,
                      equipmentStatus: int.parse(
                          cupertinoEditEquipmentStatusControler.text
                              .toString()));

                  equipMentsList[position] = newEquipment;
                  String jsonString = json.encode(equipMentsList);

                  jsonString = '{\"usrName\":\"' +
                      widget.usrName +
                      '\",\"equipments\":' +
                      jsonString +
                      '}';
                  update_equipment(widget.usrName, jsonString);
                  Navigator.pop(context);
                },
                child: Text('确定'),
              ),
            ],
          );
        });
  }

  //初始化 加载所选设备的信息并显示
  initEditEquipmentDialog(
      String equipmentName, String equipmentType, int equipmentStatus) {

    cupertinoEditEquipmentNameControler.value = TextEditingValue(
        text: equipmentName,
        selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream, offset: equipmentName.length)));

    cupertinoEditEquipmentTypeControler.value = TextEditingValue(
        text: equipmentType,
        selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream, offset: equipmentType.length)));

    cupertinoEditEquipmentStatusControler.value = TextEditingValue(
        text: equipmentStatus.toString(),
        selection: TextSelection.fromPosition(
            TextPosition(affinity: TextAffinity.downstream, offset: 1)));
  }
  Widget buildSwitchButton(BuildContext context) {
    return DropdownButton<String>(
      style: TextStyle(
        fontSize: 10.0,
        color: Colors.black38
      ),
      hint: Text("显示所有设备"),
      iconSize: 20,
      items: <String>['显示所有设备', '显示已开启设备'].map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      value: showEquipmentPattenSelectedValue, // 按钮默认显示弹框列表的哪个 item，和 DropdownMenuItem 的 value 相对应
      onChanged: (selected) {setState(() {
        showEquipmentPattenSelectedValue = selected!;
        });},
    );
  }


}
