import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gocrane_v3_new/tampilan/menu/daftar_oprator/oprator_detail.dart';
import 'package:gocrane_v3_new/tampilan/SlideRightRoute.dart';

import 'package:http/http.dart' as http;

import 'dart:ui';

class daftar_oprator extends StatefulWidget {
  @override
  _daftar_opratorState createState() => _daftar_opratorState();
}

class _daftar_opratorState extends State<daftar_oprator> {
  // void updateWidget() {
  //   setState(() {
  //     indikator = MyStepperWidget_3();
  //     btn = "Lanjut Cetak Bukti";
  //     tombol_riset = false;
  //     konten = pilihpekerjaan();
  //   });
  // }

  List? dataOprator;
  Future opratorData() async {
    final Response = await http
        .post(Uri.parse("http://103.27.206.23/api_gocrane_v3/driver_list.php"));

    this.setState(() {
      if (Response.body == "false") {
        print("null");
      } else {
        dataOprator = jsonDecode(Response.body);
      }
    });
  }

  MediaQueryData? queryData;
  @override
  void initState() {
    opratorData();
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
                          child: const Text(
                            "Daftar Operator",
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
                const SizedBox(
                  height: 10,
                ),

                Expanded(
                  child: Container(
                    child: ListView.builder(
                      itemCount: dataOprator == null ? 0 : dataOprator?.length,
                      itemBuilder: (context, index) {
                        // ignore: unused_local_variable
                        final kendaraan = dataOprator?[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 320,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Container(
                                        width: 130,
                                        height: 130,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: const Color(0xffaaaaaa),
                                        ),
                                        child: Image.network(
                                          "http://103.27.206.23/gocrane_2023/gambar/img/user/${dataOprator![index]['usr_foto']}",
                                          fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            if (exception is Exception &&
                                                exception.toString().contains(
                                                    "HTTP request failed, statusCode: 404")) {
                                              return const Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                              );
                                            }
                                            return const SizedBox
                                                .shrink(); // Return an empty widget if no error
                                          },
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dataOprator![index]['driver_nama'] ??
                                              "",
                                          style: const TextStyle(
                                            color: Color(0xff141414),
                                            fontSize: 13,
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.07,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          dataOprator![index]
                                                  ['driver_jenis_sim'] ??
                                              "",
                                          style: const TextStyle(
                                            color: Color(0xff141414),
                                            fontSize: 13,
                                            letterSpacing: 0.05,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          dataOprator![index]
                                                  ['driver_no_sim'] ??
                                              "",
                                          style: const TextStyle(
                                            color: Color(0xff141414),
                                            fontSize: 13,
                                            letterSpacing: 0.05,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          dataOprator![index]
                                                  ['driver_sim_expired_date'] ??
                                              "",
                                          style: const TextStyle(
                                            color: Color(0xff141414),
                                            fontSize: 13,
                                            letterSpacing: 0.05,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          dataOprator![index]['driver_no_hp'] ??
                                              "",
                                          style: const TextStyle(
                                            color: Color(0xff141414),
                                            fontSize: 13,
                                            letterSpacing: 0.05,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        SlidePageRoute(
                                            page: oprator_detail(
                                          id_pegawai: dataOprator![index]
                                              ['usr_id'],
                                          id_driver: dataOprator![index]
                                              ['driver_id'],
                                        )));
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: const Color(0xff2ab2a2),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: const Row(
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
                                            fontSize: 17,
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.05,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Expanded(
                //   child: ListView(
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Container(
                //           width: 320,
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(8),
                //             boxShadow: [
                //               BoxShadow(
                //                 color: Color(0x1c000000),
                //                 blurRadius: 4,
                //                 offset: Offset(0, 0),
                //               ),
                //             ],
                //             color: Colors.white,
                //           ),
                //           padding: const EdgeInsets.only(
                //             top: 8,
                //             bottom: 14,
                //           ),
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             mainAxisAlignment: MainAxisAlignment.end,
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Row(
                //                 mainAxisSize: MainAxisSize.min,
                //                 mainAxisAlignment: MainAxisAlignment.start,
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Padding(
                //                     padding: const EdgeInsets.symmetric(
                //                         horizontal: 13),
                //                     child: Container(
                //                       width: 130,
                //                       height: 130,
                //                       decoration: BoxDecoration(
                //                         image: DecorationImage(
                //                           image: NetworkImage(
                //                               "https://as1.ftcdn.net/v2/jpg/01/92/07/76/1000_F_192077668_hLewzaqBcb2RVB0iiHmjYjnbZAUGJgOq.jpg"),
                //                           fit: BoxFit.cover,
                //                         ),
                //                         borderRadius: BorderRadius.circular(4),
                //                         color: Color(0xffaaaaaa),
                //                       ),
                //                     ),
                //                   ),
                //                   Column(
                //                     mainAxisSize: MainAxisSize.min,
                //                     mainAxisAlignment: MainAxisAlignment.start,
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                     children: [
                //                       Text(
                //                         "M. Gufron Syafi’i",
                //                         style: TextStyle(
                //                           color: Color(0xff141414),
                //                           fontSize: 17,
                //                           fontFamily: "Inter",
                //                           fontWeight: FontWeight.w700,
                //                           letterSpacing: 0.07,
                //                         ),
                //                       ),
                //                       SizedBox(height: 4),
                //                       Text(
                //                         "OP. CRANE Kelas I",
                //                         style: TextStyle(
                //                           color: Color(0xff141414),
                //                           fontSize: 14,
                //                           letterSpacing: 0.05,
                //                         ),
                //                       ),
                //                       SizedBox(height: 4),
                //                       Text(
                //                         "58103-OPK3-MC/PAA/X/2018",
                //                         style: TextStyle(
                //                           color: Color(0xff141414),
                //                           fontSize: 14,
                //                           letterSpacing: 0.05,
                //                         ),
                //                       ),
                //                       SizedBox(height: 4),
                //                       Text(
                //                         "09-10-2023",
                //                         style: TextStyle(
                //                           color: Color(0xff141414),
                //                           fontSize: 14,
                //                           letterSpacing: 0.05,
                //                         ),
                //                       ),
                //                       SizedBox(height: 4),
                //                       Text(
                //                         "081235254708",
                //                         style: TextStyle(
                //                           color: Color(0xff141414),
                //                           fontSize: 14,
                //                           letterSpacing: 0.05,
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ],
                //               ),
                //               SizedBox(height: 16),
                //               InkWell(
                //                 onTap: () {
                //                   Navigator.push(context,
                //                       SlidePageRoute(page: oprator_detail()));
                //                 },
                //                 child: Container(
                //                   width: double.infinity,
                //                   decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(6),
                //                     color: Color(0xff2ab2a2),
                //                   ),
                //                   padding: const EdgeInsets.all(8),
                //                   child: Row(
                //                     mainAxisSize: MainAxisSize.min,
                //                     mainAxisAlignment: MainAxisAlignment.center,
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.center,
                //                     children: [
                //                       Text(
                //                         "Detail",
                //                         textAlign: TextAlign.center,
                //                         style: TextStyle(
                //                           color: Colors.white,
                //                           fontSize: 17,
                //                           fontFamily: "Inter",
                //                           fontWeight: FontWeight.w600,
                //                           letterSpacing: 0.05,
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       )
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
