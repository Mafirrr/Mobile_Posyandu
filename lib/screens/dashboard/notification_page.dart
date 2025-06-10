import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_mob/core/models/Jadwal.dart';
import 'package:posyandu_mob/core/services/notification_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationService _notificationService = NotificationService();
  List<Jadwal> _notifications = [];
  bool _isLoading = true;
  bool _isEligible = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _isEligible = await _notificationService.checkKehamilanStatus();

      if (_isEligible) {
        final dynamic notifications =
            await _notificationService.getJadwalNotifications();
        final List<Jadwal> allNotifications =
            List<Jadwal>.from(notifications ?? []);

        final filteredNotifications = allNotifications.where((jadwal) {
          try {
            final jadwalDate = DateTime.parse(jadwal.tanggal);
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final scheduleDay =
                DateTime(jadwalDate.year, jadwalDate.month, jadwalDate.day);
            final difference = scheduleDay.difference(today).inDays;

            return difference >= 0 && difference <= 30;
          } catch (e) {
            return false;
          }
        }).toList();

        filteredNotifications.sort((a, b) {
          try {
            final dateA = DateTime.parse(a.tanggal);
            final dateB = DateTime.parse(b.tanggal);
            return dateA.compareTo(dateB);
          } catch (e) {
            return 0;
          }
        });

        setState(() {
          _notifications = filteredNotifications;
        });
      }
    } catch (e) {
      print('Error loading notifications: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memuat notifikasi'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scheduleDay = DateTime(date.year, date.month, date.day);
    final difference = scheduleDay.difference(today).inDays;

    if (difference == 0) {
      return 'Hari ini';
    } else if (difference == 1) {
      return 'Besok';
    } else if (difference > 1 && difference <= 7) {
      return '$difference hari lagi';
    } else if (difference > 7) {
      return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    } else {
      return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    }
  }

  String _formatDateFromString(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final scheduleDay = DateTime(date.year, date.month, date.day);
      final difference = scheduleDay.difference(today).inDays;

      if (difference == 0) {
        return 'Hari ini';
      } else if (difference == 1) {
        return 'Besok';
      } else if (difference > 1 && difference <= 7) {
        return '$difference hari lagi';
      } else if (difference > 7) {
        return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
      } else {
        return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
      }
    } catch (e) {
      return dateString;
    }
  }

  Color _getTimeStatusColor(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final scheduleDay = DateTime(date.year, date.month, date.day);
      final difference = scheduleDay.difference(today).inDays;

      if (difference == 0) {
        return Colors.green.shade600;
      } else if (difference == 1) {
        return Colors.orange.shade600;
      } else if (difference <= 7) {
        return Colors.blue.shade600;
      } else {
        return Colors.grey.shade600;
      }
    } catch (e) {
      return Colors.grey.shade600;
    }
  }

  String _formatTime(String time) {
    try {
      final timeParts = time.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = timeParts[1];
      return '$hour:$minute';
    } catch (e) {
      return time;
    }
  }

  String _getDayName(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final formatter = DateFormat('EEEE', 'id_ID');
      return formatter.format(date);
    } catch (e) {
      return '';
    }
  }

  // Method untuk mendapatkan pesan reminder berdasarkan waktu
  String _getReminderMessage(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final scheduleDay = DateTime(date.year, date.month, date.day);
      final difference = scheduleDay.difference(today).inDays;

      if (difference == 0) {
        return 'Jangan lupa datang ke posyandu hari ini!';
      } else if (difference == 1) {
        return 'Siap-siap ya, jadwal posyandu besok!';
      } else if (difference <= 3) {
        return 'Jadwal posyandu sebentar lagi, siapkan diri ya!';
      } else if (difference <= 7) {
        return 'Jadwal posyandu minggu ini, catat tanggalnya!';
      } else {
        return 'Jadwal posyandu bulan ini, jangan sampai terlewat!';
      }
    } catch (e) {
      return 'Jadwal posyandu menanti Anda!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Notifikasi'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : !_isEligible
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Notifikasi tidak tersedia',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Anda tidak memiliki status kehamilan\nyang sedang dalam pemantauan',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : _notifications.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_none,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Belum ada jadwal',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Jadwal posyandu akan muncul di sini\nuntuk 30 hari ke depan',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadNotifications,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04,
                          vertical: 12,
                        ),
                        itemCount: _notifications.length,
                        itemBuilder: (context, index) {
                          final jadwal = _notifications[index];
                          final screenWidth = MediaQuery.of(context).size.width;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Card(
                              elevation: 3,
                              shadowColor: Colors.black26,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => _showNotificationDetail(jadwal),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(screenWidth * 0.045),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                      colors: [
                                        _getTimeStatusColor(jadwal.tanggal)
                                            .withOpacity(0.1),
                                        _getTimeStatusColor(jadwal.tanggal)
                                            .withOpacity(0.05),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Jadwal Posyandu ${_formatDateFromString(jadwal.tanggal)}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: screenWidth * 0.045,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                          SizedBox(height: screenWidth * 0.015),
                                          Text(
                                            _getReminderMessage(jadwal.tanggal),
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.035,
                                              color: Colors.grey.shade600,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: screenWidth * 0.035),

                                      // Divider
                                      Container(
                                        height: 1,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              _getTimeStatusColor(
                                                      jadwal.tanggal)
                                                  .withOpacity(0.3),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: screenWidth * 0.025),

                                      // Quick info dan Tap indicator - sejajar
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.025,
                                              vertical: screenWidth * 0.01,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getTimeStatusColor(
                                                      jadwal.tanggal)
                                                  .withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              '${_formatTime(jadwal.jam_mulai)} WIB',
                                              style: TextStyle(
                                                fontSize: screenWidth * 0.03,
                                                color: _getTimeStatusColor(
                                                    jadwal.tanggal),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Ketuk untuk detail lengkap',
                                                style: TextStyle(
                                                  fontSize: screenWidth * 0.03,
                                                  color: _getTimeStatusColor(
                                                      jadwal.tanggal),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(
                                                  width: screenWidth * 0.015),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: screenWidth * 0.024,
                                                color: _getTimeStatusColor(
                                                    jadwal.tanggal),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }

  void _showNotificationDetail(Jadwal jadwal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  _getTimeStatusColor(jadwal.tanggal).withOpacity(0.05),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Detail Jadwal Posyandu',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getTimeStatusColor(jadwal.tanggal),
                            ),
                            child: Text(
                              _formatDateFromString(jadwal.tanggal),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        'Judul',
                        jadwal.judul,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'Lokasi',
                        jadwal.posyandu!.nama,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'Hari',
                        _getDayName(jadwal.tanggal),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'Tanggal',
                        DateFormat('dd MMMM yyyy', 'id_ID')
                            .format(DateTime.parse(jadwal.tanggal)),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'Jam',
                        '${_formatTime(jadwal.jam_mulai)} - ${_formatTime(jadwal.jam_selesai)} WIB',
                      ),
                      if (jadwal.keterangan != null &&
                          jadwal.keterangan!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          'Keterangan',
                          jadwal.keterangan!,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Tutup',
                        style: TextStyle(
                          color: _getTimeStatusColor(jadwal.tanggal),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }
}
