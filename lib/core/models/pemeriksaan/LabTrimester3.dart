import 'package:json_annotation/json_annotation.dart';

part 'LabTrimester3.g.dart';

@JsonSerializable()
class LabTrimester3 {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "Hemoglobin")
  double? hemoglobin;
  @JsonKey(name: "Protein_urin")
  double? proteinUrin;
  @JsonKey(name: "urin_reduksi")
  String? urinReduksi;
  @JsonKey(name: "hemoglobin_rtl")
  dynamic hemoglobinRtl;
  @JsonKey(name: "protein_urin_rtl")
  dynamic proteinUrinRtl;
  @JsonKey(name: "urin_reduksi_rtl")
  dynamic urinReduksiRtl;

  LabTrimester3({
    this.id,
    this.hemoglobin,
    this.proteinUrin,
    this.urinReduksi,
    this.hemoglobinRtl,
    this.proteinUrinRtl,
    this.urinReduksiRtl,
  });

  factory LabTrimester3.fromJson(Map<String, dynamic> json) =>
      _$LabTrimester3FromJson(json);

  Map<String, dynamic> toJson() => _$LabTrimester3ToJson(this);
}
