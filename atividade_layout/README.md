# Atividade - Plataformas Móveis (Flutter)

Projeto único com as duas partes da atividade, acessíveis pela tela inicial
(`lib/main.dart`).

## Parte A — Tutorial de Layout

Arquivo: `lib/screens/layout_tutorial_screen.dart`

Implementação do tutorial oficial:
https://docs.flutter.dev/ui/layout/tutorial

Monta a tela de detalhes de um card (acampamento no Lago Oeschinen, na
Suíça) combinando os widgets básicos de layout:

- `Image.asset` para a foto de topo (`assets/images/lake.jpg`)
- `Row` + `Column` + `Expanded` para o bloco de título (nome, localização
  e o ícone de favorito com contador, que é um `StatefulWidget`)
- `Row` com `MainAxisAlignment.spaceEvenly` para os três botões
  (Call / Route / Share), cada um sendo um `Column` com `Icon` + `Text`
- `Padding` + `Text` para o parágrafo de descrição

## Parte B — Cookbook modificado

Arquivo: `lib/screens/cookbook_fetch_data_screen.dart`

**Exemplo escolhido:** "Fetch data from the internet"
https://docs.flutter.dev/cookbook/networking/fetch-data

O exemplo original busca **um único álbum** na API
`jsonplaceholder.typicode.com/albums/1`, decodifica o JSON em um objeto
Dart e mostra apenas o título dele na tela, usando `FutureBuilder`.

**Modificações feitas:**

1. Em vez de buscar 1 álbum, a requisição busca a **lista completa**
   (`/albums`) e decodifica em uma `List<Album>`.
2. Os resultados são exibidos em uma `ListView` com `Card`/`ListTile`
   para cada item, em vez de um único texto centralizado.
3. Foi adicionado um **campo de busca** (`TextField`) que filtra a lista
   localmente pelo título, sem nova requisição HTTP.
4. Foi adicionado **pull-to-refresh** (`RefreshIndicator`) para repetir
   a chamada à API.
5. **Tratamento de erro** melhorado: se a requisição falhar, mostra uma
   mensagem e um botão "Tentar novamente" em vez de deixar a tela
   travada.

Essas mudanças foram escolhidas para exercitar: `FutureBuilder` com
estado assíncrono, parsing de listas JSON, interação do usuário
(filtro), atualização de estado (`setState`) e tratamento de erros em
chamadas de rede.

## Como executar

```bash
flutter pub get
flutter run -d chrome   # ou outro device disponível
```
