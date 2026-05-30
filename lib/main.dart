import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final prov = context.read<PhotoProvider>();
    if (_controller.position.pixels >= _controller.position.maxScrollExtent - 200) {
      prov.fetchMore();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PhotoProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Picsum Gallery')),
      body: Builder(builder: (context) {
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
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: provider.fetch,
                    child: const Text('Retry'),
                  )
                ],
              ),
            );
          case Status.success:
            return RefreshIndicator(
              onRefresh: provider.fetch,
              child: ListView.builder(
                controller: _controller,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: provider.photos.length + (provider.isLoadingMore ? 1 : 0),
                itemBuilder: (context, i) {
                  if (i < provider.photos.length) return PhotoTile(photo: provider.photos[i]);
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            );
        }
      }),
    );
  }
}
