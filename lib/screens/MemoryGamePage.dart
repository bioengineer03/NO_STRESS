import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:no_stress/models/CardModel.dart';

class MemoryGamePage extends StatefulWidget {
  @override
  _MemoryGamePageState createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  List<String> _emojis = ['🍎', '🍌', '🍇', '🍓', '🍍', '🍑'];
  List<CardModel> _cards = [];
  List<int> _selectedIndices = [];
  bool _isBusy = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _score = 0;
    final List<String> gameEmojis = List.from(_emojis)..addAll(_emojis);
    gameEmojis.shuffle(Random());
    _cards = gameEmojis.map((e) => CardModel(content: e)).toList();
    setState(() {});
  }

  void _onCardTapped(int index) {
    if (_isBusy || _cards[index].isMatched || _cards[index].isRevealed) return;

    setState(() {
      _cards[index].isRevealed = true;
      _selectedIndices.add(index);
    });

    if (_selectedIndices.length == 2) {
      _isBusy = true;
      Future.delayed(Duration(seconds: 1), () {
        final first = _selectedIndices[0];
        final second = _selectedIndices[1];

        if (_cards[first].content == _cards[second].content) {
          _cards[first].isMatched = true;
          _cards[second].isMatched = true;
          _score++;
        } else {
          _cards[first].isRevealed = false;
          _cards[second].isRevealed = false;
        }

        _selectedIndices.clear();
        _isBusy = false;
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Game'),
        backgroundColor: Color(0xFF1E6F50),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _startGame,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Score: $_score', style: TextStyle(fontSize: 24)),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                return GestureDetector(
                  onTap: () => _onCardTapped(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: card.isRevealed || card.isMatched
                          ? Colors.white
                          : Color(0xFF1E6F50),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Center(
                      child: Text(
                        card.isRevealed || card.isMatched ? card.content : '',
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

