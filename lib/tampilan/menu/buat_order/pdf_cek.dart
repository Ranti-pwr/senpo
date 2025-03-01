// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';

// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart' as pw;

// class PDFScreen extends StatelessWidget {
//   final String path;

//   PDFScreen({required this.path});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Document"),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.share),
//             onPressed: () {
//               // Tambahkan kode untuk meng-share PDF jika diperlukan.
//             },
//           ),
//         ],
//       ),
//       body: PDFView(
//         filePath: path,
//         enableSwipe: true,
//         swipeHorizontal: true,
//         autoSpacing: false,
//         pageFling: true,
//         pageSnap: true,
//         defaultPage: 0,
//         fitPolicy: FitPolicy.BOTH,
//       ),
//     );
//   }
// }
