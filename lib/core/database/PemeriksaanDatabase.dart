import 'package:posyandu_mob/core/database/DatabaseProvider.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/LabTrimester1.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/LabTrimester3.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Nifas.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Pemeriksaan.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanAwal.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanFisik.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanKehamilan.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanKhusus.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanRutin.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/RencanaKonsultasi.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/SkriningKesehatan.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Trimester3.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Trimestr1.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/UsgTrimester1.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/UsgTrimester3.dart';
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

    for (var item in hasil.nifas) {
      await _insertNifas(item);
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

    await db.insert(
      'trimester_1',
      {
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
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

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

  Future<int> _insertNifas(Nifas nifas) async {
    final db = await instance.database;
    return await db.insert(
      'pemeriksaan_nifas',
      nifas.toJson(),
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

    int trimesterId = await db.insert(
      'trimester_3',
      {
        'id': trimester3.id,
        'pemeriksaan_id': trimester3.pemeriksaanId,
        'pemeriksaan_rutin': rutinId,
        'skrining_kesehatan': skriningId,
        'pemeriksaan_fisik': fisikId,
        'lab_trimester_3': labId,
        'usg_trimester_3': usgId,
        'rencana_konsultasi': rencanaId,
        'created_at': trimester3.created_at,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return trimesterId;
  }

  Future<List<Pemeriksaan>> getPemeriksaan() async {
    final db = await instance.database;

    final pemeriksaanRows = await db.query('pemeriksaan_kehamilan');
    List<Pemeriksaan> list = [];

    for (var row in pemeriksaanRows) {
      final id = row['id'] as int;
      final trimester1 = await getTrimester1(id);
      final trimester2 = await getTrimester2(id);
      final trimester3 = await getTrimester3(id);
      final nifas = await getNifas(id);

      list.add(Pemeriksaan(
        pemeriksaan: [PemeriksaanKehamilan.fromJson(row)],
        trimester1: trimester1,
        trimester2: trimester2,
        trimester3: trimester3,
        nifas: nifas,
      ));
    }

    return list;
  }

  Future<List<Trimestr1>> getTrimester1(int pemeriksaanId) async {
    final db = await instance.database;

    final rows = await db.query('trimester_1',
        where: 'pemeriksaan_id = ?', whereArgs: [pemeriksaanId]);

    List<Trimestr1> list = [];

    for (var row in rows) {
      final rutin = await db.query('pemeriksaan_rutin',
          where: 'id = ?', whereArgs: [row['pemeriksaan_rutin']]);
      final skrining = await db.query('skrining_kesehatan',
          where: 'id = ?', whereArgs: [row['skrining_kesehatan']]);
      final fisik = await db.query('pemeriksaan_fisik',
          where: 'id = ?', whereArgs: [row['pemeriksaan_fisik']]);
      final awal = await db.query('pemeriksaan_awal',
          where: 'id = ?', whereArgs: [row['pemeriksaan_awal']]);
      final khusus = await db.query('pemeriksaan_khusus',
          where: 'id = ?', whereArgs: [row['pemeriksaan_khusus']]);
      final lab = await db.query('lab_trimester_1',
          where: 'id = ?', whereArgs: [row['lab_trimester_1']]);
      final usg = await db.query('usg_trimester_1',
          where: 'id = ?', whereArgs: [row['usg_trimester_1']]);

      list.add(Trimestr1(
        id: row['id'] as int,
        pemeriksaanId: row['pemeriksaan_id'] as int,
        created_at: row['created_at'] as String,
        pemeriksaanRutin: PemeriksaanRutin.fromJson(rutin.first),
        skriningKesehatan: SkriningKesehatan.fromJson(skrining.first),
        pemeriksaanFisik: PemeriksaanFisik.fromJson(fisik.first),
        pemeriksaanAwal: PemeriksaanAwal.fromJson(awal.first),
        pemeriksaanKhusus: PemeriksaanKhusus.fromJson(khusus.first),
        labTrimester1: LabTrimester1.fromJson(lab.first),
        usgTrimester1: UsgTrimester1.fromJson(usg.first),
      ));
    }

    return list;
  }

  Future<List<PemeriksaanRutin>> getTrimester2(int pemeriksaanId) async {
    final db = await instance.database;

    final rows = await db.query('pemeriksaan_rutin',
        where: 'pemeriksaan_id = ?',
        whereArgs: [pemeriksaanId],
        orderBy: 'created_at DESC');

    return rows.map((e) => PemeriksaanRutin.fromJson(e)).toList();
  }

  Future<List<Nifas>> getNifas(int pemeriksaanId) async {
    final db = await instance.database;

    final rows = await db.query('pemeriksaan_nifas',
        where: 'pemeriksaan_id = ?',
        whereArgs: [pemeriksaanId],
        orderBy: 'created_at DESC');

    return rows.map((e) => Nifas.fromJson(e)).toList();
  }

  Future<List<Trimester3>> getTrimester3(int pemeriksaanId) async {
    final db = await instance.database;

    final rows = await db.query('trimester_3',
        where: 'pemeriksaan_id = ?', whereArgs: [pemeriksaanId]);

    List<Trimester3> list = [];

    for (var row in rows) {
      final rutin = await db.query('pemeriksaan_rutin',
          where: 'id = ?', whereArgs: [row['pemeriksaan_rutin']]);
      final skrining = await db.query('skrining_kesehatan',
          where: 'id = ?', whereArgs: [row['skrining_kesehatan']]);
      final fisik = await db.query('pemeriksaan_fisik',
          where: 'id = ?', whereArgs: [row['pemeriksaan_fisik']]);
      final lab = await db.query('lab_trimester_3',
          where: 'id = ?', whereArgs: [row['lab_trimester_3']]);
      final usg = await db.query('usg_trimester_3',
          where: 'id = ?', whereArgs: [row['usg_trimester_3']]);
      final rencana = await db.query('rencana_konsultasi',
          where: 'id = ?', whereArgs: [row['rencana_konsultasi']]);

      list.add(Trimester3(
        id: row['id'] as int,
        pemeriksaanId: row['pemeriksaan_id'] as int,
        created_at: row['created_at'] as String,
        pemeriksaanRutin: PemeriksaanRutin.fromJson(rutin.first),
        skriningKesehatan: SkriningKesehatan.fromJson(skrining.first),
        pemeriksaanFisik: PemeriksaanFisik.fromJson(fisik.first),
        labTrimester3: LabTrimester3.fromJson(lab.first),
        usgTrimester3: UsgTrimester3.fromJson(usg.first),
        rencanaKonsultasi: RencanaKonsultasi.fromJson(rencana.first),
      ));
    }

    return list;
  }

  Future<List<Map<String, dynamic>>> getAllDetailPemeriksaan(
      int kehamilanId) async {
    final db = await instance.database;

    final result = await db.query(
      'pemeriksaan_kehamilan',
      where: 'kehamilan_id = ?',
      whereArgs: [kehamilanId],
    );

    final pemeriksaanList = result.map((data) {
      final pemeriksaanId = int.parse(data['id'].toString());
      final trimesterId = data['jenis_pemeriksaan'].toString();

      return {
        'id': pemeriksaanId,
        'trimester': trimesterId,
      };
    }).toList();

    return pemeriksaanList;
  }

  Future<List<PemeriksaanRutin>> getTrimester2ByIds(List<int> ids) async {
    final db = await instance.database;
    if (ids.isEmpty) return [];
    final idsString = ids.join(', ');
    final result = await db.rawQuery(
        'SELECT * FROM pemeriksaan_rutin WHERE pemeriksaan_id IN ($idsString)');
    return result.map((e) => PemeriksaanRutin.fromJson(e)).toList();
  }

  Future<List<Nifas>> getNifasByIds(List<int> ids) async {
    final db = await instance.database;
    if (ids.isEmpty) return [];
    final idsString = ids.join(', ');
    final result = await db.rawQuery(
        'SELECT * FROM pemeriksaan_nifas WHERE pemeriksaan_id IN ($idsString)');
    return result.map((e) => Nifas.fromJson(e)).toList();
  }

  Future<List<Trimester3>> getTrimester3ByIds(List<int> pemeriksaanIds) async {
    final db = await instance.database;
    if (pemeriksaanIds.isEmpty) return [];

    final idsString = pemeriksaanIds.join(', ');
    final rows = await db.rawQuery(
        'SELECT * FROM trimester_3 WHERE pemeriksaan_id IN ($idsString)');

    List<Trimester3> list = [];

    for (var row in rows) {
      final rutin = await db.query('pemeriksaan_rutin',
          where: 'id = ?', whereArgs: [row['pemeriksaan_rutin']]);
      final skrining = await db.query('skrining_kesehatan',
          where: 'id = ?', whereArgs: [row['skrining_kesehatan']]);
      final fisik = await db.query('pemeriksaan_fisik',
          where: 'id = ?', whereArgs: [row['pemeriksaan_fisik']]);
      final lab = await db.query('lab_trimester_3',
          where: 'id = ?', whereArgs: [row['lab_trimester_3']]);
      final usg = await db.query('usg_trimester_3',
          where: 'id = ?', whereArgs: [row['usg_trimester_3']]);
      final rencana = await db.query('rencana_konsultasi',
          where: 'id = ?', whereArgs: [row['rencana_konsultasi']]);

      list.add(Trimester3(
        id: row['id'] as int,
        pemeriksaanId: row['pemeriksaan_id'] as int,
        created_at: row['created_at'] as String,
        pemeriksaanRutin: PemeriksaanRutin.fromJson(rutin.first),
        skriningKesehatan: SkriningKesehatan.fromJson(skrining.first),
        pemeriksaanFisik: PemeriksaanFisik.fromJson(fisik.first),
        labTrimester3: LabTrimester3.fromJson(lab.first),
        usgTrimester3: UsgTrimester3.fromJson(usg.first),
        rencanaKonsultasi: RencanaKonsultasi.fromJson(rencana.first),
      ));
    }

    return list;
  }

  Future<UsgTrimester1?> getPemeriksaanUsg1() async {
    final db = await instance.database;

    final result = await db.rawQuery('''
    SELECT * FROM usg_trimester_1 
    ORDER BY id DESC 
    LIMIT 1
    ''');

    if (result.isNotEmpty) {
      return UsgTrimester1.fromJson(result.first);
    } else {
      return null;
    }
  }

  Future<PemeriksaanRutin?> getPemeriksaanRutin() async {
    final db = await instance.database;

    final result = await db.rawQuery('''
    SELECT * FROM pemeriksaan_rutin 
    ORDER BY id DESC 
    LIMIT 1
    ''');

    if (result.isNotEmpty) {
      return PemeriksaanRutin.fromJson(result.first);
    } else {
      return null;
    }
  }
}
