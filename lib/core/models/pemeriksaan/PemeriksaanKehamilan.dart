import 'package:json_annotation/json_annotation.dart';

part 'PemeriksaanKehamilan.g.dart';

@JsonSerializable()
class PemeriksaanKehamilan {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "kehamilan_id")
  int? kehamilanId;
  @JsonKey(name: "petugas_id")
  int? petugasId;
  @JsonKey(name: "tanggal_pemeriksaan")
  DateTime tanggalPemeriksaan;
  @JsonKey(name: "tempat_pemeriksaan")
  String tempatPemeriksaan;
  @JsonKey(name: "jenis_pemeriksaan")
  String jenisPemeriksaan;

  PemeriksaanKehamilan({
    this.id,
    required this.kehamilanId,
    required this.petugasId,
    required this.tanggalPemeriksaan,
    required this.tempatPemeriksaan,
    required this.jenisPemeriksaan,
  });

  factory PemeriksaanKehamilan.fromJson(Map<String, dynamic> json) =>
      _$PemeriksaanKehamilanFromJson(json);

  Map<String, dynamic> toJson() => _$PemeriksaanKehamilanToJson(this);
}
