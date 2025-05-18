// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PemeriksaanKehamilan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PemeriksaanKehamilan _$PemeriksaanKehamilanFromJson(
        Map<String, dynamic> json) =>
    PemeriksaanKehamilan(
      trimester1: (json['trimester1'] as List<dynamic>)
          .map((e) => Trimestr1.fromJson(e as Map<String, dynamic>))
          .toList(),
      trimester2: (json['trimester2'] as List<dynamic>)
          .map((e) => PemeriksaanRutin.fromJson(e as Map<String, dynamic>))
          .toList(),
      trimester3: (json['trimester3'] as List<dynamic>)
          .map((e) => Trimester3.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PemeriksaanKehamilanToJson(
        PemeriksaanKehamilan instance) =>
    <String, dynamic>{
      'trimester1': instance.trimester1,
      'trimester2': instance.trimester2,
      'trimester3': instance.trimester3,
    };
