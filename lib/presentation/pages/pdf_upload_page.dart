import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../data/providers/pdf_processor.dart';

class PdfUploadPage extends StatefulWidget {
  const PdfUploadPage({super.key});

  @override
  State<PdfUploadPage> createState() => _PdfUploadPageState();
}

class _PdfUploadPageState extends State<PdfUploadPage> {
  final PdfProcessor _pdfProcessor = PdfProcessor();
  bool _isProcessing = false;

  Future<void> _pickAndProcessPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() => _isProcessing = true);
      try {
        final file = File(result.files.single.path!);
        await _pdfProcessor.processPdf(file);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PDF processed and added to knowledge base!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Knowledge Base')),
      body: Center(
        child: _isProcessing 
          ? const CircularProgressIndicator() 
          : ElevatedButton.icon(
              onPressed: _pickAndProcessPdf,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload PDF'),
            ),
      ),
    );
  }
}
