import 'dart:developer';
import 'package:get/get.dart';
import 'package:aitek/feature/promo/domain/model/promo_model.dart';
import 'package:aitek/feature/promo/domain/repository/promo_repository.dart';

class PromoController extends GetxController implements GetxService {
  final PromoRepository promoRepository;
  PromoController({required this.promoRepository});

  // ─── State ────────────────────────────────────────────────────────────────

  bool isLoading = false;
  String? errorMessage;
  List<PromoItem> promoList = [];

  // ─── Filter state ─────────────────────────────────────────────────────────

  String selectedCategory = 'All';
  String searchQuery = '';

  List<PromoItem> get filteredPromos {
    return promoList.where((p) {
      final matchCat =
          selectedCategory == 'All' || p.category == selectedCategory;
      final q = searchQuery.toLowerCase();
      final matchSearch = q.isEmpty ||
          p.title.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q);
      return matchCat && matchSearch;
    }).toList();
  }

  /// Always starts with 'All', followed by unique categories from the list.
  List<String> get categories => [
    'All',
    ...promoList.map((p) => p.category).toSet(),
  ];

  // ─── Actions ──────────────────────────────────────────────────────────────

  Future<void> getPromos({String lang = 'en'}) async {
    isLoading = true;
    errorMessage = null;
    promoList = [];
    update();

    try {
      promoList = await promoRepository.getPromos(lang: lang);
    } catch (e) {
      errorMessage = e.toString();
      log('PromoController.getPromos error: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  void setCategory(String category) {
    selectedCategory = category;
    update();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    update();
  }

  void resetFilters() {
    selectedCategory = 'All';
    searchQuery = '';
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getPromos();
  }
}