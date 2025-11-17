class MangoAiModel {
  final String sender;
  final String text;
  final bool isLoading;
  final DateTime timestamp;

  MangoAiModel({
    required this.sender,
    required this.text,
    this.isLoading = false,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
