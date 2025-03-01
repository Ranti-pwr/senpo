import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gocrane_v3_new/tampilan/SlideRightRoute.dart';
import 'package:http/http.dart' as http;
import 'package:cell_calendar/cell_calendar.dart';

class EventDetail {
  final String title;
  final String value;

  EventDetail(this.title, this.value);
}

class CalendarScreen2 extends StatefulWidget {
  const CalendarScreen2({required this.id, required this.alber});
  final String id;
  final String alber;

  @override
  _CalendarScreen2State createState() => _CalendarScreen2State();
}

class _CalendarScreen2State extends State<CalendarScreen2> {
  List<CalendarEvent> _events = [];
  bool _isLoading = true;
  bool _isLoadingt = false;

  String? unit;
  String? pic;

  String? dep;
  String? noext;
  String? jaw;
  String? jak;

  List? det;

  List? detalber;

  Future<List<EventDetail>?> cektransaksi(String? id_tr, String? tgl) async {
    final Response = await http.post(
      Uri.parse("http://103.27.206.23/api_gocrane_v3/data_transaksi.php"),
      body: {'id': id_tr, 'paht': 'tc', 'tgl': tgl},
    );

    var _data = jsonDecode(Response.body);

    if (_data == null) {
      print(null);
      print(id_tr);
      print(tgl);
      print(_data);
      return []; // Tambahkan pernyataan return di sini
    } else {
      this.setState(() {
        det = _data;
      });

      final Rsponse = await http.post(
        Uri.parse("http://103.27.206.23/api_gocrane_v3/data_transaksi.php"),
        body: {'id': widget.alber, 'paht': 'ab', 'tgl': tgl},
      );
      var _data2 = jsonDecode(Rsponse.body);

      if (_data2 == null) {
        print(null);
        print(id_tr);
        print(tgl);
        print(_data2);
        return []; // Tambahkan pernyataan return di sini
      } else {
        this.setState(() {
          detalber = _data2;
        });
      }
    }

    _showDetailPopup(context);
    return null;
  }

  // Future<List<EventDetail>> cektransaksi(String? id_tr, String? tgl) async {
  //   final Response = await http.post(
  //     Uri.parse("http://103.27.206.23/api_gocrane_v3/data_transaksi.php"),
  //     body: {'id': id_tr, 'paht': 'tc', 'tgl': tgl},
  //   );

  //   var _data = jsonDecode(Response.body);

  //   if (_data == null) {
  //     print(null);
  //     print(id_tr);
  //     print(tgl);
  //     print(_data);
  //   } else {
  //     this.setState(() {
  //       det = _data;
  //     });

  //     final Rsponse = await http.post(
  //       Uri.parse("http://103.27.206.23/api_gocrane_v3/data_transaksi.php"),
  //       body: {'id': widget.alber, 'paht': 'ab', 'tgl': tgl},
  //     );
  //     var _data2 = jsonDecode(Rsponse.body);

  //     if (_data2 == null) {
  //       print(null);
  //       print(id_tr);
  //       print(tgl);
  //       print(_data2);
  //     } else {
  //       this.setState(() {
  //         detalber = _data2;
  //       });
  //     }
  //   }

  //   _showDetailPopup(context);

  // }

  int? selectedEventIndex;

  Future<void> loadData() async {
    List<dynamic>? jsonData;
    final Response = await http.post(
      Uri.parse("http://103.27.206.23/api_gocrane_v3/data_transaksi.php"),
      body: {'id': widget.id, 'paht': 't'},
    );

    this.setState(() {
      jsonData = jsonDecode(Response.body);
      _isLoading = false;
    });

    _events = jsonData!.map((json) {
      String title = "${json['transaksi_lokasi']} (${json['transaksi_pic']})";
      DateTime date = DateTime.parse(json['transaksi_tanggal']);
      return CalendarEvent(
        eventID: json['id_alber'],
        eventName: title,
        eventDate: date,
        eventBackgroundColor:
            json['kode_transaksi'] == "pg" ? Colors.amber : Colors.green,
        eventTextStyle: const TextStyle(color: Colors.white),
      );
    }).toList();
  }

  DateTime? currentMonth;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    loadData();
    super.initState();

    currentMonth = DateTime.now();

    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  void _onCalendarChange(DateTime dateTime) {
    setState(() {
      currentMonth = dateTime;
    });
  }

  String _formatMonthYear(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}";
  }

  MediaQueryData? queryData;

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
                Container(
                  height: 50,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned.directional(
                        textDirection: Directionality.of(context),
                        start: 3,
                        top: 0,
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
                      Positioned.directional(
                        textDirection: Directionality.of(context),
                        top: 0,
                        bottom: 0,
                        start: 0,
                        end: 0,
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            "Cek Schedule",
                            style: TextStyle(
                              fontSize: 25,
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
                  height: 10,
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                          child: CellCalendar(
                            events: _events,
                            onCellTapped: (date) {
                              List<CalendarEvent> eventList = _events
                                  .where((event) => event.eventDate == date)
                                  .toList();
                              if (eventList.isNotEmpty) {
                                String? eventID = eventList[0].eventID;
                                DateTime eventDate = eventList[0].eventDate;
                                String eventtgl =
                                    "${eventDate.year}-${eventDate.month.toString().padLeft(2, '0')}-${eventDate.day.toString().padLeft(2, '0')}";
                                print(eventID);
                                print(
                                    eventtgl); // Mengambil ID dari acara pertama dalam daftar
                                cektransaksi(eventID, eventtgl);
                              }
                            },
                            daysOfTheWeekBuilder: (int dayIndex) {
                              final days = [
                                'Min',
                                'Sen',
                                'Sel',
                                'Rab',
                                'Kam',
                                'Jum',
                                'Sab'
                              ];
                              return Center(
                                child: Text(
                                  days[dayIndex],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: dayIndex == 0
                                        ? Colors.red
                                        : (dayIndex == 6
                                            ? Colors.blue
                                            : null), // Warna teks hari Minggu dan Sabtu
                                  ),
                                ),
                              );
                            },
                            dateTextStyle: TextStyle(
                              color: Colors
                                  .black, // Sesuaikan warna teks tanggal sesuai kebutuhan Anda
                            ),
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

  void _showDetailPopup(BuildContext context) {
    late PageController _pageController;
    int _currentPage = 0;

    _pageController = PageController();
    _pageController.addListener(() {
      if (_currentPage != _pageController.page?.round()) {
        _currentPage = _pageController.page?.round() ?? 0;
      }
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        content: _isLoadingt
            ? const Center(child: CircularProgressIndicator())
            : Container(
                width: 340,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.transparent,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          child: const Icon(Icons.close),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Detail",
                        style: TextStyle(
                          color: Color(0xff141414),
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.08,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Scrollbar(
                        child: ListView.builder(
                          controller: _pageController,
                          scrollDirection: Axis.horizontal,
                          itemCount: det == null ? 0 : det!.length,
                          itemBuilder: (context, index) {
                            final event = det![index];
                            if (event != null) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: Container(
                                    width: 300,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Table(
                                        columnWidths: {
                                          1: const FractionColumnWidth(0.1),
                                          0: const FractionColumnWidth(0.5),
                                        },
                                        children: [
                                          buildRow("Unit",
                                              event["alber_no_plat"] ?? "", 14),
                                          buildRow("Nama Pemesan",
                                              event["transaksi_pic"] ?? "", 14),
                                          buildRow(
                                              "Departemen",
                                              event["struk_detail_nama"] ?? "",
                                              14),
                                          buildRow(
                                              "No. Ext",
                                              event["transaksi_no_extention"] ??
                                                  "",
                                              14),
                                          buildRow(
                                              "Jam Awal",
                                              event["transaksi_jam_mulai"] ??
                                                  "",
                                              14),
                                          buildRow(
                                              "Jam Akhir",
                                              event["transaksi_jam_selesai"] ??
                                                  "",
                                              14),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Rekomendasi Alber ",
                        style: TextStyle(
                          color: Color(0xff141414),
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.08,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Scrollbar(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: detalber == null ? 0 : detalber!.length,
                          itemBuilder: (context, index) {
                            final event2 = detalber![index];
                            if (event2 != null) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        SlidePageRoute(
                                          page: CalendarScreen2(
                                            id: event2['alber_id'] ?? "",
                                            alber: event2['alber_kode'] ?? "",
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 200,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            image: const DecorationImage(
                                              image: NetworkImage(
                                                "https://media.istockphoto.com/id/862598472/photo/truck-crane.jpg?s=170667a&w=0&k=20&c=b5YBmqSurVWi9m71V-J3YyyZQH_zOM8Gw2FNqFGemrs=",
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                event2['alber_no_plat'] ?? "",
                                                style: const TextStyle(
                                                  color: Color(0xff141414),
                                                  fontSize: 10,
                                                  letterSpacing: 0.05,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                event2['alber_merk'] ?? "",
                                                style: const TextStyle(
                                                  color: Color(0xff141414),
                                                  fontSize: 14,
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.07,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                event2['alber_kode'] ?? "",
                                                style: const TextStyle(
                                                  color: Color(0xff141414),
                                                  fontSize: 10,
                                                  letterSpacing: 0.05,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                event2['alber_kapasitas'] ?? "",
                                                style: const TextStyle(
                                                  color: Color(0xff141414),
                                                  fontSize: 10,
                                                  letterSpacing: 0.05,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // void _showDetailPopup(BuildContext context, List<EventDetail> eventDetails) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(6.0),
  //       ),
  //       content: _isLoadingt
  //           ? Center(child: CircularProgressIndicator())
  //           : SingleChildScrollView(
  //               // Tambahkan SingleChildScrollView di sini
  //               child: Container(
  //                 width: 340,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(6),
  //                     topRight: Radius.circular(6),
  //                     bottomLeft: Radius.circular(0),
  //                     bottomRight: Radius.circular(0),
  //                   ),
  //                   color: Colors.white,
  //                 ),
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Container(
  //                       width: 308,
  //                       child: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.end,
  //                         children: [
  //                           Padding(
  //                             padding:
  //                                 const EdgeInsets.symmetric(horizontal: 8),
  //                             child: InkWell(
  //                               onTap: () {
  //                                 Navigator.pop(context);
  //                               },
  //                               child: Container(
  //                                 width: 12.14,
  //                                 height: 12.14,
  //                                 child: Icon(Icons.close),
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(height: 4),
  //                           SizedBox(
  //                             width: double.infinity,
  //                             child: Text(
  //                               "Detail",
  //                               style: TextStyle(
  //                                 color: Color(0xff141414),
  //                                 fontSize: 16,
  //                                 fontFamily: "Inter",
  //                                 fontWeight: FontWeight.w600,
  //                                 letterSpacing: 0.08,
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(height: 4),
  //                           Container(
  //                             width: double.infinity,
  //                             child: SingleChildScrollView(
  //                               child: Column(
  //                                 mainAxisSize: MainAxisSize.min,
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: eventDetails
  //                                     .map(
  //                                       (detail) => Container(
  //                                         height: 20,
  //                                         child: Center(
  //                                           child: Container(
  //                                             child: Table(
  //                                               columnWidths: {
  //                                                 1: FractionColumnWidth(0.1),
  //                                                 0: FractionColumnWidth(0.5),
  //                                               },
  //                                               children: [
  //                                                 buildRow2(
  //                                                   detail.title ?? "",
  //                                                   detail.value ?? "",
  //                                                   14,
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     )
  //                                     .toList(),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //     ),
  //   );
  // }

  Row buildRow2(String title, String value, double shiz) {
    return Row(
      children: [
        SizedBox(
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
        const FractionallySizedBox(
          widthFactor: 0.1,
          child: Text(
            ":",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.06,
            ),
          ),
        ),
        SizedBox(
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
    );
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
            widthFactor: 0.1,
            child: Text(
              ":",
              textAlign: TextAlign.center,
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
          child: SizedBox(
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
        ),
      ],
    );
  }
}
