import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PemantauanScreen extends StatefulWidget {
  final int mingguKehamilan;

  const PemantauanScreen({Key? key, required this.mingguKehamilan})
      : super(key: key);

  @override
  State<PemantauanScreen> createState() => _PemantauanScreenState();
}

class _PemantauanScreenState extends State<PemantauanScreen> {
  final List<String> kategoriPemantauan = [
    'Demam > 2 hari',
    'Pusing / sakit kepala berat',
    'Sulit tidur / cemas berlebih',
    'Risiko TB (batuk >2 minggu)',
    'Gerakan bayi tidak ada / kurang',
    'Nyeri perut hebat',
    'Keluar cairan jalan lahir',
    'Sakit saat kencing',
    'Keputihan / gatal daerah kewanitaan',
    'Diare berulang',
    'Pemeriksaan kehamilan',
  ];

  late List<bool> checklist;

  @override
  void initState() {
    super.initState();
    checklist = List.generate(kategoriPemantauan.length, (_) => false);
  }

  bool get isAnyChecked => checklist.contains(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pemantauan Mingguan - Minggu ${widget.mingguKehamilan}'),
        backgroundColor: Color.fromARGB(255, 0, 140, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: kategoriPemantauan.length,
                separatorBuilder: (_, __) => const Divider(height: 16),
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(
                      kategoriPemantauan[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                    value: checklist[index],
                    onChanged: (value) {
                      setState(() {
                        checklist[index] = value ?? false;
                      });
                    },
                    activeColor: const Color.fromARGB(255, 0, 110, 255),
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                },
              ),
            ),
            if (isAnyChecked)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const FaIcon(
                    FontAwesomeIcons.whatsapp,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Hubungi Petugas via WhatsApp',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
