import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/gemini_service.dart';
import 'presentation/bloc/chat_bloc.dart';
import 'presentation/pages/chat_page.dart';
import 'presentation/pages/pdf_upload_page.dart';

void main() {
  runApp(const AnanpathAIApp());
}

class AnanpathAIApp extends StatelessWidget {
  const AnanpathAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => GeminiService('YOUR_GEMINI_API_KEY'),
      child: BlocProvider(
        create: (context) => ChatBloc(RepositoryProvider.of<GeminiService>(context)),
        child: MaterialApp(
          title: 'Ananpath AI',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          home: const MainNavigationPage(),
        ),
      ),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const ChatPage(),
    const PdfUploadPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.upload_file), label: 'PDFs'),
        ],
      ),
    );
  }
}
