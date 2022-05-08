import 'dart:convert';

import '../src/damo/JsonModelDemo.dart';

class JsonUtil{

  ///  将实体类对象解析成json字符串
  static String objectsToJsonString(Map<String,String> objectsMap){

    String jsonString = generatePlatformJson(key: "result1", value: "result1Value");
    return jsonString;
  }
  ///  将json字符串解析成实体类对象
  static String generatePlatformJson({required String key, required String value}) {
    JsonModelDemo jsonModelDemo = JsonModelDemo();
    jsonModelDemo.key = key;
    jsonModelDemo.value = value;
    String jsonStr = jsonEncode(jsonModelDemo);

    return jsonStr;
  }
}