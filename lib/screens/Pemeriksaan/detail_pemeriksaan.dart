import 'package:flutter/material.dart';

class DetailPemeriksaan extends StatelessWidget {
  const DetailPemeriksaan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kehamilan Pertama'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProfileSection(),
            const SizedBox(height: 20),
            _TrimesterDropdown(),
            const SizedBox(height: 20),
            const Text(
              'Hasil Pemeriksaan Trimester 1',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _ResultTable(),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(
              'assets/images/picture.jpg'), // Ganti dengan path gambar kamu
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'SUTEYOO TYO',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Anggota Posyandu',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

class _TrimesterDropdown extends StatefulWidget {
  @override
  State<_TrimesterDropdown> createState() => _TrimesterDropdownState();
}

class _TrimesterDropdownState extends State<_TrimesterDropdown> {
  String selectedTrimester = 'Trimester 1';
  final List<String> trimesters = ['Trimester 1', 'Trimester 2', 'Trimester 3'];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedTrimester,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      items: trimesters.map((trimester) {
        return DropdownMenuItem(
          value: trimester,
          child: Text(trimester),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedTrimester = value!;
        });
      },
    );
  }
}

class _ResultTable extends StatelessWidget {
  final Map<String, String> data = {
    'Tanggal Periksa': '14-01-2025',
    'Tempat Periksa': 'Posyandu',
    'Timbang BB': '50.0kg',
    'Pengukuran TB': '170cm',
    'Lingkar Lengan Atas': '-',
    'Tekanan Darah': '120/80 mmHg',
    'Periksa Tinggi Rahim': '-',
    'Periksa Letak dan Denyut Janin': '-',
    'Status dan Imunisasi Tetanus': '-',
    'Konseling': '-',
    'Skrining Dokter': '-',
    'Tablet Tambah Darah': '-',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: data.entries.map((entry) {
        return _ResultRow(title: entry.key, value: entry.value);
      }).toList(),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String title;
  final String value;

  const _ResultRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
