import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myberikan/controllers/auth_absensi.dart';

class RiwayatKehadiranPage extends StatelessWidget {
  RiwayatKehadiranPage({super.key});

  final FirestoreServiceAbsensi _service = FirestoreServiceAbsensi();

  Color _statusColor(String s) {
    if (s == 'Hadir') return Colors.green;
    if (s == 'Tidak Hadir') return Colors.red;
    return Colors.orange;
  }

  DateTime _parseTanggal(dynamic raw) {
    try {
      if (raw is Timestamp) {
        return raw.toDate();
      }
      if (raw is String) {
        final cleaned = raw.replaceAll(RegExp(r'\.+$'), '');
        return DateTime.parse(cleaned);
      }
    } catch (_) {}
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1485C7),
              Color.fromARGB(255, 194, 228, 247),
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Opacity(
                  opacity: 0.6,
                  child: Image.asset(
                    "assets/images/motif.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Riwayat Kehadiran",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: "Poppins_Bold",
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _service.getRiwayatKehadiranByKaryawan(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        // =========================
                        // EMPTY STATE ESTETIK
                        // =========================
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /* Image.asset(
                                  "assets/images/1767188527998.png",
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                ), */
                                const SizedBox(height: 16),
                                const Text(
                                  "Belum ada riwayat kehadiran",
                                  style: TextStyle(
                                    fontFamily: "Poppins_Medium",
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Silakan lakukan check-in\nuntuk melihat riwayat Anda di sini.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Poppins_Regular",
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final docs = snapshot.data!.docs;

                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data =
                                docs[index].data() as Map<String, dynamic>;

                            final tanggal = _parseTanggal(data['tanggal']);
                            final lokasi =
                                data['lokasi'] ?? 'Lokasi tidak tersedia';

                            final bulanKey = DateFormat(
                              'MMMM yyyy',
                              'id_ID',
                            ).format(tanggal);

                            String? previousMonth;
                            if (index > 0) {
                              final prevData =
                                  docs[index - 1].data()
                                      as Map<String, dynamic>;
                              final prevDate = _parseTanggal(
                                prevData['tanggal'],
                              );
                              previousMonth = DateFormat(
                                'MMMM yyyy',
                                'id_ID',
                              ).format(prevDate);
                            }

                            final showMonthHeader =
                                index == 0 || bulanKey != previousMonth;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// HEADER BULAN
                                if (showMonthHeader)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 12,
                                      top: 8,
                                    ),
                                    child: Text(
                                      bulanKey,
                                      style: const TextStyle(
                                        fontFamily: "Poppins_SemiBold",
                                        fontSize: 16,
                                        color: Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),
                                      ),
                                    ),
                                  ),

                                /// CARD ITEM
                                Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF1485C7,
                                          ).withOpacity(0.15),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.fingerprint,
                                          color: Color(0xFF1485C7),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    DateFormat(
                                                      'EEEE, dd MMM yyyy',
                                                      'id_ID',
                                                    ).format(tanggal),
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          "Poppins_Medium",
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: _statusColor(
                                                      data['status'],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    data['status'],
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          "Poppins_SemiBold",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              "Jam: ${data['jam']}",
                                              style: const TextStyle(
                                                fontFamily: "Poppins_Regular",
                                                fontSize: 13,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  size: 14,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    lokasi,
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          "Poppins_Regular",
                                                      fontSize: 13,
                                                      color: Colors.black54,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
