import 'package:json_annotation/json_annotation.dart';

part 'PemeriksaanFisik.g.dart';

@JsonSerializable()
class PemeriksaanFisik {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "konjungtiva")
  String? konjungtiva;
  @JsonKey(name: "sklera")
  String? sklera;
  @JsonKey(name: "leher")
  String? leher;
  @JsonKey(name: "kulit")
  String? kulit;
  @JsonKey(name: "gigi_mulut")
  String? gigiMulut;
  @JsonKey(name: "tht")
  String? tht;
  @JsonKey(name: "jantung")
  String? jantung;
  @JsonKey(name: "paru")
  String? paru;
  @JsonKey(name: "perut")
  String? perut;
  @JsonKey(name: "tungkai")
  String? tungkai;

  PemeriksaanFisik({
    this.id,
    this.konjungtiva,
    this.sklera,
    this.leher,
    this.kulit,
    this.gigiMulut,
    this.tht,
    this.jantung,
    this.paru,
    this.perut,
    this.tungkai,
  });

  factory PemeriksaanFisik.fromJson(Map<String, dynamic> json) =>
      _$PemeriksaanFisikFromJson(json);

  Map<String, dynamic> toJson() => _$PemeriksaanFisikToJson(this);
}
