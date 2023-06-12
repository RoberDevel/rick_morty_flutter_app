import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class _QuoteTileResource {
  _QuoteTileResource(this.name, this.resourcePath);

  final String name;
  final String resourcePath;
}

final _quoteTileResourceList = <_QuoteTileResource>[
  _QuoteTileResource('My name is Rick Sanchez', 'sound/introduce.mp3'),
  _QuoteTileResource('Alright hear me out on this', 'sound/first.mp3'),
  _QuoteTileResource('I need you to do me a favor', 'sound/second.mp3'),
  _QuoteTileResource('Just a yes or no', 'sound/third.mp3'),
  _QuoteTileResource('Ohh great', 'sound/fourth.mp3'),
  _QuoteTileResource(
    'Summer Smith is a psycho nerd and she just got me kicked out of school',
    'sound/fifth.mp3',
  ),
  _QuoteTileResource('Haha', 'sound/sixth.mp3'),
  _QuoteTileResource('Alright I`m bored', 'sound/seventh.mp3'),
  _QuoteTileResource('Sorry about that', 'sound/eighth.mp3'),
  _QuoteTileResource('Bye', 'sound/nineth.mp3'),
];

class QuotePage extends StatelessWidget {
  const QuotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const QuoteView();
  }
}

class QuoteView extends StatelessWidget {
  const QuoteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(title: const Text('Quotes')),
        const Expanded(child: _QuotesListView())
      ],
    );
  }
}

class _QuotesListView extends StatefulWidget {
  const _QuotesListView();

  @override
  State<_QuotesListView> createState() => _QuotesListViewState();
}

class _QuotesListViewState extends State<_QuotesListView> {
  final player = AudioPlayer();
  var _playingTile = -1;

  @override
  void initState() {
    super.initState();
    player.onPlayerStateChanged.listen((status) {
      if (mounted &&
          (status == PlayerState.completed || status == PlayerState.stopped)) {
        setState(() {
          _playingTile = -1;
        });
      }
    });
  }

  @override
  void dispose() {
    player.onPlayerStateChanged.listen(null);
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _quoteTileResourceList.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: _buildItem,
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final quote = _quoteTileResourceList[index];

    return _AudioTile(
      title: quote.name,
      onPlay: () => _playQuote(quote.resourcePath, index),
      onStop: player.stop,
      isPlaying: _playingTile == index,
    );
  }

  void _playQuote(String path, int index) {
    setState(() {
      _playingTile = index;
    });
    player.play(AssetSource(path));
  }
}

class _AudioTile extends StatelessWidget {
  const _AudioTile({
    required this.onPlay,
    required this.onStop,
    required this.isPlaying,
    required this.title,
  });

  final String title;
  final VoidCallback onPlay;
  final VoidCallback onStop;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPlay,
      title: Text(title),
      trailing: isPlaying
          ? IconButton(
              onPressed: onStop,
              icon: const Icon(Icons.stop),
            )
          : null,
    );
  }
}
