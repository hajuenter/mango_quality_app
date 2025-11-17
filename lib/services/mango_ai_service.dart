import 'package:flutter_gemini/flutter_gemini.dart';

class MangoAiService {
  final Gemini _gemini = Gemini.instance;

  Future<String> sendToGemini(String text) async {
    try {
      final response = await _gemini.prompt(parts: [Part.text(text)]);

      return response?.output ?? "Tidak ada jawaban.";
    } catch (e) {
      return "Terjadi kesalahan: $e";
    }
  }
}
