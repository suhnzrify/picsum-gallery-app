import 'package:flutter/foundation.dart';
import '../models/photo.dart';
import '../services/api_service.dart';

enum Status { loading, success, error }

class PhotoProvider with ChangeNotifier {
  List<Photo> _photos = [];
  Status _status = Status.loading;
  String _message = '';
  int _page = 1;
  final int _limit = 30;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  List<Photo> get photos => _photos;
  Status get status => _status;
  String get message => _message;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  PhotoProvider() {
    fetch();
  }

  Future<void> fetch() async {
    _status = Status.loading;
    _page = 1;
    _hasMore = true;
    notifyListeners();
    try {
      final list = await ApiService.fetchPhotos(page: _page, limit: _limit);
      _photos = list;
      _status = Status.success;
      _hasMore = list.length == _limit;
    } catch (e) {
      _message = e.toString();
      _status = Status.error;
    }
    notifyListeners();
  }

  Future<void> fetchMore() async {
    if (_isLoadingMore || !_hasMore || _status == Status.loading) return;
    _isLoadingMore = true;
    _page++;
    notifyListeners();
    try {
      final list = await ApiService.fetchPhotos(page: _page, limit: _limit);
      if (list.isNotEmpty) {
        _photos.addAll(list);
        _hasMore = list.length == _limit;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      _message = e.toString();
      _hasMore = false;
    }
    _isLoadingMore = false;
    notifyListeners();
  }
}
