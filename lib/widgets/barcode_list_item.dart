import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/barcode_item.dart';

class BarcodeListItem extends StatelessWidget {
  final BarcodeItem barcode;
  final VoidCallback onDelete;

  const BarcodeListItem({
    super.key,
    required this.barcode,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            _getBarcodeIcon(barcode.type),
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          barcode.value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    barcode.type,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _formatDateTime(barcode.scannedAt),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _copyToClipboard(context),
              icon: const Icon(Icons.copy),
              tooltip: 'Copy',
              iconSize: 20,
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete),
              tooltip: 'Delete',
              iconSize: 20,
              color: Colors.red,
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  IconData _getBarcodeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'qr':
      case 'qr_code':
        return Icons.qr_code;
      case 'ean13':
      case 'ean8':
        return Icons.barcode_reader;
      case 'code128':
      case 'code39':
        return Icons.view_stream;
      case 'datamatrix':
        return Icons.grid_view;
      case 'pdf417':
        return Icons.picture_as_pdf;
      default:
        return Icons.qr_code_scanner;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: barcode.value));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}