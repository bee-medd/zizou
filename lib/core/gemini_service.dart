import 'package:google_generative_ai/google_generative_ai.dart';
import '../data/providers/database_helper.dart';

class GeminiService {
  final String apiKey;
  late final GenerativeModel _model;

  GeminiService(this.apiKey) {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }

  Future<String> chatWithContext(String prompt) async {
    final dbHelper = DatabaseHelper.instance;
    
    // Simple RAG: Search for relevant chunks in SQLite
    // In a real app, we'd use embeddings. For now, keyword search.
    final relevantChunks = await dbHelper.queryChunks(prompt);
    
    String context = "Use the following context to answer the question:\n\n";
    for (var chunk in relevantChunks) {
      context += "Source: ${chunk.sourceFile}, Page: ${chunk.pageNumber}\n${chunk.content}\n\n";
    }

    final fullPrompt = "$context\n\nQuestion: $prompt\n\nAnswer concisely, use tables if appropriate, provide summaries and highlights. If images are mentioned in the context, reference them.";
    
    final content = [Content.text(fullPrompt)];
    final response = await _model.generateContent(content);
    
    return response.text ?? "I couldn't generate a response.";
  }

  Future<String> summarizeContext(String topic) async {
    final dbHelper = DatabaseHelper.instance;
    final relevantChunks = await dbHelper.queryChunks(topic);
    
    String context = "Summarize the following information about $topic:\n\n";
    for (var chunk in relevantChunks) {
      context += "${chunk.content}\n\n";
    }
    
    final content = [Content.text(context)];
    final response = await _model.generateContent(content);
    
    return response.text ?? "Couldn't summarize.";
  }
}
