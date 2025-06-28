import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_mob/core/database/PemeriksaanDatabase.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/UsgTrimester1.dart';
import 'package:posyandu_mob/screens/Edukasi/Edukasi.dart';
import 'package:posyandu_mob/screens/Kehamilan/listKehamilan.dart';
import 'package:posyandu_mob/screens/profil/ProfilScreen.dart';
import 'package:posyandu_mob/screens/dashboard/dashboard_screen.dart';
import 'package:posyandu_mob/screens/pemantauan/pemantauan_screen.dart';

class NavAnggotaScreen extends StatefulWidget {
  const NavAnggotaScreen({super.key});

  @override
  _NavAnggotaScreenState createState() => _NavAnggotaScreenState();
}

class _NavAnggotaScreenState extends State<NavAnggotaScreen> {
  int _selectedIndex = 0;
  int minggu = 0;
  int hari = 0;
  final _db = Pemeriksaandatabase();

  final List<IconData> _icons = [
    Icons.home,
    Icons.medication,
    Icons.article,
    Icons.monitor_heart,
    Icons.person,
  ];

  final List<String> _labels = [
    "Beranda",
    "Pemeriksaan",
    "Edukasi",
    "Konsultasi",
    "Profil",
  ];

  @override
  void initState() {
    _umurKehamilan();
    super.initState();
  }

  Future<void> _umurKehamilan() async {
    try {
      UsgTrimester1? result = await _db.getPemeriksaanUsg1();

      if (result != null && result.hpht != null) {
        final hpht = DateFormat('yyyy-MM-dd').parse(result.hpht);
        final now = DateTime.now();
        final difference = now.difference(hpht);

        setState(() {
          minggu = difference.inDays ~/ 7;
          hari = difference.inDays % 7;
        });
      } else {
        setState(() {
          minggu = 0;
          hari = 0;
        });
      }
    } catch (e) {
      setState(() {
        minggu = 0;
        hari = 0;
      });
      debugPrint('Gagal menghitung umur kehamilan: $e');
    }
  }

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0:
        return DashboardPage(
          minggu: minggu,
          hari: hari,
        );
      case 1:
        return const ListKehamilanPage();
      case 2:
        return const EdukasiHomePage();
      case 3:
        return PemantauanScreen(mingguKehamilan: minggu);
      case 4:
        return const ProfilScreen();
      default:
        return const Center(child: Text("Page Not Found"));
    }
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: isSelected
          ? BoxDecoration(
              color: const Color(0xff5B37B7),
              borderRadius: BorderRadius.circular(20),
            )
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey,
          ),
          if (isSelected) ...[
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(),
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_icons.length, (index) {
              return GestureDetector(
                onTap: () => _onItemTapped(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: _buildNavItem(
                    _icons[index],
                    _labels[index],
                    index,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
