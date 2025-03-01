import 'dart:io';

import 'package:flutter/material.dart';

class DirectoryPickerScreen extends StatefulWidget {
  @override
  _DirectoryPickerScreenState createState() => _DirectoryPickerScreenState();
}

class _DirectoryPickerScreenState extends State<DirectoryPickerScreen> {
  TextEditingController _directoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Directory Picker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _directoryController,
              decoration: InputDecoration(labelText: 'Directory Path'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Validasi jalur direktori, lakukan tindakan sesuai kebutuhan Anda
                String selectedDirectory = _directoryController.text;
                Navigator.pop(context, selectedDirectory);
              },
              child: Text('Select Directory'),
            ),
          ],
        ),
      ),
    );
  }
}
