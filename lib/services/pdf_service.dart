import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../models/season_model.dart';

class PdfService {
  static Future<File> generateSeasonPdf(SeasonModel season) async {
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
              style: pw.TextStyle(fontSize: 24),
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
          pw.Text('Ringkasan Data Sortir', style: pw.TextStyle(fontSize: 18)),
          pw.SizedBox(height: 12),

          // Tabel Data
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400),
            columnWidths: {0: pw.FlexColumnWidth(2), 1: pw.FlexColumnWidth(1)},
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  _buildTableCell('Kategori'),
                  _buildTableCell('Jumlah'),
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
                  _buildTableCell('Total'),
                  _buildTableCell(
                    season.totalCount.toString(),
                    align: pw.TextAlign.right,
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 24),

          // Persentase
          pw.Text('Analisis Persentase', style: pw.TextStyle(fontSize: 18)),
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
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
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
        pw.SizedBox(width: 120, child: pw.Text(label)),
        pw.Text(': '),
        pw.Expanded(child: pw.Text(value)),
      ],
    );
  }

  static pw.Widget _buildTableCell(
    String text, {
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(8),
      child: pw.Text(text, textAlign: align),
    );
  }

  static pw.Widget _buildPercentageRow(String label, double percentage) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [pw.Text(label), pw.Text('${percentage.toStringAsFixed(1)}%')],
    );
  }
}
