// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Pemeriksaan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pemeriksaan _$PemeriksaanFromJson(Map<String, dynamic> json) => Pemeriksaan(
      pemeriksaan: (json['pemeriksaan'] as List<dynamic>)
          .map((e) => PemeriksaanKehamilan.fromJson(e as Map<String, dynamic>))
          .toList(),
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

Map<String, dynamic> _$PemeriksaanToJson(Pemeriksaan instance) =>
    <String, dynamic>{
      'pemeriksaan': instance.pemeriksaan,
      'trimester1': instance.trimester1,
      'trimester2': instance.trimester2,
      'trimester3': instance.trimester3,
    };
