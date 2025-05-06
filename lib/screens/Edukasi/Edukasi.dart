import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_mob/core/models/Artikel.dart';
import 'package:posyandu_mob/core/models/Kategori.dart';
import 'package:posyandu_mob/core/services/artikel_service.dart';
import 'package:posyandu_mob/core/services/kategori_service.dart';
import 'package:posyandu_mob/screens/Edukasi/Detail_Edukasi.dart';

class EdukasiHomePage extends StatefulWidget {
  const EdukasiHomePage({super.key});

  @override
  State<EdukasiHomePage> createState() => _EdukasiHomePageState();
}

class _EdukasiHomePageState extends State<EdukasiHomePage> {
  final PageController _pageController = PageController();
  List<Artikel> artikels = [];
  List<Artikel> allArtikels = [];
  int selectedKategoriId = -1;
  String searchQuery = '';
  bool isLoading = true;
  List<Artikel> highlightArtikels = [];

  @override
  void initState() {
    super.initState();
    fetchArtikels();
  }

  Future<void> fetchArtikels() async {
    try {
      final fetched = await ArtikelService().fetchArtikel();
      setState(() {
        allArtikels = fetched;
        highlightArtikels = fetched.length > 10 ? fetched.take(10).toList() : fetched;
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

  void filterArtikels() {
    setState(() {
      artikels = allArtikels.where((artikel) {
        final matchesKategori = selectedKategoriId == -1 ||
            artikel.kategoriId == selectedKategoriId;
        final matchesSearch =
            artikel.judul.toLowerCase().contains(searchQuery.toLowerCase());
        return matchesKategori && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    HeaderSearch(
                      onSearchChanged: (value) {
                        searchQuery = value;
                        filterArtikels();
                      },
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
                    const SizedBox(height: 24),
                    CategoryButtons(onKategoriSelected: (id) {
                      selectedKategoriId = id;
                      filterArtikels();
                    }),
                    const SizedBox(height: 24),
                    LatestArticleCard(artikels: artikels),
                    const SizedBox(height: 24),
                    TipsSection(),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
      ),
    );
  }
}

// ---------------------- WIDGETS --------------------------

class HeaderSearch extends StatefulWidget {
  final Function(String) onSearchChanged;
  const HeaderSearch({super.key, required this.onSearchChanged});

  @override
  State<HeaderSearch> createState() => _HeaderSearchState();
}

class _HeaderSearchState extends State<HeaderSearch> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('assets/images/picture.jpg'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Colors.grey.shade300, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EdukasiCard extends StatelessWidget {
  final Artikel artikel;

  const EdukasiCard({super.key, required this.artikel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailEdukasi(artikel: artikel),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              artikel.gambar,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryButtons extends StatefulWidget {
  final Function(int kategoriId) onKategoriSelected;

  const CategoryButtons({super.key, required this.onKategoriSelected});

  @override
  State<CategoryButtons> createState() => _CategoryButtonsState();
}

class _CategoryButtonsState extends State<CategoryButtons> {
  int selectedKategoriId = -1;

  Future<List<Kategori>> _loadKategories() async {
    final data = await KategoriService().fetchKategori();
    return [Kategori(id: -1, nama: 'Semua', deskripsi: ''), ...data];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Kategori>>(
      future: _loadKategories(),
      builder: (context, snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text("Gagal memuat kategori"));
        }

        final categories = snapshot.data!;

        return Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final kategori = categories[index];
              final isActive = kategori.id == selectedKategoriId;

              return OutlinedButton(
                onPressed: () {
                  setState(() {
                    selectedKategoriId = kategori.id;
                  });
                  widget.onKategoriSelected(kategori.id);
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      isActive ? const Color(0xFF1a3ea8) : Colors.white,
                  side: const BorderSide(color: Color(0xFF1a3ea8), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  kategori.nama,
                  style: TextStyle(
                    color: isActive ? Colors.white : const Color(0xFF1a3ea8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class LatestArticleCard extends StatelessWidget {
  final List<Artikel> artikels;

  const LatestArticleCard({super.key, required this.artikels});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              'Artikel dan edukasi untuk Ibu Hamil',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: artikels.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final artikel = artikels[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailEdukasi(artikel: artikel),
                      ),
                    );
                  },
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD7E6FF), width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            artikel.gambar,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('yyyy-MM-dd').format(artikel.createdAt ?? DateTime(1970)),
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                artikel.judul,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                artikel.isi,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black.withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



class TipsSection extends StatelessWidget {
  const TipsSection({super.key});

  final List<Map<String, String>> tips = const [
    {'image': 'assets/images/Edu.jpg', 'title': 'Porsi Makan dan Minum'},
    {'image': 'assets/images/Edu.jpg', 'title': 'Pentingnya Pemeriksaan'},
    {'image': 'assets/images/Edu.jpg', 'title': 'Tanda-Tanda Kehamilan'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Tips Sehat untuk Ibu Hamil',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child:
              Text('Perhatikan hal-hal ini!', style: TextStyle(fontSize: 14)),
        ),
        Container(
          height: 180,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tips.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xFFD7E6FF), width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        tips[index]['image']!,
                        height: 120,
                        width: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        tips[index]['title']!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
