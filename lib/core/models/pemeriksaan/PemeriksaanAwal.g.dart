// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PemeriksaanAwal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PemeriksaanAwal _$PemeriksaanAwalFromJson(Map<String, dynamic> json) =>
    PemeriksaanAwal(
      id: (json['id'] as num).toInt(),
      tinggiBadan: (json['tinggi_badan'] as num).toInt(),
      golonganDarah: json['golongan_darah'] as String,
      statusImunisasiTd: json['status_imunisasi_td'] as String,
      hemoglobin: (json['hemoglobin'] as num).toInt(),
      riwayatKesehatanIbuSekarang:
          (json['riwayat_kesehatan_ibu_sekarang'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      riwayatPerilaku: (json['riwayat_perilaku'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      riwayatPenyakitKeluarga:
          (json['riwayat_penyakit_keluarga'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'],
    );

Map<String, dynamic> _$PemeriksaanAwalToJson(PemeriksaanAwal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tinggi_badan': instance.tinggiBadan,
      'golongan_darah': instance.golonganDarah,
      'status_imunisasi_td': instance.statusImunisasiTd,
      'hemoglobin': instance.hemoglobin,
      'riwayat_kesehatan_ibu_sekarang': instance.riwayatKesehatanIbuSekarang,
      'riwayat_perilaku': instance.riwayatPerilaku,
      'riwayat_penyakit_keluarga': instance.riwayatPenyakitKeluarga,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt,
    };
