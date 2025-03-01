import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gocrane_v3_new/tampilan/SlideRightRoute.dart';
import 'package:gocrane_v3_new/tampilan/menu/orderan_berjalan/map.dart';
import 'package:gocrane_v3_new/tampilan/tab/beranda.dart';
import 'package:gocrane_v3_new/tampilan/tab/informasi.dart';
import 'package:gocrane_v3_new/tampilan/tab/profil.dart';
import 'package:gocrane_v3_new/tampilan/tab/schedule.dart';
import 'package:gocrane_v3_new/tampilan/tab/web_schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

int unreadNotificationCount = 0;
String? dp_id;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List? TabelWaktuOrder;
  String? judul, diskripsi, dataTran;
  String? nama_drever, noOrder, merkUnit;
  String? tglstart,
      tgland,
      pic,
      bagian,
      safetyPermits,
      kodeUnit,
      kapasitas,
      DetailPekerjaan,
      transaksi_nominal,
      lokasi;
  Future GetToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('usr_id'));
    await http.post(
        Uri.parse("http://103.27.206.23/api_gocrane_v3/token_user.php"),
        body: {
          "id_usr": id_user ?? "",
          "token": token,
        });
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> initNotifications() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future confgNotif() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initNotifications();
  }

  Future<void> onSelectNotification(String? payload) async {
    if (payload != null && payload == 'customData') {
      // Arahkan pengguna ke halaman tertentu, misalnya:
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => TargetPage()),
      // );
    }
  }

  Future lihatDetailOrder() async {
    final Response = await http.post(
        Uri.parse("http://103.27.206.23/api_gocrane_v3/data_transaksi.php"),
        body: {"id": dataTran, "paht": "o"});
    var data = jsonDecode(Response.body);
    print("${dataTran}<///data registrasi");
    this.setState(() {
      if (Response.body == "null") {
        print("null");
      } else {
        // nama_user = data[0]['username'] ?? ""; struk_id
        dp_id = data[0]['struk_id'] ?? "";

        nama_drever = data[0]['driver_nama'];
        noOrder = data[0]['transaksi_kode'];
        lokasi = data[0]['transaksi_lokasi'];
        safetyPermits = data[0]['transaksi_safety_permit'];
        merkUnit = data[0]['alber_merk'];
        DetailPekerjaan = data[0]['transaksi_jenis_barang'];
        tglstart = data[0]['transaksi_tanggal'] ?? "";
        tgland = data[0]['transaksi_tanggal_selesai'] ?? "";
        pic = data[0]['transaksi_pic'];
        bagian = data[0]['struk_detail_nama'];
        kodeUnit = data[0]['alber_kode'];
        kapasitas = data[0]['alber_kapasitas'];
        transaksi_nominal = data[0]['transaksi_nominal'];
      }
      // gambar = data[0]json[0]['faskes_foto'];
    });

    final Respon = await http.post(
        Uri.parse("http://103.27.206.23/api_gocrane_v3/data_transaksi.php"),
        body: {"id": dataTran, "paht": "od"});

    this.setState(() {
      if (Respon.body == "false") {
        print("null");
      } else {
        TabelWaktuOrder = jsonDecode(Respon.body);
      }
      // gambar = datajson[0]['faskes_foto'];
    });
  }

  void _showCustomDialog(BuildContext context) {
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 30,
        left: 30,
        right: 30,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  judul!,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  diskripsi!,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            SlidePageRoute(
                                page: GoogleMapScreen(id_reg: dataTran!)));
                        overlayEntry!.remove();
                      },
                      child: const Text('Detail',
                          style: TextStyle(color: Colors.white)),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue), // Warna latar belakang tombol
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(color: Colors.white), // Warna teks tombol
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                            Size(80, 36)), // Ukuran minimum tombol
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        overlayEntry!.remove();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.red), // Warna latar belakang tombol
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(color: Colors.white), // Warna teks tombol
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                            Size(80, 36)), // Ukuran minimum tombol
                      ),
                      child: const Text(
                        'Kembali',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  Future<void> _onSelectNotification(String payload) async {
    if (payload != null) {
      await Navigator.pushNamed(context, '/halaman_tujuan');
    }
  }

  void showDownloadNotification() {
    // Menggunakan platform channel untuk memanggil method native untuk menampilkan notifikasi
    const platform = MethodChannel('com.user.gocrane_v3');
    try {
      platform.invokeMethod('showNotification', {
        'title': 'Download Complete',
        'body': 'File berhasil diunduh.',
      });
    } on PlatformException catch (e) {
      print('Error showing notification: ${e.message}');
    }
  }

  Future<void> showNotification(String id) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.high,
      priority: Priority.high,
      sound: const RawResourceAndroidNotificationSound('notification_sound'),
      additionalFlags: Int32List.fromList(<int>[4]),
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      judul,
      diskripsi,
      platformChannelSpecifics,
      payload:
          'customData', // Data kustom yang akan digunakan untuk menentukan aksi
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        Navigator.push(
            context, SlidePageRoute(page: GoogleMapScreen(id_reg: dataTran!)));
      },
    );
  }

  TabController? tb;
  @override
  void initState() {
    super.initState();

    tb = TabController(length: 4, vsync: this);
    tb?.addListener(_handleTabSelection);

    FirebaseMessaging.instance.getToken().then((value) {
      GetToken(value!);
      print(value);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Aplikasi dibuka dari notifikasi: ${message.notification!.title}');
    });
    //  ketika notifikasi on terminet nam gerlk nag soon
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        print(value.data);
        print(value.notification);

        var dataTran = value.data['data'];

        Navigator.push(
            context, SlidePageRoute(page: GoogleMapScreen(id_reg: dataTran)));
      } else {}
    });
//ketika notifikasi backgroun
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (event != null) {
        print(event.data);
        print(event.notification);

        var dataTran = event.data['data'];

        Navigator.push(
            context, SlidePageRoute(page: GoogleMapScreen(id_reg: dataTran)));
      } else {}
    });

//ketika botifikasi fourgroun
    FirebaseMessaging.onMessage.listen((message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      setState(() {
        unreadNotificationCount +=
            1; // Tambah 1 ke jumlah notifikasi belum terbaca
      });

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        print(message.notification!.title);

        dataTran = message.data['data'];
        judul = message.data['title'];
        diskripsi = message.data['body'];
        _showCustomDialog(context);
      }
    });
  }

  void _handleTabSelection() {
    setState(() {});
  }

  // final theImage = Icon(icon);

  /// Did Change Dependencies
  // @override
  // void didChangeDependencies() {
  //   precacheImage(theImage.icone, context);
  //   super.didChangeDependencies();
  // }

  MediaQueryData? queryData;
  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return MediaQuery(
      data: queryData!.copyWith(textScaleFactor: 1.0),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            child: Column(
              children: [
                //
                Expanded(
                  child: TabBarView(
                      controller: tb,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        berandaPengguna(),
                        //schedule(),
                        WebViewApp(),
                        informasi(),
                        biodatapengguna(),
                        // absenmap(),
                        // MyTable(),
                        // // HomeScreen(),
                        // // ScheduleScreen(),
                        // // CommunityScreen(),
                        // // NotificationScreen(),
                        // ProfileScreen(),
                      ]),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            elevation: 4,
            child: Container(
              height: 60,
              padding: const EdgeInsets.only(left: 4),
              child: TabBar(
                  controller: tb,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  indicator: const UnderlineTabIndicator(
                    borderSide:
                        BorderSide(width: 0.0, color: Colors.transparent),
                  ),
                  tabs: [
                    Tab(
                      child: tb!.index == 0
                          ? tabItem1(context, 0, Icons.home, 10, "Beranda")
                          : tabItem(0, Icons.home, 20),
                    ),
                    Tab(
                      child: tb!.index == 1
                          ? tabItem1(
                              context, 0, Icons.calendar_today, 10, "Schedule")
                          : tabItem(1, Icons.calendar_today, 20),
                    ),
                    Tab(
                      child: tb!.index == 2
                          ? tabItem1(context, 0, Icons.info, 10, "Informasi")
                          : tabItem(2, Icons.info_outline, 20),
                    ),
                    // Tab(
                    //   child: tb.index == 3
                    //       ? tabItem1(
                    //           context, 0, "assets/icons/tab5.png", 10, "Pesan")
                    //       : tabItem(3, "assets/icons/ic_notification2.png", 20),
                    // ),
                    Tab(
                      child: tb?.index == 3
                          ? tabItem1(context, 0, Icons.person, 10, "Profil")
                          : tabItem(4, Icons.person_outlined, 18.0),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

Container tabItem1(context, int index, IconData icon, double sc, String title) {
  return Container(
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.directional(
          top: 0,
          start: 0,
          end: 0,
          textDirection: Directionality.of(context),
          child: Container(
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 26,
                  color: const Color(0xff2ab2a2),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff2ab2a2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

//1
Container tabItem(int index, IconData icon, double sc) {
  return Container(
    child: Icon(
      icon,
      size: 26,
      color: Colors.grey,
    ),
  );
}
