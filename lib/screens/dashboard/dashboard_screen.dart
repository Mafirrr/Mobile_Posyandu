import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/screens/dashboard/EdukasiCard.dart';
import 'package:posyandu_mob/core/services/artikel_service.dart';
import 'notification_dialog.dart';
import 'grafik_popup.dart';
import 'package:posyandu_mob/core/models/Artikel.dart';
import 'package:posyandu_mob/core/services/jadwal_service.dart';
import 'package:posyandu_mob/core/models/Jadwal.dart';

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

  String formatJamMenit(String jam) {
    try {
      DateTime time = DateFormat("HH:mm:ss").parse(jam);
      return DateFormat("HH:mm").format(time);
    } catch (e) {
      return jam;
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
    fetchArtikels();
    fetchJadwal();
  }

  Future<void> _getUser() async {
    dynamic user = await UserDatabase().readUser();

    if (user != null) {
      setState(() {
        nama = user.anggota.nama ?? '';
      });
    } else {
      print("object not found");
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
                          borderRadius: BorderRadius.circular(7),
                          child: Image.asset(
                            'assets/images/picture.jpg',
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
                              'Selamat Datang!',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          color: Colors.white,
                          onPressed: () {
                            showNotifikasiDialog(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: highlightArtikels.length,
                        itemBuilder: (context, index) {
                          return EdukasiCard(artikel: highlightArtikels[index]);
                        },
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Indicator
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(4, (index) {
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
                                    Text(
                                      'Normal',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: Colors.purple,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      '50.2 Kg',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: SizedBox(
                                    width: double.infinity, // Lebih lebar
                                    height:
                                        40, // Lebih tinggi agar tidak terlihat lancip
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const GrafikPopup(
                                            title: "Grafik Berat Badan",
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              6), // Sedikit membulat
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
