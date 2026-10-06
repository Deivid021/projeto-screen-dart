import 'package:flutter/material.dart';

import 'screens/cookbook_fetch_data_screen.dart';
import 'screens/layout_tutorial_screen.dart';

void main() {
  runApp(const AtividadeApp());
}

class AtividadeApp extends StatelessWidget {
  const AtividadeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atividade - Plataformas Móveis',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atividade - Plataformas Móveis')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Escolha uma parte da atividade:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                icon: const Icon(Icons.dashboard_customize),
                label: const Text('Parte A - Tutorial de Layout'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const LayoutTutorialScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                icon: const Icon(Icons.cloud_download),
                label: const Text('Parte B - Cookbook (modificado)'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CookbookFetchDataScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
