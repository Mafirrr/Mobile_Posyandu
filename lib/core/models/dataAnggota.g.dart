// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataAnggota.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataAnggota _$DataAnggotaFromJson(Map<String, dynamic> json) => DataAnggota(
      id: (json['id'] as num).toInt(),
      anggotaId: (json['anggota_id'] as num).toInt(),
      nik: json['nik'] as String,
      nama: json['nama'] as String,
      noJkn: json['no_jkn'] as String,
      faskesTk1: json['faskes_tk1'] as String?,
      faskesRujukan: json['faskes_rujukan'] as String?,
      tanggalLahir: json['tanggal_lahir'] as String,
      tempatLahir: json['tempat_lahir'] as String,
      pekerjaan: json['pekerjaan'] as String,
      alamat: json['alamat'] as String,
      noTelepon: json['no_telepon'] as String?,
      golonganDarah: json['golongan_darah'] as String?,
    );

Map<String, dynamic> _$DataAnggotaToJson(DataAnggota instance) =>
    <String, dynamic>{
      'id': instance.id,
      'anggota_id': instance.anggotaId,
      'nik': instance.nik,
      'nama': instance.nama,
      'no_jkn': instance.noJkn,
      'faskes_tk1': instance.faskesTk1,
      'faskes_rujukan': instance.faskesRujukan,
      'tanggal_lahir': instance.tanggalLahir,
      'tempat_lahir': instance.tempatLahir,
      'pekerjaan': instance.pekerjaan,
      'alamat': instance.alamat,
      'no_telepon': instance.noTelepon,
      'golongan_darah': instance.golonganDarah,
    };
