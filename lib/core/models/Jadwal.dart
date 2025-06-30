import 'package:json_annotation/json_annotation.dart';
import 'package:posyandu_mob/core/models/Posyandu.dart';

part 'Jadwal.g.dart';

@JsonSerializable()
class Jadwal {
  final int id;
  final int? anggota_id;
  final String judul;
  final String tanggal;
  final String? keterangan;
  final int lokasi;
  final String jam_mulai;
  final String jam_selesai;

  @JsonKey(name: "posyandu")
  Posyandu? posyandu;

  @JsonKey(name: "yang_menghadiri")
  @StringListToIntListConverter()
  final List<int>? yangMenghadiri;

  Jadwal({
    required this.id,
    this.anggota_id,
    required this.judul,
    required this.tanggal,
    this.keterangan,
    required this.lokasi,
    required this.jam_mulai,
    required this.jam_selesai,
    this.posyandu,
    this.yangMenghadiri,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) => _$JadwalFromJson(json);
  Map<String, dynamic> toJson() => _$JadwalToJson(this);
}

class StringListToIntListConverter
    implements JsonConverter<List<int>?, List<dynamic>?> {
  const StringListToIntListConverter();

  @override
  List<int>? fromJson(List<dynamic>? jsonList) {
    if (jsonList == null) return null;
    return jsonList
        .map((e) => int.tryParse(e.toString()))
        .whereType<int>()
        .toList();
  }

  @override
  List<dynamic>? toJson(List<int>? object) {
    return object;
  }
}
