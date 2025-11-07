import 'package:myberikan/models/cuti_model.dart';

final List<CutiModel> dummyRiwayatCuti = [
  CutiModel(
    tanggalMulai: DateTime(2025, 01, 05),
    tanggalAkhir: DateTime(2025, 01, 07),
    alasan: 'Acara keluarga',
    bukti: 'assets/images/bukti1.png',
    status: 'Dipending',
  ),
  CutiModel(
    tanggalMulai: DateTime(2025, 01, 08),
    tanggalAkhir: DateTime(2025, 01, 09),
    alasan: 'Kepentingan pribadi',
    bukti: 'assets/images/bukti2.png',
    status: 'Dipending',
  ),
  CutiModel(
    tanggalMulai: DateTime(2025, 10, 20),
    tanggalAkhir: DateTime(2025, 10, 21),
    alasan: 'Menghadiri pernikahan keluarga',
    bukti: 'assets/images/bukti_cuti_wildan.jpg',
    status: 'Dipending',
  ),
  CutiModel(
    tanggalMulai: DateTime(2025, 9, 25),
    tanggalAkhir: DateTime(2025, 9, 27),
    alasan: 'Liburan bersama keluarga',
    bukti: 'assets/images/bukti_cuti_nur.png',
    status: 'Dipending',
  ),
];
