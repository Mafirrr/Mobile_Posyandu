import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'RencanaKonsultasi.g.dart';

@JsonSerializable()
class RencanaKonsultasi {
  @JsonKey(name: "id")
  int id;
  @JsonKey(
    name: "rencana_konsultasi_lanjut",
    fromJson: stringToList,
    toJson: listToString,
  )
  List<String>? rencanaKonsultasiLanjut;
  @JsonKey(name: "rencana_proses_melahirkan")
  String? rencanaProsesMelahirkan;
  @JsonKey(name: "pilihan_kontrasepsi")
  String? pilihanKontrasepsi;
  @JsonKey(name: "kebutuhan_konseling")
  String? kebutuhanKonseling;

  RencanaKonsultasi({
    required this.id,
    this.rencanaKonsultasiLanjut,
    this.rencanaProsesMelahirkan,
    this.pilihanKontrasepsi,
    this.kebutuhanKonseling,
  });

  factory RencanaKonsultasi.fromJson(Map<String, dynamic> json) =>
      _$RencanaKonsultasiFromJson(json);

  Map<String, dynamic> toJson() => _$RencanaKonsultasiToJson(this);
}

List<String> stringToList(dynamic input) {
  if (input == null) return [];
  if (input is List) return input.cast<String>();
  if (input is String) return List<String>.from(jsonDecode(input));
  return [];
}

String listToString(List<String>? input) {
  return jsonEncode(input ?? []);
}
