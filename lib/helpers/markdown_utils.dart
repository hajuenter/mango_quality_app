import 'package:markdown/markdown.dart' as md;

String markdownToPlainText(String markdown) {
  final document = md.Document();

  // Parse markdown
  final nodes = document.parseInline(markdown);

  // Ambil semua teks
  final buffer = StringBuffer();

  for (var node in nodes) {
    if (node is md.Text) {
      buffer.write(node.text);
    }
  }

  return buffer.toString();
}
