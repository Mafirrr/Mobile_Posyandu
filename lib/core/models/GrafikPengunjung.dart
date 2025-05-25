class GrafikPemeriksaan {
  final List<int> labels;
  final List<int> data;

  GrafikPemeriksaan({required this.labels, required this.data});

  factory GrafikPemeriksaan.fromJson(Map<String, dynamic> json) {
    return GrafikPemeriksaan(
      labels: (json['labels'] as List).map((e) => int.tryParse(e.toString()) ?? 0).toList(),
      data: (json['data'] as List).map((e) => int.tryParse(e.toString()) ?? 0).toList(),
    );
  }
}
