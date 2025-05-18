import 'package:json_annotation/json_annotation.dart';

part 'Jadwal.g.dart';

@JsonSerializable()
class Jadwal {
  final int id;
  final int? anggota_id;
  final String judul;
  final String tanggal;
  final String? keterangan;
  final String lokasi;
  final String jam_mulai;
  final String jam_selesai;

  Jadwal({
    required this.id,
    this.anggota_id,
    required this.judul,
    required this.tanggal,
    this.keterangan,
    required this.lokasi,
    required this.jam_mulai,
    required this.jam_selesai,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) => _$JadwalFromJson(json);
  Map<String, dynamic> toJson() => _$JadwalToJson(this);
}
