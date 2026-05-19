import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aitek/feature/promo/controller/promo_controller.dart';
import 'package:aitek/feature/promo/domain/model/promo_model.dart';
import 'package:url_launcher/url_launcher.dart';


class PromoScreen extends StatefulWidget {
  const PromoScreen({super.key});

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<PromoController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1E3A5F)));
          }

          if (controller.errorMessage != null) {
            return _ErrorView(
              message: controller.errorMessage!,
              onRetry: () => controller.getPromos(),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 130,
                pinned: true,
                backgroundColor: const Color(0xFF0F172A),
                actions: [
                  IconButton(
                    onPressed: () {
                      controller.resetFilters();
                      _searchController.clear();
                      controller.getPromos();
                    },
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    tooltip: 'Refresh',
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 16, bottom: 14),
                  title: const Text(
                    'Promo Materials',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0F172A), Color(0xFF1E3A5F)],
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 16, top: 52),
                    child: const Text(
                      '📣  InstaForex',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _searchController,
                        onChanged: controller.setSearchQuery,
                        decoration: InputDecoration(
                          hintText: 'Search promos…',
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.clear, size: 18, color: Color(0xFF94A3B8)),
                            onPressed: () {
                              _searchController.clear();
                              controller.setSearchQuery('');
                            },
                          )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF1E3A5F), width: 1.5),
                          ),
                        ),
                      ),
                      if (controller.categories.length > 1) ...[
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: controller.categories.map((cat) {
                              final isActive = controller.selectedCategory == cat;
                              final accent = cat == 'All' ? const Color(0xFF1E3A5F) : _accentFor(cat);
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(cat),
                                  selected: isActive,
                                  onSelected: (_) => controller.setCategory(cat),
                                  selectedColor: accent.withOpacity(0.12),
                                  checkmarkColor: accent,
                                  labelStyle: TextStyle(
                                    color: isActive ? accent : const Color(0xFF475569),
                                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                    fontSize: 12.5,
                                  ),
                                  side: BorderSide(color: isActive ? accent : Colors.grey.shade300),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Text(
                        'Showing ${controller.filteredPromos.length} of ${controller.promoList.length} offers',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ),
              ),
              controller.filteredPromos.isEmpty
                  ? const SliverFillRemaining(child: _EmptyView())
                  : SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (ctx, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PromoCard(item: controller.filteredPromos[i]),
                    ),
                    childCount: controller.filteredPromos.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PromoCard extends StatelessWidget {
  final PromoItem item;
  const PromoCard({super.key, required this.item});

  Future<void> _openLink() async {
    if (item.linkUrl == null) return;
    final uri = Uri.parse(item.linkUrl!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _fmt(String? raw) {
    if (raw == null) return '';
    try {
      final dt = DateTime.parse(raw);
      const m = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${dt.day} ${m[dt.month]} ${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentFor(item.category);
    final hasDate = item.dateStart != null || item.dateEnd != null;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 160,
            child: item.imageUrl != null
                ? Image.network(
              item.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _ImagePlaceholder(category: item.category, accent: accent),
              loadingBuilder: (ctx, child, prog) =>
              prog == null ? child : Center(child: CircularProgressIndicator(color: accent, strokeWidth: 2)),
            )
                : _ImagePlaceholder(category: item.category, accent: accent),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CategoryBadge(label: item.category, accent: accent),
                const SizedBox(height: 10),
                Text(
                  item.title.isNotEmpty ? item.title : 'Promotional Offer',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                    height: 1.3,
                  ),
                ),
                if (item.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      height: 1.55,
                    ),
                  ),
                ],
                if (hasDate) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 13, color: Colors.grey.shade400),
                      const SizedBox(width: 5),
                      Text(
                        [
                          if (item.dateStart != null) _fmt(item.dateStart),
                          if (item.dateEnd != null) _fmt(item.dateEnd),
                        ].join(' – '),
                        style: TextStyle(fontSize: 11.5, color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                ],
                if (item.linkUrl != null) ...[
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _openLink,
                      icon: const Icon(Icons.open_in_new, size: 15),
                      label: const Text('Learn More'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: accent,
                        side: BorderSide(color: accent),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String label;
  final Color accent;
  const _CategoryBadge({required this.label, required this.accent});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(
      color: accent.withOpacity(0.09),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: accent.withOpacity(0.3)),
    ),
    child: Text(
      label.toUpperCase(),
      style: TextStyle(color: accent, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2),
    ),
  );
}

class _ImagePlaceholder extends StatelessWidget {
  final String category;
  final Color accent;
  const _ImagePlaceholder({required this.category, required this.accent});

  static const _icons = {
    'Bonus': '🎁',
    'No Deposit': '💰',
    'Service': '⚡',
    'Contest': '🏆',
    'Partnership': '🤝',
  };

  @override
  Widget build(BuildContext context) => Container(
    color: accent.withOpacity(0.08),
    child: Center(
      child: Text(_icons[category] ?? '📢', style: const TextStyle(fontSize: 40)),
    ),
  );
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 52, color: Color(0xFF94A3B8)),
          const SizedBox(height: 16),
          const Text('Could not load promos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A5F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    ),
  );
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('🔍', style: TextStyle(fontSize: 40)),
        SizedBox(height: 12),
        Text('No promos found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        SizedBox(height: 6),
        Text('Try a different search or filter.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
      ],
    ),
  );
}

Color _accentFor(String category) {
  switch (category) {
    case 'Bonus': return const Color(0xFFEA580C);
    case 'No Deposit': return const Color(0xFF16A34A);
    case 'Service': return const Color(0xFF2563EB);
    case 'Contest': return const Color(0xFF9333EA);
    case 'Partnership': return const Color(0xFFCA8A04);
    default: return const Color(0xFF475569);
  }
}