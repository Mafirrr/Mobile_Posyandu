import 'package:posyandu_mob/core/database/DatabaseProvider.dart';
import 'package:posyandu_mob/core/models/Anggota.dart';
import 'package:posyandu_mob/core/models/Kehamilan.dart';
import 'package:posyandu_mob/core/models/User.dart';
import 'package:sqflite/sqflite.dart';

class UserDatabase {
  final instance = DatabaseProvider.instance;

  //insert kehamilan
  Future<int> insertKehamilan(Kehamilan kehamilan) async {
    final db = await instance.database;
    return await db.insert(
      'kehamilan',
      kehamilan.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Kehamilan>> getAllKehamilan() async {
    final db = await instance.database;
    final maps = await db.query('kehamilan', orderBy: 'tanggal_awal ASC');

    return maps.map((map) => Kehamilan.fromJson(map)).toList();
  }

  //user
  Future<Anggota> create(Anggota user, String role, String token) async {
    final db = await instance.database;
    final id = await db.insert(
      'user',
      {
        ...user.toJson(),
        'role': role,
        'token': token,
      },
    );

    return user..id = id;
  }

  Future<UserWithRole?> readUser() async {
    final db = await instance.database;
    final result = await db.query('user', limit: 1);
    if (result.isNotEmpty) {
      Anggota anggota = Anggota.fromJson(result.first);
      String role = result.first['role'].toString();
      String token = result.first['token'].toString();

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
    final db = await instance.database;
    await db.delete('user');
    await db.delete('kehamilan');
  }
}
