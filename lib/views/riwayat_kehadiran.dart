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
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Riwayat Kehadiran",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: "Poppins_Bold"
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
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text("Belum ada riwayat kehadiran", style: TextStyle(fontFamily: "Poppins_Regular")),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final data =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;

                            final tanggal = _parseTanggal(data['tanggal']);
                            final tanggalFormat = DateFormat(
                              'EEEE, dd MMM yyyy',
                              'id_ID',
                            ).format(tanggal);

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.fingerprint),
                                title: Text(
                                  tanggalFormat,
                                  style: const TextStyle(
                                    fontFamily: "Poppins_Medium",
                                  ),
                                ),
                                subtitle: Text(
                                  "Jam: ${data['jam']}",
                                  style: const TextStyle(
                                    fontFamily: "Poppins_Regular",
                                  ),
                                ),
                                trailing: Text(
                                  data['status'],
                                  style: TextStyle(
                                    color: _statusColor(data['status']),
                                    fontFamily: "Poppins_SemiBold",
                                    fontSize: 14,
                                  ),
                                ),
                              ),
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
