import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:myberikan/data/dummy_riwayat.dart';
import 'package:myberikan/data/dummy_user.dart';
import 'package:myberikan/models/riwayat_model.dart';
import 'package:myberikan/models/user_model.dart';

class DashboardKaryawan extends StatefulWidget {
  DashboardKaryawan({super.key});
  @override
  State<DashboardKaryawan> createState() => _DashboardKaryawanState();
}

class _DashboardKaryawanState extends State<DashboardKaryawan> {
  final RiwayatCutiModel riwayat = dummyRiwayatCuti.first;
  final UserModel user = dummyUsers.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1485C7),
              Color.fromARGB(255, 194, 228, 247),
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              height: 330,
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  "assets/images/motif.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.notifications, color: Colors.white),
                      ),
                      Text(
                        "Selamat Datang!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        height: 188,
                        width: 382,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(104, 0, 0, 0),
                              offset: Offset(0, 7),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(30),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 35,
                                    backgroundImage: AssetImage(
                                      "assets/images/profile 1.png",
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.nama,
                                        style: TextStyle(
                                          fontSize: 21,
                                          fontFamily: "Poppins_SemiBold",
                                        ),
                                      ),
                                      Text(
                                        user.jabatan,
                                        style: TextStyle(
                                          fontFamily: "Poppins_Medium",
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text(
                                user.id,
                                style: TextStyle(
                                  fontFamily: "Poppins_Regular",
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildPieCard(
                            title: "Absensi",
                            sections: [
                              PieChartSectionData(
                                value: 75,
                                color: Color(0xFF1485C7),
                                showTitle: false,
                                radius: 25,
                              ),
                              PieChartSectionData(
                                value: 25,
                                color: const Color.fromARGB(255, 240, 236, 236),
                                showTitle: false,
                                radius: 25,
                              ),
                            ],
                          ),
                          _buildPieCard(
                            title: "Cuti",
                            sections: [
                              PieChartSectionData(
                                value: 80,
                                color: Color(0xFF1485C7),
                                showTitle: false,
                                radius: 25,
                              ),
                              PieChartSectionData(
                                value: 20,
                                color: const Color.fromARGB(255, 240, 236, 236),
                                showTitle: false,
                                radius: 25,
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
                      Container(
                        height: 77,
                        width: 380,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 0.5,
                            color: const Color.fromARGB(255, 222, 221, 221),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 3),
                              blurRadius: 2,
                              color: const Color.fromARGB(255, 222, 221, 221),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "Mengajukan cuti",
                                  style: TextStyle(
                                    fontFamily: "Poppins_SemiBold",
                                    fontSize: 15,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      "assets/icons/calendar-add.png",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Riwayat Pengajuan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins_Medium",
                        ),
                      ),
                      SizedBox(height: 10),
                      Stack(
                        children: [
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/motif 2.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: riwayat.user.cuti.length,
                            itemBuilder: (context, index) {
                              final cuti = riwayat.user.cuti[index];
                              return Card(
                                color: Color.fromARGB(
                                  255,
                                  168,
                                  241,
                                  255,
                                ).withOpacity(0.50),
                                child: ListTile(
                                  title: Text(
                                    cuti.alasan,
                                    style: TextStyle(
                                      fontFamily: "Poppins_Medium",
                                      fontSize: 13,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${cuti.tanggalMulai.day}/${cuti.tanggalMulai.month}/${cuti.tanggalMulai.year}",
                                    style: TextStyle(
                                      fontFamily: "Poppins_Regular",
                                      fontSize: 13,
                                    ),
                                  ),
                                  trailing: Text(
                                    cuti.status,
                                    style: TextStyle(
                                      color: cuti.status == "Disetujui"
                                          ? Colors.green
                                          : Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins_SemiBold",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieCard({
    required String title,
    required List<PieChartSectionData> sections,
  }) {
    final double progressValue = sections.isNotEmpty ? sections.first.value : 0;

    return Container(
      height: 189,
      width: 166,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 0.2),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 90,
              width: 90,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sections: sections,
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                    ),
                  ),
                  Text(
                    '${progressValue.toInt()}%',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Poppins_SemiBold",
                      color: Color(0xFF656464),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins_Medium",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
