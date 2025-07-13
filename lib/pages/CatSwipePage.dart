import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:cat_swipe_app/main.dart';
import 'package:cat_swipe_app/pages/SummaryPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CatSwipePage extends StatefulWidget {
  @override
  _CatSwipePageState createState() => _CatSwipePageState();
}

class _CatSwipePageState extends State<CatSwipePage> {
  List<Cat> cats = [];
  List<Cat> liked = [];
  List<Cat> disliked = [];
  int currentIndex = 0;
  bool isLoading = true;
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    _audioPlayer = AudioPlayer();
    super.initState();
    fetchCats();
    _playMusic();
  }

 
  Future<void> _playMusic() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(
        AssetSource('audio/background_Music.mp3'),
        volume: 0.5,
      );
      if (_audioPlayer.state == PlayerState.playing) {
        print("Audio is now playing");
      } else {
        print("Failed to play audio");
      }
    } catch (e) {
      print("Error playing audio: $e");
    }
  }
  // ...existing code...

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> fetchCats() async {
    const int CAT_COUNT = 10;
    List<Cat> fetchedCats = [];

    for (int i = 0; i < CAT_COUNT; i++) {
      final response = await http.get(
        Uri.parse('https://cataas.com/cat?json=true'),
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        String url = jsonData['url'];

        // Ensure URL starts with https://cataas.com
        if (!url.startsWith('http')) {
          url = 'https://cataas.com$url';
        }

        // Append unique parameter to prevent caching
        final separator = url.contains('?') ? '&' : '?';
        url =
            '$url${separator}unique=${DateTime.now().millisecondsSinceEpoch}-$i';

        fetchedCats.add(Cat(index: i, imageUrl: url));
      } else {
        throw Exception('Failed to load cat $i');
      }
    }

    setState(() {
      cats = fetchedCats;
      isLoading = false;
    });
  }

  void handleSwipe(DismissDirection direction) {
    final cat = cats[currentIndex];
    if (direction == DismissDirection.startToEnd) {
      liked.add(cat);
    } else if (direction == DismissDirection.endToStart) {
      disliked.add(cat);
    }

    setState(() {
      currentIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {

    
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (currentIndex >= cats.length) {
      return SummaryPage(liked: liked, disliked: disliked);
    }

    final cat = cats[currentIndex];

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
              backgroundColor: Colors.grey,

        title: Text('Paws & Preferences',style: TextStyle(color:Colors.black,
        fontWeight: FontWeight.bold),)
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Text(
              "  👈 Swipe left to DISLIKE   Swipe right to LIKE 👉 ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Center(
            child: Dismissible(
              key: ValueKey(cat.index),
              direction: DismissDirection.horizontal,
              onDismissed: handleSwipe,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: 300,
                  height: 400,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      cat.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
