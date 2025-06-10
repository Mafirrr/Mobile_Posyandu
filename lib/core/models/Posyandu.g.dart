// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Posyandu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Posyandu _$PosyanduFromJson(Map<String, dynamic> json) => Posyandu(
      id: (json['id'] as num).toInt(),
      nama: json['nama'] as String,
      alamat: json['alamat'],
    );

Map<String, dynamic> _$PosyanduToJson(Posyandu instance) => <String, dynamic>{
      'id': instance.id,
      'nama': instance.nama,
      'alamat': instance.alamat,
    };
