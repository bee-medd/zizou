import 'package:equatable/equatable.dart';

class PDFChunk extends Equatable {
  final int id;
  final String content;
  final String type; // 'text' or 'image'
  final String? imagePath;
  final String? description;
  final int pageNumber;
  final String sourceFile;

  const PDFChunk({
    this.id = 0,
    required this.content,
    required this.type,
    this.imagePath,
    this.description,
    required this.pageNumber,
    required this.sourceFile,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'type': type,
      'imagePath': imagePath,
      'description': description,
      'pageNumber': pageNumber,
      'sourceFile': sourceFile,
    };
  }

  factory PDFChunk.fromMap(Map<String, dynamic> map) {
    return PDFChunk(
      id: map['id'],
      content: map['content'],
      type: map['type'],
      imagePath: map['imagePath'],
      description: map['description'],
      pageNumber: map['pageNumber'],
      sourceFile: map['sourceFile'],
    );
  }

  @override
  List<Object?> get props => [id, content, type, imagePath, description, pageNumber, sourceFile];
}
