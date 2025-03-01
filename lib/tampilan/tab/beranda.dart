import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gocrane_v3_new/tampilan/SlideRightRoute.dart';
import 'package:gocrane_v3_new/tampilan/home.dart';
import 'package:gocrane_v3_new/tampilan/menu/buat_order/creatorder.dart';
import 'package:gocrane_v3_new/tampilan/menu/daftar_oprator/daftar_oprator.dart';
import 'package:gocrane_v3_new/tampilan/menu/galeri_unit/galeri_unit_list.dart';
import 'package:gocrane_v3_new/tampilan/menu/histori_order/histori_order.dart';
import 'package:gocrane_v3_new/tampilan/menu/orderan_berjalan/oderan_berjalan.dart';
import 'package:gocrane_v3_new/tampilan/menu/tagihan.dart/tagihan.dart';
import 'package:gocrane_v3_new/tampilan/tab/notif.dart';

// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:gocrane_v3/UI/posisi.dart';

import 'package:gocrane_v3_new/main.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'YourBillingScreen.dart';

class berandaPengguna extends StatefulWidget {
  @override
  _berandaPenggunaState createState() => _berandaPenggunaState();
}

class _berandaPenggunaState extends State<berandaPengguna> {
  //Tests Items

  //Tests Items
  //////////////////////////////////////////
  final List<String?> gambar = [
    'https://images.unsplash.com/photo-1586458995526-09ce6839babe?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=873&q=80',
    'https://media.istockphoto.com/id/1318258124/photo/yellow-heavy-duty-mobile-crane-parked-on-the-roadside.jpg?s=170667a&w=0&k=20&c=IyINXp8ZpEUFTojeb92FlE1H1f5_kZWF2thhuYUJN2A=',
    'https://media.istockphoto.com/id/862598472/photo/truck-crane.jpg?s=170667a&w=0&k=20&c=b5YBmqSurVWi9m71V-J3YyyZQH_zOM8Gw2FNqFGemrs='
  ];
  ///////////////////////////////////////////
  ScrollController? _scrollController;
  bool isTitle = false;
  Color _text = Colors.transparent;
  myfung() {
    _scrollController = ScrollController()
      ..addListener(
        () => _isAppBarExpanded
            ? _text != Colors.grey
                ? setState(
                    () {
                      _text = const Color.fromARGB(255, 31, 31, 31);
                      isTitle = true;
                      // _icon = Theme.of(context).textTheme.caption.color;
                      // theme= true;
                      print('setState is called');
                    },
                  )
                : {}
            : _text != Colors.transparent
                ? setState(() {
                    print('setState is called');
                    _text = Colors.transparent;
                    isTitle = false;
                    //_icon = Theme.of(context).textTheme.bodyText1.color;
                  })
                : {},
      );
  }

  bool locStatus = false;

  // final Geolocator geolocator = Geolocator();

// final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();

//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );

//   static const CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(37.43296265331129, -122.08832357078792),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);
/////////////////////////////////////////////////////////////////////////////////

  final picker = ImagePicker();

  // Future<void> _compressImage() async {
  //   if (_imageFile == null) {
  //     return;
  //   }
  //   final filePath = _imageFile.path;
  //   final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
  //   final splitted = filePath.substring?(0, (lastIndex));
  //   final outPath = "${splitted}_compressed.jpg";

  //   final compressedImage = await FlutterImageCompress.compressAndGetFile(
  //     filePath,
  //     outPath,
  //     quality: 50,
  //   );

  //   if (compressedImage != null) {
  //     setState(() {
  //       _imageFile = compressedImage;
  //     });
  //   }
  // }

////////////////////////////////////////////////////////////////////////////////
  Future<void> goToPosition() async {
    // if (this.mounted) {
    //   setState(() {
    //     Geolocator.getCurrentPosition(
    //       desiredAccuracy: LocationAccuracy.best,
    //     ).then((Position position) async {
    //       currentLocation = new LatLng(position.latitude, position.longitude);
    //       getaddress(position.latitude, position.longitude);
    //       CameraPosition position1 = CameraPosition(
    //         target: currentLocation,
    //         zoom: 16.0,
    //       );
    //       GoogleMapController controller = await _mapcontroller.future;
    //       controller.animateCamera(CameraUpdate.newCameraPosition(position1));
    //     }).catchError((e) {
    //       print(e);
    //     });
    //   });
    // }
  }

/////////////////////////////////////////////////////////////////////////////
  ///
  String? nama_pengguna;
  String? dep_nama;
  String? jumlah_order;
  String? jumlah_saldo;

  Future profil() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('usr_id'));

    final Response = await http.post(
        Uri.parse("http://103.27.206.23/api_gocrane_v3/profil.php"),
        body: {"id_usr": id_user});

    this.setState(() {
      var datajson = jsonDecode(Response.body);

      nama_pengguna = datajson['profile']?[0]["usr_name"];
      dep_nama = datajson['profile']?[0]["struk_nama"];
      jumlah_order = datajson['orderan']?[0]["order"];
      jumlah_saldo = datajson['jumlah_saldo'];
      dp_id = datajson['profile']?[0]["struk_id"];
      print(datajson);
    });
  }
/////////////////////////////////////////////////////////////////////////////

  String? jumlah_notif;
  List? notif_list;

  Future notif() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('usr_id'));

    final Response = await http.post(
        Uri.parse("http://103.27.206.23/api_gocrane_v3/notif_jumlah.php"),
        body: {"id": id_user});

    setState(() {
      var datajson = jsonDecode(Response.body);
      notif_list = datajson[0]['kategory'];
      jumlah_notif = datajson[0]['total'][0]["count"];
      print(datajson);
    });
  }

/////////////////////////////////////////////////////////////////////////////
  List<dynamic> data = [];
  List? datajson;
  String? chek = "";

  String? cek_absen;
  String? id_absen;

  // Future ambildata() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   id_user = (prefs.get('pegawai_id'));
  //   final Response = await http.post(
  //       Uri.parse("http://103.157.97.200/swa_absen/API/riwayat_absen.php"),
  //       body: {"pegawai_id": id_user == "" ? pegawaiid : id_user, "aksi": "1"});
  //   var _data = jsonDecode(Response.body);
  //   if (_data == false) {
  //     chek = "Belum Ada Data";

  //     this.setState(() {
  //       cek_absen = "0";
  //     });
  //   } else {
  //     this.setState(() {
  //       _masuk = _data[0]['check_in'] == null ? "-" : _data[0]['check_in'];
  //       _keluar = _data[0]['check_out'] == null ? "-" : _data[0]['check_out'];
  //       if (_data[0]['check_out'] != null) {
  //         cek_absen = "1";
  //       }
  //     });
  //   }
  // }

  //////////////////////////////////////////////////////////
  String? nama_user;
  String? alamat;
  String? nowa;
  String? id_user = "";
  String? image_profil;

  Future lihatprofil() async {
    final prefs = await SharedPreferences.getInstance();

    iduser = (prefs.get('usr_id')) as String?;
    final Response = await http.get(
        Uri.parse("http://103.157.97.200/richzspot/user/getData/$id_user"));
    var profil = jsonDecode(Response.body);
    this.setState(() {
      if (Response.body == "false") {
        print("null");
      } else {
        // nama_user = profil[0]['username'] ?? "";
        nama_user = profil['user_nama_lengkap'] ?? "";
        nowa = profil['user_no_telp'] ?? "";
        image_profil = profil['user_foto'];
      }
      // gambar = datajson[0]['faskes_foto'];
    });
  }

  // Future lihatprofil() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   id_user = (prefs.get('pegawai_id'));

  //   final Response = await http.post(
  //       Uri.parse("http://103.157.97.200/swa_absen/API/user_profil.php"),
  //       body: {"user_id": id_user == "" ? pegawaiid : id_user});
  //   var profil = jsonDecode(Response.body);
  //   this.setState(() {
  //     if (Response.body == "false") {
  //       print("null");
  //     } else {
  //       // nama_user = profil[0]['username'] ?? "";
  //       nama_user = profil[0]['user_nama_lengkap'] ?? "";
  //       nowa = profil[0]['id_dep'] ?? "";
  //     }

  //     // gambar = datajson[0]['faskes_foto'];
  //   });
  // }
  //////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////
  String? formatCurrency(String? value) {
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
    return currencyFormat.format(double.tryParse(value!) ?? 0);
  }

  @override
  void initState() {
    profil();
    notif();
    // lihatprofil();
    // ambildata();
    if (this.mounted) {
      // _getLocationPermission();
      // _getCurrentLocation();
      // _getpeta();
      // myfung();
    }

    super.initState();

    // _timeString? = _formatDateTime(DateTime.now());
    // Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    // super.initState();
    // // addMarkers();
    // _locationController.text = lat + lng;

    // lihatprofil();
    // ambildata();
    // ambildata();
    //  _pageController = PageController();
  }

  bool get _isAppBarExpanded {
    return _scrollController!.hasClients &&
        _scrollController!.offset > (188 - kToolbarHeight);
  }

  //
  Set<Marker> markers = Set();

  //  String? _locationMessage = '';

  // Future<void> getCurrentLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   setState(() {
  //     _locationMessage =
  //         'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
  //   });

  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);
  //   Placemark placemark = placemarks[0];

  //   setState(() {
  //     _locationMessage =
  //         'Alamat: ${placemark.name}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}, ${placemark.postalCode}';
  //   });
  // }

  String? getDateFormatted() {
    initializeDateFormatting('id_ID', null);
    String? formattedDate =
        DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now());
    return formattedDate;
  }

  final houseNumbController = new TextEditingController();
  final cityController = new TextEditingController();
  final districtController = new TextEditingController();
  String? _timeString;
  String? jam;
  String? _formatDatejam(DateTime datejam) {
    return DateFormat('HH:mm:ss').format(datejam);
  }

  String? _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String? formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString != null ? null : formattedDateTime;
    });
  }

  void _getjam() {
    final DateTime now = DateTime.now();
    final String? formattedDatejam = _formatDateTime(now);
    setState(() {
      jam = formattedDatejam;
    });
  }

  //
  bool isSave = false;
  checkChanged() {
    if (houseNumbController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        districtController.text.isNotEmpty) {
      setState(() {
        isSave = true;
      });
    } else {
      setState(() {
        isSave = false;
      });
    }
  }

  MediaQueryData? queryData;
  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return MediaQuery(
      data: queryData!.copyWith(textScaleFactor: 1.0),
      child: SafeArea(
        child: Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: const Color(0xff2ab2a2), // atur warna status bar
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    color: Color(0xff2ab2a2),
                  ),
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 50,
                    top: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              SlidePageRoute(
                                  page: notifList(notif_list: notif_list)));
                        },
                        child: Container(
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: 30,
                                              height: 30,
                                              child: const Icon(
                                                Icons.notifications_outlined,
                                                color: Color(0xfffdc75e),
                                                size: 37,
                                              ),
                                            ),
                                            Positioned.fill(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Container(
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        width: 15,
                                                        height: 15,
                                                        decoration:
                                                            const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              Color(0xfffdc75e),
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            jumlah_notif ?? "",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10,
                                                              fontFamily:
                                                                  "Inter",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: 94,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 94,
                                            height: 112,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                image: const DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                        "assets/imgs/ppc.jpg"))),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            nama_pengguna ?? "",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.06,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dep_nama ?? "",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.08,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  "Jumlah Order",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    letterSpacing: 0.05,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Text(
                                                      jumlah_order ?? "0",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontFamily: "Inter",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.08,
                                                      ),
                                                    ),
                                                    const Text(
                                                      " Order",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontFamily: "Inter",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.08,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Nominal",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    letterSpacing: 0.05,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Text(
                                                      jumlah_saldo == null
                                                          ? formatCurrency("0")
                                                              .toString()
                                                          : formatCurrency(
                                                                  jumlah_saldo)
                                                              .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xfffdc75e),
                                                        fontSize: 20,
                                                        fontFamily: "Inter",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.08,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
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
                      ),
                    ],
                  ),
                ),
                // Container(
                //   height: MediaQuery.of(context).size.height * 0.4,
                //   child: googleMap(context),
                // )

                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      CarouselSlider(
                        options: CarouselOptions(height: 160, autoPlay: true),
                        items: gambar.map((image) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(image ?? ""))),
                              );
                            },
                          );
                        }).toList(),
                      ),

                      //Homitel
                      Center(
                          child: Container(
                        height: 200,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            SlidePageRoute(page: buat_order()));
                                      },
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  image: const DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                          "assets/icons/mg1.png"))),
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              "Buat Order",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xff141414),
                                                fontSize: 14,
                                                letterSpacing: 0.07,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            SlidePageRoute(
                                                page: order_berjalan()));
                                      },
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  image: const DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                          "assets/icons/mg2.png"))),
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              "Order Berjalan",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xff141414),
                                                fontSize: 14,
                                                letterSpacing: 0.07,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            SlidePageRoute(
                                                page: histori_order()));
                                      },
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  image: const DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                          "assets/icons/mg3.png"))),
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              "Histori Order",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xff141414),
                                                fontSize: 14,
                                                letterSpacing: 0.07,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            SlidePageRoute(
                                                page: galeriunitlist()));
                                      },
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 41,
                                              height: 41,
                                              padding: const EdgeInsets.only(
                                                  left: 4,
                                                  right: 3,
                                                  top: 4,
                                                  bottom: 7),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 34,
                                                    height: 34,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        image: const DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: AssetImage(
                                                                "assets/icons/mg4.png"))),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              "Galeri Unit",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xff141414),
                                                fontSize: 14,
                                                letterSpacing: 0.07,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            SlidePageRoute(
                                                page: daftar_oprator()));
                                      },
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  image: const DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                          "assets/icons/mg5.png"))),
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              "Daftar Operator",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xff141414),
                                                fontSize: 14,
                                                letterSpacing: 0.07,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            SlidePageRoute(
                                                page: tagihan_page()));
                                      },
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  image: const DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                          "assets/icons/mg6.png"))),
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              "Tagihan",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xff141414),
                                                fontSize: 14,
                                                letterSpacing: 0.07,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                      const SizedBox(
                        height: 10,
                      ),
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: 16,
                      //   ),
                      //   alignment: Alignment.centerLeft,
                      //   child: Text(
                      //     "Lokasi Anda",
                      //     style: TextStyle(
                      //         fontSize: 18,
                      //         fontFamily: "medium",
                      //         color: Theme.of(context)
                      //             .accentTextTheme
                      //             .headline2
                      //             .color),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 10,
                      ),

                      // Row(
                      //   children: [
                      //     Container(
                      //       padding: EdgeInsets.symmetric(
                      //         horizontal: 16,
                      //       ),
                      //       child: Text(
                      //         lat ?? "",
                      //         style: TextStyle(
                      //             fontSize: 14,
                      //             fontFamily: "medium",
                      //             color: Theme.of(context)
                      //                 .accentTextTheme
                      //                 .headline3
                      //                 .color),
                      //       ),
                      //     ),
                      //     Container(
                      //       padding: EdgeInsets.symmetric(
                      //         horizontal: 16,
                      //       ),
                      //       child: Text(
                      //         lng ?? "",
                      //         style: TextStyle(
                      //             fontSize: 14,
                      //             fontFamily: "medium",
                      //             color: Theme.of(context)
                      //                 .accentTextTheme
                      //                 .headline3
                      //                 .color),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // RaisedButton(
                      //   child: Text("Absen"),
                      // ),
                      const SizedBox(
                        height: 10,
                      ),

                      //////////////////////////////////////////////////
                    ],
                  ),
                ),

                // Container(
                //   decoration: BoxDecoration(
                //       color: Theme.of(context).textTheme.subtitle2.color,
                //       borderRadius: BorderRadius.only(
                //         topLeft: Radius.circular(20),
                //         topRight: Radius.circular(20),
                //       )),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       //Space
                //       Container(
                //         height: 20,
                //         child: Stack(
                //           clipBehavior: Clip.none,
                //           children: [
                //             Positioned.directional(
                //                 textDirection: Directionality.of(context),
                //                 top: -10,
                //                 start: 0,
                //                 end: 0,
                //                 child: Container(
                //                   height: 40,
                //                   width: double.infinity,
                //                   decoration: BoxDecoration(
                //                       color: Theme.of(context)
                //                           .accentTextTheme
                //                           .bodyText1
                //                           .color,
                //                       borderRadius: BorderRadius.only(
                //                         topLeft: Radius.circular(20),
                //                         topRight: Radius.circular(20),
                //                       )),
                //                 )),
                //           ],
                //         ),
                //       ),
                //       //House number or Apartmant

                //       //City

                //       //District or Street
                //     ],
                //   ),
                // ),
                //Space

                //Basic health examination
                // Container(
                //   padding: EdgeInsets.symmetric(
                //     horizontal: 16,
                //   ),
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     "Lokasi Anda",
                //     style: TextStyle(
                //         fontSize: 18,
                //         fontFamily: "medium",
                //         color: Theme.of(context).accentTextTheme.headline2.color),
                //   ),
                // ),
                //Space

                //Space
                // SizedBox(
                //   height: 12,
                // ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Container(
                //       width: MediaQuery.of(context).size.width - 80,
                //       child: TextField(
                //         controller: _locationController,
                //         decoration: InputDecoration(
                //           hintText: "Keterangan Tempat",
                //         ),
                //       ),
                //     ),
                //     SizedBox(height: 16),
                //     ElevatedButton(
                //       onPressed: _getImage,
                //       child: Text("Pilih Gambar"),
                //     ),
                //   ],
                // ),

                //wrap////////////////////////////////////////////////////////////////////////////////////////////

                //Space
                // SizedBox(
                //   height: 20,
                // ),

                // //Space
                // SizedBox(
                //   height: 10,
                // ),
                // testItem(),
                // //Space
                // SizedBox(
                //   height: 20,
                // ),
                // //Our 4 categories check-up
                // Container(
                //   padding: EdgeInsets.symmetric(
                //     horizontal: 16,
                //   ),
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     "Our 4 categories check-up",
                //     style: TextStyle(
                //         fontSize: 18,
                //         fontFamily: "medium",
                //         color: Theme.of(context).accentTextTheme.headline2.color),
                //   ),
                // ),
                // //Space
                // SizedBox(
                //   height: 10,
                // ),
                // checkUpItem(),
                // //Space
                // SizedBox(
                //   height: 80,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Appbar
  Widget appBar() {
    return //Img
        Container(
      width: double.infinity,
      height: 188,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/imgs/libartry_img.jpg"))),
      child: Container(
        height: 50,
        padding: const EdgeInsets.only(left: 16, top: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //back btn
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.black),
                child: Image.asset(
                  "assets/icons/ic_back.png",
                  scale: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container verticalDivider() {
    return //Divider
        Container(
      height: 30,
      padding: const EdgeInsets.only(left: 25),
      child: const Row(
        children: [
          VerticalDivider(
            width: 2,
            thickness: 2,
            indent: 2,
            endIndent: 2,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

// class LocationAttendancePage extends StatefulWidget {
//   @override
//   _LocationAttendancePageState createState() => _LocationAttendancePageState();
// }

// class _LocationAttendancePageState extends State<LocationAttendancePage> {
//   GoogleMapController _mapController;
//   LatLng _currentPosition;
//   Marker _currentMarker;
//   TextEditingController _locationController;
//   File _image;

//   @override
//   void initState() {
//     super.initState();

//     // Mengambil posisi saat ini dan menginisialisasi marker
//     _getCurrentLocation().then((position) {
//       setState(() {
//         _currentPosition = position;
//         _currentMarker = Marker(
//           markerId: MarkerId("current_position"),
//           position: _currentPosition,
//         );
//       });
//     });

//     // Menginisialisasi controller untuk TextField lokasi
//     _locationController = TextEditingController();
//   }

//   void _moveCameraToCurrentPosition() {
//     if (_currentPosition != null) {
//       _mapController
//           .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//         target: _currentPosition,
//         zoom: 16.0,
//       )));
//     }
//   }

//   @override
//   void dispose() {
//     _locationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Absensi Lokasi"),
//       ),
//       body: Stack(
//         children: [
//           // Widget untuk menampilkan peta
//           GoogleMap(
//             onMapCreated: _onMapCreated,
//             initialCameraPosition: CameraPosition(
//               target:
//                   _currentPosition, // Gunakan posisi saat ini sebagai posisi awal peta
//               zoom: 15,
//             ),
//             markers: _currentMarker != null
//                 ? Set<Marker>.of([_currentMarker])
//                 : null, // Ubah dari Set menjadi Set.of
//           ),
//           // Widget untuk menampilkan keterangan lokasi dan tombol untuk memilih gambar
//           Positioned(
//             left: 16,
//             bottom: 16,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: MediaQuery.of(context).size.width - 80,
//                   child: TextField(
//                     controller: _locationController,
//                     decoration: InputDecoration(
//                       hintText: "Keterangan Tempat",
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: _getImage,
//                   child: Text("Pilih Gambar"),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Callback yang dipanggil saat peta selesai dibuat
//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//   }

//   // Fungsi untuk mengambil posisi saat ini menggunakan package geolocator
//   Future<LatLng> _getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     return LatLng(position.latitude, position.longitude);
//   }

//   // Fungsi untuk memilih gambar dari galeri menggunakan package image_picker
//   Future<void> _getImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print("Gambar tidak dipilih.");
//       }
//     });
//   }
// }
