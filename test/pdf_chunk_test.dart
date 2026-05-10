import 'package:flutter_test/flutter_test.dart';
import 'package:ananpath_ai/data/models/pdf_chunk.dart';

void main() {
  test('PDFChunk should be created and converted to map', () {
    const chunk = PDFChunk(
      content: 'Test content',
      type: 'text',
      pageNumber: 1,
      sourceFile: 'test.pdf',
    );

    final map = chunk.toMap();

    expect(map['content'], 'Test content');
    expect(map['type'], 'text');
    expect(map['pageNumber'], 1);
    expect(map['sourceFile'], 'test.pdf');
  });

  test('PDFChunk should be created from map', () {
    final map = {
      'id': 1,
      'content': 'Test content',
      'type': 'text',
      'imagePath': null,
      'description': null,
      'pageNumber': 1,
      'sourceFile': 'test.pdf',
    };

    final chunk = PDFChunk.fromMap(map);

    expect(chunk.id, 1);
    expect(chunk.content, 'Test content');
    expect(chunk.type, 'text');
    expect(chunk.pageNumber, 1);
    expect(chunk.sourceFile, 'test.pdf');
  });
}
