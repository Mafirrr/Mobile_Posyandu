import 'package:flutter/material.dart';
import 'package:posyandu_mob/screens/pelayanan/trimester_1.dart';
import 'package:posyandu_mob/screens/pelayanan/trimester_2.dart';
import 'package:posyandu_mob/screens/pelayanan/trimestr_3.dart';

class PemeriksaanScreen extends StatefulWidget {
  const PemeriksaanScreen({super.key});

  @override
  State<PemeriksaanScreen> createState() => _PemeriksaanScreenState();
}

class _PemeriksaanScreenState extends State<PemeriksaanScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
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
          const Trimester1(),
          Trimester2(),
          const Trimestr3(),
        ],
      ),
    );
  }
}
