import 'package:json_annotation/json_annotation.dart';

part 'SkriningKesehatan.g.dart';

@JsonSerializable()
class SkriningKesehatan {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "skrining_jiwa")
  String? skriningJiwa;
  @JsonKey(name: "tindak_lanjut_jiwa")
  String? tindakLanjutJiwa;
  @JsonKey(name: "perlu_rujukan")
  String? perluRujukan;

  SkriningKesehatan({
    required this.id,
    this.skriningJiwa,
    this.tindakLanjutJiwa,
    this.perluRujukan,
  });

  factory SkriningKesehatan.fromJson(Map<String, dynamic> json) =>
      _$SkriningKesehatanFromJson(json);

  Map<String, dynamic> toJson() => _$SkriningKesehatanToJson(this);
}
