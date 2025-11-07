import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/cuti_model.dart';
import '../data/dummy_user.dart';
import 'detail_cuti_screen.dart';

const List<String> monthNames = [
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
  'Desember',
];

class VerifikasiCutiScreen extends StatefulWidget {
  const VerifikasiCutiScreen({super.key});

  @override
  State<VerifikasiCutiScreen> createState() => _VerifikasiCutiScreenState();
}

class _VerifikasiCutiScreenState extends State<VerifikasiCutiScreen> {
  String selectedTab = 'Verifikasi';
  String selectedMonth = monthNames[DateTime.now().month - 1];

  List<UserModel> getFilteredUsers() {
    return dummyUsers.where((user) {
      for (var c in user.cuti) {
        if (selectedTab == 'Verifikasi' && c.status == 'Dipending') return true;
        if (selectedTab == 'Riwayat' &&
            (c.status == 'Disetujui' || c.status == 'Ditolak')) {
          final bulan = monthNames[c.tanggalMulai.month - 1];
          if (bulan == selectedMonth) return true;
        }
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = getFilteredUsers();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 6),
            child: _buildTabRow(),
          ),
          Divider(color: Colors.grey.shade300, height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        selectedTab == 'Verifikasi'
                            ? 'Tidak ada cuti pending'
                            : 'Tidak ada riwayat untuk bulan $selectedMonth',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, idx) {
                        final user = filtered[idx];
                        CutiModel cuti;
                        if (selectedTab == 'Verifikasi') {
                          cuti = user.cuti.firstWhere(
                            (c) => c.status == 'Dipending',
                          );
                        } else {
                          cuti = user.cuti.firstWhere(
                            (c) =>
                                (c.status == 'Disetujui' ||
                                    c.status == 'Ditolak') &&
                                monthNames[c.tanggalMulai.month - 1] ==
                                    selectedMonth,
                          );
                        }
                        return _userCard(user, cuti);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 88,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1485C7),
            Color.fromARGB(255, 126, 203, 248),
          ],
        ),
        image: const DecorationImage(
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
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Verifikasi Cuti',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins_Bold",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _tabButton('Verifikasi'),
          const SizedBox(width: 20),
          _tabButton('Riwayat'),
          const Spacer(),
          if (selectedTab == 'Riwayat')
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: Colors.white,
                    value: selectedMonth,
                    items: monthNames
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() => selectedMonth = v);
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _tabButton(String label) {
    final active = selectedTab == label;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = label),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: active ? FontWeight.w800 : FontWeight.w500,
          color: active ? Colors.black : Colors.grey,
          fontSize: 18, 
        ),
      ),
    );
  }

  Widget _userCard(UserModel user, CutiModel cuti) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailCutiScreen(user: user, cuti: cuti),
          ),
        );
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(
                user.nama.contains('Intan') || user.nama.contains('Nur')
                    ? 'assets/images/image 2.png'
                    : 'assets/images/profile 1.png',
              ),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(user.id, style: const TextStyle(color: Colors.blue)),
                ],
              ),
            ),
            if (selectedTab == 'Riwayat')
              Text(
                cuti.status,
                style: TextStyle(
                  color: cuti.status == 'Disetujui' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
