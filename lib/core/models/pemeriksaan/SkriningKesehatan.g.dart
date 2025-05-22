// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SkriningKesehatan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkriningKesehatan _$SkriningKesehatanFromJson(Map<String, dynamic> json) =>
    SkriningKesehatan(
      id: (json['id'] as num?)?.toInt(),
      skriningJiwa: json['skrining_jiwa'] as String?,
      tindakLanjutJiwa: json['tindak_lanjut_jiwa'] as String?,
      perluRujukan: json['perlu_rujukan'] as String?,
    );

Map<String, dynamic> _$SkriningKesehatanToJson(SkriningKesehatan instance) =>
    <String, dynamic>{
      'id': instance.id,
      'skrining_jiwa': instance.skriningJiwa,
      'tindak_lanjut_jiwa': instance.tindakLanjutJiwa,
      'perlu_rujukan': instance.perluRujukan,
    };
