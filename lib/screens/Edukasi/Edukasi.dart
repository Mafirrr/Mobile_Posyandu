import 'package:flutter/material.dart';

void main() => runApp(const Edukasi());

class Edukasi extends StatelessWidget {
  const Edukasi({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Edukasi Ibu Hamil',
      home: EdukasiHomePage(),
    );
  }
}

class EdukasiHomePage extends StatelessWidget {
  const EdukasiHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HeaderSearch(),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return EdukasiCard(index: index);
                  },
                ),
              ),
              const SizedBox(height: 8),
              const CategoryButtons(),
              const LatestArticleCard(),
              const TipsSection(),
              const SizedBox(height: 80), // Space for bottom nav
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderSearch extends StatelessWidget {
  const HeaderSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage(
              'assets/images/picture.jpg',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
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
  final int index;
  const EdukasiCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'Edukasi ${index + 1}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class CategoryButtons extends StatelessWidget {
  const CategoryButtons({super.key});

  final List<String> categories = const [
    "Semua",
    "Makanan Sehat",
    "Aktivitas Fisik",
    "Perawatan",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isActive = index == 0;
          return OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: isActive ? const Color(0xFF1a3ea8) : Colors.white,
              side: const BorderSide(color: Color(0xFF1a3ea8), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              categories[index],
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF1a3ea8),
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
  const LatestArticleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD7E6FF), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              'assets/images/Edu.jpg',
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('17 Maret 2020', style: TextStyle(fontSize: 13, color: Colors.black87)),
                const SizedBox(height: 6),
                const Text(
                  'Manfaat Yoga untuk Ibu Hamil: Menjaga Kesehatan Fisik dan Mental',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  'Yoga untuk ibu hamil atau yoga prenatal adalah salah satu bentuk latihan...',
                  style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.7)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Baca Sekarang',
                  style: TextStyle(color: Color(0xFF1a3ea8), fontWeight: FontWeight.w600),
                ),
              ],
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
    {
      'image': 'assets/images/Edu.jpg',
      'title': 'Porsi Makan dan Minum',
    },
    {
      'image': 'assets/images/Edu.jpg',
      'title': 'Pentingnya Pemeriksaan',
    },
    {
      'image': 'assets/images/Edu.jpg',
      'title': 'Tanda-Tanda Kehamilan',
    },
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
          child: Text('Perhatikan hal-hal ini!', style: TextStyle(fontSize: 14)),
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
                  border: Border.all(color: const Color(0xFFD7E6FF), width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
