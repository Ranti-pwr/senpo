// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';


// class PDFScreen extends StatefulWidget {
//  final Uint8List? path; 

//   PDFScreen({Key? key, this.path}) : super(key: key);

//   _PDFScreenState createState() => _PDFScreenState();
// }

// class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
//   final Completer<PDFViewController> _controller =
//       Completer<PDFViewController>();
//   int? pages = 0;
//   int? currentPage = 0;
//   bool isReady = false;
//   String errorMessage = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Document"),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.share),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Stack(
//         children: <Widget>[
//           pdfViewer.PDFView(
//             filePath: widget.path,
//             enableSwipe: true,
//             swipeHorizontal: true,
//             autoSpacing: false,
//             pageFling: true,
//             pageSnap: true,
//             defaultPage: currentPage!,
//             fitPolicy: FitPolicy.BOTH,
//             preventLinkNavigation:
//                 false, // if set to true the link is handled in flutter
//             onRender: (_pages) {
//               setState(() {
//                 pages = _pages;
//                 isReady = true;
//               });
//             },
//             onError: (error) {
//               setState(() {
//                 errorMessage = error.toString();
//               });
//               print(error.toString());
//             },
//             onPageError: (page, error) {
//               setState(() {
//                 errorMessage = '$page: ${error.toString()}';
//               });
//               print('$page: ${error.toString()}');
//             },
//             onViewCreated: (PDFViewController pdfViewController) {
//               _controller.complete(pdfViewController);
//             },
//             onLinkHandler: (String? uri) {
//               print('goto uri: $uri');
//             },
//             onPageChanged: (int? page, int? total) {
//               print('page change: $page/$total');
//               setState(() {
//                 currentPage = page;
//               });
//             },
//           ),
//           errorMessage.isEmpty
//               ? !isReady
//                   ? Center(
//                       child: CircularProgressIndicator(),
//                     )
//                   : Container()
//               : Center(
//                   child: Text(errorMessage),
//                 )
//         ],
//       ),
//       floatingActionButton: FutureBuilder<PDFViewController>(
//         future: _controller.future,
//         builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
//           if (snapshot.hasData) {
//             return FloatingActionButton.extended(
//               label: Text("Go to ${pages! ~/ 2}"),
//               onPressed: () async {
//                 await snapshot.data!.setPage(pages! ~/ 2);
//               },
//             );
//           }

//           return Container();
//         },
//       ),
//     );
//   }
// }
  // Future<void> generatePDFAndNotify(BuildContext context) async {
  //   final pdf = pw.Document();

  //   pdf.addPage(
  //     pw.MultiPage(
  //       build: (pw.Context context) => [
  //         pw.SizedBox(height: 20),
  //         pw.Row(
  //           children: [
  //             pw.Padding(
  //               padding: pw.EdgeInsets.all(16),
  //               child: pw.Text(
  //                 "Order Transaksi",
  //                 textAlign: pw.TextAlign.center,
  //                 style: pw.TextStyle(
  //                   color: PdfColor.fromInt(0xff141414),
  //                   fontSize: 18,
  //                   font: pw.Font.helveticaBold(),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         pw.Align(
  //           alignment: pw.Alignment.center,
  //           child: pw.Container(
  //             alignment: pw.Alignment.center,
  //             child: pw.BarcodeWidget(
  //               barcode: pw.Barcode.qrCode(),
  //               data: 'Halo, ini adalah kode QR',
  //               width: 200.0,
  //               height: 200.0,
  //             ),
  //           ),
  //         ),
  //         pw.SizedBox(height: 12),
  //         pw.Container(
  //           alignment: pw.Alignment.center,
  //           child: pw.Text(
  //             "Transaksi Berhasil",
  //             textAlign: pw.TextAlign.center,
  //             style: pw.TextStyle(
  //               color: PdfColor.fromInt(0xff2ab2a2),
  //               fontSize: 20,
  //               font: pw.Font.helveticaBold(),
  //             ),
  //           ),
  //         ),
  //         pw.SizedBox(height: 12),
  //         pw.Padding(
  //           padding: pw.EdgeInsets.symmetric(horizontal: 20),
  //           child: pw.Container(
  //             alignment: pw.Alignment.center,
  //             child: pw.Row(
  //               crossAxisAlignment: pw.CrossAxisAlignment.start,
  //               mainAxisAlignment: pw.MainAxisAlignment.center,
  //               children: [
  //                 pw.Container(
  //                   child: pw.Column(
  //                     crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                     children: [
  //                       pw.Text(
  //                         "No. Transaksi",
  //                         textAlign: pw.TextAlign.left,
  //                         style: pw.TextStyle(
  //                           color: PdfColor.fromInt(0xff2ab2a2),
  //                           fontSize: 16,
  //                           font: pw.Font.helveticaBold(),
  //                         ),
  //                       ),
  //                       pw.Text(
  //                         "Periode",
  //                         textAlign: pw.TextAlign.left,
  //                         style: pw.TextStyle(
  //                           color: PdfColor.fromInt(0xff2ab2a2),
  //                           fontSize: 16,
  //                           font: pw.Font.helveticaBold(),
  //                         ),
  //                       ),
  //                       pw.Text(
  //                         "Waktu",
  //                         textAlign: pw.TextAlign.left,
  //                         style: pw.TextStyle(
  //                           color: PdfColor.fromInt(0xff2ab2a2),
  //                           fontSize: 16,
  //                           font: pw.Font.helveticaBold(),
  //                         ),
  //                       ),
  //                       pw.Text(
  //                         "Alber",
  //                         textAlign: pw.TextAlign.left,
  //                         style: pw.TextStyle(
  //                           color: PdfColor.fromInt(0xff2ab2a2),
  //                           fontSize: 16,
  //                           font: pw.Font.helveticaBold(),
  //                         ),
  //                       ),
  //                       pw.Text(
  //                         "Biaya",
  //                         textAlign: pw.TextAlign.left,
  //                         style: pw.TextStyle(
  //                           color: PdfColor.fromInt(0xff2ab2a2),
  //                           fontSize: 16,
  //                           font: pw.Font.helveticaBold(),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 pw.Padding(
  //                   padding: pw.EdgeInsets.symmetric(horizontal: 8),
  //                   child: pw.Container(
  //                     child: pw.Column(
  //                       crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                       children: [
  //                         pw.Text(
  //                           ":",
  //                           textAlign: pw.TextAlign.left,
  //                           style: pw.TextStyle(
  //                             color: PdfColor.fromInt(0xff2ab2a2),
  //                             fontSize: 16,
  //                             font: pw.Font.helveticaBold(),
  //                           ),
  //                         ),
  //                         pw.Text(
  //                           ":",
  //                           textAlign: pw.TextAlign.left,
  //                           style: pw.TextStyle(
  //                             color: PdfColor.fromInt(0xff2ab2a2),
  //                             fontSize: 16,
  //                             font: pw.Font.helveticaBold(),
  //                           ),
  //                         ),
  //                         pw.Text(
  //                           ":",
  //                           textAlign: pw.TextAlign.left,
  //                           style: pw.TextStyle(
  //                             color: PdfColor.fromInt(0xff2ab2a2),
  //                             fontSize: 16,
  //                             font: pw.Font.helveticaBold(),
  //                           ),
  //                         ),
  //                         pw.Text(
  //                           ":",
  //                           textAlign: pw.TextAlign.left,
  //                           style: pw.TextStyle(
  //                             color: PdfColor.fromInt(0xff2ab2a2),
  //                             fontSize: 16,
  //                             font: pw.Font.helveticaBold(),
  //                           ),
  //                         ),
  //                         pw.Text(
  //                           ":",
  //                           textAlign: pw.TextAlign.left,
  //                           style: pw.TextStyle(
  //                             color: PdfColor.fromInt(0xff2ab2a2),
  //                             fontSize: 16,
  //                             font: pw.Font.helveticaBold(),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 pw.Expanded(
  //                   child: pw.Column(
  //                     crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                     children: [
  //                       pw.SizedBox(
  //                         child: pw.Text(
  //                           "162216231624",
  //                           textAlign: pw.TextAlign.left,
  //                           style: pw.TextStyle(
  //                             color: PdfColor.fromInt(0xff000000),
  //                             fontSize: 16,
  //                             font: pw.Font.helveticaBold(),
  //                           ),
  //                         ),
  //                       ),
  //                       pw.SizedBox(
  //                         child: pw.Row(
  //                           children: [
  //                             pw.Text(
  //                               "tgl_awal_ymd",
  //                               textAlign: pw.TextAlign.left,
  //                               style: pw.TextStyle(
  //                                 color: PdfColor.fromInt(0xff000000),
  //                                 fontSize: 16,
  //                                 font: pw.Font.helveticaBold(),
  //                               ),
  //                             ),
  //                             pw.Text(
  //                               " - ",
  //                               textAlign: pw.TextAlign.left,
  //                               style: pw.TextStyle(
  //                                 color: PdfColor.fromInt(0xff000000),
  //                                 fontSize: 16,
  //                                 font: pw.Font.helveticaBold(),
  //                               ),
  //                             ),
  //                             pw.Text(
  //                               "tgl_akhir_ymd",
  //                               textAlign: pw.TextAlign.left,
  //                               style: pw.TextStyle(
  //                                 color: PdfColor.fromInt(0xff000000),
  //                                 fontSize: 16,
  //                                 font: pw.Font.helveticaBold(),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       pw.SizedBox(
  //                         child: pw.Text(
  //                           "11.30 - 12.30",
  //                           textAlign: pw.TextAlign.left,
  //                           style: pw.TextStyle(
  //                             color: PdfColor.fromInt(0xff000000),
  //                             fontSize: 16,
  //                             font: pw.Font.helveticaBold(),
  //                           ),
  //                         ),
  //                       ),
  //                       pw.SizedBox(
  //                         child: pw.Text(
  //                           "Bulldozer",
  //                           textAlign: pw.TextAlign.left,
  //                           style: pw.TextStyle(
  //                             color: PdfColor.fromInt(0xff000000),
  //                             fontSize: 16,
  //                             font: pw.Font.helveticaBold(),
  //                           ),
  //                         ),
  //                       ),
  //                       pw.SizedBox(
  //                         child: pw.Text(
  //                           "24.800.000",
  //                           textAlign: pw.TextAlign.left,
  //                           style: pw.TextStyle(
  //                             color: PdfColor.fromInt(0xff000000),
  //                             fontSize: 16,
  //                             font: pw.Font.helveticaBold(),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );

  //   final output = await getTemporaryDirectory();
  //   final file = File("${output.path}/example.pdf");
  //   // await file.writeAsBytes(pdf.save());

  //   // Tampilkan notifikasi di App Bar bahwa file telah diunduh
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('PDF has been downloaded'),
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  //   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //       FlutterLocalNotificationsPlugin();

  //   Future<void> initializeNotifications() async {
  //     var initializationSettingsAndroid =
  //         AndroidInitializationSettings('app_icon');

  //     var initializationSettings = InitializationSettings(
  //       android: initializationSettingsAndroid,
  //     );
  //     await flutterLocalNotificationsPlugin.initialize(
  //       initializationSettings,
  //       onDidReceiveNotificationResponse: (details) {
  //         openPDF(file);
  //       },
  //     );
  //   }
  // }