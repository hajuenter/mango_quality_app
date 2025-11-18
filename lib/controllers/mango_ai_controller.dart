import 'dart:async';
import 'package:get/get.dart';
import '../models/mango_ai_model.dart';
import '../services/mango_ai_service.dart';

class MangoAiController extends GetxController {
  final MangoAiService _service = MangoAiService();

  RxList<MangoAiModel> messages = <MangoAiModel>[].obs;
  RxBool isTyping = false.obs;
  RxBool isFreeMode = false.obs;

  RxBool showWelcome = true.obs;

  RxBool isLoadingBubble = false.obs;

  void addLoadingBubble() {
    if (isLoadingBubble.value) return;

    isLoadingBubble.value = true;
    messages.add(MangoAiModel(sender: "bot", text: "...", isLoading: true));
  }

  void removeLoadingBubble() {
    if (!isLoadingBubble.value) return;

    if (messages.isNotEmpty && messages.last.isLoading) {
      messages.removeLast();
    }

    isLoadingBubble.value = false;
  }

  void onWelcomeFinished() async {
    showWelcome.value = false;

    addLoadingBubble();
    await Future.delayed(const Duration(seconds: 1));
    removeLoadingBubble();

    sendInitialOptions();
  }

  void sendInitialOptions() {
    messages.add(
      MangoAiModel(
        sender: 'bot',
        text: """
Halo! Pilih bantuan:
1. Cara menanam mangga
2. Cara merawat mangga
3. Ciri-ciri mangga sehat dan busuk
4. Hama dan penyakit umum pada mangga
5. Tanya bebas apa saja
        """,
      ),
    );
    isFreeMode.value = false;
  }

  void clearChat() {
    messages.clear();
    isFreeMode.value = false;
    showWelcome.value = true;
    isLoadingBubble.value = false;
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    messages.add(MangoAiModel(sender: 'user', text: text));

    if (!isFreeMode.value) {
      if (!(["1", "2", "3", "4", "5"].contains(text))) {
        _botReply("⚠️ Silakan pilih opsi 1–5 terlebih dahulu.");
        return;
      }

      if (text != "5") {
        addLoadingBubble();
        await Future.delayed(const Duration(seconds: 2));
        removeLoadingBubble();

        switch (text) {
          case "1":
            _botReply(
              "Cara menanam mangga yang baik dan benar agar tanaman dapat tumbuh subur dan cepat berbuah:\n\n"
              "1. **Pilih Bibit Unggul:**\n"
              "- Gunakan bibit dari varietas yang sesuai dengan kondisi tanah.\n"
              "- Pastikan bibit sehat.\n\n"
              "2. **Media Tanam:**\n"
              "- Gunakan tanah gembur + kompos.\n\n"
              "3. **Jarak Tanam:** 5–7 meter.\n\n"
              "4. **Penanaman:**\n"
              "- Lubang 50–60 cm.\n\n"
              "5. **Penyiraman:**\n"
              "- Siram 1–2× sehari pada minggu awal.",
            );
            return;

          case "2":
            _botReply(
              "Cara merawat pohon mangga:\n\n"
              "1. Penyiraman rutin.\n"
              "2. Pemupukan NPK.\n"
              "3. Pemangkasan.\n"
              "4. Pengendalian hama.",
            );
            return;

          case "3":
            _botReply(
              "Ciri mangga sehat:\n"
              "- Kulit cerah.\n"
              "- Aroma harum.\n"
              "- Tidak banyak bercak.\n\n"
              "Ciri mangga busuk:\n"
              "- Lembek.\n"
              "- Aroma asam.\n"
              "- Ada jamur.",
            );
            return;

          case "4":
            _botReply(
              "Hama mangga:\n"
              "- Kutu putih.\n"
              "- Wereng.\n"
              "- Ulat.\n\n"
              "Penyakit:\n"
              "- Antraknosa.\n"
              "- Powdery mildew.",
            );
            return;
        }
      }

      if (text == "5") {
        isFreeMode.value = true;
        _botReply("Anda masuk mode tanya bebas. Silakan bertanya.");
        return;
      }
    }

    addLoadingBubble();
    isTyping.value = true;

    final reply = await _service.sendToGemini(text);

    removeLoadingBubble();
    isTyping.value = false;

    _botReply(reply);
  }

  void _botReply(String text) {
    messages.add(MangoAiModel(sender: 'bot', text: text));
  }
}
