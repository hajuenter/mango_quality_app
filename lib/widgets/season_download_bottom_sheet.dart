import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';

import '../../models/season_model.dart';
import '../../services/pdf_service.dart';
import '../config/colors.dart';
import 'custom_snackbar.dart';

class SeasonDownloadBottomSheet {
  static void show(BuildContext context, List<SeasonModel> seasons) {
    if (seasons.isEmpty) {
      CustomSnackbar.show(
        title: 'Info',
        message: 'Tidak ada musim untuk didownload',
        alignment: Alignment.bottomCenter,
        backgroundColor: AppColors.redAuth,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) {
        return _BottomSheetContent(seasons: seasons);
      },
    );
  }
}

class _BottomSheetContent extends StatefulWidget {
  final List<SeasonModel> seasons;

  const _BottomSheetContent({required this.seasons});

  @override
  State<_BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<_BottomSheetContent> {
  String? _downloadingSeasonId;

  Future<void> _handleDownload(SeasonModel season) async {
    setState(() {
      _downloadingSeasonId = season.id;
    });

    try {
      // Generate PDF
      final file = await PdfService.generateSeasonPdf(season);

      // Tutup bottom sheet
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Tampilkan snackbar sukses
      CustomSnackbar.show(
        title: 'Berhasil',
        message: 'PDF ${season.name} berhasil dibuat',
        alignment: Alignment.bottomCenter,
        backgroundColor: AppColors.borGreen,
        icon: Icons.check_circle,
      );

      // Buka file PDF
      await OpenFile.open(file.path);
    } catch (e) {
      // Tampilkan snackbar error
      if (mounted) {
        CustomSnackbar.show(
          title: 'Gagal',
          message: 'Gagal membuat PDF: $e',
          alignment: Alignment.bottomCenter,
          backgroundColor: AppColors.redAuth,
          icon: Icons.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _downloadingSeasonId = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return SafeArea(
          top: false,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // Judul
                Text(
                  'Pilih Musim untuk Download PDF',
                  style: GoogleFonts.rubik(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // List musim
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: widget.seasons.length,
                    itemBuilder: (context, index) {
                      final season = widget.seasons[index];
                      final isDownloading = _downloadingSeasonId == season.id;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: isDownloading
                              ? null
                              : () => _handleDownload(season),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: isDownloading
                                  ? Colors.grey[300]
                                  : Colors.grey[100],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        season.name,
                                        style: GoogleFonts.rubik(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Total: ${season.totalCount} mangga',
                                        style: GoogleFonts.rubik(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isDownloading)
                                  const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                else
                                  const Icon(Icons.download),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
