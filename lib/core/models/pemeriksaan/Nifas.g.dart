// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Nifas.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Nifas _$NifasFromJson(Map<String, dynamic> json) => Nifas(
      id: (json['id'] as num?)?.toInt(),
      pemeriksaanId: (json['pemeriksaan_id'] as num?)?.toInt(),
      bagianKf: json['bagian_kf'] as String?,
      periksaPayudara: json['periksa_payudara'] as String?,
      periksaPendarahan: json['periksa_pendarahan'] as String?,
      periksaJalanLahir: json['periksa_jalan_lahir'] as String?,
      vitaminA: json['vitamin_a'] as String?,
      kbPascaMelahirkan: json['kb_pasca_melahirkan'] as String?,
      skriningKesehatanJiwa: json['skrining_kesehatan_jiwa'] as String?,
      konseling: json['konseling'] as String?,
      tataLaksanaKasus: json['tata_laksana_kasus'] as String?,
      kesimpulanIbu: json['kesimpulan_ibu'] as String?,
      kesimpulanBayi: json['kesimpulan_bayi'] as String?,
      masalahNifas: json['masalah_nifas'] as String?,
      kesimpulan: json['kesimpulan'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$NifasToJson(Nifas instance) => <String, dynamic>{
      'id': instance.id,
      'pemeriksaan_id': instance.pemeriksaanId,
      'bagian_kf': instance.bagianKf,
      'periksa_payudara': instance.periksaPayudara,
      'periksa_pendarahan': instance.periksaPendarahan,
      'periksa_jalan_lahir': instance.periksaJalanLahir,
      'vitamin_a': instance.vitaminA,
      'kb_pasca_melahirkan': instance.kbPascaMelahirkan,
      'skrining_kesehatan_jiwa': instance.skriningKesehatanJiwa,
      'konseling': instance.konseling,
      'tata_laksana_kasus': instance.tataLaksanaKasus,
      'kesimpulan_ibu': instance.kesimpulanIbu,
      'kesimpulan_bayi': instance.kesimpulanBayi,
      'masalah_nifas': instance.masalahNifas,
      'kesimpulan': instance.kesimpulan,
      'created_at': instance.createdAt,
    };
