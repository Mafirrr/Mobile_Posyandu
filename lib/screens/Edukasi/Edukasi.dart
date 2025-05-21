import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_mob/core/models/Artikel.dart';
import 'package:posyandu_mob/core/services/artikel_service.dart';
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
  String selectedKategori = 'Semua';
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
        highlightArtikels =
            fetched.length > 10 ? fetched.take(10).toList() : fetched;
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
        final matchesKategori = selectedKategori == 'Semua' ||
            artikel.kategoriEdukasi == selectedKategori;
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
                ),
              ),
            ),
            SafeArea(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : allArtikels.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 100),
                            child: Text(
                              'Tidak ada data artikel',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ),
                        )
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
                                    return EdukasiCard(
                                        artikel: highlightArtikels[index]);
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),
                              CategoryButtons(
                                allArtikels: allArtikels,
                                onKategoriSelected: (kategori) {
                                  selectedKategori = kategori;
                                  filterArtikels();
                                },
                              ),
                              const SizedBox(height: 24),
                              artikels.isEmpty
                                  ? const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 80),
                                      child: Center(
                                        child: Text(
                                          'Tidak ada artikel',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                      ),
                                    )
                                  : LatestArticleCard(artikels: artikels),
                              const SizedBox(height: 24),
                              TipsSection(),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
            ),
          ],
        ));
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
          // const CircleAvatar(
          //   radius: 22,
          //   backgroundImage: AssetImage('assets/images/picture.jpg'),
          // ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                onChanged: widget.onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Cari...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
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
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.broken_image),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryButtons extends StatefulWidget {
  final List<Artikel> allArtikels;
  final Function(String kategori) onKategoriSelected;

  const CategoryButtons({
    super.key,
    required this.allArtikels,
    required this.onKategoriSelected,
  });

  @override
  State<CategoryButtons> createState() => _CategoryButtonsState();
}

class _CategoryButtonsState extends State<CategoryButtons> {
  String selectedKategori = 'Semua';

  @override
  Widget build(BuildContext context) {
    final uniqueKategories = [
      'Semua',
      ...{
        for (var artikel in widget.allArtikels)
          if (artikel.kategoriEdukasi.isNotEmpty) artikel.kategoriEdukasi
      }.toList()
    ];

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: uniqueKategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final kategori = uniqueKategories[index];
          final isActive = kategori == selectedKategori;

          return OutlinedButton(
            onPressed: () {
              setState(() {
                selectedKategori = kategori;
              });
              widget.onKategoriSelected(kategori);
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: isActive
                  ? const Color.fromARGB(255, 66, 135, 255)
                  : Colors.white,
              side: const BorderSide(
                  color: Color.fromARGB(255, 124, 172, 255), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              kategori,
              style: TextStyle(
                color: isActive
                    ? Colors.white
                    : const Color.fromARGB(255, 66, 135, 255),
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
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
                      border: Border.all(
                          color: const Color(0xFFD7E6FF), width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Image.network(
                            artikel.gambar,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.broken_image),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('yyyy-MM-dd').format(
                                    artikel.createdAt ?? DateTime(1970)),
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
                                    fontSize: 12,
                                    color: Colors.black.withOpacity(0.7)),
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

class TipsSection extends StatefulWidget {
  const TipsSection({super.key});

  @override
  State<TipsSection> createState() => _TipsSectionState();
}

class _TipsSectionState extends State<TipsSection> {
  List<Artikel> tipsArtikels = [];

  @override
  void initState() {
    super.initState();
    fetchTipsArtikels();
  }

  Future<void> fetchTipsArtikels() async {
    try {
      final fetched = await ArtikelService().fetchArtikel();
      setState(() {
        tipsArtikels =
            fetched.where((artikel) => _isTipsArtikel(artikel.judul)).toList();
      });
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat data tips')),
      );
    }
  }

  bool _isTipsArtikel(String judul) {
    final tipsKeywords = [
      'tips',
      'panduan',
      'saran',
      'petunjuk',
      'cara',
      'informasi',
      'tutorial'
    ];

    return tipsKeywords.any((keyword) => judul.toLowerCase().contains(keyword));
  }

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
        tipsArtikels.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 80),
                child: Center(
                  child: Text(
                    'Tidak ada artikel tips',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
            : Container(
                height: 300,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: tipsArtikels.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final artikel = tipsArtikels[index];

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
                          border: Border.all(
                              color: const Color(0xFFD7E6FF), width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Image.network(
                                artikel.gambar,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.broken_image),
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                      child: CircularProgressIndicator());
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('yyyy-MM-dd').format(
                                        artikel.createdAt ?? DateTime(1970)),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    artikel.judul,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    artikel.isi,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black.withOpacity(0.7)),
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
    );
  }
}
