// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UsgTrimester3.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsgTrimester3 _$UsgTrimester3FromJson(Map<String, dynamic> json) =>
    UsgTrimester3(
      id: (json['id'] as num).toInt(),
      usgTrimester3: json['usg_trimester3'] as String?,
      umurKehamilanUsgTrimester3:
          (json['umur_kehamilan_usg_trimester_3'] as num?)?.toInt(),
      selisihUkUsg1HphtDenganTrimester3:
          json['selisih_uk_usg_1_hpht_dengan_trimester_3'] as String?,
      jumlahBayi: json['jumlah_bayi'] as String?,
      letakBayi: json['letak_bayi'] as String?,
      presentasiBayi: json['presentasi_bayi'] as String?,
      keadaanBayi: json['keadaan_bayi'] as String?,
      djjStatus: json['djj_status'] as String?,
      lokasiPlasenta: json['lokasi_plasenta'] as String?,
      jumlahCairanKetuban: json['jumlah_cairan_ketuban'] as String?,
      bpd: (json['BPD'] as num?)?.toInt(),
      hc: (json['HC'] as num?)?.toInt(),
      ac: (json['AC'] as num?)?.toInt(),
      fl: (json['FL'] as num?)?.toInt(),
      efw: (json['EFW'] as num?)?.toInt(),
      hcSesuaiMinggu: (json['HC_Sesuai_Minggu'] as num?)?.toInt(),
      bpdSesuaiMinggu: (json['BPD_Sesuai_Minggu'] as num?)?.toInt(),
      acSesuaiMinggu: (json['AC_Sesuai_Minggu'] as num?)?.toInt(),
      flSesuaiMinggu: (json['FL_Sesuai_Minggu'] as num?)?.toInt(),
      efwSesuaiMinggu: (json['EFW_Sesuai_Minggu'] as num?)?.toInt(),
      kecurigaanTemuanAbnormal: json['kecurigaan_temuan_abnormal'] as String?,
      keterangan: json['keterangan'] as String?,
      djj: (json['djj'] as num?)?.toInt(),
      sdp: (json['sdp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UsgTrimester3ToJson(UsgTrimester3 instance) =>
    <String, dynamic>{
      'id': instance.id,
      'usg_trimester3': instance.usgTrimester3,
      'umur_kehamilan_usg_trimester_3': instance.umurKehamilanUsgTrimester3,
      'selisih_uk_usg_1_hpht_dengan_trimester_3':
          instance.selisihUkUsg1HphtDenganTrimester3,
      'jumlah_bayi': instance.jumlahBayi,
      'letak_bayi': instance.letakBayi,
      'presentasi_bayi': instance.presentasiBayi,
      'keadaan_bayi': instance.keadaanBayi,
      'djj_status': instance.djjStatus,
      'lokasi_plasenta': instance.lokasiPlasenta,
      'jumlah_cairan_ketuban': instance.jumlahCairanKetuban,
      'BPD': instance.bpd,
      'HC': instance.hc,
      'AC': instance.ac,
      'FL': instance.fl,
      'EFW': instance.efw,
      'HC_Sesuai_Minggu': instance.hcSesuaiMinggu,
      'BPD_Sesuai_Minggu': instance.bpdSesuaiMinggu,
      'AC_Sesuai_Minggu': instance.acSesuaiMinggu,
      'FL_Sesuai_Minggu': instance.flSesuaiMinggu,
      'EFW_Sesuai_Minggu': instance.efwSesuaiMinggu,
      'kecurigaan_temuan_abnormal': instance.kecurigaanTemuanAbnormal,
      'keterangan': instance.keterangan,
      'djj': instance.djj,
      'sdp': instance.sdp,
    };
