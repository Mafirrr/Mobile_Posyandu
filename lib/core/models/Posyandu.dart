import 'package:json_annotation/json_annotation.dart';

part 'Posyandu.g.dart';

@JsonSerializable()
class Posyandu {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "nama")
  String nama;
  @JsonKey(name: "alamat")
  dynamic alamat;

  Posyandu({
    required this.id,
    required this.nama,
    required this.alamat,
  });

  factory Posyandu.fromJson(Map<String, dynamic> json) =>
      _$PosyanduFromJson(json);

  Map<String, dynamic> toJson() => _$PosyanduToJson(this);
}
