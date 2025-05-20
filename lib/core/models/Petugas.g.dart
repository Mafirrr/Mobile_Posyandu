// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Petugas.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Petugas _$PetugasFromJson(Map<String, dynamic> json) => Petugas(
      id: (json['id'] as num?)?.toInt(),
      nip: json['nip'] as String?,
      nama: json['nama'] as String?,
      noTelepon: json['no_telepon'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$PetugasToJson(Petugas instance) => <String, dynamic>{
      'id': instance.id,
      'nip': instance.nip,
      'nama': instance.nama,
      'no_telepon': instance.noTelepon,
      'email': instance.email,
      'role': instance.role,
    };
