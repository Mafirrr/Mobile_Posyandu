import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/GrafikBB.dart';
import 'package:posyandu_mob/core/services/grafik_service.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';

class GrafikBeratBadanPage extends StatefulWidget {
  final String? anggotaId;

  const GrafikBeratBadanPage({
    Key? key,
    this.anggotaId
  }) : super(key: key);

  @override
  State<GrafikBeratBadanPage> createState() => _GrafikBeratBadanPageState();
}

class LinePainter extends CustomPainter {
  final Color color;
  final bool isDashed;

  LinePainter({required this.color, required this.isDashed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (isDashed) {
      double dashWidth = 3;
      double dashSpace = 2;
      double startX = 0;

      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, size.height / 2),
          Offset(startX + dashWidth, size.height / 2),
          paint,
        );
        startX += dashWidth + dashSpace;
      }
    } else {
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GrafikBeratBadanPageState extends State<GrafikBeratBadanPage> {
  final GrafikService _grafikService = GrafikService();

  bool isLoading = true;
  String? errorMessage;
  String? currentAnggotaId;

  List<FlSpot> titikHitam = [];
  Grafik? grafikData;
  final List<double> minggu = List.generate(41, (index) => index.toDouble());
  final List<double> underweightMin = List.generate(41, (index) {
    if (index <= 13) {
      return (index * 0.5 / 13);
    } else {
      return 0.5 + ((index - 13) * 12.0 / 27);
    }
  }).map((e) => double.parse(e.toStringAsFixed(2))).toList();

  final List<double> underweightMax = List.generate(41, (index) {
    if (index <= 13) {
      return (index * 2.0 / 13);
    } else {
      return 2.0 + ((index - 13) * 16.0 / 27);
    }
  }).map((e) => double.parse(e.toStringAsFixed(2))).toList();

  final List<double> normalMin = List.generate(41, (index) {
    if (index <= 13) {
      return (index * 0.5 / 13);
    } else {
      return 0.5 + ((index - 13) * 11.0 / 27);
    }
  }).map((e) => double.parse(e.toStringAsFixed(2))).toList();

  final List<double> normalMax = List.generate(41, (index) {
    if (index <= 13) {
      return (index * 2.0 / 13);
    } else {
      return 2.0 + ((index - 13) * 14.0 / 27);
    }
  }).map((e) => double.parse(e.toStringAsFixed(2))).toList();

  final List<double> overweightMin = List.generate(41, (index) {
    if (index <= 13) {
      return (index * 0.5 / 13);
    } else {
      return 0.5 + ((index - 13) * 6.5 / 27);
    }
  }).map((e) => double.parse(e.toStringAsFixed(2))).toList();

  final List<double> overweightMax = List.generate(41, (index) {
    if (index <= 13) {
      return (index * 2.0 / 13);
    } else {
      return 2.0 + ((index - 13) * 9.5 / 27);
    }
  }).map((e) => double.parse(e.toStringAsFixed(2))).toList();

  final List<double> obeseMin = List.generate(41, (index) {
    if (index <= 13) {
      return (index * 0.5 / 13);
    } else {
      return 0.5 + ((index - 13) * 4.5 / 27);
    }
  }).map((e) => double.parse(e.toStringAsFixed(2))).toList();

  final List<double> obeseMax = List.generate(41, (index) {
    if (index <= 13) {
      return (index * 2.0 / 13);
    } else {
      return 2.0 + ((index - 13) * 7.0 / 27);
    }
  }).map((e) => double.parse(e.toStringAsFixed(2))).toList();

  @override
  void initState() {
    super.initState();
    _loadGrafikData();
  }

  Future<void> _getCurrentUserId() async {
    if (widget.anggotaId != null) {
      currentAnggotaId = widget.anggotaId;
      return;
    }

    try {
      final UserDatabase userDb = UserDatabase();
      dynamic user = await userDb.readUser();

      if (user != null && user.anggota != null) {
        currentAnggotaId = user.anggota.id.toString();
      } else {
        throw Exception('User tidak ditemukan');
      }
    } catch (e) {
      throw Exception('Gagal mengambil data user: $e');
    }
  }

  Future<void> _loadGrafikData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      await _getCurrentUserId();

      if (currentAnggotaId == null) {
        throw Exception('ID Anggota tidak ditemukan');
      }

      final List<Grafik> grafikList = await _grafikService.getBeratBadanById(currentAnggotaId!);

      if (grafikList.isNotEmpty) {
        final grafik = grafikList.first;
        List<FlSpot> spots = [];
        for (var dataPoint in grafik.data) {
          if (dataPoint.berat != null) {
            spots.add(FlSpot(
                dataPoint.minggu.toDouble(),
                dataPoint.berat!
            ));
          }
        }

        setState(() {
          grafikData = grafik;
          titikHitam = spots;
          isLoading = false;
        });
      } else {
        setState(() {
          grafikData = null;
          titikHitam = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        grafikData = null;
        titikHitam = [];
        isLoading = false;
      });
    }
  }

  List<FlSpot> generateSpots(List<double> data) {
    int maxLength = data.length < minggu.length ? data.length : minggu.length;
    return List.generate(maxLength, (index) => FlSpot(minggu[index], data[index]));
  }

  Widget _buildLegend() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Keterangan :',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold
                )),
            const SizedBox(height: 12),
            _buildLegendItem(
              'Kurus',
              'IMT < 18.5',
              '12.5 - 18 kg',
              Colors.black,
              isDashed: true,
            ),
            const SizedBox(height: 8),
            _buildLegendItem(
              'Normal',
              'IMT 18.5 - 24.9',
              '11.5 - 16 kg',
              Colors.pink,
              isDashed: false,
            ),
            const SizedBox(height: 8),
            _buildLegendItem(
              'Overweight',
              'IMT 25.0 - 29.9',
              '7 - 11.5 kg',
              Colors.pink,
              isDashed: true,
            ),
            const SizedBox(height: 8),
            _buildLegendItem(
              'Obese',
              'IMT ≥ 30.0',
              '5 - 9 kg',
              Colors.green,
              isDashed: false,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle
                    )
                ),
                const SizedBox(width: 12),
                const Text('Kenaikan berat badan anda'),
              ],
            ),
            if (grafikData != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text('Info Kehamilan', style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold
              )),
              const SizedBox(height: 8),
              Text('IMT: ${grafikData!.imt}'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String category, String imt, String weight, Color color, {required bool isDashed}) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 20,
          child: CustomPaint(
            painter: LinePainter(color: color, isDashed: isDashed),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                imt,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'Dengan rekomendasi kenaikan berat badan $weight',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive sizing
    double chartWidth = screenWidth > 800 ? 1000 : screenWidth * 2.5;
    double chartHeight = screenHeight > 600 ? 900 : screenHeight * 1.2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grafik Berat Badan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadGrafikData,
          ),
        ],
      ),
      body: Column(
        children: [
          if (isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                        width: chartWidth,
                        height: chartHeight,
                        child: LineChart(
                          LineChartData(
                            minX: 0,
                            maxX: 41,
                            minY: -3,
                            maxY: 23,
                            lineTouchData: LineTouchData(
                              enabled: true,
                              touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor: Colors.black87,
                                tooltipRoundedRadius: 8,
                                tooltipPadding: EdgeInsets.all(8),
                                tooltipMargin: 8,
                                getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                                  return touchedBarSpots.map((barSpot) {
                                    if (barSpot.barIndex == 8) {
                                      return LineTooltipItem(
                                        '${barSpot.y.toStringAsFixed(1)} KG',
                                        TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      );
                                    }
                                    return null;
                                  }).toList();
                                },
                              ),
                              touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {},
                              handleBuiltInTouches: true,
                              getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                                return spotIndexes.map((index) {
                                  if (barData.dotData.show == true) {
                                    return TouchedSpotIndicatorData(
                                      FlLine(
                                        color: Colors.transparent,
                                        strokeWidth: 0,
                                      ),
                                      FlDotData(
                                        show: true,
                                        getDotPainter: (spot, percent, barData, index) =>
                                            FlDotCirclePainter(
                                              radius: 6,
                                              color: Colors.black,
                                              strokeWidth: 3,
                                              strokeColor: Colors.white,
                                            ),
                                      ),
                                    );
                                  } else {
                                    return TouchedSpotIndicatorData(
                                      FlLine(color: Colors.transparent, strokeWidth: 0),
                                      FlDotData(show: false),
                                    );
                                  }
                                }).toList();
                              },
                            ),
                            titlesData: FlTitlesData(
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)
                              ),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)
                              ),
                              bottomTitles: AxisTitles(
                                axisNameWidget: Text(
                                  'MINGGU',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                axisNameSize: 15,
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  reservedSize: 32,
                                  getTitlesWidget: (value, meta) {
                                    if (value % 1 == 0) {
                                      return Text(
                                          '${value.toInt()}',
                                          style: const TextStyle(fontSize: 10)
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                axisNameWidget: Text(
                                  'KG',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                axisNameSize: 15,
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                        '${value.toInt()}',
                                        style: const TextStyle(fontSize: 10)
                                    );
                                  },
                                ),
                              ),
                            ),
                            gridData: FlGridData(
                                show: true,
                                horizontalInterval: 1,
                                verticalInterval: 1
                            ),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: generateSpots(underweightMin),
                                isCurved: false,
                                color: Colors.black,
                                barWidth: 2,
                                dotData: FlDotData(show: false),
                                dashArray: [5, 5],
                              ),
                              LineChartBarData(
                                spots: generateSpots(underweightMax),
                                isCurved: false,
                                color: Colors.black,
                                barWidth: 2,
                                dotData: FlDotData(show: false),
                                dashArray: [5, 5],
                              ),
                              LineChartBarData(
                                spots: generateSpots(normalMin),
                                isCurved: false,
                                color: Colors.transparent,
                                barWidth: 2,
                                dotData: FlDotData(show: false),
                              ),
                              LineChartBarData(
                                spots: generateSpots(normalMax),
                                isCurved: false,
                                color: Colors.transparent,
                                barWidth: 2,
                                dotData: FlDotData(show: false),
                              ),
                              LineChartBarData(
                                spots: generateSpots(overweightMin),
                                isCurved: false,
                                color: Colors.pink,
                                barWidth: 2,
                                dotData: FlDotData(show: false),
                                dashArray: [5, 5],
                              ),
                              LineChartBarData(
                                spots: generateSpots(overweightMax),
                                isCurved: false,
                                color: Colors.pink,
                                barWidth: 2,
                                dotData: FlDotData(show: false),
                                dashArray: [5, 5],
                              ),
                              LineChartBarData(
                                spots: generateSpots(obeseMin),
                                isCurved: false,
                                color: Colors.transparent,
                                barWidth: 2,
                                dotData: FlDotData(show: false),
                              ),
                              LineChartBarData(
                                spots: generateSpots(obeseMax),
                                isCurved: false,
                                color: Colors.transparent,
                                barWidth: 2,
                                dotData: FlDotData(show: false),
                              ),
                              LineChartBarData(
                                spots: titikHitam,
                                isCurved: false,
                                color: Colors.transparent,
                                barWidth: 3,
                                dotData: FlDotData(
                                  show: titikHitam.isNotEmpty,
                                  getDotPainter: (spot, percent, barData, index) =>
                                      FlDotCirclePainter(
                                        radius: 4,
                                        color: Colors.black,
                                        strokeWidth: 2,
                                        strokeColor: Colors.white,
                                      ),
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.transparent,
                                ),
                              ),
                            ],
                            betweenBarsData: [
                              BetweenBarsData(
                                fromIndex: 6,
                                toIndex: 7,
                                color: Color.fromRGBO(0, 255, 0, 0.3),
                              ),
                              BetweenBarsData(
                                fromIndex: 2,
                                toIndex: 3,
                                color: Color.fromRGBO(255, 192, 203, 0.3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          _buildLegend(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}