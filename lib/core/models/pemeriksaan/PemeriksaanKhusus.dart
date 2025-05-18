import 'package:json_annotation/json_annotation.dart';

part 'PemeriksaanKhusus.g.dart';

@JsonSerializable()
class PemeriksaanKhusus {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "porsio")
  String? porsio;
  @JsonKey(name: "uretra")
  String? uretra;
  @JsonKey(name: "vagina")
  String? vagina;
  @JsonKey(name: "vulva")
  String? vulva;
  @JsonKey(name: "fluksus")
  String? fluksus;
  @JsonKey(name: "fluor")
  String? fluor;

  PemeriksaanKhusus({
    required this.id,
    this.porsio,
    this.uretra,
    this.vagina,
    this.vulva,
    this.fluksus,
    this.fluor,
  });

  factory PemeriksaanKhusus.fromJson(Map<String, dynamic> json) =>
      _$PemeriksaanKhususFromJson(json);

  Map<String, dynamic> toJson() => _$PemeriksaanKhususToJson(this);
}
