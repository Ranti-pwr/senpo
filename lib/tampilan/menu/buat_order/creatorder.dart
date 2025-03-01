import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gocrane_v3_new/tampilan/menu/buat_order/pdf_cek.dart';
import 'package:gocrane_v3_new/tampilan/menu/buat_order/pilih_folder.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gocrane_v3_new/Widget/Alert.dart';
import 'package:gocrane_v3_new/tampilan/menu/buat_order/cetak.dart';
import 'package:gocrane_v3_new/tampilan/menu/buat_order/indikator_step.dart';
import 'package:gocrane_v3_new/tampilan/menu/buat_order/pekerjaan.dart';
import 'package:gocrane_v3_new/tampilan/menu/buat_order/unit.dart';
import 'package:gocrane_v3_new/tampilan/menu/buat_order/waktu.dart';
import 'package:gocrane_v3_new/tampilan/menu/buat_order/pdf_viwe.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: duplicate_import
import 'package:permission_handler/permission_handler.dart';
// ignore: duplicate_import
import 'package:fluttertoast/fluttertoast.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Widget? indikator;
Widget? konten;
bool? tombol_riset;
String? btn;
String? nama_pengguna;
////////////////////////////////////

final TextEditingController transaksiLokasiController = TextEditingController();
final TextEditingController transaksiJenisBarangController =
    TextEditingController();
final TextEditingController transaksiTonaseCraneController =
    TextEditingController();
// final TextEditingController transaksiJamSelesaiController =
//     TextEditingController();
// final TextEditingController transaksiTanggalSelesaiController =
//     TextEditingController();
final TextEditingController transaksiNominalController =
    TextEditingController();
final TextEditingController idAlberController = TextEditingController();
// final TextEditingController transaksiStatusController = TextEditingController();
// final TextEditingController idDriverController = TextEditingController();
// final TextEditingController idUsrController = TextEditingController();
// final TextEditingController idStrukController = TextEditingController();
// final TextEditingController transaksiCallCentreController =
//     TextEditingController();
final TextEditingController transaksiNoExtentionController =
    TextEditingController();
// final TextEditingController transaksiSatuanWaktuController =
//     TextEditingController();
final TextEditingController transaksiBiayaMdmController =
    TextEditingController();
// final TextEditingController transaksiBiayaSatuanController =
//     TextEditingController();
final TextEditingController transaksiSapController = TextEditingController();
final TextEditingController transaksiPicController = TextEditingController();
// final TextEditingController transaksiShiftMulaiController =
//     TextEditingController();
// final TextEditingController transaksiShiftSelesaiController =
//     TextEditingController();
// final TextEditingController idStrukDetailController = TextEditingController();

class buat_order extends StatefulWidget {
  @override
  _buat_orderState createState() => _buat_orderState();
}

class _buat_orderState extends State<buat_order> {
  void updateWidget() {
    setState(() {
      indikator = MyStepperWidget_3();
      btn = "Lanjut Cetak Bukti";
      tombol_riset = false;
      konten = pilihpekerjaan();
    });
  }

  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  ///
  void _insertDataOrder() async {
    final prefs = await SharedPreferences.getInstance();

    var idUsr = (prefs.get('usr_id'));
    final url = Uri.parse(
        'http://103.27.206.23/gocraneapp_v2/production/buat_order/buat_order.php'); // Ganti dengan URL endpoint API Anda
    try {
      final response = await http.post(url, body: {
        // 'id_shift': "1",
        'id_jenis_alber': alber_jenis ?? "",
        'transaksi_tanggal': tgl_awal_ymd ?? "",
        'transaksi_tanggal_awal': tgl_awal_ymd ?? "",
        'transaksi_who_create': nama_pengguna ?? "",
        'transaksi_lokasi': transaksiLokasiController.text,
        'transaksi_jenis_barang': transaksiJenisBarangController.text,
        'transaksi_tonase_crane': transaksiTonaseCraneController.text,
        'transaksi_shift_awal': shift_awal ?? "",
        'transaksi_shift_akhir': shift_akhir ?? "",
        'transaksi_tanggal_akhir': tgl_akhir_ymd ?? "",
        'transaksi_nominal': transaksiNominalController.text,
        'id_alber': idAlberController.text,
        'id_usr': idUsr ?? "",
        'id_struk': dp_id ?? "",
        'transaksi_no_extention': transaksiNoExtentionController.text,
        'transaksi_biaya_mdm': transaksiBiayaMdmController.text,
        'transaksi_sap': transaksiSapController.text,
        'id_struk_detail': bagian_jenis ?? "",
        'transaksi_pic': transaksiPicController.text,
      });
      print(response.body);

      if (response.statusCode == 200) {
        // Jika insert berhasil
        final responseData = jsonDecode(response.body);
        print(responseData); // Output response dari server
        print('Data inserted successfully!');
        // Tambahkan tindakan yang diinginkan setelah data berhasil diinsert
      } else {
        // Jika insert gagal
        print('Failed to insert data.');
        // Tambahkan tindakan yang diinginkan jika gagal melakukan insert
      }
    } catch (error) {
      print('Error: $error');
    }
  }

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
  String? id_user;
  String? image_profil;
  String? unit_list = "n";
////////////////////////////////////
  String? nama_pengguna;
  String? dep_nama;
  String? jumlah_order;
  String? jumlah_saldo;

  Future profil() async {
    final prefs = await SharedPreferences.getInstance();

    var idUser = (prefs.get('usr_id'));

    final Response = await http.post(
        Uri.parse("http://103.27.206.23/api_gocrane_v3/profil.php"),
        body: {"id_usr": idUser});

    setState(() {
      var datajson = jsonDecode(Response.body);

      nama_pengguna = datajson['profile'][0]["usr_name"];
      dep_nama = datajson['profile'][0]["struk_nama"];
      jumlah_order = datajson['orderan'][0]["order"];
      jumlah_saldo = datajson['jumlah_saldo'];
      print(datajson);
    });
  }

  Future _edit() async {
    final prefs = await SharedPreferences.getInstance();

    id_user = (prefs.get('pegawai_id')) as String?;
    if (_image != null) {
      var request = http.MultipartRequest('POST',
          Uri.parse('http://103.27.206.23/richzspot/user/updateData/$id_user'));
      request.fields.addAll({
        'user_nama_lengkap': nameController.text,
        'user_no_telp': phoneNumController.text,
        'pasien_alamat': alamat.text,
        "user_tgl_lahir": dateVal,
      });
      request.files
          .add(await http.MultipartFile.fromPath('user_foto', _image!.path));

      // ignore: unused_local_variable
      http.StreamedResponse response = await request.send();

      // ignore: use_build_context_synchronously
      showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return Alert(
              title: "Pembritahuan !!!",
              subTile: "Berhasil Edit Profil",
            );
          });
      // Navigator.pop(context);
    } else {
      var request = http.MultipartRequest('POST',
          Uri.parse('http://103.27.206.23/richzspot/user/updateData/$id_user'));
      request.fields.addAll({
        'user_nama_lengkap': nameController.text,
        'user_no_telp': phoneNumController.text,
        'pasien_alamat': alamat.text,
        "user_tgl_lahir": dateVal,
      });

      // ignore: unused_local_variable
      http.StreamedResponse response = await request.send();

      // ignore: use_build_context_synchronously
      showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return Alert(
              title: "Pembritahuan !!!",
              subTile: " Berhasil Edit Profil",
            );
          });
      // Navigator.pop(context);
    }
  }

  check() {
    if (nameController.text.isEmpty) {
      return showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return Alert(
              title: "Alert !!!",
              subTile: "First name is required !",
            );
          });
    } else if (genderVal == null) {
      return showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return Alert(
              title: "Alert !!!",
              subTile: "Gender is required !",
            );
          });
    } else if (dateVal == null) {
      return showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return Alert(
              title: "Alert !!!",
              subTile: "Date of birth is required !",
            );
          });
    } else if (phoneNumController.text.isEmpty) {
      return showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return Alert(
              title: "Alert !!!",
              subTile: "Phone number is required !",
            );
          });
    } else if (alamat.text.isEmpty) {
      return showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return Alert(
              title: "Alert !!!",
              subTile: "Email is required !",
            );
          });
    } else {
      Navigator.pop(context);
    }
  }

  bool isSave = false;
  checkChanged() {
    if (nameController.text.isNotEmpty &&
        genderVal != null &&
        dateVal != null &&
        phoneNumController.text.isNotEmpty &&
        alamat.text.isNotEmpty) {
      setState(() {
        isSave = true;
      });
    } else {
      isSave = false;
    }
  }

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
      var filePath = '${directory?.path}/${fileName}.pdf';
      await File(filePath).writeAsBytes(bytes);
    }
  }

  // Future<void> downloadFilepdf() async {
  //   Directory? directory;

  //   try {
  //     if (Platform.isAndroid) {
  //       directory = await getExternalStorageDirectory();
  //     } else if (Platform.isIOS) {
  //       directory = await getApplicationDocumentsDirectory();
  //     }

  //     if (directory == null) {
  //       // Tangani situasi jika direktori tidak ditemukan
  //       return;
  //     }

  //     final taskId = await FlutterDownloader.enqueue(
  //       url:
  //           "https://digilabs.petrokimia-gresik.com/document/11426971_220204014802.pdf",
  //       savedDir: directory.path,
  //       fileName: "1683944847159_23051301.pdf",
  //       showNotification: true,
  //       openFileFromNotification: true,
  //     );

  //     // Tambahkan logika tambahan sesuai kebutuhan Anda, seperti penanganan event saat unduhan selesai atau gagal.
  //   } catch (error) {
  //     // Tangani kesalahan saat mengunduh file.
  //   }
  // }

  // Future<void> downloadAndOpenPDF() async {
  //   var directory = await getExternalStorageDirectory();
  //   String downloadPath = directory.path;

  //   final taskId = await FlutterDownloader.enqueue(
  //     url:
  //         'https://digilabs.petrokimia-gresik.com/document/11426971_220204014802.pdf',
  //     savedDir: downloadPath,
  //     fileName: 'examp879luhhe.pdf',
  //     showNotification: true,
  //     openFileFromNotification: true,
  //   );
  // }

  // void _download() async {
  //   final status = await Permission.storage.request();

  //   if (status.isGranted) {
  //     var directory = await getExternalStorageDirectory();
  //     String downloadPath = directory!.path;
  //     var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  //     var random = Random().nextInt(999999).toString().padLeft(6, '0');

  //     final Id = await FlutterDownloader.enqueue(
  //       url:
  //           "http://103.27.206.23/decpetro/document/1683944847159_230513093901_22176211.pdf",
  //       savedDir: downloadPath,
  //       fileName: 'bukti_$timestamp$random.pdf',
  //       showNotification: true,
  //       saveInPublicStorage: true,
  //       openFileFromNotification: true,
  //     );
  //   } else {
  //     print('Permission Denied');
  //   }
  // }

  Future<void> pdfdo() async {
    String url =
        'http://103.27.206.23/decpetro/project/pekerjaan_usulan/downloadDokumenUsulan?pekerjaan_id=1670209077204&pekerjaan_dokumen_file=94587462_230619015531.pdf~07fe23fc2f206a80b736d1afed18910ce4e5a723';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        String filePath = '${directory.path}/bukti_1687158077452055877.pdf';
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        showDownloadNotification();
        print('File downloaded successfully. Path: $filePath');
      } else {
        print('Error: Unable to get external storage directory.');
      }
    } else {
      print(
          'Error: Failed to download file. Status code: ${response.statusCode}');
    }
  }

  void showDownloadNotification() {
    // Menggunakan platform channel untuk memanggil method native untuk menampilkan notifikasi
    const platform = MethodChannel('com.gocranev3/downloadChannel');
    try {
      platform.invokeMethod('showNotification', {
        'title': 'Download Complete',
        'body': 'File berhasil diunduh.',
      });
    } on PlatformException catch (e) {
      print('Error showing notification: ${e.message}');
    }
  }

  // Future<void> unduhpdf() async {
  //   try {
  //     final taskId = await FlutterDownloader.enqueue(
  //       url:
  //           "http://103.27.206.23/decpetro/document/1683944847159_230513093901_22176211.pdf",
  //       savedDir:
  //           '/path/to/directory', // Ubah dengan direktori penyimpanan yang sesuai di perangkat
  //       fileName: "ujocoba,pdf",
  //       showNotification: true,
  //       openFileFromNotification: true,
  //     );

  //     // Tambahkan logika tambahan sesuai kebutuhan Anda, seperti penanganan event saat unduhan selesai atau gagal.
  //   } catch (error) {
  //     // Tangani kesalahan saat mengunduh file.
  //   }
  // }

  Future<void> showNotification(
      BuildContext context, String title, String body, String pdfPath) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: pdfPath, // Menggunakan payload untuk menyimpan path file PDF
    );
  }

  Future<void> openPDF(File file) async {
    final url = file.uri.toString();

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> showDownloadingIndicatorT(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Downloading..."),
            ],
          ),
        );
      },
    );
  }

  Future<void> generatePDFAndNotify(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.SizedBox(height: 20),
          pw.Row(
            children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(16),
                child: pw.Text(
                  "Order Transaksi",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    color: PdfColor.fromInt(0xff141414),
                    fontSize: 18,
                    font: pw.Font.helveticaBold(),
                  ),
                ),
              ),
            ],
          ),
          pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Container(
              alignment: pw.Alignment.center,
              child: pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: 'Halo, ini adalah kode QR',
                width: 200.0,
                height: 200.0,
              ),
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Container(
            alignment: pw.Alignment.center,
            child: pw.Text(
              "Transaksi Berhasil",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                color: PdfColor.fromInt(0xff2ab2a2),
                fontSize: 20,
                font: pw.Font.helveticaBold(),
              ),
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Padding(
            padding: pw.EdgeInsets.symmetric(horizontal: 20),
            child: pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Container(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "No. Transaksi",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(
                            color: PdfColor.fromInt(0xff2ab2a2),
                            fontSize: 16,
                            font: pw.Font.helveticaBold(),
                          ),
                        ),
                        pw.Text(
                          "Periode",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(
                            color: PdfColor.fromInt(0xff2ab2a2),
                            fontSize: 16,
                            font: pw.Font.helveticaBold(),
                          ),
                        ),
                        pw.Text(
                          "Waktu",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(
                            color: PdfColor.fromInt(0xff2ab2a2),
                            fontSize: 16,
                            font: pw.Font.helveticaBold(),
                          ),
                        ),
                        pw.Text(
                          "Alber",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(
                            color: PdfColor.fromInt(0xff2ab2a2),
                            fontSize: 16,
                            font: pw.Font.helveticaBold(),
                          ),
                        ),
                        pw.Text(
                          "Biaya",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(
                            color: PdfColor.fromInt(0xff2ab2a2),
                            fontSize: 16,
                            font: pw.Font.helveticaBold(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 8),
                    child: pw.Container(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            ":",
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(0xff2ab2a2),
                              fontSize: 16,
                              font: pw.Font.helveticaBold(),
                            ),
                          ),
                          pw.Text(
                            ":",
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(0xff2ab2a2),
                              fontSize: 16,
                              font: pw.Font.helveticaBold(),
                            ),
                          ),
                          pw.Text(
                            ":",
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(0xff2ab2a2),
                              fontSize: 16,
                              font: pw.Font.helveticaBold(),
                            ),
                          ),
                          pw.Text(
                            ":",
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(0xff2ab2a2),
                              fontSize: 16,
                              font: pw.Font.helveticaBold(),
                            ),
                          ),
                          pw.Text(
                            ":",
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(0xff2ab2a2),
                              fontSize: 16,
                              font: pw.Font.helveticaBold(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(
                          child: pw.Text(
                            "162216231624",
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(0xff000000),
                              fontSize: 16,
                              font: pw.Font.helveticaBold(),
                            ),
                          ),
                        ),
                        pw.SizedBox(
                          child: pw.Row(
                            children: [
                              pw.Text(
                                "tgl_awal_ymd",
                                textAlign: pw.TextAlign.left,
                                style: pw.TextStyle(
                                  color: PdfColor.fromInt(0xff000000),
                                  fontSize: 16,
                                  font: pw.Font.helveticaBold(),
                                ),
                              ),
                              pw.Text(
                                " - ",
                                textAlign: pw.TextAlign.left,
                                style: pw.TextStyle(
                                  color: PdfColor.fromInt(0xff000000),
                                  fontSize: 16,
                                  font: pw.Font.helveticaBold(),
                                ),
                              ),
                              pw.Text(
                                "tgl_akhir_ymd",
                                textAlign: pw.TextAlign.left,
                                style: pw.TextStyle(
                                  color: PdfColor.fromInt(0xff000000),
                                  fontSize: 16,
                                  font: pw.Font.helveticaBold(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        pw.SizedBox(
                          child: pw.Text(
                            "11.30 - 12.30",
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(0xff000000),
                              fontSize: 16,
                              font: pw.Font.helveticaBold(),
                            ),
                          ),
                        ),
                        pw.SizedBox(
                          child: pw.Text(
                            "Bulldozer",
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(0xff000000),
                              fontSize: 16,
                              font: pw.Font.helveticaBold(),
                            ),
                          ),
                        ),
                        pw.SizedBox(
                          child: pw.Text(
                            "24.800.000",
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(0xff000000),
                              fontSize: 16,
                              font: pw.Font.helveticaBold(),
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
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/example.pdf");
    // await file.writeAsBytes(pdf.save());

    // Tampilkan notifikasi di App Bar bahwa file telah diunduh
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF has been downloaded'),
        duration: Duration(seconds: 2),
      ),
    );
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    Future<void> initializeNotifications() async {
      var initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');

      var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          openPDF(file);
        },
      );
    }
  }

  Future notif(String aksi, String pdf) async {
    final prefs = await SharedPreferences.getInstance();

    var iduser = (prefs.get('usr_id'));
    final Response = await http.post(
      Uri.parse('http://103.27.206.23/api_gocrane_v3/notifikasi.php'),
      body: {'id_user': iduser, 'body': "Unduhan Selesai", 'transaksi': "pdf"},
    );
    if (Response.statusCode != 200) {
      throw Exception('Gagal Mengirim Notifikasi');
    }
  }

  Future<void> unduhpdf2() async {
    await Permission.storage.request();
    var directory = await getExternalStorageDirectory();

    String down = directory!.path;
    try {
      final request = await HttpClient().getUrl(Uri.parse(
          'http://103.27.206.23/decpetro/project/pekerjaan_usulan/downloadDokumenUsulan?pekerjaan_id=1670209077204&pekerjaan_dokumen_file=94587462_230619015531.pdf~07fe23fc2f206a80b736d1afed18910ce4e5a723'));
      final response = await request.close();
      response.pipe(File(down).openWrite());
      // Tambahkan logika tambahan sesuai kebutuhan Anda, seperti penanganan event saat unduhan selesai atau gagal.
    } catch (error) {
      // Tangani kesalahan saat mengunduh file.
    }
  }

  void sendpdfbuka() async {
    String url =
        'https://media.neliti.com/media/publications/281919-analisis-sistem-pengolahan-absensi-karya-7075a71b.pdf';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Tidak dapat membuka WhatsApp';
    }
  }

  final String pdfUrl = 'http://103.157.97.200/api_gocrane/pdf_api.php';

  Future<void> _downloadAndOpenPDF(BuildContext context) async {
    // Memeriksa izin penyimpanan
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
      status = await Permission.storage.status;
    }

    if (status.isGranted) {
      final response = await http.get(Uri.parse(pdfUrl));
      if (response.statusCode == 200) {
        final dir = await getExternalStorageDirectory();
        final file = File('${dir!.path}/my_pdf_file.pdf');
        await file.writeAsBytes(response.bodyBytes);

        // Membuka file PDF dengan menggunakan url_launcher
        if (await canLaunch(file.path)) {
          await launch(file.path);
        } else {
          Fluttertoast.showToast(
            msg: 'Cannot open PDF',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        }

        Fluttertoast.showToast(
          msg: 'PDF Downloaded and Opened',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Error downloading PDF',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Permission not granted',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  // Future<void> downloadFilepdf2(
  //     String url, FlutterLocalNotificationsPlugin notifications) async {
  //   try {
  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  //       var random = Random().nextInt(999999).toString().padLeft(6, '0');

  //       final directory = await getExternalStorageDirectory();
  //       final filePath =
  //           '${directory!.path}/downloaded_filebukti_$timestamp$random.pdf';

  //       final file = File(filePath);
  //       await file.writeAsBytes(response.bodyBytes);

  //       print('File berhasil diunduh dan disimpan di: $filePath');

  //       // Tampilkan notifikasi
  //       _showPDFNotification(notifications, 'File berhasil diunduh',
  //           'Klik untuk membuka PDF', filePath);
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => PDFViewerScaffold(
  //             appBar: AppBar(
  //               title: Text('PDF Viewer'),
  //             ),
  //             path: filePath,
  //           ),
  //         ),
  //       );
  //     } else {
  //       print('Error saat mengunduh file');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  Future<void> _showPDFNotification(
    FlutterLocalNotificationsPlugin notifications,
    String title,
    String body,
    String filePath,
  ) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'pdf_channel_id', 'PDF Channel',
        importance: Importance.high, priority: Priority.high, ticker: 'ticker');
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notifications.show(0, title, body, platformChannelSpecifics,
        payload: filePath);
  }

  Future<void> _showNotification(FlutterLocalNotificationsPlugin notifications,
      String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Ganti dengan ID channel yang unik
      'Your Channel Name',

      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await notifications.show(
      0, // ID notifikasi
      title,
      body,
      platformChannelSpecifics,
    );
  }

  List? data_alber;
  Future ambildata() async {
    final Response = await http.post(
        Uri.parse("http://103.27.206.23/api_gocrane_v3/unit.php"),
        body: {"id_jenis_alber": alber_jenis ?? ""});
    if (this.mounted) {
      setState(() {
        data_alber = jsonDecode(Response.body);
        print(data_alber);
        print(alber_jenis);
      });
    }
  }

  // List? data_alber;
  Future ambildataAlber() async {
    final Response = await http.post(
        Uri.parse("http://103.27.206.23/api_gocrane_v3/unit_transaksi.php"),
        body: {
          "id_jenis_alber": alber_jenis ?? "",
          "transaksi_tanggal_awal": tgl_awal_ymd ?? "",
          "transaksi_tanggal_akhir": tgl_akhir_ymd ?? ""
        });
    if (this.mounted) {
      setState(() {
        data_alber = jsonDecode(Response.body);
        print(data_alber);
        print(alber_jenis);
      });
    }
  }

  bool downloading = false;
  String? downloadedFilePath;
  late PDFDocument document;
  String? taskId;
  MediaQueryData? queryData;
  var formatCurrency;

  Future<void> downloadPDF() async {
    setState(() {
      downloading = true;
    });

    final response = await http.get(Uri.parse(pdfUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final filePath = documentDirectory.path + "/document.pdf";

    taskId = await FlutterDownloader.enqueue(
      url: pdfUrl,
      savedDir: documentDirectory.path,
      fileName: "document.pdf",
      showNotification: true,
      openFileFromNotification: true,
    );
    await launch('file://$filePath');
    // Wait until the download is complete
    FlutterDownloader.registerCallback((id, status, progress) {
      if (id == taskId && status == DownloadTaskStatus.complete) {
        setState(() {
          downloading = false;
          downloadedFilePath = filePath;
        });
        FlutterDownloader.registerCallback(
            downloadCallback as DownloadCallback);
      }
    });
  }

  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  Directory? documentDirectory;
  Future<void> generatePDF() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child: pw.Text('Hello, PDF!'),
      );
    }));

    final bytes = await pdf.save();
    documentDirectory = await getApplicationDocumentsDirectory();
    ;

    if (documentDirectory != null) {
      final filePath = '${documentDirectory!.path}/generated_pdf.pdf';
      File(filePath).writeAsBytes(bytes);

      // Simpan path file untuk diunduh
      setState(() {
        _downloadPath = filePath;
      });

      // Mulai proses unduh
      _startDownload(filePath);
    } else {
      print('Error: External storage directory not available.');
    }
  }

  String? _downloadPath;

  Future<void> _startDownload(String filePath) async {
    documentDirectory = await getApplicationDocumentsDirectory();
    ;
    if (documentDirectory != null) {
      final taskId = await FlutterDownloader.enqueue(
        url:
            'file://$filePath', // Menyertakan "file://" untuk menunjukkan bahwa ini adalah file lokal
        savedDir: documentDirectory!.path,
        fileName: 'downloaded_pdf.pdf',
        showNotification: true,
        openFileFromNotification: true,
      );

      print('Task ID: $taskId');
    } else {
      print('Error: External storage directory not available.');
    }
  }

////////////////////////////////////////////////////////////////////////////////
  Future<void> _requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      // Lanjutkan dengan operasi yang membutuhkan izin
    } else {
      // Izin ditolak, berikan pesan kepada pengguna
      print('Permission denied');
    }
  }

  Future<void> _chooseStorageAndDownload3() async {
    try {
      Directory downloadsDir = await _getDownloadsDirectory();
      // Memulai proses unduh
      await _startDownload3(downloadsDir.path);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Directory> _getDownloadsDirectory() async {
    final downloadsPath = await _getPlatformDownloadsPath();
    final downloadsDir = Directory(downloadsPath);

    if (!downloadsDir.existsSync()) {
      downloadsDir.createSync(recursive: true);
    }

    return downloadsDir;
  }

  Future<String> _getPlatformDownloadsPath() async {
    final platform = Platform.isAndroid ? 'Download' : 'Downloads';

    try {
      final result = await MethodChannel('downloads_path_provider')
          .invokeMethod('getDownloadsDirectory');
      return result ?? '';
    } catch (e) {
      return '/storage/emulated/0/$platform'; // fallback path for Android
    }
  }

  Future<void> _startDownload3(String selectedDirectory) async {
    setState(() {
      downloading = true;
    });

    try {
      // Ganti dengan metode pengunduhan yang sesuai dengan aplikasi Anda
      // Misalnya, menggunakan http package untuk mengunduh file PDF dari URL
      final response = await http.get(Uri.parse(pdfUrl));
      final Uint8List bytes = response.bodyBytes;

      final filePath = '$selectedDirectory/document.pdf';
      File(filePath).writeAsBytesSync(bytes);

      setState(() {
        downloading = false;
        downloadedFilePath = filePath;
      });

      print('Downloaded file to: $filePath');
    } catch (e) {
      print('Error: $e');
    }
  }

////////////////////////////////////////////////////////////////////////////////
  Future<void> chooseStorageAndDownload() async {
    // Request storage permission
    final storageStatus = await Permission.storage.request();
    if (storageStatus != PermissionStatus.granted) {
      // Handle permission denied case
      return;
    }

    Directory? selectedDirectory = await getExternalStorageDirectory();
    if (selectedDirectory == null) {
      print('Error: Failed to get the selected directory.');
      return;
    }
    await _startDownload2(selectedDirectory);
  }

  Future<void> _startDownload2(Directory selectedDirectory) async {
    setState(() {
      downloading = true;
    });

    final response = await http.get(Uri.parse(pdfUrl));
    final filePath = '${selectedDirectory.path}/document.pdf';

    taskId = await FlutterDownloader.enqueue(
      url: pdfUrl,
      savedDir: selectedDirectory.path,
      fileName: "document.pdf",
      showNotification: true,
      openFileFromNotification:
          false, // Set ke false agar tidak membuka file otomatis
    );

    // Buka file dengan browser setelah pengunduhan selesai
    await launch('file://$filePath');

    // Wait until the download is complete
    FlutterDownloader.registerCallback((id, status, progress) {
      if (id == taskId && status == DownloadTaskStatus.complete) {
        setState(() {
          downloading = false;
          downloadedFilePath = filePath;
        });
        // Tidak perlu mendaftar callback di dalam callback
      }
    });
  }
  /////////////////////////////////////////////////////////////////////////////////
  // Future<void> chooseStorageAndDownload() async {
  //   // Request storage permission
  //   final storageStatus = await Permission.storage.request();
  //   if (storageStatus != PermissionStatus.granted) {
  //     // Handle permission denied case
  //     return;
  //   }

  //   Directory? selectedDirectory = await getExternalStorageDirectory();
  //   if (selectedDirectory == null) {
  //     print('Error: Failed to get the selected directory.');
  //     return;
  //   }

  //   await _startDownload2(selectedDirectory);
  // }

  // Future<void> _startDownload2(Directory selectedDirectory) async {
  //   setState(() {
  //     downloading = true; // Only update state before download starts
  //   });

  //   final pdfUrl =
  //       'http://103.157.97.200/api_gocrane/pdf_api.php'; // Replace with your actual PDF URL
  //   final filePath = '${selectedDirectory.path}/document1.pdf';

  //   try {
  //     final response = await http.get(Uri.parse(pdfUrl));
  //     if (response.statusCode == 200) {
  //       await File(filePath).writeAsBytes(response.bodyBytes);

  //       setState(() {
  //         // Update state after download completes successfully
  //         downloading = false;
  //         downloadedFilePath = filePath;
  //       });

  //       // Launch the downloaded file using platform-specific methods or state management
  //     } else {
  //       print('Error: Download failed with status code ${response.statusCode}');
  //       // Handle network error
  //     }
  //   } on Exception catch (error) {
  //     print('Error: Download failed with exception: $error');
  //     // Handle other exceptions
  //   } finally {
  //     // Optionally, unregister the callback here if needed
  //   }
  // }
  ////////////////////////////////////////////////////////////////////////////////////
  // bool downloading = false;
  // String downloadedFilePath = '';

////////////////////////////////////////////////////////////////////////////////////
  // Future<void> chooseStorageAndDownload(BuildContext context) async {
  //   Directory? selectedDirectory = await getExternalStorageDirectory();
  //   if (selectedDirectory != null) {
  //     // Get user preference for automatic opening
  //     bool openAutomatically = await _getOpenFilePreference(context);

  //     // Start download with user preference
  //     await _startDownload2(selectedDirectory, openAutomatically);
  //   } else {
  //     print('Error: Failed to get the selected directory.');
  //   }
  // }

  // Future<bool> _getOpenFilePreference(BuildContext context) async {
  //   bool openAutomatically = false;
  //   await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Open File Automatically?'),
  //       content: Text(
  //           'Do you want to open the downloaded file automatically after completion?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, false),
  //           child: Text('No'),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, true),
  //           child: Text('Yes'),
  //         ),
  //       ],
  //     ),
  //   ).then((value) => openAutomatically = value ?? false);
  //   return openAutomatically;
  // }

  // Future<void> _startDownload2(
  //     Directory selectedDirectory, bool openAutomatically) async {
  //   setState(() {
  //     downloading = true;
  //   });

  //   final response = await http.get(Uri.parse(pdfUrl));
  //   final filePath = '${selectedDirectory.path}/${fileName ?? "document.pdf"}';

  //   taskId = await FlutterDownloader.enqueue(
  //     url: pdfUrl,
  //     savedDir: selectedDirectory.path,
  //     fileName: fileName,
  //     showNotification: true,
  //     openFileFromNotification: openAutomatically,
  //   );

  //   if (!openAutomatically) {
  //     // Open file manually if automatic opening is disabled
  //     await launch('file://$filePath');
  //   }

  //   // Wait until the download is complete
  //   FlutterDownloader.registerCallback((id, status, progress) {
  //     if (id == taskId && status == DownloadTaskStatus.complete) {
  //       setState(() {
  //         downloading = false;
  //         downloadedFilePath = filePath;
  //       });
  //     }
  //   });
  // }

  String? fileName; // Make filename optional
// bool downloading = false;
// String? downloadedFilePath;
////////////////////////////////////////////////////////////////////////////////////
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

////////////////////////////////////////////////////////////////////////////////////
  ///
  @override
  void initState() {
    indikator = MyStepperWidget();
    btn = "Lanjut Pilih Unit";
    tombol_riset = false;
    konten = formwaktu();
    // lihatprofil();
    // TODO: implement initState
    super.initState();
    FlutterDownloader.initialize(debug: true);

    ambildataAlber();

    // IsolateNameServer.registerPortWithName(
    //     _port.sendPort, 'downloader_send_port');
    // _port.listen((dynamic data) {
    //   String id = data[0];
    //   DownloadTaskStatus status = data[1];
    //   int progress = data[2];
    //   setState(() {
    //     // Update UI state based on download progress/status
    //   });
    // });

    // FlutterDownloader.registerCallback(downloadCallback);
    // final InitializationSettings initializationSettings =
    //     InitializationSettings(
    //         android: AndroidInitializationSettings(
    //             'app_icon')); // Ganti dengan nama icon aplikasi Anda
    // flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  // static void downloadCallback(
  //     String id, DownloadTaskStatus status, int progress) {
  //   final SendPort send =
  //       IsolateNameServer.lookupPortByName('downloader_send_port');
  //   send.send([id, status, progress]);
  // }

  @override
  Widget build(BuildContext context) {
    formatCurrency =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
    queryData = MediaQuery.of(context);
    return MediaQuery(
      data: queryData!.copyWith(textScaleFactor: 1.0),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                        top: 15,
                        bottom: 0,
                        start: 0,
                        end: 0,
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            "Order Transaksi",
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
                const SizedBox(
                  height: 20,
                ),

                indikator ?? Container(),
                const SizedBox(
                  height: 10,
                ),

                Visibility(
                  visible: unit_list == "n" ? true : false,
                  child: Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        konten ?? Container(),
                      ],
                    ),
                  ),
                ),
//////////////////pekerjaan_data di kirim di sini///////////////////////
                Visibility(
                  visible: unit_list == "p" ? true : false,
                  child: Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              //Space
                              const SizedBox(
                                height: 20,
                              ),
                              const Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      "Pilih Pekerjaan",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xff141414),
                                        fontSize: 18,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.09,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 16, bottom: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      "Lokasi",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.07,
                                      ),
                                    ),
                                    Text(
                                      "*",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.07,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Stack(
                                  children: [
                                    TextFormField(
                                      cursorColor:
                                          Color.fromARGB(255, 48, 47, 47),
                                      controller: transaksiLokasiController,
                                      onChanged: (_) {},
                                      decoration: const InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(255, 48, 47,
                                                  47)), // Ubah warna border saat terfokus
                                        ),
                                        contentPadding:
                                            EdgeInsets.only(left: 14),
                                        hintText: "Masukan Lokasi",
                                        labelStyle: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "medium",
                                            color: Color.fromARGB(
                                                255, 31, 31, 31)),
                                        border: OutlineInputBorder(
                                          // Tambahkan border di sini
                                          // Atur radius sesuai keinginan
                                          borderSide: BorderSide(
                                            // Tentukan warna dan ketebalan garis
                                            color: Colors.grey, // Warna garis
                                            width: 1.0, // Ketebalan garis
                                          ),
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                      ),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: "medium",
                                          color:
                                              Color.fromARGB(255, 31, 31, 31)),
                                    ),
                                  ],
                                ),
                              ),

                              const Padding(
                                padding: EdgeInsets.only(
                                    left: 16, bottom: 10, top: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      "Jenis Barang",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.07,
                                      ),
                                    ),
                                    Text(
                                      "*",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.07,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Stack(
                                  children: [
                                    TextFormField(
                                      cursorColor:
                                          Color.fromARGB(255, 48, 47, 47),
                                      controller:
                                          transaksiJenisBarangController,
                                      onChanged: (_) {},
                                      decoration: const InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(255, 48, 47,
                                                  47)), // Ubah warna border saat terfokus
                                        ),
                                        contentPadding:
                                            EdgeInsets.only(left: 14),
                                        hintText: "Masukan Jenis Barang",
                                        labelStyle: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "medium",
                                            color: Colors.black),
                                        border: OutlineInputBorder(
                                          // Tambahkan border di sini
                                          // Atur radius sesuai keinginan
                                          borderSide: BorderSide(
                                            // Tentukan warna dan ketebalan garis
                                            color: Colors.grey, // Warna garis
                                            width: 1.0, // Ketebalan garis
                                          ),
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                      ),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: "medium",
                                          color:
                                              Color.fromARGB(255, 31, 31, 31)),
                                    ),
                                  ],
                                ),
                              ),

                              //
                              const Padding(
                                padding: EdgeInsets.only(
                                    left: 16, top: 10, bottom: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      "No. SAP",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.07,
                                      ),
                                    ),
                                    Text(
                                      "*",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.07,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Stack(
                                  children: [
                                    TextFormField(
                                      cursorColor:
                                          Color.fromARGB(255, 48, 47, 47),
                                      controller: transaksiSapController,
                                      onChanged: (_) {},
                                      decoration: const InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(255, 48, 47,
                                                  47)), // Ubah warna border saat terfokus
                                        ),
                                        contentPadding:
                                            EdgeInsets.only(left: 14),
                                        hintText: "Masukan No. SAP",
                                        labelStyle: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "medium",
                                            color: Colors.black),
                                        border: OutlineInputBorder(
                                          // Tambahkan border di sini
                                          // Atur radius sesuai keinginan
                                          borderSide: BorderSide(
                                            // Tentukan warna dan ketebalan garis
                                            color: Colors.grey, // Warna garis
                                            width: 1.0, // Ketebalan garis
                                          ),
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                      ),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: "medium",
                                          color:
                                              Color.fromARGB(255, 31, 31, 31)),
                                    ),
                                  ],
                                ),
                              ),

                              //First name & Last name
                              const Padding(
                                padding: EdgeInsets.only(
                                    left: 16, top: 10, bottom: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      "Nama PIC",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.07,
                                      ),
                                    ),
                                    Text(
                                      "*",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.07,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //Gender
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Stack(
                                  children: [
                                    TextFormField(
                                      cursorColor:
                                          Color.fromARGB(255, 48, 47, 47),
                                      controller: transaksiPicController,
                                      onChanged: (_) {},
                                      decoration: const InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(255, 48, 47,
                                                  47)), // Ubah warna border saat terfokus
                                        ),
                                        contentPadding:
                                            EdgeInsets.only(left: 14),
                                        hintText: "Masukan Nama PIC",
                                        labelStyle: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "medium",
                                            color: Colors.black),
                                        border: OutlineInputBorder(
                                          // Tambahkan border di sini
                                          // Atur radius sesuai keinginan
                                          borderSide: BorderSide(
                                            // Tentukan warna dan ketebalan garis
                                            color: Colors.grey, // Warna garis
                                            width: 1.0, // Ketebalan garis
                                          ),
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                      ),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: "medium",
                                          color:
                                              Color.fromARGB(255, 31, 31, 31)),
                                    ),
                                  ],
                                ),
                              ),

                              //Space

                              //Email
                              const Padding(
                                padding: EdgeInsets.only(
                                    left: 16, top: 10, bottom: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      "No. Extention",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.07,
                                      ),
                                    ),
                                    Text(
                                      "*",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.07,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //Gender
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Stack(
                                  children: [
                                    TextFormField(
                                      cursorColor:
                                          Color.fromARGB(255, 48, 47, 47),
                                      controller:
                                          transaksiNoExtentionController,
                                      onChanged: (_) {},
                                      decoration: const InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(255, 48, 47,
                                                  47)), // Ubah warna border saat terfokus
                                        ),
                                        contentPadding:
                                            EdgeInsets.only(left: 14),
                                        hintText: "Masukan No. Extention",
                                        labelStyle: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "medium",
                                            color: Colors.black),
                                        border: OutlineInputBorder(
                                          // Tambahkan border di sini
                                          // Atur radius sesuai keinginan
                                          borderSide: BorderSide(
                                            // Tentukan warna dan ketebalan garis
                                            color: Colors.grey, // Warna garis
                                            width: 1.0, // Ketebalan garis
                                          ),
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                      ),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: "medium",
                                          color:
                                              Color.fromARGB(255, 31, 31, 31)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: indikator is MyStepperWidget_3
                              ? const EdgeInsets.all(8)
                              : const EdgeInsets.all(16.0),
                          child: MaterialButton(
                              height: 44,
                              onPressed: () {
                                setState(() async {
                                  if (indikator is MyStepperWidget) {
                                    indikator = MyStepperWidget_2();
                                    tombol_riset = false;

                                    btn = "Reset";
                                    unit_list = "y";
                                  } else if (indikator is MyStepperWidget_2) {
                                    tombol_riset = false;
                                    btn = "Lanjut Pilih Unit";
                                    unit_list = "n";
                                    indikator = MyStepperWidget();
                                    konten = formwaktu();
                                  } else if (indikator is MyStepperWidget_3) {
                                    tombol_riset = false;
                                    unit_list = "n";
                                    konten = bukti_reg();
                                    indikator = MyStepperWidget_4();
                                    btn = "Unduh";
                                    _insertDataOrder();
                                  } else if (indikator is MyStepperWidget_4) {
                                    // notif("Unduh Berhasil", "123");
                                    //downloadPDF();
                                    //await chooseStorageAndDownload();
                                    downloadPdf(context);
                                    // generatePDF();
                                    // unduhpdf2();
                                    //_download();
                                    // downloadFilepdf2(
                                    //     "http://103.27.206.23/decpetro/document/1683944847159_230513093901_22176211.pdf",
                                    //     flutterLocalNotificationsPlugin);
                                    // sendpdfbuka();
                                    // pdfdo();
                                    // _downloadAndOpenPDF(context);
                                  }
                                });

                                // FocusScope.of(context).requestFocus(FocusNode());
                                // _edit();
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 320,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x21000000),
                                          blurRadius: 26,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                      color: const Color(0xff2ab2a2),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          btn!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.08,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Visibility(
                          visible: tombol_riset!,
                          child: Padding(
                            padding: indikator is MyStepperWidget_3
                                ? const EdgeInsets.all(8)
                                : const EdgeInsets.all(16.0),
                            child: MaterialButton(
                                height: 44,
                                onPressed: () {
                                  setState(() {
                                    if (indikator is MyStepperWidget_3) {
                                      indikator = MyStepperWidget_2();
                                      konten = pilihunit();
                                      tombol_riset = false;
                                      unit_list = "y";
                                      btn = "Reset";
                                    }
                                  });

                                  // FocusScope.of(context).requestFocus(FocusNode());
                                  // _edit();
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 320,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x21000000),
                                            blurRadius: 26,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                        color: const Color(0xff2ab2a2),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Reset",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.08,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ), ////////////////////akhir pekerjaaan
////////////////////////Untuk memilih Unit
                Visibility(
                  visible: indikator is MyStepperWidget_2 ? true : false,
                  child: Expanded(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                "Pilih Unit",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xff141414),
                                  fontSize: 18,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.09,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount:
                                  data_alber == null ? 0 : data_alber?.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                    onTap: () {
                                      if (data_alber![index]["isAvailable"] ==
                                          false) {
                                        print("kosong");
                                      } else {
                                        setState(() {
                                          indikator = MyStepperWidget_3();
                                          btn = "Lanjut Cetak Bukti";
                                          tombol_riset = true;
                                          konten = pilihpekerjaan();
                                          unit_list = "p";
                                          idAlberController.text =
                                              data_alber![index]["alber_id"];
                                          transaksiTonaseCraneController.text =
                                              data_alber![index]
                                                  ["alber_kapasitas"];

                                          //////////////////////////////////////
                                          transaksiBiayaMdmController.text =
                                              data_alber![index]
                                                  ["alber_tarif_mdm"];
                                          transaksiTonaseCraneController.text =
                                              data_alber![index]
                                                  ["alber_kapasitas"];
                                          transaksiNominalController.text =
                                              data_alber![index]["alber_tarif"];
                                        });
                                      }
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Container(
                                                          width: 130,
                                                          height: 130,
                                                          decoration:
                                                              ShapeDecoration(
                                                            image:
                                                                const DecorationImage(
                                                              image: NetworkImage(
                                                                  "https://images.unsplash.com/photo-1586458995526-09ce6839babe?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=873&q=80"),
                                                              fit: BoxFit.cover,
                                                            ),
                                                            color: const Color(
                                                                0xFFD9D9D9),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 16),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              7),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        data_alber![index]["alber_no_plat"] ??
                                                                            "",
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Color(0xff141414),
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              "Inter",
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              10),
                                                                      Text(
                                                                        data_alber![index]["isAvailable"] ==
                                                                                true
                                                                            ? "Tersedia"
                                                                            : "Tidak Tersedia",
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style:
                                                                            TextStyle(
                                                                          color: data_alber![index]["isAvailable"] == true
                                                                              ? Colors.green
                                                                              : Colors.red,
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              "Inter",
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            7),
                                                                child: Text(
                                                                  data_alber![index]
                                                                          [
                                                                          "alber_merk"] ??
                                                                      "",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Color(
                                                                        0xff141414),
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        "Inter",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                ),
                                                              ),
                                                              // Padding(
                                                              //   padding:
                                                              //       const EdgeInsets.only(
                                                              //           bottom: 7),
                                                              //   child: Text(
                                                              //     "HT/TR",
                                                              //     textAlign: TextAlign.left,
                                                              //     style: TextStyle(
                                                              //       color: Color(0xff141414),
                                                              //       fontSize: 16,
                                                              //       fontFamily: "Inter",
                                                              //       fontWeight:
                                                              //           FontWeight.w400,
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Table(
                                                            columnWidths: const {
                                                              1: FractionColumnWidth(
                                                                  0.1),
                                                              0: FractionColumnWidth(
                                                                  0.5),
                                                            },
                                                            children: [
                                                              buildRow(
                                                                  "Kapasitas",
                                                                  "( ${data_alber![index]["alber_kapasitas"]} Ton)",
                                                                  14),
                                                              buildRow(
                                                                  "Biaya MDM",
                                                                  "${formatCurrency.format(double.parse(data_alber![index]["alber_tarif_mdm"]))}",
                                                                  14),
                                                              // buildRow(
                                                              //     "Biaya Satuan Waktu",
                                                              //     "Rp. ${data_alber[index]["st"]}",
                                                              //     14),
                                                              buildRow(
                                                                  "Total Biaya",
                                                                  " ${formatCurrency.format(double.parse(data_alber![index]["alber_tarif"]))}",
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
                                            ],
                                          ),
                                        )));
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
///////////////////////akhir selet unit
                Visibility(
                  visible: unit_list != "p" ? true : false,
                  child: Padding(
                    padding: indikator is MyStepperWidget_3
                        ? const EdgeInsets.all(8)
                        : const EdgeInsets.all(16.0),
                    child: MaterialButton(
                        height: 44,
                        onPressed: () {
                          setState(() async {
                            if (indikator is MyStepperWidget) {
                              indikator = MyStepperWidget_2();
                              tombol_riset = false;
                              btn = "Reset";
                              unit_list = "y";
                              ambildataAlber();
                            } else if (indikator is MyStepperWidget_2) {
                              tombol_riset = false;
                              btn = "Lanjut Pilih Unit";
                              unit_list = "n";
                              indikator = MyStepperWidget();
                              konten = formwaktu();
                            } else if (indikator is MyStepperWidget_3) {
                              tombol_riset = false;
                              unit_list = "n";
                              konten = bukti_reg();
                              indikator = MyStepperWidget_4();
                              btn = "Unduh";
                              _insertDataOrder();
                            } else if (indikator is MyStepperWidget_4) {
                              //  Uint8List pdf = await generatePDF();

                              // downloadFilepdf2(
                              //     "http://103.27.206.23/decpetro/document/1683944847159_230513093901_22176211.pdf",
                              //     flutterLocalNotificationsPlugin);
                              //notif("Unduh Berhasil", "123");
                              // pdfdo();
                              //downloadPDF();
                              // await chooseStorageAndDownload();
                              downloadPdf(context);
                              // generatePDF();
                              //notif("Unduh Selsai", "123");
                            }
                          });

                          // FocusScope.of(context).requestFocus(FocusNode());
                          // _edit();
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 320,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x21000000),
                                    blurRadius: 26,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                                color: const Color(0xff2ab2a2),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    btn!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.08,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
                Visibility(
                  visible: unit_list != "p" ? true : false,
                  child: Visibility(
                    visible: tombol_riset!,
                    child: Padding(
                      padding: indikator is MyStepperWidget_3
                          ? const EdgeInsets.all(8)
                          : const EdgeInsets.all(16.0),
                      child: MaterialButton(
                          height: 44,
                          onPressed: () {
                            setState(() {
                              if (indikator is MyStepperWidget_3) {
                                indikator = MyStepperWidget_2();
                                konten = pilihunit();
                                tombol_riset = false;
                                unit_list = "y";
                                btn = "Reset";
                              }
                            });

                            // FocusScope.of(context).requestFocus(FocusNode());
                            // _edit();
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 320,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x21000000),
                                      blurRadius: 26,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  color: const Color(0xff2ab2a2),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Reset",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.08,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
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
  String? genderVal;
  void genderDialogue() {
    showDialog<void>(
      context: context,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            insetPadding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(genderList.length, (index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          genderVal = genderList[index]["kode"];
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          genderList[index]["jenis_kelamin"],
                          style: const TextStyle(
                              fontSize: 18,
                              fontFamily: "medium",
                              color: Color.fromARGB(255, 31, 31, 31)),
                        ),
                      ),
                    );
                  })),
            ),
          );
        });
      },
    );
  }
}

TableRow buildRow(String title, String value, double shiz) {
  return TableRow(
    children: [
      TableCell(
        child: SizedBox(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.06,
            ),
          ),
        ),
      ),
      const TableCell(
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
                style: const TextStyle(
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
