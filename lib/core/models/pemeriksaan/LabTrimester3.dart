import 'package:json_annotation/json_annotation.dart';

part 'LabTrimester3.g.dart';

@JsonSerializable()
class LabTrimester3 {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "Hemoglobin")
  int hemoglobin;
  @JsonKey(name: "Protein_urin")
  int proteinUrin;
  @JsonKey(name: "urin_reduksi")
  String urinReduksi;
  @JsonKey(name: "created_at")
  DateTime createdAt;
  @JsonKey(name: "updated_at")
  DateTime updatedAt;
  @JsonKey(name: "deleted_at")
  dynamic deletedAt;
  @JsonKey(name: "hemoglobin_rtl")
  dynamic hemoglobinRtl;
  @JsonKey(name: "protein_urin_rtl")
  dynamic proteinUrinRtl;
  @JsonKey(name: "urin_reduksi_rtl")
  dynamic urinReduksiRtl;

  LabTrimester3({
    required this.id,
    required this.hemoglobin,
    required this.proteinUrin,
    required this.urinReduksi,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.hemoglobinRtl,
    required this.proteinUrinRtl,
    required this.urinReduksiRtl,
  });

  factory LabTrimester3.fromJson(Map<String, dynamic> json) =>
      _$LabTrimester3FromJson(json);

  Map<String, dynamic> toJson() => _$LabTrimester3ToJson(this);
}
