import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:posyandu_mob/core/models/Anggota.dart';
import 'package:posyandu_mob/core/models/User.dart';
import 'package:sqflite/sqflite.dart';

class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();
  static Database? _database;

  UserDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db
              .execute("ALTER TABLE user ADD COLUMN role TEXT DEFAULT 'user'");
        }
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
  CREATE TABLE user (
    id INTEGER PRIMARY KEY,
    nik TEXT NOT NULL,
    nama TEXT NOT NULL,
    tanggal_lahir TEXT NOT NULL,
    tempat_lahir TEXT NOT NULL,
    pekerjaan TEXT NOT NULL,
    alamat TEXT NOT NULL,
    no_telepon TEXT,
    golongan_darah TEXT,
    role TEXT DEFAULT 'Anggota',
    token Text
  )
''');
  }

  Future<Anggota> create(Anggota user, String role) async {
    final db = await instance.database;
    final id = await db.insert(
      'user',
      {
        ...user.toJson(),
        'role': role,
      },
    );

    return user..id = id;
  }

  Future<UserWithRole?> readUser() async {
    final db = await instance.database;
    final result = await db.query('user', limit: 1);
    if (result.isNotEmpty) {
      Anggota anggota = Anggota.fromJson(result.first);
      String role = result.first['role'].toString() ?? '';
      String token = result.first['token'].toString() ?? '';

      return UserWithRole(anggota: anggota, role: role, token: token);
    } else {
      return null;
    }
  }

  Future<int> update(Anggota anggota) async {
    final db = await instance.database;
    return db.update(
      'user',
      anggota.toJson(),
      where: 'id = ?',
      whereArgs: [anggota.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'user',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> logout() async {
    final db = await UserDatabase.instance.database;
    await db.delete('user');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
