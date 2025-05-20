import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._init();
  static Database? _database;

  DatabaseProvider._init();

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
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY,
        nik TEXT NOT NULL,
        nama TEXT NOT NULL,
        no_jkn TEXT NOT NULL,
        faskes_tk1 TEXT NOT NULL,
        faskes_rujukan TEXT NOT NULL,
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

    await db.execute('''
      CREATE TABLE petugas (
        id INTEGER PRIMARY KEY,
        nip TEXT,
        nama TEXT,
        no_telepon TEXT,
        email TEXT,
        role TEXT DEFAULT 'Anggota',
        token Text
      )
    ''');

    await db.execute('''
      CREATE TABLE keluarga (
        id INTEGER PRIMARY KEY,
        anggota_id TEXT NOT NULL,
        nik TEXT NOT NULL,
        nama TEXT NOT NULL,
        no_jkn TEXT NOT NULL,
        faskes_tk1 TEXT,
        faskes_rujukan TEXT,
        tanggal_lahir TEXT NOT NULL,
        tempat_lahir TEXT NOT NULL,
        pekerjaan TEXT NOT NULL,
        alamat TEXT NOT NULL,
        no_telepon TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE kehamilan (
        id INTEGER PRIMARY KEY,
        anggota_id INTEGER NOT NULL,
        status TEXT NOT NULL,
        label TEXT,
        tahun TEXT,
        berat_badan_bayi TEXT,
        proses_melahirkan TEXT,
        penolong TEXT,
        masalah TEXT
      )
    ''');

    await db.execute('''
  CREATE TABLE skrining_kesehatan (
    id INTEGER PRIMARY KEY,
    skrining_jiwa TEXT,
    tindak_lanjut_jiwa TEXT,
    perlu_rujukan TEXT
  )
''');

    await db.execute('''
  CREATE TABLE pemeriksaan_fisik (
    id INTEGER PRIMARY KEY,
    konjungtiva TEXT,
    sklera TEXT,
    kulit TEXT,
    leher TEXT,
    gigi_mulut TEXT,
    tht TEXT,
    jantung TEXT,
    paru TEXT,
    perut TEXT,
    tungkai TEXT
  )
''');

    await db.execute('''
  CREATE TABLE pemeriksaan_rutin (
    id INTEGER PRIMARY KEY,
    pemeriksaan_id INTEGER UNIQUE,
    berat_badan REAL,
    tekanan_darah_sistol INTEGER,
    tekanan_darah_diastol INTEGER,
    letak_dan_denyut_nadi_bayi TEXT,
    lingkar_lengan_atas REAL,
    protein_urin Text,
    tinggi_rahim Text,
    tablet_tambah_darah Text,
    konseling Text,
    skrining_dokter Text,
    tes_lab_gula_darah Text,
    created_at Text
  )
''');

    await db.execute('''
  CREATE TABLE pemeriksaan_khusus (
    id INTEGER PRIMARY KEY,
    porsio TEXT,
    uretra TEXT,
    vagina TEXT,
    vulva TEXT,
    fluksus TEXT,
    fluor TEXT
  )
''');

    await db.execute('''
  CREATE TABLE pemeriksaan_awal (
    id INTEGER PRIMARY KEY,
    tinggi_badan REAL,
    golongan_darah TEXT,
    status_imunisasi_td TEXT,
    hemoglobin REAL,
    gula_darah_puasa REAL,
    riwayat_kesehatan_ibu_sekarang TEXT,
    riwayat_perilaku TEXT,
    riwayat_penyakit_keluarga TEXT
  )
''');

    await db.execute('''
  CREATE TABLE pemeriksaan_kehamilan (
  id INTEGER PRIMARY KEY,
  kehamilan_id INTEGER,
  petugas_id INTEGER,
  tanggal_pemeriksaan Text,
  tempat_pemeriksaan Text,
  jenis_pemeriksaan Text
  )
''');

    await db.execute('''
  CREATE TABLE trimester_1 (
    id INTEGER PRIMARY KEY,
    pemeriksaan_id INTEGER UNIQUE,
    pemeriksaan_rutin INTEGER,
    skrining_kesehatan INTEGER,
    pemeriksaan_fisik INTEGER,
    pemeriksaan_awal INTEGER,
    pemeriksaan_khusus INTEGER,
    lab_trimester_1 INTEGER,
    usg_trimester_1 INTEGER,
    created_at Text
  )
''');

    await db.execute('''
  CREATE TABLE trimester_3 (
    id INTEGER PRIMARY KEY,
    pemeriksaan_id INTEGER UNIQUE,
    pemeriksaan_rutin INTEGER,
    skrining_kesehatan INTEGER,
    pemeriksaan_fisik INTEGER,
    lab_trimester_3 INTEGER,
    usg_trimester_3 INTEGER,
    rencana_konsultasi INTEGER,
    created_at Text
  )
''');

    await db.execute('''
  CREATE TABLE usg_trimester_1 (
    id INTEGER PRIMARY KEY,
    hpht Text,
    keteraturan_haid TEXT,
    umur_kehamilan_berdasar_hpht INTEGER,
    umur_kehamilan_berdasarkan_usg INTEGER,
    hpl_berdasarkan_hpht TEXT,
    hpl_berdasarkan_usg TEXT,
    jumlah_bayi TEXT,
    jumlah_gs TEXT,
    diametes_gs REAL,
    gs_hari INTEGER,
    gs_minggu INTEGER,
    crl REAL,
    crl_hari INTEGER,
    crl_minggu INTEGER,
    letak_produk_kehamilan TEXT,
    pulsasi_jantung TEXT,
    kecurigaan_temuan_abnormal TEXT,
    keterangan TEXT
  )
''');

    await db.execute('''
  CREATE TABLE lab_trimester_1 (
    id INTEGER PRIMARY KEY,
    hemoglobin REAL,
    golongan_darah_dan_rhesus TEXT,
    gula_darah REAL,
    hemoglobin_rtl Text,
    rhesus_rtl TEXT,
    gula_darah_rtl REAL,
    hiv TEXT,
    sifilis TEXT,
    hepatitis_b TEXT
  )
''');

    await db.execute('''
  CREATE TABLE usg_trimester_3 (
    id INTEGER PRIMARY KEY,
    usg_trimester3 TEXT,
    umur_kehamilan_usg_trimester_3 REAL,
    selisih_uk_usg_1_hpht_dengan_trimester_3 TEXT,
    jumlah_bayi TEXT,
    letak_bayi TEXT,
    presentasi_bayi TEXT,
    keadaan_bayi TEXT,
    djj TEXT,
    djj_status TEXT,
    lokasi_plasenta TEXT,
    sdp TEXT,
    jumlah_cairan_ketuban TEXT,
    BPD REAL,
    HC REAL,
    AC REAL,
    FL REAL,
    EFW REAL,
    HC_Sesuai_Minggu INTEGER,
    BPD_Sesuai_Minggu INTEGER,
    AC_Sesuai_Minggu INTEGER,
    FL_Sesuai_Minggu INTEGER,
    EFW_Sesuai_Minggu INTEGER,
    kecurigaan_temuan_abnormal TEXT,
    keterangan TEXT
  )
''');

    await db.execute('''
  CREATE TABLE lab_trimester_3 (
    id INTEGER PRIMARY KEY,
    Hemoglobin REAL,
    Protein_urin REAL,
    urin_reduksi TEXT,
    hemoglobin_rtl Text,
    protein_urin_rtl Text,
    urin_reduksi_rtl TEXT
  )
''');

    await db.execute('''
  CREATE TABLE rencana_konsultasi (
    id INTEGER PRIMARY KEY,
    rencana_konsultasi_lanjut TEXT,
    rencana_proses_melahirkan TEXT,
    pilihan_kontrasepsi TEXT,
    kebutuhan_konseling TEXT
  )
''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    //upgrade
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
