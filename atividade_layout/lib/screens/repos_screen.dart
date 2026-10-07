// Baseado no cookbook "Fetch data from the internet" do Flutter, mas
// aqui os dados ficam fixos na lista em vez de vir de uma API.

import 'package:flutter/material.dart';

class Repo {
  final String name;
  final String description;
  final String language;
  final int stars;

  const Repo({
    required this.name,
    required this.description,
    required this.language,
    required this.stars,
  });
}

const List<Repo> _repos = [
  Repo(
    name: 'projeto-screen-dart',
    description: 'Atividade de layout e cookbook em Flutter',
    language: 'C++',
    stars: 0,
  ),
  Repo(
    name: 'crypto-price-alert',
    description: 'Monitor de preço de criptomoedas com alertas em tempo real',
    language: 'Java',
    stars: 2,
  ),
  Repo(
    name: 'GRID-CSS',
    description: 'Sem descrição',
    language: 'HTML',
    stars: 0,
  ),
  Repo(
    name: 'ControleFinanceiro',
    description: 'Sem descrição',
    language: 'Blade',
    stars: 0,
  ),
  Repo(
    name: 'notely-project',
    description: 'Sem descrição',
    language: 'C#',
    stars: 0,
  ),
  Repo(
    name: 'calculadora-imc-horas-de-sono',
    description: 'Sem descrição',
    language: 'Blade',
    stars: 0,
  ),
];

class ReposScreen extends StatefulWidget {
  const ReposScreen({super.key});

  @override
  State<ReposScreen> createState() => _ReposScreenState();
}

class _ReposScreenState extends State<ReposScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? _repos
        : _repos.where((r) => r.name.toLowerCase().contains(_query)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Meus repositórios no GitHub')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar repositório',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => _query = value.trim().toLowerCase());
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final repo = filtered[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.folder),
                    title: Text(repo.name),
                    subtitle: Text(repo.description),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(repo.language),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, size: 14, color: Colors.amber),
                            Text(' ${repo.stars}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
