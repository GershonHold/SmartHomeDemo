class JsonModelDemo {
  late String key;
  late String value;

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map toJson() {
    Map map = new Map();
    map["key"] = this.key;
    map["value"] = this.value;
    return map;
  }

  @override
  String toString() {
    return 'JsonModelDemo{key: $key, value: $value}';
  }
}
