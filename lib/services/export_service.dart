import 'dart:io';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/barcode_item.dart';

class ExportService {
  static Future<void> exportToCsv(List<BarcodeItem> barcodes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/barcodes_$timestamp.csv');

      List<List<dynamic>> rows = [
        ['Value', 'Type', 'Scanned At']
      ];

      for (var barcode in barcodes) {
        rows.add([
          barcode.value,
          barcode.type,
          barcode.scannedAt.toString(),
        ]);
      }

      String csv = const ListToCsvConverter().convert(rows);
      await file.writeAsString(csv);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Exported Barcodes CSV',
      );
    } catch (e) {
      throw Exception('Failed to export CSV: $e');
    }
  }

  static Future<void> exportToExcel(List<BarcodeItem> barcodes) async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Barcodes'];

      // Add headers
      sheet.cell(CellIndex.indexByString('A1')).value = 'Value';
      sheet.cell(CellIndex.indexByString('B1')).value = 'Type';
      sheet.cell(CellIndex.indexByString('C1')).value = 'Scanned At';

      // Add data
      for (int i = 0; i < barcodes.length; i++) {
        final barcode = barcodes[i];
        final row = i + 2; // Start from row 2 (after header)
        
        sheet.cell(CellIndex.indexByString('A$row')).value = barcode.value;
        sheet.cell(CellIndex.indexByString('B$row')).value = barcode.type;
        sheet.cell(CellIndex.indexByString('C$row')).value = barcode.scannedAt.toString();
      }

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/barcodes_$timestamp.xlsx');

      final excelBytes = excel.encode();
      if (excelBytes != null) {
        await file.writeAsBytes(excelBytes);

        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Exported Barcodes Excel',
        );
      }
    } catch (e) {
      throw Exception('Failed to export Excel: $e');
    }
  }
}