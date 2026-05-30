import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/photo.dart';
import '../providers/photo_provider.dart';

class PhotoDetailPage extends StatelessWidget {
  final Photo photo;

  const PhotoDetailPage({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.watch<PhotoProvider>().isFavorite(photo.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(photo.author),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () => context.read<PhotoProvider>().toggleFavorite(photo.id),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Hero(
                tag: 'photo-${photo.id}',
                child: CachedNetworkImage(
                  imageUrl: photo.downloadUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.08),
                  blurRadius: 10,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Author: ${photo.author}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
