// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LabTrimester3.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabTrimester3 _$LabTrimester3FromJson(Map<String, dynamic> json) =>
    LabTrimester3(
      id: (json['id'] as num?)?.toInt(),
      hemoglobin: (json['Hemoglobin'] as num?)?.toDouble(),
      proteinUrin: (json['Protein_urin'] as num?)?.toDouble(),
      urinReduksi: json['urin_reduksi'] as String?,
      hemoglobinRtl: json['hemoglobin_rtl'],
      proteinUrinRtl: json['protein_urin_rtl'],
      urinReduksiRtl: json['urin_reduksi_rtl'],
    );

Map<String, dynamic> _$LabTrimester3ToJson(LabTrimester3 instance) =>
    <String, dynamic>{
      'id': instance.id,
      'Hemoglobin': instance.hemoglobin,
      'Protein_urin': instance.proteinUrin,
      'urin_reduksi': instance.urinReduksi,
      'hemoglobin_rtl': instance.hemoglobinRtl,
      'protein_urin_rtl': instance.proteinUrinRtl,
      'urin_reduksi_rtl': instance.urinReduksiRtl,
    };
