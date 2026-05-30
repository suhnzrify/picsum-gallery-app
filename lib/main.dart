import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_debounce/easy_debounce.dart'; // Added for performance
import 'providers/photo_provider.dart';
import 'widgets/photo_tile.dart';

void main() {
  runApp(const PicsumApp());
}

class PicsumApp extends StatelessWidget {
  const PicsumApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PhotoProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Picsum Gallery',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _controller = ScrollController();
  bool _searchEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final prov = context.read<PhotoProvider>();
    // Trigger pagination 200px before reaching the end to ensure seamless infinite scrolling
    if (_controller.position.pixels >= _controller.position.maxScrollExtent - 200) {
      prov.fetchMore();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    EasyDebounce.cancel('search-debouncer'); // Clean up timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PhotoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Picsum Gallery'),
        actions: [
          IconButton(
            icon: Icon(provider.showFavoritesOnly ? Icons.favorite : Icons.favorite_border),
            onPressed: provider.toggleFavoritesOnly,
          ),
          IconButton(
            icon: Icon(_searchEnabled ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _searchEnabled = !_searchEnabled;
                if (!_searchEnabled) {
                  context.read<PhotoProvider>().setSearchQuery('');
                }
              });
            },
          ),
        ],
      ),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(PhotoProvider provider) {
    switch (provider.status) {
      case Status.loading:
        return const Center(child: CircularProgressIndicator());
      case Status.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(provider.message),
              ElevatedButton(onPressed: provider.fetch, child: const Text('Retry'))
            ],
          ),
        );
      case Status.success:
        return Column(
          children: [
            if (_searchEnabled)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  // Improved: Added debounce to prevent unnecessary rebuilds
                  onChanged: (val) => EasyDebounce.debounce(
                    'search-debouncer',
                    const Duration(milliseconds: 300),
                    () => provider.setSearchQuery(val),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search by author or id',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            Expanded(
              child: provider.filteredPhotos.isEmpty
                  ? _buildEmptyState() // Improved: Extracted empty state method
                  : RefreshIndicator(
                      onRefresh: provider.fetch,
                      child: ListView.builder(
                        controller: _controller,
                        itemCount: provider.filteredPhotos.length + (provider.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, i) {
                          if (i < provider.filteredPhotos.length) {
                            return PhotoTile(photo: provider.filteredPhotos[i]);
                          }
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
    }
  }

  // Improved: Professional Empty State UI
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image_search, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No matching photos found.',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}