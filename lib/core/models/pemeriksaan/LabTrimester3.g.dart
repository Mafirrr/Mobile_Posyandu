// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LabTrimester3.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabTrimester3 _$LabTrimester3FromJson(Map<String, dynamic> json) =>
    LabTrimester3(
      id: (json['id'] as num).toInt(),
      hemoglobin: (json['Hemoglobin'] as num).toInt(),
      proteinUrin: (json['Protein_urin'] as num).toInt(),
      urinReduksi: json['urin_reduksi'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'],
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
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt,
      'hemoglobin_rtl': instance.hemoglobinRtl,
      'protein_urin_rtl': instance.proteinUrinRtl,
      'urin_reduksi_rtl': instance.urinReduksiRtl,
    };
