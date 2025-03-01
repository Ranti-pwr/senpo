import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class detail_unit extends StatefulWidget {
  const detail_unit({
    required this.id_unit,
  });
  final String id_unit;

  @override
  _detail_unitState createState() => _detail_unitState();
}

class _detail_unitState extends State<detail_unit> {
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

  Future lihatprofil() async {
    final prefs = await SharedPreferences.getInstance();

    id_user = (prefs.get('pegawai_id')) as String?;
    final Response = await http.get(
        Uri.parse("http://103.157.97.200/richzspot/user/getData/$id_user"));
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
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://images.unsplash.com/photo-1586458995526-09ce6839babe?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=873&q=80"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      //back btn
                      Positioned.directional(
                        textDirection: Directionality.of(context),
                        start: 2,
                        top: 0,
                        bottom: 140,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            "assets/icons/ic_back.png",
                            scale: 15,
                          ),
                        ),
                      ),
                      //title
                    ],
                  ),
                ),

                // indikator,
                const SizedBox(
                  height: 10,
                ),

                Expanded(
                  child: ListView(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Komatsu (FLT 199)",
                                  style: TextStyle(
                                    color: Color(0xff141414),
                                    fontSize: 16,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.08,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "FLT",
                                      style: TextStyle(
                                        color: Color(0xff141414),
                                        fontSize: 12,
                                        letterSpacing: 0.06,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Kapasitas : (25.0)",
                                      style: TextStyle(
                                        color: Color(0xff141414),
                                        fontSize: 12,
                                        letterSpacing: 0.06,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Biaya MDM : 200.000",
                                      style: TextStyle(
                                        color: Color(0xff141414),
                                        fontSize: 12,
                                        letterSpacing: 0.06,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Biaya Satuan Waktu : 550.000",
                                      style: TextStyle(
                                        color: Color(0xff141414),
                                        fontSize: 12,
                                        letterSpacing: 0.06,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Total Biaya : 750.000",
                                      style: TextStyle(
                                        color: Color(0xff141414),
                                        fontSize: 12,
                                        letterSpacing: 0.06,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              "Tahun Perolehan : ",
                              style: TextStyle(
                                color: Color(0xff141414),
                                fontSize: 14,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.07,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              "No. Silo :",
                              style: TextStyle(
                                color: Color(0xff141414),
                                fontSize: 14,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.07,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              "Masa Berlaku Silo : ",
                              style: TextStyle(
                                color: Color(0xff141414),
                                fontSize: 14,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.07,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              "Deskripsi : ",
                              style: TextStyle(
                                color: Color(0xff141414),
                                fontSize: 14,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.07,
                              ),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              maxLines:
                                  5, // Atur jumlah baris yang ingin ditampilkan
                              decoration: InputDecoration(
                                labelText: 'Diskripsi',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      )
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
