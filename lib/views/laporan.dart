import 'package:flutter/material.dart';
import 'package:myberikan/data/dummy_user.dart';
import 'package:myberikan/extension/navigation.dart';
import 'package:myberikan/views/dashboard.dart';
import 'package:myberikan/models/user_model.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({Key? key}) : super(key: key);

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  late UserModel user;
  final TextEditingController judulController = TextEditingController();
  final TextEditingController tanggalMulaiController = TextEditingController();
  final TextEditingController tanggalSelesaiController =
      TextEditingController();

  bool showMessage = false;
  String messageText = "";
  Color messageColor = Colors.green;

  @override
  void initState() {
    super.initState();
    user = dummyUsers.firstWhere(
      (u) => u.jabatan.toLowerCase() == "hr",
      orElse: () => dummyUsers.first,
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  void _simpanLaporan() {
    if (judulController.text.isEmpty ||
        tanggalMulaiController.text.isEmpty ||
        tanggalSelesaiController.text.isEmpty) {
      setState(() {
        messageText = "Harap isi semua data terlebih dahulu";
        messageColor = Colors.redAccent;
        showMessage = true;
      });
    } else {
      setState(() {
        messageText = "Laporan telah tersimpan";
        messageColor = Colors.greenAccent;
        showMessage = true;
      });
    }

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showMessage = false;
        });
      }
    });
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.pop(DashboardScreen());
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 130),
                          child: Text(
                            "Laporan",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 35),
                    Text(
                      user.nama,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      user.jabatan,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "ID HR",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      readOnly: true,
                      controller: TextEditingController(text: user.id),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Judul",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: judulController,
                      decoration: InputDecoration(
                        hintText: "Masukkan judul laporan...",
                        filled: true,
                        fillColor: const Color.fromARGB(255, 243, 241, 241),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Tanggal Mulai:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: tanggalMulaiController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "hh/bb/tt",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () =>
                              _selectDate(context, tanggalMulaiController),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 243, 241, 241),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Tanggal Selesai:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: tanggalSelesaiController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "hh/bb/tt",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () =>
                              _selectDate(context, tanggalSelesaiController),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 243, 241, 241),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Tombol Simpan
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _simpanLaporan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007BFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          "Simpan",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (showMessage)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: messageColor,
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      messageText,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
