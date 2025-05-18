// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Kehamilan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kehamilan _$KehamilanFromJson(Map<String, dynamic> json) => Kehamilan(
      id: (json['id'] as num).toInt(),
      anggotaId: (json['anggota_id'] as num).toInt(),
      status: json['status'] as String,
      label: json['label'] as String,
    );

Map<String, dynamic> _$KehamilanToJson(Kehamilan instance) => <String, dynamic>{
      'id': instance.id,
      'anggota_id': instance.anggotaId,
      'status': instance.status,
      'label': instance.label,
    };
