// Parte B da atividade.
//
// Ponto de partida: Cookbook "Fetch data from the internet"
// https://docs.flutter.dev/cookbook/networking/fetch-data
//
// A receita original do cookbook busca APENAS um álbum
// (https://jsonplaceholder.typicode.com/albums/1), converte o JSON em um
// objeto Dart e mostra o título em um FutureBuilder simples.
//
// Modificações feitas em relação ao exemplo original (para estudar o
// código e demonstrar ao professor):
//
//   1. Em vez de buscar 1 álbum, busca a LISTA completa de álbuns
//      (/albums) e decodifica em uma List<Album> em vez de um único
//      objeto.
//   2. Os resultados são exibidos em uma ListView (com Card para cada
//      item), em vez de um único Text central.
//   3. Foi adicionado um campo de busca (TextField) que filtra a lista
//      localmente pelo título, sem precisar de nova requisição.
//   4. Foi adicionado "pull to refresh" (RefreshIndicator) para repetir
//      a requisição HTTP.
//   5. Tratamento de erro melhorado: em caso de falha (ConnectionError,
//      status != 200, etc.) mostra uma mensagem amigável com um botão
//      "Tentar novamente", em vez de deixar a tela travada no erro.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Album {
  final int id;
  final int userId;
  final String title;

  const Album({required this.id, required this.userId, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
    );
  }
}

Future<List<Album>> fetchAlbums() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((json) => Album.fromJson(json as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Falha ao carregar os álbuns (HTTP ${response.statusCode})');
  }
}

class CookbookFetchDataScreen extends StatefulWidget {
  const CookbookFetchDataScreen({super.key});

  @override
  State<CookbookFetchDataScreen> createState() =>
      _CookbookFetchDataScreenState();
}

class _CookbookFetchDataScreenState extends State<CookbookFetchDataScreen> {
  late Future<List<Album>> _futureAlbums;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _futureAlbums = fetchAlbums();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureAlbums = fetchAlbums();
    });
    await _futureAlbums;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parte B - Cookbook: Fetch Data (modificado)'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Filtrar por título',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _query = value.trim().toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Album>>(
              future: _futureAlbums,
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

                final albums = snapshot.data ?? const <Album>[];
                final filtered = _query.isEmpty
                    ? albums
                    : albums
                        .where((a) => a.title.toLowerCase().contains(_query))
                        .toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('Nenhum álbum encontrado.'));
                }

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final album = filtered[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(child: Text('${album.id}')),
                          title: Text(album.title),
                          subtitle: Text('Usuário ${album.userId}'),
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
