import 'package:flutter/material.dart';
import 'package:posyandu_mob/screens/profil/ProfilScreen.dart';
import 'package:posyandu_mob/widgets/custom_text.dart';

class NavAnggotaScreen extends StatefulWidget {
  const NavAnggotaScreen({Key? key}) : super(key: key);

  @override
  _NavAnggotaScreenState createState() => _NavAnggotaScreenState();
}

class _NavAnggotaScreenState extends State<NavAnggotaScreen> {
  int _selectedIndex = 0;

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
        return CustomText(text: "Beranda");
      case 1:
        return CustomText(text: "Pemeriksaan");
      case 2:
        return CustomText(text: "Edukasi");
      case 3:
        return const ProfilScreen();
      default:
        return const Center(child: Text("Page Not Found"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          _buildNavItem(Icons.home, "Beranda", 0),
          _buildNavItem(Icons.medication, "Pemeriksaan", 1),
          _buildNavItem(Icons.article, "Edukasi", 2),
          _buildNavItem(Icons.person, "Profil", 3),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ],
          ],
        ),
      ),
      label: "",
    );
  }
}
