// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LabTrimester1.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabTrimester1 _$LabTrimester1FromJson(Map<String, dynamic> json) =>
    LabTrimester1(
      id: (json['id'] as num).toInt(),
      hemoglobin: (json['hemoglobin'] as num).toInt(),
      golonganDarahDanRhesus: json['golongan_darah_dan_rhesus'] as String,
      gulaDarah: (json['gula_darah'] as num).toInt(),
      hemoglobinRtl: json['hemoglobin_rtl'],
      rhesusRtl: json['rhesus_rtl'],
      gulaDarahRtl: json['gula_darah_rtl'] as String,
      hiv: json['hiv'] as String,
      sifilis: json['sifilis'] as String,
      hepatitisB: json['hepatitis_b'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'],
    );

Map<String, dynamic> _$LabTrimester1ToJson(LabTrimester1 instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hemoglobin': instance.hemoglobin,
      'golongan_darah_dan_rhesus': instance.golonganDarahDanRhesus,
      'gula_darah': instance.gulaDarah,
      'hemoglobin_rtl': instance.hemoglobinRtl,
      'rhesus_rtl': instance.rhesusRtl,
      'gula_darah_rtl': instance.gulaDarahRtl,
      'hiv': instance.hiv,
      'sifilis': instance.sifilis,
      'hepatitis_b': instance.hepatitisB,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt,
    };
