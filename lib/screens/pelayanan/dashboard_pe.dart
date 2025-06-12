import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanKehamilan.dart';
import 'package:posyandu_mob/core/models/GrafikPengunjung.dart';
import 'package:posyandu_mob/core/services/dashboard_pe_service.dart';

class DashboardPe extends StatefulWidget {
  const DashboardPe({Key? key}) : super(key: key);

  @override
  State<DashboardPe> createState() => _DashboardPeState();
}

class _DashboardPeState extends State<DashboardPe> {
  final service = DashboardService();

  GrafikPemeriksaan? grafik;
  List<PemeriksaanKehamilan> riwayat = [];
  final Map<int, String> namaIbuMap = {};
  final Map<int, String> waktuMap = {};
  bool loading = true;
  bool error = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final g = await service.fetchGrafik();
      final r = await service.fetchRiwayat(
        namaIbuMap: namaIbuMap,
        waktuMap: waktuMap,
      );

      setState(() {
        grafik = g;
        riwayat = r;
        loading = false;
        error = false;
      });
    } catch (e) {
      print('ERROR FETCH: $e');
      setState(() {
        loading = false;
        error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isDesktop = screenSize.width > 1200;

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error || grafik == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: isTablet ? 80 : 60,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'Gagal memuat data.',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    loading = true;
                    error = false;
                  });
                  fetchData();
                },
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final values = grafik!.data.map((e) => e.toDouble()).toList();
    final minY = (values.reduce((a, b) => a < b ? a : b)) - 5;
    final maxY = (values.reduce((a, b) => a > b ? a : b)) + 10;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return RefreshIndicator(
            onRefresh: fetchData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              child: _buildContent(constraints, isTablet, isDesktop),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(
      BoxConstraints constraints, bool isTablet, bool isDesktop) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: _buildChartCard(constraints, isTablet, isDesktop),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: _buildHistoryCard(constraints, isTablet, isDesktop),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          _buildChartCard(constraints, isTablet, isDesktop),
          SizedBox(height: isTablet ? 32 : 24),
          _buildHistoryCard(constraints, isTablet, isDesktop),
        ],
      );
    }
  }

  Widget _buildChartCard(
      BoxConstraints constraints, bool isTablet, bool isDesktop) {
    final values = grafik!.data.map((e) => e.toDouble()).toList();
    final minY = (values.reduce((a, b) => a < b ? a : b)) - 5;
    final maxY = (values.reduce((a, b) => a > b ? a : b)) + 10;

    return Card(
      elevation: isTablet ? 4 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: Colors.blue,
                  size: isTablet ? 28 : 24,
                ),
                const SizedBox(width: 12),
                Text(
                  "Grafik Pengunjung",
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 24 : 16),
            _buildChart(constraints, isTablet, isDesktop, minY, maxY),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(BoxConstraints constraints, bool isTablet, bool isDesktop,
      double minY, double maxY) {
    final chartHeight = isDesktop ? 400.0 : (isTablet ? 350.0 : 300.0);
    final needsHorizontalScroll = constraints.maxWidth < 600;

    Widget chart = SizedBox(
      height: chartHeight,
      child: LineChart(
        LineChartData(
          minY: minY < 0 ? 0 : minY,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: grafik!.data
                  .asMap()
                  .entries
                  .map(
                    (e) => FlSpot(e.key.toDouble(), e.value.toDouble()),
                  )
                  .toList(),
              isCurved: false,
              barWidth: isTablet ? 4 : 3,
              color: Colors.blue,
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade600],
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.3),
                    Colors.blue.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: isTablet ? 6 : 4,
                    color: Colors.blue,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: isTablet ? 40 : 30,
                getTitlesWidget: (value, _) {
                  const months = [
                    'Jan',
                    'Feb',
                    'Mar',
                    'Apr',
                    'Mei',
                    'Jun',
                    'Jul',
                    'Agu',
                    'Sep',
                    'Okt',
                    'Nov',
                    'Des'
                  ];
                  final i = value.toInt();
                  if (i < 0 || i >= months.length) return const Text('');
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      months[i],
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: isTablet ? 50 : 40,
                interval: isTablet ? null : (maxY - (minY < 0 ? 0 : minY)) / 5,
                getTitlesWidget: (value, _) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      value.toInt().toString(),
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.right,
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              left: BorderSide(color: Colors.grey[300]!, width: 1),
              bottom: BorderSide(color: Colors.grey[300]!, width: 1),
              top: BorderSide.none,
              right: BorderSide.none,
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            drawHorizontalLine: true,
            horizontalInterval: (maxY - (minY < 0 ? 0 : minY)) / 5,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey[200]!,
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey[200]!,
                strokeWidth: 1,
              );
            },
          ),
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.white,
              tooltipRoundedRadius: 8,
              tooltipPadding: EdgeInsets.all(isTablet ? 12 : 8),
              tooltipMargin: 16,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  final value = touchedSpot.y.toInt();
                  const months = [
                    'Januari',
                    'Februari',
                    'Maret',
                    'April',
                    'Mei',
                    'Juni',
                    'Juli',
                    'Agustus',
                    'September',
                    'Oktober',
                    'November',
                    'Desember'
                  ];
                  final monthIndex = touchedSpot.x.toInt();
                  final monthName =
                      monthIndex >= 0 && monthIndex < months.length
                          ? months[monthIndex]
                          : 'Bulan ${monthIndex + 1}';

                  return LineTooltipItem(
                    '$monthName\n$value Pengunjung',
                    TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 16 : 14,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );

    if (needsHorizontalScroll) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 800,
          child: chart,
        ),
      );
    }

    return chart;
  }

  Widget _buildHistoryCard(
      BoxConstraints constraints, bool isTablet, bool isDesktop) {
    return Card(
      elevation: isTablet ? 4 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.history,
                  color: Colors.green,
                  size: isTablet ? 28 : 24,
                ),
                const SizedBox(width: 12),
                Text(
                  "Riwayat Pemeriksaan",
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 24 : 16),
            if (riwayat.isEmpty)
              _buildEmptyState(isTablet)
            else
              _buildHistoryTable(constraints, isTablet, isDesktop),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isTablet) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 48 : 32),
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: isTablet ? 80 : 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada riwayat pemeriksaan',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTable(
      BoxConstraints constraints, bool isTablet, bool isDesktop) {
    final needsHorizontalScroll = constraints.maxWidth < 800;

    Widget table = DataTable(
      headingRowHeight: isTablet ? 60 : 56,
      dataRowHeight: isTablet ? 60 : 56,
      headingTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: isTablet ? 16 : 14,
        color: Colors.grey[800],
      ),
      dataTextStyle: TextStyle(
        fontSize: isTablet ? 15 : 13,
        color: Colors.grey[700],
      ),
      columnSpacing: isTablet ? 24 : 16,
      horizontalMargin: isTablet ? 24 : 12,
      columns: [
        DataColumn(
          label: Expanded(
            child: Text(
              'Nama Ibu',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Jenis Pemeriksaan',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Tanggal',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Waktu',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Lokasi',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
      rows: riwayat.map((item) {
        final nama = namaIbuMap[item.id ?? 0] ?? 'Tidak Diketahui';
        final waktu = waktuMap[item.id ?? 0] ?? '-';
        final tanggal = item.tanggalPemeriksaan.toIso8601String().split('T')[0];

        return DataRow(
          cells: [
            DataCell(
              Container(
                constraints: BoxConstraints(maxWidth: isTablet ? 150 : 120),
                child: Text(
                  nama,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
            DataCell(
              Container(
                constraints: BoxConstraints(maxWidth: isTablet ? 180 : 140),
                child: Text(
                  item.jenisPemeriksaan,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
            DataCell(
              Text(
                _formatDate(tanggal),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            DataCell(
              Text(waktu),
            ),
            DataCell(
              Container(
                constraints: BoxConstraints(maxWidth: isTablet ? 150 : 120),
                child: Text(
                  "${item.tempatPemeriksaan}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );

    if (needsHorizontalScroll) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: table,
      );
    }

    return table;
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
