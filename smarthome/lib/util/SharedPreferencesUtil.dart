import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils{
  ///静态实例
  static late SharedPreferences sp;

  /// 向Sharedpreference保存数据 保存不同类型的数据都调用此方法
  static Future setSPData(key,dynamic value) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (value is String) {
      sp.setString(key, value);
    } else if (value is bool) {
      sp.setBool(key, value);
    } else if (value is double) {
      sp.setDouble(key, value);
    } else if (value is int) {
      sp.setInt(key, value);
    } else if (value is List<String>) {
      sp.setStringList(key, value);
    }
  }

  /// 从Sharedpreference获取数据
  static Future getUserData(key) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.get(key);
  }

  ///由于async的延迟特性，因此要获取到SharedPreferences读出的字符串，需要延迟读出
  static getSPData(String key) async {
    dynamic value = await SharedPreferencesUtils.getUserData(key);      //延迟执行后赋值给data
    dynamic data="";
    if (value is String) {
      data = (await SharedPreferencesUtils.getUserData(key)) as String;      //延迟执行后赋值给data
    }else if (value is int) {
      data = (await SharedPreferencesUtils.getUserData(key)) as int;      //延迟执行后赋值给data
    }
    return data;
  }

  ///获取自定义对象
  ///返回的是 Map<String,dynamic> 类型数据
  static dynamic? getObject(String key) {

    String? _data = sp.getString(key);
    if (_data == null) {
      return null;
    }
    return (_data.isEmpty) ? null : json.decode(_data);
  }

  ///保存自定义对象
  static Future saveObject(String key, dynamic value) async {
    ///通过 json 将Object对象编译成String类型保存
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, json.encode(value));
  }
  ///从Sharedpreference中移除数据
  ///本应用没有添加注销用户的功能，因此该方法未调用
  static void removedata(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.containsKey(key)) {
      sp.remove(key);
    }
  }

  static keyContained(key) async{
    SharedPreferences sp = await SharedPreferences.getInstance();

    dynamic data="";
    data = await sp.containsKey(key) as bool;      //延迟执行后赋值给data
    return data;
  }
}
