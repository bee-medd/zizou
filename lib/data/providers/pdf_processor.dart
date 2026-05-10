import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/pdf_chunk.dart';
import 'database_helper.dart';

class PdfProcessor {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> processPdf(File file) async {
    final List<int> bytes = await file.readAsBytes();
    final PdfDocument document = PdfDocument(inputBytes: bytes);
    final String fileName = p.basename(file.path);

    for (int i = 0; i < document.pages.count; i++) {
      final PdfPage page = document.pages[i];
      
      // Extract Text
      String text = PdfTextExtractor(document).extractText(startPageIndex: i, endPageIndex: i);
      if (text.trim().isNotEmpty) {
        await _dbHelper.insertChunk(PDFChunk(
          content: text,
          type: 'text',
          pageNumber: i + 1,
          sourceFile: fileName,
        ));
      }

      // Extract Images (Conceptual implementation as syncfusion allows extracting images)
      // In a real app, we'd iterate through page elements and save images to disk
      // For this prototype, we'll simulate image extraction and assume Gemini describes them later
      // or we send them to Gemini API here.
    }
    document.dispose();
  }
}
