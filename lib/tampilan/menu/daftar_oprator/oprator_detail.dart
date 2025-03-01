import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';

class oprator_detail extends StatefulWidget {
  const oprator_detail({required this.id_pegawai, required this.id_driver});
  final String id_pegawai;
  final String id_driver;
  @override
  _oprator_detailState createState() => _oprator_detailState();
}

class _oprator_detailState extends State<oprator_detail> {
  // void updateWidget() {
  //   setState(() {
  //     indikator = MyStepperWidget_3();
  //     btn = "Lanjut Cetak Bukti";
  //     tombol_riset = false;
  //     konten = pilihpekerjaan();
  //   });
  // }
  String? jenis;
  List<dynamic> pilihjenis = [
    {
      "jenis_nama": "Laki-laki",
      "nilai": "L",
    },
    {
      "jenis_nama": "Perempuan",
      "nilai": "P",
    },
  ];

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
      } else {
        print('No image selected.');
      }
    });
  }

  int _waktuRating = 0;
  int _pelayananRating = 0;
  int _performaAlatRating = 0;
  int _performaOperatorRating = 0;

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

  TextEditingController tgllahirController = TextEditingController();

  String? nama_user;
  String? alamat_;
  String? nowa;
  String? id_user = "";
  String? image_profil;
  String? unit_list = "n";
  String? nik;
  String? alamat;
  String? NoSIO;
  String? NoEXP;
  String? foto;

  Future lihatDetailOprator() async {
    final Response = await http.post(
        Uri.parse("http://103.27.206.23/api_gocrane_v3/orator_profil.php"),
        body: {"id_user": widget.id_pegawai, "id_driver": widget.id_driver});
    var data = jsonDecode(Response.body);

    setState(() {
      if (Response.body == "null") {
        print("null");
      } else {
        // nama_user = data[0]['username'] ?? "";
        nama_user = data[0]['usr_name'];
        nik = data[0]['driver_ktp'];
        alamat = data[0]['driver_alamat'];
        NoSIO = data[0]['driver_no_sim'];
        foto = data[0]['usr_foto'];

        DateTime tanggal = DateTime.parse(data[0]['driver_sim_expired_date']);
        NoEXP = DateFormat('dd-MM-yyyy').format(tanggal);
        nowa = data[0]['driver_no_hp'];

        _waktuRating = int.tryParse(data[0]['waktu'] ?? "") ?? 0;
        _pelayananRating = int.tryParse(data[0]['kinerja'] ?? "") ?? 0;
        _performaAlatRating = int.tryParse(data[0]['alat'] ?? "") ?? 0;
        _performaOperatorRating = int.tryParse(data[0]['operator'] ?? "") ?? 0;
      }
      // gambar = data[0]json[0]['faskes_foto'];
    });
  }

  void sendWhatsAppMessage(String phoneNumber, String message) async {
    String url = 'https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Tidak dapat membuka WhatsApp';
    }
  }

  MediaQueryData? queryData;
  @override
  void initState() {
    lihatDetailOprator();
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
    super.dispose();
  }

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
                //Appbar
                Container(
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
                        top: 10,
                        bottom: 0,
                        start: 0,
                        end: 0,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Feedback",
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
                SizedBox(
                  height: 10,
                ),

                // indikator,

                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Container(
                              //     width: double.infinity,
                              //     child: Column(
                              //       mainAxisSize: MainAxisSize.min,
                              //       mainAxisAlignment: MainAxisAlignment.start,
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         Text(
                              //           nama_user ?? "",
                              //           style: TextStyle(
                              //             color: Color(0xff141414),
                              //             fontSize: 16,
                              //             fontFamily: "Inter",
                              //             fontWeight: FontWeight.w600,
                              //             letterSpacing: 0.08,
                              //           ),
                              //         ),
                              //         SizedBox(height: 8),
                              //         Container(
                              //           width: double.infinity,
                              //           child: Row(
                              //             mainAxisSize: MainAxisSize.min,
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.start,
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //             children: [
                              //               Expanded(
                              //                 child: Column(
                              //                   mainAxisSize: MainAxisSize.max,
                              //                   mainAxisAlignment:
                              //                       MainAxisAlignment.start,
                              //                   crossAxisAlignment:
                              //                       CrossAxisAlignment.start,
                              //                   children: [
                              //                     Text(
                              //                       "Nama",
                              //                       style: TextStyle(
                              //                         color: Color(0xff141414),
                              //                         fontSize: 12,
                              //                         letterSpacing: 0.06,
                              //                       ),
                              //                     ),
                              //                     SizedBox(height: 4),
                              //                     Text(
                              //                       "NIK",
                              //                       style: TextStyle(
                              //                         color: Color(0xff141414),
                              //                         fontSize: 12,
                              //                         letterSpacing: 0.06,
                              //                       ),
                              //                     ),
                              //                     SizedBox(height: 4),
                              //                     Text(
                              //                       "Alamat",
                              //                       style: TextStyle(
                              //                         color: Color(0xff141414),
                              //                         fontSize: 12,
                              //                         letterSpacing: 0.06,
                              //                       ),
                              //                     ),
                              //                     SizedBox(height: 4),
                              //                     Text(
                              //                       "No. HP",
                              //                       style: TextStyle(
                              //                         color: Color(0xff141414),
                              //                         fontSize: 12,
                              //                         letterSpacing: 0.06,
                              //                       ),
                              //                     ),
                              //                     SizedBox(height: 4),
                              //                     Text(
                              //                       "No. SIO",
                              //                       style: TextStyle(
                              //                         color: Color(0xff141414),
                              //                         fontSize: 12,
                              //                         letterSpacing: 0.06,
                              //                       ),
                              //                     ),
                              //                     SizedBox(height: 4),
                              //                     Text(
                              //                       "Exp. SIO",
                              //                       style: TextStyle(
                              //                         color: Color(0xff141414),
                              //                         fontSize: 12,
                              //                         letterSpacing: 0.06,
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //               SizedBox(width: 8),
                              //               Column(
                              //                 mainAxisSize: MainAxisSize.max,
                              //                 mainAxisAlignment:
                              //                     MainAxisAlignment.start,
                              //                 crossAxisAlignment:
                              //                     CrossAxisAlignment.start,
                              //                 children: [
                              //                   Text(
                              //                     nama_user ?? "",
                              //                     style: TextStyle(
                              //                       color: Color(0xff141414),
                              //                       fontSize: 12,
                              //                       fontWeight: FontWeight.w500,
                              //                     ),
                              //                   ),
                              //                   SizedBox(height: 4),
                              //                   Text(
                              //                     nik ?? "",
                              //                     style: TextStyle(
                              //                       color: Color(0xff141414),
                              //                       fontWeight: FontWeight.w500,
                              //                       fontSize: 12,
                              //                     ),
                              //                   ),
                              //                   SizedBox(height: 4),
                              //                   Text(
                              //                     alamat ?? "",
                              //                     style: TextStyle(
                              //                       color: Color(0xff141414),
                              //                       fontSize: 12,
                              //                       fontWeight: FontWeight.w500,
                              //                       letterSpacing: 0.06,
                              //                     ),
                              //                   ),
                              //                   SizedBox(height: 4),
                              //                   Text(
                              //                     nowa ?? "",
                              //                     style: TextStyle(
                              //                       color: Color(0xff141414),
                              //                       fontSize: 12,
                              //                       fontWeight: FontWeight.w500,
                              //                       letterSpacing: 0.06,
                              //                     ),
                              //                   ),
                              //                   SizedBox(height: 4),
                              //                   Text(
                              //                     NoSIO ?? "",
                              //                     style: TextStyle(
                              //                       color: Color(0xff141414),
                              //                       fontSize: 12,
                              //                       fontWeight: FontWeight.w500,
                              //                       letterSpacing: 0.06,
                              //                     ),
                              //                   ),
                              //                   SizedBox(height: 4),
                              //                   Text(
                              //                     NoEXP ?? "",
                              //                     style: TextStyle(
                              //                       color: Color(0xff141414),
                              //                       fontSize: 12,
                              //                       fontWeight: FontWeight.w500,
                              //                       letterSpacing: 0.06,
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              //  ),

                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 130,
                                            height: 160,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: Color(0xffaaaaaa),
                                            ),
                                            child: foto == null
                                                ? const Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.error,
                                                          color: Colors.red,
                                                          size: 24,
                                                        ),
                                                        SizedBox(height: 8),
                                                        Text('Image not found'),
                                                      ],
                                                    ),
                                                  )
                                                : Image.network(
                                                    "http://103.27.206.23/gocrane_2023/gambar/img/user/${foto}",
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      if (exception
                                                              is Exception &&
                                                          exception
                                                              .toString()
                                                              .contains(
                                                                  "HTTP request failed, statusCode: 404")) {
                                                        return Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons.error,
                                                                color:
                                                                    Colors.red,
                                                                size: 24,
                                                              ),
                                                              const SizedBox(
                                                                  height: 8),
                                                              Text(
                                                                  'Image not found'),
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                      return const SizedBox
                                                          .shrink(); // Return an empty widget if no error
                                                    },
                                                  ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                            vertical: 5),
                                                    child: Text(
                                                      nama_user ?? "",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff141414),
                                                        fontSize: 16,
                                                        fontFamily: "Inter",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.08,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16),
                                                  child: Table(
                                                    columnWidths: {
                                                      1: FractionColumnWidth(
                                                          0.1),
                                                      0: FractionColumnWidth(
                                                          0.3),
                                                      3: FractionColumnWidth(1),
                                                    },
                                                    children: [
                                                      buildRow("Nama",
                                                          nama_user ?? "", 14),
                                                      buildRow(
                                                          "NIK", nik ?? "", 14),
                                                      buildRow("Alamat",
                                                          alamat ?? "", 14),
                                                      buildRow("No. Hp",
                                                          nowa ?? "", 14),
                                                      buildRow("No. SIO",
                                                          NoSIO ?? "", 14),
                                                      buildRow("Exp.SIO",
                                                          NoEXP ?? "", 14),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Sisanya mengikuti pola yang sama
                                      // ...
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InkWell(
                          onTap: () {
                            sendWhatsAppMessage('+6282224076234', '');
                          },
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 0.50,
                                    color:
                                        const Color.fromARGB(255, 46, 165, 50)),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.call,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                Text(
                                  'WhatsApp',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 15,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.06,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildRatingForm(
                                'Ketepatan Waktu :', _waktuRating, (value) {}),
                            buildRatingForm('Pelayanan Kerja :',
                                _pelayananRating, (value) {}),
                            buildRatingForm('Performa Alat :',
                                _performaAlatRating, (value) {}),
                            buildRatingForm('Performa Operator',
                                _performaOperatorRating, (value) {}),
                          ],
                        ),
                      ),
                    ],
                  ),
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

Widget buildRatingForm(String label, int rating, ValueChanged<int> onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Color(0xff141414),
          fontSize: 16,
          fontFamily: "Inter",
          fontWeight: FontWeight.w600,
          letterSpacing: 0.08,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildStar(1, rating, onChanged),
          buildStar(2, rating, onChanged),
          buildStar(3, rating, onChanged),
          buildStar(4, rating, onChanged),
          buildStar(5, rating, onChanged),
        ],
      ),
      SizedBox(height: 10),
    ],
  );
}

Widget buildStar(int value, int rating, ValueChanged<int> onChanged) {
  IconData iconData = value <= rating ? Icons.star : Icons.star_border;

  return GestureDetector(
    onTap: () {
      onChanged(value);
    },
    child: Icon(
      iconData,
      color: Color(0xff2ab2a2),
      size: 40,
    ),
  );
}

TableRow buildRow(String title, String value, double shiz) {
  return TableRow(
    children: [
      TableCell(
        child: SizedBox(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.06,
            ),
          ),
        ),
      ),
      TableCell(
        child: FractionallySizedBox(
          widthFactor:
              0.1, // Ubah nilai widthFactor sesuai kebutuhan (0.0 - 1.0)
          child: Text(
            ":",
            textAlign: TextAlign.center, // Perataan teks ke tengah
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.06,
            ),
          ),
        ),
      ),
      TableCell(
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.06,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
