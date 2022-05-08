import 'package:sqflite/sqflite.dart';

/// 用来管理数据库的类
class SqfliteManager {
  static const sqlName = "smarthome.db";
  static const tableName = "equipments";
  Database? db;
  static SqfliteManager? _instance;

  /// 创建table 的 sql语句title integer primary key,
  static var CREATE_DATA_TABLE = '''
        create table equipments (
        id integer primary key,
        usr_name VARCHAR(30) not null unique,
        json_string VARCHAR not null)
        ''';

  ///获取SqfliteManager的对象实例
  static Future<SqfliteManager> getInstance() async {
    if (_instance == null) {
      _instance = await _initDataBase();
    }
    return _instance!;
  }

  /// 打开 数据库 db
  static Future<SqfliteManager> _initDataBase() async {
    SqfliteManager manager = SqfliteManager();
    String dbPath = await getDatabasesPath() + "/$sqlName";

    if (manager.db == null) {
      manager.db = await openDatabase(
        dbPath,
        version: 1,
        onCreate: (db, version) async {
          /// 如果不存在 当前的表 就创建需要的表
          if (await manager.isTableExit(db, tableName) == false) {
            await db.execute(CREATE_DATA_TABLE);
          }
        },
      );
    }
    return manager;
  }

  /// 插入数据
  Future<int> insertData(Map<String, dynamic> value) async {
    /// 因为原数据里面有id参数，先移除掉
    value.remove("id");
    return await db!.insert(tableName, value);
  }

  /// 查询所有数据
  Future<List<Map<String, dynamic>>> queryData(String usrName) async {
    // return await db!.rawQuery("SELECT COUNT(*) FROM equipments WHERE usr_name = '$usrName'");

    // return await db!.query(tableName);
    return await db!.query(tableName,
        where: 'usr_name = ?',
        whereArgs: [usrName]);

  }



  /// 删除一条数据
  Future<int> deleteData(int id) async {
    if (id == null || id == 0) {
      return 0;
    }
    return await db!.delete(tableName, where: "id = ?", whereArgs: [id]);
  }

  /// 更新数据
  Future<int> updateData(Map<String, dynamic> value, String usr_name) async {
    return await db!.update(
      tableName,
      value,
      where: "usr_name = ?",
      whereArgs: [usr_name],
    );
  }

  /// 判断是否存在 数据库表
  Future<bool> isTableExit(Database db, String tableName) async {
    var result = await db.rawQuery(
        "select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return result != null && result.length > 0;
  }

}
