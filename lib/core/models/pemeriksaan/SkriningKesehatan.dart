import 'package:json_annotation/json_annotation.dart';

part 'SkriningKesehatan.g.dart';

@JsonSerializable()
class SkriningKesehatan {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "skrining_jiwa")
  String skriningJiwa;
  @JsonKey(name: "tindak_lanjut_jiwa")
  String tindakLanjutJiwa;
  @JsonKey(name: "perlu_rujukan")
  String perluRujukan;
  @JsonKey(name: "created_at")
  DateTime createdAt;
  @JsonKey(name: "updated_at")
  DateTime updatedAt;
  @JsonKey(name: "deleted_at")
  dynamic deletedAt;

  SkriningKesehatan({
    required this.id,
    required this.skriningJiwa,
    required this.tindakLanjutJiwa,
    required this.perluRujukan,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory SkriningKesehatan.fromJson(Map<String, dynamic> json) =>
      _$SkriningKesehatanFromJson(json);

  Map<String, dynamic> toJson() => _$SkriningKesehatanToJson(this);
}
