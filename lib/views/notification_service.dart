import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notif =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidInit,
    );

    await _notif.initialize(initSettings);

    const androidChannel = AndroidNotificationChannel(
      'cuti_channel',
      'Notifikasi Laporan Cuti',
      description: 'Notifikasi unduh laporan cuti',
      importance: Importance.high,
    );

    await _notif
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  static Future<void> showSuccess(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'cuti_channel',
      'Notifikasi Laporan Cuti',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notifDetails = NotificationDetails(android: androidDetails);

    await _notif.show(
      0,
      title,
      body,
      notifDetails,
    );
  }
}
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notif =
//       FlutterLocalNotificationsPlugin();

//   static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
//     'cuti_channel',
//     'Notifikasi Laporan Cuti',
//     description: 'Notifikasi unduh laporan cuti',
//     importance: Importance.high,
//   );

//   static Future<void> init() async {
//     const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const initSettings = InitializationSettings(android: androidInit);
//     await _notif.initialize(initSettings);

//     await _notif
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(_channel);

//     // Listen FCM messages saat app foreground
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       showFCMNotification(message);
//     });
//   }

//   // Menampilkan notifikasi lokal dari FCM
//   static Future<void> showFCMNotification(RemoteMessage message) async {
//     final notification = message.notification;
//     final android = message.notification?.android;

//     if (notification != null && android != null) {
//       const androidDetails = AndroidNotificationDetails(
//         'cuti_channel',
//         'Notifikasi Laporan Cuti',
//         importance: Importance.high,
//         priority: Priority.high,
//       );

//       const notifDetails = NotificationDetails(android: androidDetails);

//       await _notif.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         notifDetails,
//       );
//     }
//   }

//   // Untuk notifikasi lokal manual
//   static Future<void> showLocal(String title, String body) async {
//     const androidDetails = AndroidNotificationDetails(
//       'cuti_channel',
//       'Notifikasi Laporan Cuti',
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     const notifDetails = NotificationDetails(android: androidDetails);

//     await _notif.show(
//       0,
//       title,
//       body,
//       notifDetails,
//     );
//   }
// }