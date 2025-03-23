// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Anggota.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Anggota _$AnggotaFromJson(Map<String, dynamic> json) => Anggota(
      id: (json['id'] as num).toInt(),
      nik: json['nik'] as String,
      nama: json['nama'] as String,
      tanggal_lahir: json['tanggal_lahir'] as String,
      tempat_lahir: json['tempat_lahir'] as String,
      pekerjaan: json['pekerjaan'] as String,
      alamat: json['alamat'] as String,
      no_telepon: json['no_telepon'] as String,
      golongan_darah: json['golongan_darah'] as String,
    );

Map<String, dynamic> _$AnggotaToJson(Anggota instance) => <String, dynamic>{
      'id': instance.id,
      'nik': instance.nik,
      'nama': instance.nama,
      'tanggal_lahir': instance.tanggal_lahir,
      'tempat_lahir': instance.tempat_lahir,
      'pekerjaan': instance.pekerjaan,
      'alamat': instance.alamat,
      'no_telepon': instance.no_telepon,
      'golongan_darah': instance.golongan_darah,
    };
