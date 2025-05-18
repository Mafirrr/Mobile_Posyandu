import 'package:json_annotation/json_annotation.dart';

part 'RencanaKonsultasi.g.dart';

@JsonSerializable()
class RencanaKonsultasi {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "rencana_konsultasi_lanjut")
  List<String> rencanaKonsultasiLanjut;
  @JsonKey(name: "rencana_proses_melahirkan")
  String rencanaProsesMelahirkan;
  @JsonKey(name: "pilihan_kontrasepsi")
  String pilihanKontrasepsi;
  @JsonKey(name: "kebutuhan_konseling")
  String kebutuhanKonseling;
  @JsonKey(name: "created_at")
  DateTime createdAt;
  @JsonKey(name: "updated_at")
  DateTime updatedAt;
  @JsonKey(name: "deleted_at")
  dynamic deletedAt;

  RencanaKonsultasi({
    required this.id,
    required this.rencanaKonsultasiLanjut,
    required this.rencanaProsesMelahirkan,
    required this.pilihanKontrasepsi,
    required this.kebutuhanKonseling,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory RencanaKonsultasi.fromJson(Map<String, dynamic> json) =>
      _$RencanaKonsultasiFromJson(json);

  Map<String, dynamic> toJson() => _$RencanaKonsultasiToJson(this);
}
