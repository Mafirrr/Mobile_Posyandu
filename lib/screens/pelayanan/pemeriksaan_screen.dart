import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_mob/screens/pelayanan/trimester_1.dart';
import 'package:posyandu_mob/screens/pelayanan/trimester_2.dart';
import 'package:posyandu_mob/screens/pelayanan/trimester_3.dart';

class PemeriksaanScreen extends StatefulWidget {
  const PemeriksaanScreen({super.key});

  @override
  State<PemeriksaanScreen> createState() => _PemeriksaanScreenState();
}

class _PemeriksaanScreenState extends State<PemeriksaanScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentStep = 0; // total 4 step: 0,1,2,3

  // State checkbox
  List<String> _selectedRiwayatKesehatan = [];
  List<String> _selectedPerilaku = [];
  List<String> _selectedPenyakitKeluarga = [];

  final TextEditingController _tanggalPeriksaController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tanggalPeriksaController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Pilih Tanggal Pemeriksaan',
    );
    if (picked != null) {
      setState(() {
        _tanggalPeriksaController.text =
            DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  final _buttonRadius = BorderRadius.circular(8);
  int imunisasiSelected = -1;

  void _saveData() {
    final data = {
      "tanggalPeriksa": _tanggalPeriksaController.text,
      "riwayatKesehatanIbu": _selectedRiwayatKesehatan,
      "riwayatPerilaku": _selectedPerilaku,
      "riwayatPenyakitKeluarga": _selectedPenyakitKeluarga,
    };
    print("Data disimpan: $data");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data pemeriksaan berhasil disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemeriksaan Kehamilan'),
        backgroundColor: Colors.blue,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.blue,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black87,
              indicatorColor: Colors.white,
              indicatorWeight: 3.0,
              tabs: const [
                Tab(text: 'Trimester 1'),
                Tab(text: 'Trimester 2'),
                Tab(text: 'Trimester 3'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Trimester1(),
          Trimester2(),
          Trimester3(),
        ],
      ),
    );
  }
}
