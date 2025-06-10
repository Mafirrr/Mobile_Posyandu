import 'package:posyandu_mob/core/database/DatabaseProvider.dart';
import 'package:posyandu_mob/core/models/Anggota.dart';
import 'package:posyandu_mob/core/models/Kehamilan.dart';
import 'package:posyandu_mob/core/models/Petugas.dart';
import 'package:posyandu_mob/core/models/User.dart';
import 'package:posyandu_mob/core/models/dataAnggota.dart';
import 'package:posyandu_mob/core/models/petugasWithRole.dart';
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
    final maps = await db.query('kehamilan', orderBy: 'id ASC');

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
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return user..id = id;
  }

  Future<Petugas> createPetugas(Petugas user, String role, String token) async {
    final db = await instance.database;
    final id = await db.insert(
      'petugas',
      {
        ...user.toJson(),
        'role': role,
        'token': token,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
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

  Future<int> upsert(DataAnggota keluarga) async {
    final db = await instance.database;
    return await db.insert(
      'keluarga',
      keluarga.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateKeluarga(DataAnggota keluarga) async {
    final db = await instance.database;
    return await db.update(
      'keluarga',
      keluarga.toJson(),
      where: 'id = ?',
      whereArgs: [keluarga.id],
    );
  }

  Future<DataAnggota?> getKeluargaById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'keluarga',
      where: 'anggota_id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return DataAnggota.fromJson(result.first);
    }
    return null;
  }

  Future<void> logout() async {
    final db = await instance.database;
    final tables = [
      'user',
      'keluarga',
      'kehamilan',
      'pemeriksaan_kehamilan',
      'skrining_kesehatan',
      'pemeriksaan_fisik',
      'pemeriksaan_rutin',
      'pemeriksaan_khusus',
      'pemeriksaan_awal',
      'lab_trimester_1',
      'usg_trimester_1',
      'trimester_1',
      'lab_trimester_3',
      'usg_trimester_3',
      'trimester_3',
      'rencana_konsultasi'
    ];

    for (final table in tables) {
      await db.delete(table);
    }
  }
}
