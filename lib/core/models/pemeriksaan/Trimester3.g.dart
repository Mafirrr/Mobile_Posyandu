// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Trimester3.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trimester3 _$Trimester3FromJson(Map<String, dynamic> json) => Trimester3(
      id: (json['id'] as num).toInt(),
      created_at: json['created_at'] as String,
      pemeriksaanId: (json['pemeriksaan_id'] as num).toInt(),
      pemeriksaanRutin: PemeriksaanRutin.fromJson(
          json['pemeriksaan_rutin'] as Map<String, dynamic>),
      skriningKesehatan: SkriningKesehatan.fromJson(
          json['skrining_kesehatan'] as Map<String, dynamic>),
      pemeriksaanFisik: PemeriksaanFisik.fromJson(
          json['pemeriksaan_fisik'] as Map<String, dynamic>),
      rencanaKonsultasi: RencanaKonsultasi.fromJson(
          json['rencana_konsultasi'] as Map<String, dynamic>),
      labTrimester3: LabTrimester3.fromJson(
          json['lab_trimester3'] as Map<String, dynamic>),
      usgTrimester3: UsgTrimester3.fromJson(
          json['usg_trimester3'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$Trimester3ToJson(Trimester3 instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.created_at,
      'pemeriksaan_id': instance.pemeriksaanId,
      'pemeriksaan_rutin': instance.pemeriksaanRutin,
      'skrining_kesehatan': instance.skriningKesehatan,
      'pemeriksaan_fisik': instance.pemeriksaanFisik,
      'rencana_konsultasi': instance.rencanaKonsultasi,
      'lab_trimester3': instance.labTrimester3,
      'usg_trimester3': instance.usgTrimester3,
    };
