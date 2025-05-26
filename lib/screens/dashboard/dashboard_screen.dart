import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/models/Kehamilan.dart';
import 'package:posyandu_mob/core/services/KehamilanService.dart';
import 'package:posyandu_mob/core/viewmodel/profile_viewmodel.dart';
import 'package:posyandu_mob/screens/dashboard/EdukasiCard.dart';
import 'package:posyandu_mob/core/services/artikel_service.dart';
import 'package:provider/provider.dart';
import 'package:posyandu_mob/core/models/Artikel.dart';
import 'package:posyandu_mob/core/services/jadwal_service.dart';
import 'package:posyandu_mob/core/models/Jadwal.dart';
import 'notification_page.dart';
import 'grafik_bb.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  List<Artikel> highlightArtikels = [];
  List<Artikel> allArtikels = [];
  List<Artikel> artikels = [];
  List<Jadwal> jadwalPemeriksaan = [];
  int selectedKategoriId = 0;
  bool isLoading = true;
  bool _isExpanded = false;
  String? nama;
  DateTime? selectedJadwal;
  File? localImg;
  late List<Kehamilan> kehamilanData = [];

  String formatJamMenit(String jam) {
    try {
      DateTime time = DateFormat("HH:mm:ss").parse(jam);
      return DateFormat("HH:mm").format(time);
    } catch (e) {
      return jam;
    }
  }

  Future<void> _loadKehamilanData() async {
    try {
      final pemeriksaanService = KehamilanService();

      List<Kehamilan> localData = await UserDatabase().getAllKehamilan();
      if (localData.isNotEmpty) {
        setState(() {
          kehamilanData = localData;
          isLoading = false;
        });
      } else {
        List<Kehamilan> remoteData = await pemeriksaanService.dataKehamilan();
        setState(() {
          kehamilanData = remoteData;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error load kehamilan data: $e");
    }
  }

  Future<void> _checkImage() async {
    final authProvider = Provider.of<ProfilViewModel>(context, listen: false);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/profile.jpg');

    if (await file.exists()) {
      setState(() {
        localImg = file;
      });
    } else {
      final url = await authProvider.checkImage();
      setState(() {
        localImg = File(url);
      });
    }
  }

  bool isPemeriksaan(DateTime date) {
    for (var jadwal in jadwalPemeriksaan) {
      DateTime jadwalDate = DateTime.parse(jadwal.tanggal);
      if (jadwalDate.year == date.year &&
          jadwalDate.month == date.month &&
          jadwalDate.day == date.day) {
        return true;
      }
    }
    return false;
  }

  List<Widget> generateKalender(DateTime today) {
    DateTime mingguIni = today.subtract(Duration(days: today.weekday - 1));

    List<Widget> kalenderRow = List.generate(7, (i) {
      DateTime tanggal = mingguIni.add(Duration(days: i));
      bool isToday = tanggal.day == today.day &&
          tanggal.month == today.month &&
          tanggal.year == today.year;

      bool adaJadwal = isPemeriksaan(tanggal);
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: isToday ? Border.all(color: Colors.blue, width: 2) : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  DateFormat.E('id_ID').format(tanggal).substring(0, 1),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${tanggal.day}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (adaJadwal) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 243, 33, 33),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      );
    });

    return kalenderRow;
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int currentPage = _pageController.page?.toInt() ?? 0;
      if (selectedKategoriId != currentPage) {
        setState(() {
          selectedKategoriId = currentPage;
        });
      }
    });
    _getUser();
    _checkImage();
    fetchArtikels();
    fetchJadwal();
    _loadKehamilanData();
  }

  Future<void> _getUser() async {
    dynamic user = await UserDatabase().readUser();

    if (user != null) {
      setState(() {
        nama = user.anggota.nama ?? '';
      });
    } else {
      throw ("object not found");
    }
  }

  Future<void> fetchArtikels() async {
    try {
      final fetched = await ArtikelService().fetchArtikel();
      setState(() {
        allArtikels = fetched;
        highlightArtikels =
            fetched.length > 4 ? fetched.take(4).toList() : fetched;
        artikels = fetched;
        isLoading = false;
      });
    } catch (_) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat data artikel')),
      );
    }
  }

  Future<void> fetchJadwal() async {
    try {
      List<Jadwal> fetchedJadwal = await JadwalService().fetchJadwal();
      setState(() {
        jadwalPemeriksaan = fetchedJadwal;
      });
    } catch (e) {
      print("Error fetching jadwal: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    String formattedDate =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(today);

    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 77, 129, 231),
              Colors.white,
            ],
            stops: [0.0, 0.3],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image(
                            image: (localImg != null &&
                                    localImg!.path.isNotEmpty)
                                ? FileImage(localImg!)
                                : const AssetImage('assets/images/picture.jpg')
                                    as ImageProvider,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nama ?? 'Nama User',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const Text(
                              'Selamat Datang di Posyandu!',
                              style: TextStyle(
                                color: Color.fromARGB(255, 39, 39, 39),
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          color: Colors.black,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationPage()),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 200,
                      child: highlightArtikels.isEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.article_outlined,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Tidak ada edukasi terbaru',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                  ],
                                ),
                              ),
                            )
                          : PageView.builder(
                              controller: _pageController,
                              itemCount: highlightArtikels.length,
                              itemBuilder: (context, index) {
                                return EdukasiCard(
                                    artikel: highlightArtikels[index]);
                              },
                            ),
                    ),
                    const SizedBox(height: 8),

                    if (highlightArtikels.isNotEmpty)
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children:
                              List.generate(highlightArtikels.length, (index) {
                            return Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: selectedKategoriId == index
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                            );
                          }),
                        ),
                      ),
                    const SizedBox(height: 24),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jadwal Pemeriksaan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Jangan Lewatkan pemeriksaan kehamilan secara rutin.',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 12),
                        ],
                      ),
                    ),

                    //
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue.shade100),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            formattedDate,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: generateKalender(today),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                                selectedJadwal = jadwalPemeriksaan.isNotEmpty
                                    ? DateTime.parse(
                                        jadwalPemeriksaan[0].tanggal)
                                    : null;
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              jadwalPemeriksaan.isNotEmpty
                                                  ? jadwalPemeriksaan[0].judul
                                                  : 'Tidak ada jadwal',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              jadwalPemeriksaan.isNotEmpty
                                                  ? '${formatJamMenit(jadwalPemeriksaan[0].jam_mulai)} - ${formatJamMenit(jadwalPemeriksaan[0].jam_selesai)} WIB'
                                                  : '-',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        _isExpanded
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                      ),
                                    ],
                                  ),
                                  AnimatedCrossFade(
                                    firstChild: SizedBox.shrink(),
                                    secondChild: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            jadwalPemeriksaan.isNotEmpty
                                                ? jadwalPemeriksaan[0].lokasi
                                                : 'Lokasi tidak tersedia',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            selectedJadwal != null
                                                ? DateFormat(
                                                        'EEEE, dd MMMM yyyy',
                                                        'id_ID')
                                                    .format(selectedJadwal!)
                                                : 'Tanggal belum tersedia',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    crossFadeState: _isExpanded
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                    duration: Duration(milliseconds: 300),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    //Grafik
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Grafik',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Pemantauan kehamilan dan peningkatan berat badan.',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 12),
                        ],
                      ),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(color: Colors.grey.shade100),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Berat Badan',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const GrafikBeratBadanPage(),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      child: const Text(
                                        'Lihat grafik',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
