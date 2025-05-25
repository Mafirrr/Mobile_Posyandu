import 'package:json_annotation/json_annotation.dart';

part 'GrafikBB.g.dart';

@JsonSerializable(explicitToJson: true)
class Grafik {
  @JsonKey(name: 'anggota_id')
  final int anggotaId;

  @JsonKey(name: 'IMT')
  final double imt;

  @JsonKey(name: 'minggu_usg')
  final int mingguUsg;

  @JsonKey(name: 'Berat_badan_awal')
  final double beratAwal;

  @JsonKey(name: 'tanggal_pemeriksaan')
  final DateTime tanggalPemeriksaan;

  final List<DataPoint> data;

  Grafik({
    required this.anggotaId,
    required this.imt,
    required this.mingguUsg,
    required this.beratAwal,
    required this.tanggalPemeriksaan,
    required this.data,
  });

  factory Grafik.fromJson(Map<String, dynamic> json) => _$GrafikFromJson(json);
  Map<String, dynamic> toJson() => _$GrafikToJson(this);
}

@JsonSerializable()
class DataPoint {
  final int minggu;

  @JsonKey(name: 'berat_badan')
  final double? berat;

  DataPoint({required this.minggu, this.berat});

  factory DataPoint.fromJson(Map<String, dynamic> json) => _$DataPointFromJson(json);
  Map<String, dynamic> toJson() => _$DataPointToJson(this);
}
