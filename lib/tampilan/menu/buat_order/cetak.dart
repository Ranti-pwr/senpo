import 'dart:convert';
import 'dart:io';

// import 'package:gocrane_v3/pengguna/menu/buat_order/waktu.dart';
import 'package:flutter/material.dart';

import 'package:gocrane_v3_new/Widget/Alert.dart';
import 'package:gocrane_v3_new/tampilan/menu/buat_order/waktu.dart';
// import 'package:gocrane_v3/pengguna/menu/buat_order/creatorder.dart';
// import 'package:gocrane_v3/pengguna/menu/buat_order/indikator_step.dart';
// import 'package:gocrane_v3/pengguna/menu/buat_order/pekerjaan.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class bukti_reg extends StatefulWidget {
  @override
  _bukti_regState createState() => _bukti_regState();
}

class _bukti_regState extends State<bukti_reg> {
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
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Row(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Order Transaksi",
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
        Align(
          alignment: Alignment.center,
          child: Container(
            alignment: Alignment.center,
            child: QrImageView(
              data: 'Halo, ini adalah kode QR',
              version: QrVersions.auto,
              size: 200.0,
            ),

            //widget.list[widget.index]['reservasi_id']),
            // width: double.infinity,
            // height: 200,
            // margin: EdgeInsets.symmetric(horizontal: 14.5),
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //         fit: BoxFit.contain,
            //         image: AssetImage("assets/imgs/qr.png"))),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
            alignment: Alignment.center,
            child: const Text(
              "Transaksi Berhasil",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff2ab2a2),
                fontSize: 20,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
                letterSpacing: 0.08,
              ),
            )),
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Text(
                          "No. Transaksi",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xff2ab2a2),
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.07,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          "Periode",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xff2ab2a2),
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.07,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          "Waktu",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xff2ab2a2),
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.07,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          "Alber",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xff2ab2a2),
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.07,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          "Biaya",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xff2ab2a2),
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.07,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Text(
                            ":",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xff2ab2a2),
                              fontSize: 16,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.07,
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            ":",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xff2ab2a2),
                              fontSize: 16,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.07,
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            ":",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xff2ab2a2),
                              fontSize: 16,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.07,
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            ":",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xff2ab2a2),
                              fontSize: 16,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.07,
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            ":",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xff2ab2a2),
                              fontSize: 16,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.07,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        child: Text(
                          "162216231624",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.07,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          children: [
                            Text(
                              tgl_awal_ymd,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.07,
                              ),
                            ),
                            const Text(
                              " - ",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.07,
                              ),
                            ),
                            Text(
                              tgl_akhir_ymd,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.07,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        child: Text(
                          "11.30 - 12.30",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.07,
                          ),
                        ),
                      ),
                      const SizedBox(
                        child: Text(
                          "Bulldozer",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.07,
                          ),
                        ),
                      ),
                      const SizedBox(
                        child: Text(
                          "24.800.000",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.07,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
