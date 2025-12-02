import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../models/season_model.dart';

class PdfService {
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      if (androidInfo.version.sdkInt >= 33) {
        // Android 13+ tidak perlu permission untuk menulis ke Downloads
        return true;
      } else if (androidInfo.version.sdkInt >= 30) {
        // Android 11+
        var status = await Permission.manageExternalStorage.status;
        if (!status.isGranted) {
          status = await Permission.manageExternalStorage.request();
        }
        return status.isGranted;
      } else {
        // Android 10 dan ke bawah
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
        return status.isGranted;
      }
    }
    return true;
  }

  static Future<File> generateSeasonPdf(SeasonModel season) async {
    final hasPermission = await requestStoragePermission();
    if (!hasPermission) {
      throw Exception('Permission storage ditolak');
    }

    final pdf = pw.Document();
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (context) => [
          // Header
          pw.Header(
            level: 0,
            child: pw.Text(
              'Laporan Musim Panen',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),

          // Info Musim
          pw.Container(
            padding: pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Nama Musim', season.name),
                pw.SizedBox(height: 8),
                _buildInfoRow(
                  'Tanggal Mulai',
                  dateFormat.format(season.startedAt),
                ),
                pw.SizedBox(height: 8),
                _buildInfoRow(
                  'Tanggal Selesai',
                  season.endedAt != null
                      ? dateFormat.format(season.endedAt!)
                      : '-',
                ),
                pw.SizedBox(height: 8),
                _buildInfoRow(
                  'Status',
                  season.status == 'active' ? 'Aktif' : 'Selesai',
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 24),

          // Ringkasan Data
          pw.Text(
            'Ringkasan Data Sortir',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),

          // Tabel Data
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400),
            columnWidths: {0: pw.FlexColumnWidth(2), 1: pw.FlexColumnWidth(1)},
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  _buildTableCell('Kategori', bold: true),
                  _buildTableCell('Jumlah', bold: true),
                ],
              ),
              pw.TableRow(
                children: [
                  _buildTableCell('Mangga Sehat'),
                  _buildTableCell(
                    season.healthyCount.toString(),
                    align: pw.TextAlign.right,
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  _buildTableCell('Mangga Busuk'),
                  _buildTableCell(
                    season.rottenCount.toString(),
                    align: pw.TextAlign.right,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _buildTableCell('Total', bold: true),
                  _buildTableCell(
                    season.totalCount.toString(),
                    align: pw.TextAlign.right,
                    bold: true,
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 24),

          // Persentase
          pw.Text(
            'Analisis Persentase',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          pw.Container(
            padding: pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildPercentageRow(
                  'Persentase Sehat',
                  season.totalCount > 0
                      ? (season.healthyCount / season.totalCount * 100)
                      : 0,
                ),
                pw.SizedBox(height: 8),
                _buildPercentageRow(
                  'Persentase Busuk',
                  season.totalCount > 0
                      ? (season.rottenCount / season.totalCount * 100)
                      : 0,
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 40),
          pw.Divider(),
          pw.SizedBox(height: 8),
          pw.Text(
            'Dicetak pada: ${dateFormat.format(DateTime.now())}',
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ],
      ),
    );

    final fileName =
        'Laporan_${season.name.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';

    Directory? directory;

    if (Platform.isAndroid) {
      // Gunakan getExternalStorageDirectory untuk Android 10+
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      if (androidInfo.version.sdkInt >= 30) {
        // Android 11+ - gunakan app-specific directory
        directory = await getExternalStorageDirectory();
        // Buat folder Downloads di dalam app directory
        final downloadsDir = Directory('${directory!.path}/Downloads');
        if (!await downloadsDir.exists()) {
          await downloadsDir.create(recursive: true);
        }
        directory = downloadsDir;
      } else {
        // Android 10 ke bawah - coba akses folder Download publik
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final file = File('${directory!.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 120,
          child: pw.Text(
            label,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Text(': '),
        pw.Expanded(child: pw.Text(value)),
      ],
    );
  }

  static pw.Widget _buildTableCell(
    String text, {
    pw.TextAlign align = pw.TextAlign.left,
    bool bold = false,
  }) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        textAlign: align,
        style: bold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null,
      ),
    );
  }

  static pw.Widget _buildPercentageRow(String label, double percentage) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label),
        pw.Text(
          '${percentage.toStringAsFixed(1)}%',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }
}
