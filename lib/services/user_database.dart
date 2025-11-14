import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:projet_dclic/models/user.dart';

class UserDatabase {
  //declaration des propriétes statiques
  static Database? _database;
  static const String _databaseName = "user.db";
  static const int _databaseVersion = 1;

  static const String tableUsers = 'users';
  static const String columnId = 'id';
  static const String columnUsername = 'username';
  static const String columnEmail = 'email';
  static const String columnPassword = 'password';

  //Eviter de repeter la base de donnees et consever la connexion
  UserDatabase._privateConstructor();
  static final UserDatabase instance = UserDatabase._privateConstructor();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  //initilisation de la base de donnes
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  //creation de la base de donnees
  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $tableUsers(
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnUsername TEXT NOT NULL, 
        $columnEmail TEXT NOT NULL,
        $columnPassword TEXT NOT NULL 
        )
    ''');
  }

  //insertion d'un user dans la table user
  Future<int> insertUser(User user) async {
    Database db = await instance.database;
    return await db.insert(tableUsers, user.toMap());
  }

  //recuperation d'un utilisateur
  Future<User?> getUserByEmail(String email) async {
    final db = await instance.database;
    final res = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (res.isNotEmpty) {
      // Debug : affiche le contenu exact de la ligne retournée
      // ignore: avoid_print
      print('DEBUG getUserByEmail result: ${res.first}');
      return User.fromMap(res.first);
    }
    return null;
  }

  //fermer la base de donnees
  Future close() async {
    Database db = await instance.database;
    db.close();
  }
}
