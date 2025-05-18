// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Trimester1.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trimester1 _$Trimester1FromJson(Map<String, dynamic> json) => Trimester1(
      id: (json['id'] as num).toInt(),
      pemeriksaanId: (json['pemeriksaan_id'] as num).toInt(),
      skriningKesehatan: SkriningKesehatan.fromJson(
          json['skrining_kesehatan'] as Map<String, dynamic>),
      pemeriksaanFisik: PemeriksaanFisik.fromJson(
          json['pemeriksaan_fisik'] as Map<String, dynamic>),
      pemeriksaanAwal: PemeriksaanAwal.fromJson(
          json['pemeriksaan_awal'] as Map<String, dynamic>),
      pemeriksaanKhusus: PemeriksaanKhusus.fromJson(
          json['pemeriksaan_khusus'] as Map<String, dynamic>),
      labTrimester1: LabTrimester1.fromJson(
          json['lab_trimester1'] as Map<String, dynamic>),
      usgTrimester1: UsgTrimester1.fromJson(
          json['usg_trimester1'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$Trimester1ToJson(Trimester1 instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pemeriksaan_id': instance.pemeriksaanId,
      'skrining_kesehatan': instance.skriningKesehatan,
      'pemeriksaan_fisik': instance.pemeriksaanFisik,
      'pemeriksaan_awal': instance.pemeriksaanAwal,
      'pemeriksaan_khusus': instance.pemeriksaanKhusus,
      'lab_trimester1': instance.labTrimester1,
      'usg_trimester1': instance.usgTrimester1,
    };
