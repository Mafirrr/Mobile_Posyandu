import 'package:json_annotation/json_annotation.dart';

part 'Kehamilan.g.dart';

@JsonSerializable()
class Kehamilan {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "anggota_id")
  int anggotaId;
  @JsonKey(name: "status")
  String status;
  @JsonKey(name: "label")
  String label;

  Kehamilan({
    required this.id,
    required this.anggotaId,
    required this.status,
    required this.label,
  });

  factory Kehamilan.fromJson(Map<String, dynamic> json) =>
      _$KehamilanFromJson(json);

  Map<String, dynamic> toJson() => _$KehamilanToJson(this);
}
