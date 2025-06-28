import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:posyandu_mob/core/services/AnggotaService.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void _kirimPesanWhatsApp() async {
    final nomorBidan = await AnggotaService().getNomor();
    final keluhan = <String>[];

    for (int i = 0; i < kategoriPemantauan.length; i++) {
      if (checklist[i]) {
        keluhan.add('- ${kategoriPemantauan[i]}');
      }
    }

    final pesan = '''
      Halo Bidan, saya ingin melaporkan beberapa keluhan pada minggu ke-${widget.mingguKehamilan} kehamilan:
      ${keluhan.join('\n')}
      ''';

    final url = Uri.parse(
        'https://wa.me/$nomorBidan?text=${Uri.encodeComponent(pesan)}');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka WhatsApp')),
      );
    }
  }

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
                  onPressed: () {
                    _kirimPesanWhatsApp();
                  },
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
