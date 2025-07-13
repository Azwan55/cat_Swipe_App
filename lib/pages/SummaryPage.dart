import 'package:cat_swipe_app/main.dart';
import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  final List<Cat> liked;
  final List<Cat> disliked;

  const SummaryPage({required this.liked, required this.disliked});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Liked Cats (${liked.length})', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: liked.map((cat) => Image.network(cat.imageUrl, width: 100)).toList(),
            ),
            SizedBox(height: 16),
            Text('Disliked Cats (${disliked.length})', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: disliked.map((cat) => Image.network(cat.imageUrl, width: 100)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
