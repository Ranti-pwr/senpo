import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';

class galeri_unit extends StatefulWidget {
  @override
  _galeri_unitState createState() => _galeri_unitState();
}

class _galeri_unitState extends State<galeri_unit> {
  // void updateWidget() {
  //   setState(() {
  //     indikator = MyStepperWidget_3();
  //     btn = "Lanjut Cetak Bukti";
  //     tombol_riset = false;
  //     konten = pilihpekerjaan();
  //   });
  // }

  List list = [
    {
      "gambar":
          "https://images.unsplash.com/photo-1586458995526-09ce6839babe?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=873&q=80",
      "nama": "Komatsu",
      "jenis": "FLT 199(Tersedia)",
      "status": "y",
      "kapastas": "2.50",
      "mdm": "200,000",
      "st": "550,000",
      "total": "750,000",
    },
    {
      "gambar":
          "https://images.unsplash.com/photo-1586458995526-09ce6839babe?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=873&q=80",
      "nama": "Komatsu",
      "jenis": "FLT 199(Tersedia)",
      "status": "y",
      "kapastas": "2.50",
      "mdm": "200,000",
      "st": "550,000",
      "total": "750,000",
    },
  ];

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

  Future lihatprofil() async {
    final prefs = await SharedPreferences.getInstance();

    id_user = (prefs.get('pegawai_id')) as String?;
    final Response = await http
        .get(Uri.parse("http://103.27.206.23/richzspot/user/getData/$id_user"));
    var profil = jsonDecode(Response.body);
    this.setState(() {
      if (Response.body == "false") {
        print("null");
      } else {
        // nama_user = profil[0]['username'] ?? "";
        nameController.text = profil['user_nama_lengkap'] ?? "";
        phoneNumController.text = profil['user_no_telp'] ?? "";
        image_profil = profil['user_foto'];
        dateVal = profil['user_tgl_lahir'] ?? "";
        alamat.text = profil['user_alamat'] ?? "";
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
                            "Galeri Unit",
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

                // indikator,
                SizedBox(
                  height: 10,
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: list == null ? 0 : list.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x1c000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 0),
                                ),
                              ],
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 14,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Container(
                                            width: 130,
                                            height: 130,
                                            decoration: ShapeDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(list[index]
                                                        ["gambar"] ??
                                                    ""),
                                                fit: BoxFit.cover,
                                              ),
                                              color: Color(0xFFD9D9D9),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 16),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 7),
                                                  child: Text(
                                                    list[index]["jenis"] ?? "",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: Color(0xff141414),
                                                      fontSize: 14,
                                                      fontFamily: "Inter",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 7),
                                                  child: Text(
                                                    list[index]["nama"] ?? "",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: Color(0xff141414),
                                                      fontSize: 16,
                                                      fontFamily: "Inter",
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 7),
                                                  child: Text(
                                                    "HT/TR",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: Color(0xff141414),
                                                      fontSize: 16,
                                                      fontFamily: "Inter",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Table(
                                              columnWidths: {
                                                1: FractionColumnWidth(0.1),
                                                0: FractionColumnWidth(0.6),
                                              },
                                              children: [
                                                buildRow(
                                                    "Kapasitas",
                                                    "( ${list[index]["kapastas"]})",
                                                    14),
                                                buildRow(
                                                    "Biaya MDM",
                                                    "Rp. ${list[index]["mdm"]}",
                                                    14),
                                                buildRow(
                                                    "Biaya Satuan Waktu",
                                                    "Rp. ${list[index]["st"]}",
                                                    14),
                                                buildRow(
                                                    "Total Biaya",
                                                    "Rp. ${list[index]["total"]}",
                                                    14),
                                              ],
                                            ),
                                          ),
                                          // Sisanya mengikuti pola yang sama
                                          // ...
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: InkWell(
                                    onTap: () {
                                      // Navigator.push(context,
                                      //     SlidePageRoute(page: detail_unit(key: null, id_unit: '',)));
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Color(0xff2ab2a2),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Detail",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.05,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                  ),
                ),

                // Expanded(
                //   child: ListView(
                //     children: [
                //       InkWell(
                //         onTap: () {
                //           setState(() {
                //             // indikator = MyStepperWidget_3();
                //             // btn = "Lanjut Cetak Bukti";
                //             // tombol_riset = true;
                //             // konten = pilihpekerjaan();
                //             // unit_list = "n";
                //           });
                //         },
                //         child: Padding(
                //             padding: const EdgeInsets.all(10),
                //             child: Container(
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(8),
                //                 boxShadow: [
                //                   BoxShadow(
                //                     color: Color(0x1c000000),
                //                     blurRadius: 4,
                //                     offset: Offset(0, 0),
                //                   ),
                //                 ],
                //                 color: Colors.white,
                //               ),
                //               padding: const EdgeInsets.only(
                //                 top: 8,
                //                 bottom: 14,
                //               ),
                //               child: Column(
                //                 mainAxisSize: MainAxisSize.min,
                //                 mainAxisAlignment: MainAxisAlignment.end,
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Row(
                //                     mainAxisSize: MainAxisSize.min,
                //                     mainAxisAlignment: MainAxisAlignment.start,
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                     children: [
                //                       Column(
                //                         mainAxisSize: MainAxisSize.min,
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.start,
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.center,
                //                         children: [
                //                           Padding(
                //                             padding:
                //                                 const EdgeInsets.only(left: 10),
                //                             child: Container(
                //                               width: 130,
                //                               height: 130,
                //                               decoration: ShapeDecoration(
                //                                 image: DecorationImage(
                //                                   image: NetworkImage(
                //                                       "https://images.unsplash.com/photo-1586458995526-09ce6839babe?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=873&q=80"),
                //                                   fit: BoxFit.cover,
                //                                 ),
                //                                 color: Color(0xFFD9D9D9),
                //                                 shape: RoundedRectangleBorder(
                //                                   borderRadius:
                //                                       BorderRadius.circular(4),
                //                                 ),
                //                               ),
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                       Expanded(
                //                         child: Column(
                //                           crossAxisAlignment:
                //                               CrossAxisAlignment.start,
                //                           children: [
                //                             Padding(
                //                               padding: const EdgeInsets.only(
                //                                   left: 16),
                //                               child: Column(
                //                                 mainAxisSize: MainAxisSize.min,
                //                                 mainAxisAlignment:
                //                                     MainAxisAlignment.start,
                //                                 crossAxisAlignment:
                //                                     CrossAxisAlignment.start,
                //                                 children: [
                //                                   Padding(
                //                                     padding:
                //                                         const EdgeInsets.only(
                //                                             bottom: 7),
                //                                     child: Text(
                //                                       "HT 06 TR 11(Tersedia)",
                //                                       textAlign: TextAlign.left,
                //                                       style: TextStyle(
                //                                         color:
                //                                             Color(0xff141414),
                //                                         fontSize: 14,
                //                                         fontFamily: "Inter",
                //                                         fontWeight:
                //                                             FontWeight.w400,
                //                                       ),
                //                                     ),
                //                                   ),
                //                                   Padding(
                //                                     padding:
                //                                         const EdgeInsets.only(
                //                                             bottom: 7),
                //                                     child: Text(
                //                                       "Quester - Lowbed Trailer",
                //                                       textAlign: TextAlign.left,
                //                                       style: TextStyle(
                //                                         color:
                //                                             Color(0xff141414),
                //                                         fontSize: 16,
                //                                         fontFamily: "Inter",
                //                                         fontWeight:
                //                                             FontWeight.w700,
                //                                       ),
                //                                     ),
                //                                   ),
                //                                   Padding(
                //                                     padding:
                //                                         const EdgeInsets.only(
                //                                             bottom: 7),
                //                                     child: Text(
                //                                       "HT/TR",
                //                                       textAlign: TextAlign.left,
                //                                       style: TextStyle(
                //                                         color:
                //                                             Color(0xff141414),
                //                                         fontSize: 16,
                //                                         fontFamily: "Inter",
                //                                         fontWeight:
                //                                             FontWeight.w400,
                //                                       ),
                //                                     ),
                //                                   ),
                //                                 ],
                //                               ),
                //                             ),
                //                             Container(
                //                               padding: EdgeInsets.symmetric(
                //                                   horizontal: 16),
                //                               child: Table(
                //                                 columnWidths: {
                //                                   1: FractionColumnWidth(0.1),
                //                                   0: FractionColumnWidth(0.6),
                //                                 },
                //                                 children: [
                //                                   buildRow("Kapasitas",
                //                                       "(60.00)", 14),
                //                                   buildRow("Biaya MDM",
                //                                       "500,000", 14),
                //                                   buildRow("Biaya Satuan Waktu",
                //                                       "5,500,000", 14),
                //                                   buildRow("Total Biaya",
                //                                       "6,000,000", 14),
                //                                 ],
                //                               ),
                //                             ),
                //                             // Sisanya mengikuti pola yang sama
                //                             // ...
                //                           ],
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                   SizedBox(height: 16),
                //                   Padding(
                //                     padding: const EdgeInsets.symmetric(
                //                         horizontal: 16),
                //                     child: InkWell(
                //                       onTap: () {
                //                         Navigator.push(
                //                             context,
                //                             SlidePageRoute(
                //                                 page: detail_unit()));
                //                       },
                //                       child: Container(
                //                         width: double.infinity,
                //                         decoration: BoxDecoration(
                //                           borderRadius:
                //                               BorderRadius.circular(6),
                //                           color: Color(0xff2ab2a2),
                //                         ),
                //                         padding: const EdgeInsets.all(8),
                //                         child: Row(
                //                           mainAxisSize: MainAxisSize.min,
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.center,
                //                           crossAxisAlignment:
                //                               CrossAxisAlignment.center,
                //                           children: [
                //                             Text(
                //                               "Detail",
                //                               textAlign: TextAlign.center,
                //                               style: TextStyle(
                //                                 color: Colors.white,
                //                                 fontSize: 14,
                //                                 fontFamily: "Inter",
                //                                 fontWeight: FontWeight.w600,
                //                                 letterSpacing: 0.05,
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             )),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
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
