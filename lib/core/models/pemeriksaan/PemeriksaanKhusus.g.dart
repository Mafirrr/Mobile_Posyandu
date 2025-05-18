// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PemeriksaanKhusus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PemeriksaanKhusus _$PemeriksaanKhususFromJson(Map<String, dynamic> json) =>
    PemeriksaanKhusus(
      id: (json['id'] as num).toInt(),
      porsio: json['porsio'] as String,
      uretra: json['uretra'] as String,
      vagina: json['vagina'] as String,
      vulva: json['vulva'] as String,
      fluksus: json['fluksus'] as String,
      fluor: json['fluor'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'],
    );

Map<String, dynamic> _$PemeriksaanKhususToJson(PemeriksaanKhusus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'porsio': instance.porsio,
      'uretra': instance.uretra,
      'vagina': instance.vagina,
      'vulva': instance.vulva,
      'fluksus': instance.fluksus,
      'fluor': instance.fluor,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt,
    };
