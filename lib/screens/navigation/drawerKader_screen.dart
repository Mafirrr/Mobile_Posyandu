import 'package:flutter/material.dart';
import 'package:posyandu_mob/screens/pelayanan/jadwal_posyandu.dart';

class DrawerkaderScreen extends StatefulWidget {
  const DrawerkaderScreen({super.key});

  @override
  State<DrawerkaderScreen> createState() => _DrawerkaderScreenState();
}

class _DrawerkaderScreenState extends State<DrawerkaderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 50),
            ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/images/picture.jpg'),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Mafira", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 2),
                  Text("mafira@email.com",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            Expanded(
              child: ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("Home",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.home_outlined, color: Colors.blue),
                    title: Text("Dashboard"),
                    onTap: () {},
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("Data Pengguna",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    dense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                    leading: Icon(Icons.people, color: Colors.blue),
                    title: Text("Ibu Hamil"),
                    onTap: () {},
                  ),
                  ListTile(
                    dense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                    leading: Icon(Icons.person, color: Colors.blue),
                    title: Text("Bidan"),
                    onTap: () {},
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("Pelayanan Posyandu",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.calendar_month, color: Colors.blue),
                    title: Text("Jadwal Posyandu"),
                    onTap: () {
                      Navigator.pop(context); // Tutup drawer dulu
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JadwalPosyanduView()),
                      );
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading:
                        Icon(Icons.medical_information, color: Colors.blue),
                    title: Text("Pemeriksaan"),
                    onTap: () {},
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("Lainnya",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.menu_book, color: Colors.blue),
                    title: Text("Edukasi"),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  minimumSize: Size(double.infinity, 40),
                ),
                icon: Icon(Icons.power_settings_new, color: Colors.white),
                label: Text(
                  "LogOut",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Drawer Kader"),
      ),
      body: const Center(
        child: Text("Selamat Datang di Halaman Kader"),
      ),
    );
  }
}
