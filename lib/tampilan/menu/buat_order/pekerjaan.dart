import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gocrane_v3_new/Widget/Alert.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class pilihpekerjaan extends StatefulWidget {
  @override
  _pilihpekerjaanState createState() => _pilihpekerjaanState();
}

class _pilihpekerjaanState extends State<pilihpekerjaan> {
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
  TextEditingController dep_nama = TextEditingController();

  String? nama_user;
  String? alamat_;
  String? nowa;
  String? id_user = "";
  String? image_profil;
  Widget? indikator;

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
    dep_nama.text = "Riset";
    // lihatprofil();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          //Space
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
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
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 10),
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
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                TextFormField(
                  controller: tgllahirController,
                  onChanged: (_) {},
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 14),
                    hintText: "Masukan Lokasi",
                    labelStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: "medium",
                        color: const Color.fromARGB(255, 32, 32, 32)),
                  ),
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "medium",
                      color: const Color.fromARGB(255, 85, 85, 85)),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 10, top: 10),
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
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                TextFormField(
                  controller: tgllahirController,
                  onChanged: (_) {},
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 14),
                    hintText: "Masukan Jenis Barang",
                    labelStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: "medium",
                        color: Colors.black),
                  ),
                  style: TextStyle(
                      fontSize: 14, fontFamily: "medium", color: Colors.black),
                ),
              ],
            ),
          ),

          //
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
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
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                TextFormField(
                  controller: tgllahirController,
                  onChanged: (_) {},
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 14),
                    hintText: "Masukan No. SAP",
                    labelStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: "medium",
                        color: Colors.black),
                  ),
                  style: TextStyle(
                      fontSize: 14, fontFamily: "medium", color: Colors.black),
                ),
              ],
            ),
          ),

          //First name & Last name
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
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
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                TextFormField(
                  controller: tgllahirController,
                  onChanged: (_) {},
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 14),
                    hintText: "Masukan Nama PIC",
                    labelStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: "medium",
                        color: Colors.black),
                  ),
                  style: TextStyle(
                      fontSize: 14, fontFamily: "medium", color: Colors.black),
                ),
              ],
            ),
          ),

          //Space

          //Email
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
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
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                TextFormField(
                  controller: tgllahirController,
                  onChanged: (_) {},
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 14),
                    hintText: "Masukan No. Extention",
                    labelStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: "medium",
                        color: Colors.black),
                  ),
                  style: TextStyle(
                      fontSize: 14, fontFamily: "medium", color: Colors.black),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
