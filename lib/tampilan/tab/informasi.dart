import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:ui';

class informasi extends StatefulWidget {
  @override
  _informasiState createState() => _informasiState();
}

class _informasiState extends State<informasi> {
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
                            "Informasi",
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
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          "Go Crane Mobile User",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xff141414),
                            fontSize: 20,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.10,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: 320,
                          child: Text(
                            "Aplikasi Go Crane Mobile Apps adalah Aplikasi Alat Berat yang terpadu dan terintegrasi yang akan digunakan oleh Departemen Bengkel dan Fabrikasi dalam melaksanakan proses kegiatan unit Alat Berat. Sedangkan Go Crane Mobile User sendiri dapat diakses dan berfungsi untuk memastikan proses E-Order, Pengecekan E-Order dan Pengecekan Tagihan E-Order dapat dilakukan secara otomatis, cepat, dan dapat diakses oleh siapa saja melalui perangkat handphone.",
                            style: TextStyle(
                              color: Color(0xff141414),
                              fontSize: 16,
                              letterSpacing: 0.07,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Versi : GoCraneapp_V.2",
                                style: TextStyle(
                                  color: Color(0xff141414),
                                  fontSize: 15,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 0.06,
                                ),
                              ),
                              Text(
                                "Rilis : 2021",
                                style: TextStyle(
                                  color: Color(0xff141414),
                                  fontSize: 15,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 0.06,
                                ),
                              ),
                              Text(
                                "Contact : +62 815 3422 1369",
                                style: TextStyle(
                                  color: Color(0xff141414),
                                  fontSize: 15,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 0.06,
                                ),
                              )
                            ],
                          ),
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
  List genderList = [
    "Laki-laki",
    "perempuan",
  ];
}
