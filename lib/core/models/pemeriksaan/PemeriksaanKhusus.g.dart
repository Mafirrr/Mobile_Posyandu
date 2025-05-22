// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PemeriksaanKhusus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PemeriksaanKhusus _$PemeriksaanKhususFromJson(Map<String, dynamic> json) =>
    PemeriksaanKhusus(
      id: (json['id'] as num?)?.toInt(),
      porsio: json['porsio'] as String?,
      uretra: json['uretra'] as String?,
      vagina: json['vagina'] as String?,
      vulva: json['vulva'] as String?,
      fluksus: json['fluksus'] as String?,
      fluor: json['fluor'] as String?,
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
    };
