import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:gocrane_v3_new/main.dart';
import 'package:gocrane_v3_new/tampilan/SignIn.dart';
import 'package:gocrane_v3_new/tampilan/SlideRightRoute.dart';
import 'package:gocrane_v3_new/tampilan/menu/setting_profil/ubah_katasandi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';

class biodatapengguna extends StatefulWidget {
  @override
  _biodatapenggunaState createState() => _biodatapenggunaState();
}

class _biodatapenggunaState extends State<biodatapengguna> {
  Future<String?> _ambildata() async {
    final prefs = await SharedPreferences.getInstance();

    iduser = (prefs.get('login_id')) as String?;
    print(iduser);
    return iduser;
  }

  String? nama_user;
  String? alamat;
  String? nowa;
  String? id_user = "";
  String? image_profil;
  String? bagian;

  Future profil() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('usr_id'));

    final Response = await http.post(
        Uri.parse("http://103.27.206.23/api_gocrane_v3/profil.php"),
        body: {"id_usr": id_user});

    this.setState(() {
      var datajson = jsonDecode(Response.body);

      nama_user = datajson['profile'][0]["usr_name"];
      dep_nama = datajson['profile'][0]["struk_nama"];
      bagian = datajson['profile'][0]["struk_detail_nama"];
      //nowa = datajson['profile'][0]["struk_nama"];
      print(datajson);
    });
  }

  bool downloading = false;
  double progress = 0.0;

  void downloadPdf(BuildContext context) async {
    // Declare progress variable outside the function
    double progress = 0.0;

    final taskId = await FlutterDownloader.enqueue(
      url: "http://103.157.97.200/api_gocrane/pdf_api.php",
      savedDir: (await getExternalStorageDirectory())!.path,
      fileName: "downloaded_pdf.pdf",
      showNotification: true,
      openFileFromNotification: false,
    );

    FlutterDownloader.registerCallback((id, status, downloadProgress) {
      if (id == taskId && status == DownloadTaskStatus.complete) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Download Selesai"),
          ),
        );
        progress = 0.0; // Reset progress after completion
      } else if (id == taskId) {
        // Update progress within the callback
        progress = downloadProgress / 100;
      }
    });

    Dio dio = Dio();
    dio.download(
      "http://103.157.97.200/api_gocrane/pdf_api.php",
      (await getExternalStorageDirectory())!.path + "/downloaded_pdf.pdf",
      onReceiveProgress: (received, total) {
        // Update progress within the progress callback
        progress = received / total;
      },
    );

    while (downloading) {
      await Future.delayed(Duration(seconds: 1));
    }

    // Buka file PDF setelah download selesai
    final file = File(
        (await getExternalStorageDirectory())!.path + "/downloaded_pdf.pdf");
    if (await file.exists()) {
      await OpenFile.open(file.path);
    }
  }

  @override
  void initState() {
    profil();
    // _ambildata();
    // lihatprofil();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                //back btn

                //title
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Profil",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            child: Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffd9d9d9),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                'https://as1.ftcdn.net/v2/jpg/01/92/07/76/1000_F_192077668_hLewzaqBcb2RVB0iiHmjYjnbZAUGJgOq.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nama_user ?? "",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.08,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    dep_nama ?? "",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      letterSpacing: 0.07,
                                    ),
                                  ),
                                ],
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
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 320,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 4,
                          offset: Offset(0, 0),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Information",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xff141414),
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.08,
                                ),
                              ),
                              SizedBox(height: 14),
                              Container(
                                width: double.infinity,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Username",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color(0xffbfbfbf),
                                                    fontSize: 12,
                                                    letterSpacing: 0.06,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            nama_user ?? "",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xff141414),
                                              fontSize: 12,
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.06,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Departemen",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color(0xffbfbfbf),
                                                    fontSize: 12,
                                                    letterSpacing: 0.06,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            dep_nama ?? "",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xff141414),
                                              fontSize: 12,
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.06,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Bagian",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color(0xffbfbfbf),
                                                    fontSize: 12,
                                                    letterSpacing: 0.06,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            bagian ?? "",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xff141414),
                                              fontSize: 12,
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.06,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //SizedBox(height: 8),
                                    // Container(
                                    //   width: double.infinity,
                                    //   child: Row(
                                    //     mainAxisSize: MainAxisSize.min,
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.start,
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.center,
                                    //     children: [
                                    //       Expanded(
                                    //         child: Row(
                                    //           mainAxisSize: MainAxisSize.max,
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment.start,
                                    //           crossAxisAlignment:
                                    //               CrossAxisAlignment.start,
                                    //           children: [
                                    //             Text(
                                    //               "No. Telepon",
                                    //               textAlign: TextAlign.center,
                                    //               style: TextStyle(
                                    //                 color: Color(0xffbfbfbf),
                                    //                 fontSize: 12,
                                    //                 letterSpacing: 0.06,
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       Text(
                                    //         "0000000000",
                                    //         textAlign: TextAlign.center,
                                    //         style: TextStyle(
                                    //           color: Color(0xff141414),
                                    //           fontSize: 12,
                                    //           fontFamily: "Inter",
                                    //           fontWeight: FontWeight.w500,
                                    //           letterSpacing: 0.06,
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
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
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: 317,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pengaturan Akun",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff141414),
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.08,
                          ),
                        ),
                        SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.push(context,
                              //         SlidePageRoute(page: editprofil_user()));
                              //   },
                              //   child: Container(
                              //     width: double.infinity,
                              //     child: Row(
                              //       mainAxisSize: MainAxisSize.min,
                              //       mainAxisAlignment: MainAxisAlignment.start,
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.center,
                              //       children: [
                              //         Expanded(
                              //           child: Row(
                              //             mainAxisSize: MainAxisSize.max,
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.start,
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //             children: [
                              //               Text(
                              //                 "Edit Profil",
                              //                 textAlign: TextAlign.center,
                              //                 style: TextStyle(
                              //                   color: Color(0xff141414),
                              //                   fontSize: 15,
                              //                   fontFamily: "Inter",
                              //                   fontWeight: FontWeight.w600,
                              //                   letterSpacing: 0.06,
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //         Transform.rotate(
                              //           angle: 3.14,
                              //           child: Container(
                              //             width: 16,
                              //             height: 16,
                              //             decoration: BoxDecoration(
                              //               borderRadius:
                              //                   BorderRadius.circular(8),
                              //             ),
                              //             child: Icon(Icons.arrow_back_ios),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(height: 18),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      SlidePageRoute(page: ubah_katasandi()));

                                  // downloadPdf(context);
                                },
                                child: Container(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Ubah Kata Sandi",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xff141414),
                                                fontSize: 15,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.06,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Transform.rotate(
                                        angle: 3.14,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Icon(Icons.arrow_back_ios),
                                        ),
                                      ),
                                    ],
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

                // Space
                SizedBox(
                  height: 13,
                ),
                // //Help Center
                // InkWell(
                //   onTap: () {
                //     Navigator.push(
                //         context, SlidePageRoute(page: BasicHealthScreen()));
                //   }, //BasicHealthScreen
                //   child: Container(
                //     height: 45,
                //     padding: EdgeInsets.symmetric(horizontal: 16),
                //     child: Row(
                //       children: [
                //         Image.asset(
                //           "assets/icons/ic_help.png",
                //           scale: 22,
                //         ),
                //         Container(
                //           padding: EdgeInsets.only(left: 12),
                //           child: Text(
                //             "Customer Service",
                //             style: TextStyle(
                //                 fontSize: 15,
                //                 fontFamily: "medium",
                //                 color: Theme.of(context)
                //                     .accentTextTheme
                //                     .headline3
                //                     .color),
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                //Hotline
                // InkWell(
                //   onTap: () {},
                //   child: Container(
                //     height: 45,
                //     padding: EdgeInsets.symmetric(horizontal: 16),
                //     child: Row(
                //       children: [
                //         Image.asset(
                //           "assets/icons/ic_hotline.png",
                //           scale: 22,
                //         ),
                //         Container(
                //           padding: EdgeInsets.only(left: 12),
                //           child: Text(
                //             "Hotline",
                //             style: TextStyle(
                //                 fontSize: 15,
                //                 fontFamily: "medium",
                //                 color: Theme.of(context)
                //                     .accentTextTheme
                //                     .headline3
                //                     .color),
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                //About Us

                //Space
                // SizedBox(
                //   height: 13,
                // ),
                //Logout
              ],
            ),
          ),
          MaterialButton(
            onPressed: () async {
              logoutDialogue();
            },
            child: Container(
              width: 328,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0xff020438),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x44000000),
                    blurRadius: 24,
                    offset: Offset(8, 8),
                  ),
                ],
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 16,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Keluar",
                    style: TextStyle(
                      color: Color(0xff020438),
                      fontSize: 20,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void logoutDialogue() {
    showDialog<void>(
      context: context,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            insetPadding: EdgeInsets.all(30),
            child: Container(
              height: 164,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Keluar",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "medium",
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 9),
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: new TextSpan(
                              text: "Anda Yakin ?",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "medium",
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Tidak",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "medium",
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        //Space
                        SizedBox(
                          width: 8,
                        ),
                        InkWell(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.remove('usr_id');
                            prefs.remove('pegawai_nama');
                            prefs.remove('set_jab');
                            // Navigator.pop(context);
                            // Navigator.push(
                            //     context, SlidePageRoute(page: SignIn()));

                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn()),
                                (route) => false);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Keluar",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "medium",
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
