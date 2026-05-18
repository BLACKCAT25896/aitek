import 'package:get/get.dart';

class PaginatedDropdownController<T> extends GetxController implements GetxService {
  late Future<List<T>> Function(int page) fetchPage;

  List<T> items = [];
  T? selectedItem;

  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMore = true;

  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  void setSelectedItem(T item) {
    selectedItem = item;
    update();
  }

  // Initialize with fetch function and optional initial items
  void init({
    required Future<List<T>> Function(int page) fetchPage,
    List<T>? initialItems,
  }) {
    this.fetchPage = fetchPage;
    items = initialItems ?? [];
    _currentPage = 1;
    _hasMore = true;
    if (items.length < 10) _hasMore = false;
    update();
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoading) return;

    _isLoading = true;
    update();

    try {
      final newItems = await fetchPage(_currentPage + 1);
      if (newItems.isEmpty) {
        _hasMore = false;
      } else {
        _currentPage++;
        items.addAll(newItems);
      }
    } finally {
      _isLoading = false;
      update();
    }
  }
}
