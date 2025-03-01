import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gocrane_v3_new/Widget/Alert.dart';
import 'package:gocrane_v3_new/tampilan/menu/buat_order/creatorder.dart';
import 'package:gocrane_v3_new/tampilan/menu/buat_order/indikator_step.dart';
import 'package:gocrane_v3_new/tampilan/menu/buat_order/pekerjaan.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class pilihunit extends StatefulWidget {
  @override
  _pilihunitState createState() => _pilihunitState();
}

class _pilihunitState extends State<pilihunit> {
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

  Future lihatprofil() async {
    final prefs = await SharedPreferences.getInstance();

    id_user = (prefs.get('pegawai_id')) as String?;
    final Response = await http
        .get(Uri.parse("http://103.27.206.23/richzspot/user/getData/$id_user"));
    var profil = jsonDecode(Response.body);
    setState(() {
      if (Response.body == "false") {
        print("null");
      } else {
        // nama_user = profil[0]['username'] ?? "";
        nameController.text = profil['user_nama_lengkap'] ?? "";
        phoneNumController.text = profil['user_no_telp'] ?? "";
        image_profil = profil['user_foto'];
        dateVal = profil['user_tgl_lahir'] ?? "";
        alamat.text = profil['user_alamat'] ?? "";
        jenis = profil['user_jenis_kelamin'] ?? "";
      }
      // gambar = datajson[0]['faskes_foto'];
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

  String? selectedStartTime =
      ''; // Variabel untuk menyimpan nilai terpilih dari dropdown jam awal
  String? selectedEndTime =
      ''; // Variabel untuk menyimpan nilai terpilih dari dropdown jam akhir

  List<String?> startTimeList = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    // Tambahkan pilihan jam awal lainnya sesuai kebutuhan
  ];

  List<String?> endTimeList = [
    '05:00 PM',
    '06:00 PM',
    '07:00 PM',
    // Tambahkan pilihan jam akhir lainnya sesuai kebutuhan
  ];

  MediaQueryData? queryData;
  @override
  void initState() {
    // lihatprofil();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                indikator = MyStepperWidget_3();
                btn = "Lanjut Cetak Bukti";
                tombol_riset = false;
                konten = pilihpekerjaan();
              });
            },
            child: Card(
              child: Container(
                width: 320,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 85,
                          height: 85,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const FlutterLogo(size: 85),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "DZR 17 (Tidak Tersedia)",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xffe00000),
                                fontSize: 14,
                                letterSpacing: 0.07,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Liugong",
                              style: TextStyle(
                                color: Color(0xff141414),
                                fontSize: 14,
                                letterSpacing: 0.07,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 38,
                              height: 18,
                              child: const Stack(
                                children: [
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "4.5 M",
                                        style: TextStyle(
                                          color: Color(0xff141414),
                                          fontSize: 14,
                                          letterSpacing: 0.07,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 33,
                                    top: 0,
                                    child: Text(
                                      "3",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xff141414),
                                        fontSize: 6,
                                        letterSpacing: 0.03,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Biaya MDM : 500.000",
                              style: TextStyle(
                                color: Color(0xff141414),
                                fontSize: 14,
                                letterSpacing: 0.07,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Biaya Satuan Waktu : 24.000.000",
                              style: TextStyle(
                                color: Color(0xff141414),
                                fontSize: 14,
                                letterSpacing: 0.07,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Total Biaya : 24.500.000",
                              style: TextStyle(
                                color: Color(0xff141414),
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
            ),
          ),
        ],
      ),
    );
  }
}
