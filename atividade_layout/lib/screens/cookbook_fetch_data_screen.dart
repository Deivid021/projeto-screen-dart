// Baseado no cookbook "Fetch data from the internet" do Flutter.
// Em vez do exemplo padrão (1 álbum do jsonplaceholder), busco meus
// próprios repositórios no GitHub e mostro em uma lista com busca.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Repo {
  final String name;
  final String? description;
  final String? language;
  final int stars;

  const Repo({
    required this.name,
    required this.description,
    required this.language,
    required this.stars,
  });

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      name: json['name'] as String,
      description: json['description'] as String?,
      language: json['language'] as String?,
      stars: json['stargazers_count'] as int,
    );
  }
}

Future<List<Repo>> fetchRepos() async {
  final response = await http.get(
    Uri.parse('https://api.github.com/users/Deivid021/repos?sort=updated&per_page=6'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data.map((json) => Repo.fromJson(json as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Não foi possível carregar os repositórios');
  }
}

class CookbookFetchDataScreen extends StatefulWidget {
  const CookbookFetchDataScreen({super.key});

  @override
  State<CookbookFetchDataScreen> createState() => _CookbookFetchDataScreenState();
}

class _CookbookFetchDataScreenState extends State<CookbookFetchDataScreen> {
  late Future<List<Repo>> _futureRepos;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _futureRepos = fetchRepos();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureRepos = fetchRepos();
    });
    await _futureRepos;
  }

  @override
  Widget build(BuildContext context) {
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
            child: FutureBuilder<List<Repo>>(
              future: _futureRepos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Erro: ${snapshot.error}'),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _refresh,
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  );
                }

                final repos = snapshot.data ?? const <Repo>[];
                final filtered = _query.isEmpty
                    ? repos
                    : repos.where((r) => r.name.toLowerCase().contains(_query)).toList();

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final repo = filtered[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.folder),
                          title: Text(repo.name),
                          subtitle: Text(repo.description ?? 'Sem descrição'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (repo.language != null) Text(repo.language!),
                              Row(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
