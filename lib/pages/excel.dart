// import 'package:flutter/material.dart';
// import 'package:excel/excel.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/services.dart' show rootBundle;

// class excel extends StatefulWidget {
//   @override
//   _excelState createState() => _excelState();
// }

// class _excelState extends State<excel> {
//   final TextEditingController _snoController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _numberController = TextEditingController();

//   List<List<String>> excelData = [
//     ['Sno', 'Name', 'Number'] // Header row
//   ];

//   void _addDataToExcel() {
//     String sno = _snoController.text;
//     String name = _nameController.text;
//     String number = _numberController.text;

//     excelData.add([sno, name, number]);

//     _snoController.clear();
//     _nameController.clear();
//     _numberController.clear();
//   }

//   void _createNewExcel() {
//     excelData.clear(); // Clear the existing data
//     excelData.add(['Sno', 'Name', 'Number']); // Re-add the header row
//   }

//   Future<void> _saveExcelToFile() async {
//     var excel = Excel.createExcel();
//     var sheet = excel['Sheet1'];

//     for (var row in excelData) {
//       sheet.appendRow(row);
//     }

//     Directory? appDocDir = Directory('/storage/emulated/0/Download');
//     String appDocPath = appDocDir.path;

//     String excelFilePath = '$appDocPath/1.xlsx';

//     File excelFile = File(excelFilePath);
//     final abc = await excel.encode();
//     excelFile.writeAsBytesSync(abc!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Excel Data Entry and Download'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _snoController,
//               decoration: InputDecoration(labelText: 'Sno'),
//             ),
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: 'Name'),
//             ),
//             TextField(
//               controller: _numberController,
//               decoration: InputDecoration(labelText: 'Number'),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _addDataToExcel,
//               child: Text('Add Data to Excel'),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _saveExcelToFile,
//               child: Text('Download Excel'),
//             ),
//             ElevatedButton(
//               onPressed: _createNewExcel,
//               child: Text('Create New Excel'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
