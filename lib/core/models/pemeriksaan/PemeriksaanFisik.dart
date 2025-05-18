import 'package:json_annotation/json_annotation.dart';

part 'PemeriksaanFisik.g.dart';

@JsonSerializable()
class PemeriksaanFisik {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "konjungtiva")
  String konjungtiva;
  @JsonKey(name: "sklera")
  String sklera;
  @JsonKey(name: "leher")
  String leher;
  @JsonKey(name: "kulit")
  String kulit;
  @JsonKey(name: "gigi_mulut")
  String gigiMulut;
  @JsonKey(name: "tht")
  String tht;
  @JsonKey(name: "jantung")
  String jantung;
  @JsonKey(name: "paru")
  String paru;
  @JsonKey(name: "perut")
  String perut;
  @JsonKey(name: "tungkai")
  String tungkai;
  @JsonKey(name: "created_at")
  DateTime createdAt;
  @JsonKey(name: "updated_at")
  DateTime updatedAt;
  @JsonKey(name: "deleted_at")
  dynamic deletedAt;

  PemeriksaanFisik({
    required this.id,
    required this.konjungtiva,
    required this.sklera,
    required this.leher,
    required this.kulit,
    required this.gigiMulut,
    required this.tht,
    required this.jantung,
    required this.paru,
    required this.perut,
    required this.tungkai,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory PemeriksaanFisik.fromJson(Map<String, dynamic> json) =>
      _$PemeriksaanFisikFromJson(json);

  Map<String, dynamic> toJson() => _$PemeriksaanFisikToJson(this);
}
