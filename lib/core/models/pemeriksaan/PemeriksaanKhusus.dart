import 'package:json_annotation/json_annotation.dart';

part 'PemeriksaanKhusus.g.dart';

@JsonSerializable()
class PemeriksaanKhusus {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "porsio")
  String porsio;
  @JsonKey(name: "uretra")
  String uretra;
  @JsonKey(name: "vagina")
  String vagina;
  @JsonKey(name: "vulva")
  String vulva;
  @JsonKey(name: "fluksus")
  String fluksus;
  @JsonKey(name: "fluor")
  String fluor;
  @JsonKey(name: "created_at")
  DateTime createdAt;
  @JsonKey(name: "updated_at")
  DateTime updatedAt;
  @JsonKey(name: "deleted_at")
  dynamic deletedAt;

  PemeriksaanKhusus({
    required this.id,
    required this.porsio,
    required this.uretra,
    required this.vagina,
    required this.vulva,
    required this.fluksus,
    required this.fluor,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory PemeriksaanKhusus.fromJson(Map<String, dynamic> json) =>
      _$PemeriksaanKhususFromJson(json);

  Map<String, dynamic> toJson() => _$PemeriksaanKhususToJson(this);
}
