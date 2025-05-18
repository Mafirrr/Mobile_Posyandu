// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PemeriksaanFisik.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PemeriksaanFisik _$PemeriksaanFisikFromJson(Map<String, dynamic> json) =>
    PemeriksaanFisik(
      id: (json['id'] as num).toInt(),
      konjungtiva: json['konjungtiva'] as String,
      sklera: json['sklera'] as String,
      leher: json['leher'] as String,
      kulit: json['kulit'] as String,
      gigiMulut: json['gigi_mulut'] as String,
      tht: json['tht'] as String,
      jantung: json['jantung'] as String,
      paru: json['paru'] as String,
      perut: json['perut'] as String,
      tungkai: json['tungkai'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'],
    );

Map<String, dynamic> _$PemeriksaanFisikToJson(PemeriksaanFisik instance) =>
    <String, dynamic>{
      'id': instance.id,
      'konjungtiva': instance.konjungtiva,
      'sklera': instance.sklera,
      'leher': instance.leher,
      'kulit': instance.kulit,
      'gigi_mulut': instance.gigiMulut,
      'tht': instance.tht,
      'jantung': instance.jantung,
      'paru': instance.paru,
      'perut': instance.perut,
      'tungkai': instance.tungkai,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt,
    };
