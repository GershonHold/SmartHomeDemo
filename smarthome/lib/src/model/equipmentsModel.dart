class EquimentsModel {
  late final String usrName;
  late final List<Equipment> equipments;

  EquimentsModel({required this.usrName, required this.equipments});

  factory EquimentsModel.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['equipments'] as List;
    print(list.runtimeType);
    List<Equipment> imagesList =
        list.map((i) => Equipment.fromJson(i)).toList();

    return EquimentsModel(
        usrName: parsedJson['usrName'], equipments: imagesList);
  }
}

class Equipment {
  final String equipmentName;
  final String equipmentType;
  final int equipmentStatus;

  Equipment(
      {required this.equipmentName,
      required this.equipmentType,
      required this.equipmentStatus});

  factory Equipment.fromJson(Map<String, dynamic> parsedJson) {
    return Equipment(
        equipmentName: parsedJson['equipmentName'],
        equipmentType: parsedJson['equipmentType'],
        equipmentStatus: parsedJson['equipmentStatus']);
  }

  Map<String, dynamic> toJson() => {
        "equipmentName": equipmentName,
        "equipmentType": equipmentType,
        "equipmentStatus": equipmentStatus,
      };
//   var bean = map["user"];
//   if (bean != null) {
//     userBean = UserBean.fromMap(bean);
//   }

}
