import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/photo.dart';

class PhotoDetailPage extends StatelessWidget {
  final Photo photo;

  const PhotoDetailPage({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(photo.author)),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: CachedNetworkImage(
                imageUrl: photo.downloadUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Author: ${photo.author}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('Size: ${photo.width} × ${photo.height}', style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text('Source: ${photo.url}', style: const TextStyle(color: Colors.blue)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
