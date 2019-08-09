import 'dart:core';
import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Welcome to Flutter',
        theme: ThemeData(
          primaryColor: Colors.white
        ),
        debugShowCheckedModeBanner: false,
        home: RandomWords());
  }
}

class RandomWords extends StatefulWidget {
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);
  final _saved = Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;

          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WordSaved(saved: _saved)),
    );
  }
}

class WordSaved extends StatelessWidget {
  final Set<WordPair> saved;
  final _biggerFont = const TextStyle(fontSize: 18);

  WordSaved({@required this.saved});

  @override
  Widget build(BuildContext context) {
    /**
  * Cria os itens da lista
  */
    final Iterable<ListTile> tiles = saved.map(
      (WordPair pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      },
    );

    /**
    * Adiciona os itens juntamente com deparatores
     */
    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    /**
    * Retorna o Scaffold com TopBar e no body a ListView 
    */
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Suggestions'),
      ),
      body: ListView(children: divided),
    );
  }
}
