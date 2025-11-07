import 'package:flutter/material.dart';

class RiwayatKehadiranScreen extends StatelessWidget {
  const RiwayatKehadiranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // bawah putih aja
      body: SafeArea(
        child: Column(
          children: [
            // 🌈 box atas dengan gradient + motif
            Container(
              width: double.infinity,
              height: 200, // tinggi header
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1485C7),
                    Color.fromARGB(255, 255, 255, 255),
                  ],
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/motif 2.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              child: const Center(
                child: Text(
                  'Riwayat Kehadiran',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // 🧾 daftar riwayat di bawah (scrollable)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 6,
                itemBuilder: (context, index) {
                  final data = [
                    {
                      "hari": "Hari Ini",
                      "tanggal": "09/06/2025",
                      "status": "Hadir",
                    },
                    {
                      "hari": "Kemarin",
                      "tanggal": "08/06/2025",
                      "status": "Tidak Hadir",
                    },
                    {
                      "hari": "Kamis",
                      "tanggal": "07/06/2025",
                      "status": "Hadir",
                    },
                    {
                      "hari": "Rabu",
                      "tanggal": "06/06/2025",
                      "status": "Hadir",
                    },
                    {
                      "hari": "Selasa",
                      "tanggal": "05/06/2025",
                      "status": "Hadir",
                    },
                    {
                      "hari": "Senin",
                      "tanggal": "04/06/2025",
                      "status": "Hadir",
                    },
                  ];
                  final item = data[index];
                  final hadir = item["status"] == "Hadir";

                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(item["hari"]!),
                          content: Text(
                            'Tanggal: ${item["tanggal"]}\nStatus: ${item["status"]}',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Tutup'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade50.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["hari"]!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(item["tanggal"]!),
                            ],
                          ),
                          Text(
                            item["status"]!,
                            style: TextStyle(
                              color: hadir ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
