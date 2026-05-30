import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/photo.dart';
import '../providers/photo_provider.dart';
import '../screens/photo_detail.dart';

class PhotoTile extends StatelessWidget {
  final Photo photo;

  const PhotoTile({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final aspect = photo.width > 0 ? photo.width / photo.height : 1.0;
    final isFavorite = context.watch<PhotoProvider>().isFavorite(photo.id);

    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => PhotoDetailPage(photo: photo),
      )),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 4,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                  tag: 'photo-${photo.id}',
                  child: AspectRatio(
                    aspectRatio: aspect,
                    child: CachedNetworkImage(
                      imageUrl: photo.downloadUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.broken_image)),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    photo.author,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 12,
              right: 12,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black45,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.redAccent : Colors.white,
                    size: 20,
                  ),
                  onPressed: () => context.read<PhotoProvider>().toggleFavorite(photo.id),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
