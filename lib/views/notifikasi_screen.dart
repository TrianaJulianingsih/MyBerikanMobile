import 'package:flutter/material.dart';
import '../models/notifikasi_model.dart';

class NotifikasiScreen extends StatelessWidget {
  NotifikasiScreen({super.key});

  final List<NotifikasiModel> notifikasiList = [
    NotifikasiModel(
      judul: 'Cuti Disetujui',
      deskripsi: 'Pengajuan cuti kamu sudah disetujui oleh HRD.',
      tanggal: DateTime(2025, 11, 6, 10, 30),
      sudahDibaca: true,
    ),
    NotifikasiModel(
      judul: 'Cuti Ditolak',
      deskripsi: 'Pengajuan cuti kamu ditolak karena tidak memenuhi syarat.',
      tanggal: DateTime(2025, 11, 5, 14, 10),
    ),
    NotifikasiModel(
      judul: 'Pengajuan Cuti Baru',
      deskripsi: 'Pengajuan cuti baru telah dikirim untuk verifikasi.',
      tanggal: DateTime(2025, 11, 4, 9, 0),
    ),
  ];

  String formatTanggal(DateTime tanggal) {
    return "${tanggal.day.toString().padLeft(2, '0')}/"
        "${tanggal.month.toString().padLeft(2, '0')}/"
        "${tanggal.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 88,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1485C7), Color.fromARGB(255, 126, 203, 248)],
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/motif.png'),
                fit: BoxFit.cover,
                opacity: 0.93,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Notifikasi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: "Poppins_Bold",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notifikasiList.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final n = notifikasiList[index];
                return Card(
                  elevation: 1,
                  color: n.sudahDibaca ? Colors.grey.shade100 : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(
                      n.sudahDibaca
                          ? Icons.notifications_none
                          : Icons.notifications_active,
                      color: n.sudahDibaca ? Colors.grey : Colors.blue,
                      size: 30,
                    ),
                    title: Text(
                      n.judul,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: "Poppins_Bold",
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          n.deskripsi,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontFamily: "Poppins_Regular",
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          formatTanggal(n.tanggal),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: "Poppins_Regular",
                          ),
                        ),
                      ],
                    ),
                    trailing: n.sudahDibaca
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 22,
                          )
                        : const Icon(
                            Icons.circle,
                            color: Colors.blue,
                            size: 12,
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
