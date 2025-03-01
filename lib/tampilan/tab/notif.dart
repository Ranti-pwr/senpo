import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gocrane_v3_new/tampilan/SlideRightRoute.dart';
import 'package:gocrane_v3_new/tampilan/menu/orderan_berjalan/map.dart';
import 'package:gocrane_v3_new/tampilan/menu/orderan_berjalan/oderan_berjalan.dart';
import 'package:gocrane_v3_new/tampilan/menu/orderan_berjalan/order_detail2.dart';

import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';
import 'dart:isolate';
import 'dart:ui';

import 'package:url_launcher/url_launcher.dart';

class notifList extends StatefulWidget {
  const notifList({required this.notif_list});
  final List? notif_list;
  @override
  _notifListState createState() => _notifListState();
}

class _notifListState extends State<notifList> {
  // void updateWidget() {
  //   setState(() {
  //     indikator = MyStepperWidget_3();
  //     btn = "Lanjut Cetak Bukti";
  //     tombol_riset = false;
  //     konten = pilihpekerjaan();
  //   });
  // }

  //
  DateTime currentDate = new DateTime.now();
  var dateVal;
  var now = new DateTime.now();
  Future<void> openDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != currentDate) {
      setState(() {
        dateVal = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController tgllahirController = TextEditingController();

  String? nama_user;
  String? alamat_;
  String? nowa;
  String? id_user = "";
  String? image_profil;
  String? unit_list = "n";

  // ignore: unused_field
  final ReceivePort _port = ReceivePort();

  void downloadFile() async {
    var fileUrl =
        'http://103.27.206.23/decpetro/document/1683944847159_230513093901_22176211.pdf';
    var fileName = 'coba';
    var response = await http.get(Uri.parse(fileUrl));
    if (response.statusCode == 200) {
      var bytes = response.bodyBytes;
      var directory = await getExternalStorageDirectory();
      var filePath = '${directory!.path}/${fileName}.pdf';
      await File(filePath).writeAsBytes(bytes);
    }
  }

  void sendWhatsAppMessage(String phoneNumber, String message) async {
    String url = 'https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Tidak dapat membuka WhatsApp';
    }
  }

  List card = [
    {
      "no_order": "230411142931",
      "lokasi": "coba",
      "Unit": "CRN 25",
      "PIC": "coba",
      "no_ext": "12345",
      "keterangan": "Konfirmasi Candal",
      "status": "c"
    },
    {
      "no_order": "230411142931",
      "lokasi": "coba",
      "Unit": "CRN 25",
      "PIC": "coba",
      "no_ext": "12345",
      "keterangan": "Menunggu Persetujuan Alber",
      "status": "n"
    },
    {
      "no_order": "230411142931",
      "lokasi": "coba",
      "Unit": "CRN 25",
      "PIC": "coba",
      "no_ext": "12345",
      "keterangan": "Disetujui Evaluator Alber",
      "status": "a"
    },
    {
      "no_order": "230411142931",
      "lokasi": "coba",
      "Unit": "CRN 25",
      "PIC": "coba",
      "no_ext": "12345",
      "keterangan": "Start by Driver",
      "status": "f"
    },
    // {
    //   "no_order": "230411142931",
    //   "lokasi": "coba",
    //   "Unit": "CRN 25",
    //   "PIC": "coba",
    //   "no_ext": "12345",
    //   "keterangan": "Closed by Evaluator Alber",
    //   "status": "s"
    // }
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case "disetujui_evaluator_alber":
        return Colors.blue; // Warna untuk status 1
      case "menunggu_persetujuan_evaluator_alber":
        return Colors.amber; // Warna untuk status 2
      case "konfirmasi_candal":
        return Colors.red; // Warna untuk status 3
      case "start_by_driver":
        return const Color(0xFF2AB2A2); // Warna untuk status 4
      case "closed_by_evaluator_alber":
        return Colors.white; // Warna untuk status 5
      default:
        return Colors.white; // Warna default jika status tidak cocok
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case "disetujui_evaluator_alber":
        return "Disetujui Evaluator Alber"; // Warna untuk status 1
      case "menunggu_persetujuan_evaluator_alber":
        return "Menunggu Persetujuan Alber"; // Warna untuk status 2
      case "konfirmasi_candal":
        return "Konfirmasi Candal"; // Warna untuk status 3
      case "start_by_driver":
        return "Start by Driver"; // Warna untuk status 4
      case "closed_by_evaluator_alber":
        return "Closed by Bvaluator Alber"; // Warna untuk status 5
      default:
        return ""; // Warna default jika status tidak cocok
    }
  }

  //////////////////////////////////////////////////////
  List? dataOrder;
  Future OrderBerjalan() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('usr_id'));
    final Response = await http.post(
        Uri.parse("http://103.27.206.23/api_gocrane_v3/user_notifList.php"),
        body: {"id_usr": id_user});

    setState(() {
      if (Response.body == "false") {
        print("null");
      } else {
        dataOrder = jsonDecode(Response.body);
      }
      // gambar = datajson[0]['faskes_foto'];
    });
  }

  MediaQueryData? queryData;

  @override
  void initState() {
    // indikator = MyStepperWidget();
    // btn = "Lanjut Pilih Unit";
    // tombol_riset = false;
    // konten = formwaktu();
    // lihatprofil();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return MediaQuery(
      data: queryData!.copyWith(textScaleFactor: 1.0),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            child: Column(
              children: [
                //Appbar
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    height: 50,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        //back btn
                        Positioned.directional(
                          textDirection: Directionality.of(context),
                          start: 5,
                          top: 10,
                          bottom: 0,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                "assets/icons/ic_back.png",
                                scale: 15,
                              ),
                            ),
                          ),
                        ),
                        //title
                        Positioned.directional(
                          textDirection: Directionality.of(context),
                          top: 0,
                          bottom: 0,
                          start: 0,
                          end: 0,
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              "Notifikasi",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'inter',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // indikator,
                const SizedBox(
                  height: 10,
                ),

                Expanded(
                  child: ListView.builder(
                      itemCount: widget.notif_list == null
                          ? 0
                          : widget.notif_list?.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              // indikator = MyStepperWidget_3();
                              // btn = "Lanjut Cetak Bukti";
                              // tombol_riset = true;
                              // konten = pilihpekerjaan();
                              // unit_list = "n";
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Card(
                              elevation: 5,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        ListTile(
                                          title: Text(_getStatusText(widget
                                              .notif_list?[index]["category"])),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                SlidePageRoute(
                                                    page: order_berjalan()));
                                          },
                                          trailing: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: widget.notif_list?[index]
                                                            ["count"] ==
                                                        "0"
                                                    ? Colors.transparent
                                                    : widget.notif_list?[index]
                                                                ["category"] ==
                                                            "closed_by_evaluator_alber"
                                                        ? Colors.black
                                                        : Colors
                                                            .transparent, // Ganti dengan warna yang diinginkan
                                                width:
                                                    1, // Ganti dengan lebar yang diinginkan
                                              ),
                                              shape: BoxShape.circle,
                                              color: widget.notif_list?[index]
                                                          ["count"] ==
                                                      "0"
                                                  ? Colors.transparent
                                                  : _getStatusColor(
                                                      widget.notif_list?[index]
                                                          ["category"]),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                widget.notif_list?[index]
                                                    ["count"],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: widget.notif_list?[
                                                              index]["count"] ==
                                                          "0"
                                                      ? Colors.transparent
                                                      : widget.notif_list?[
                                                                      index][
                                                                  "category"] ==
                                                              "closed_by_evaluator_alber"
                                                          ? Colors.black
                                                          : Colors.white,
                                                  fontSize: 15,
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        /////////////////////////////

                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
}
