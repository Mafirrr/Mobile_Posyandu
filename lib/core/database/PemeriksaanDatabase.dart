import 'package:posyandu_mob/core/database/DatabaseProvider.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Pemeriksaan.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanKehamilan.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanRutin.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Trimester3.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Trimestr1.dart';
import 'package:sqflite/sqflite.dart';

class Pemeriksaandatabase {
  final instance = DatabaseProvider.instance;

  Future<Pemeriksaan> insertPemeriksaan(Pemeriksaan hasil) async {
    for (var item in hasil.pemeriksaan) {
      await _insertPemeriksaan(item);
    }

    for (var item in hasil.trimester1) {
      await _insertTrimester1(item);
    }

    for (var item in hasil.trimester2) {
      await _insertTrimester2(item);
    }

    for (var item in hasil.trimester3) {
      await _insertTrimester3(item);
    }
    return hasil;
  }

  Future<PemeriksaanKehamilan> _insertPemeriksaan(
      PemeriksaanKehamilan pemeriksaanKehamilan) async {
    final db = await instance.database;
    await db.insert(
      'pemeriksaan_kehamilan',
      pemeriksaanKehamilan.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return pemeriksaanKehamilan;
  }

  Future<Trimestr1> _insertTrimester1(Trimestr1 trimester1) async {
    final db = await instance.database;

    int rutinId = await db.insert(
      'pemeriksaan_rutin',
      trimester1.pemeriksaanRutin.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    int skriningId = await db.insert(
      'skrining_kesehatan',
      trimester1.skriningKesehatan.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    int fisikId = await db.insert(
      'pemeriksaan_fisik',
      trimester1.pemeriksaanFisik.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    int awalId = await db.insert(
      'pemeriksaan_awal',
      trimester1.pemeriksaanAwal.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    int khususId = await db.insert(
      'pemeriksaan_khusus',
      trimester1.pemeriksaanKhusus.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    int labId = await db.insert(
      'lab_trimester_1',
      trimester1.labTrimester1.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    int usgId = await db.insert(
      'usg_trimester_1',
      trimester1.usgTrimester1.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.insert('trimester_1', {
      'id': trimester1.id,
      'pemeriksaan_id': trimester1.pemeriksaanId,
      'pemeriksaan_rutin': rutinId,
      'skrining_kesehatan': skriningId,
      'pemeriksaan_fisik': fisikId,
      'pemeriksaan_awal': awalId,
      'pemeriksaan_khusus': khususId,
      'lab_trimester_1': labId,
      'usg_trimester_1': usgId,
      'created_at': trimester1.created_at,
    });

    return trimester1;
  }

  Future<int> _insertTrimester2(PemeriksaanRutin trimester2) async {
    final db = await instance.database;
    return await db.insert(
      'pemeriksaan_rutin',
      trimester2.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> _insertTrimester3(Trimester3 trimester3) async {
    final db = await instance.database;

    int rutinId = await db.insert(
      'pemeriksaan_rutin',
      trimester3.pemeriksaanRutin.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    int skriningId = await db.insert(
      'skrining_kesehatan',
      trimester3.skriningKesehatan.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    int fisikId = await db.insert(
      'pemeriksaan_fisik',
      trimester3.pemeriksaanFisik.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    int labId = await db.insert(
      'lab_trimester_3',
      trimester3.labTrimester3.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    int usgId = await db.insert(
      'usg_trimester_3',
      trimester3.usgTrimester3.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    int rencanaId = await db.insert(
      'rencana_konsultasi',
      trimester3.rencanaKonsultasi.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    int trimesterId = await db.insert('trimester_3', {
      'id': trimester3.id,
      'pemeriksaan_id': trimester3.pemeriksaanId,
      'pemeriksaan_rutin': rutinId,
      'skrining_kesehatan': skriningId,
      'pemeriksaan_fisik': fisikId,
      'lab_trimester_3': labId,
      'usg_trimester_3': usgId,
      'rencana_konsultasi': rencanaId,
      'created_at': trimester3.created_at,
    });

    return trimesterId;
  }
}
