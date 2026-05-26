import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/ac_colors.dart';
import '../core/constants/ac_strings.dart';
import '../core/constants/ac_text_styles.dart';
import '../providers/entitlements_provider.dart';
import '../widgets/subscriber_tile.dart';

class SubscribersListScreen extends ConsumerStatefulWidget {
  const SubscribersListScreen({super.key});

  @override
  ConsumerState<SubscribersListScreen> createState() =>
      _SubscribersListScreenState();
}

class _SubscribersListScreenState extends ConsumerState<SubscribersListScreen> {
  String _filterStatus = 'all';
  // valid values: 'all' | 'active' | 'expired' | 'suspended' | 'kill'
  String _searchQuery = '';

  String _chipLabel(String option) {
    switch (option) {
      case 'all':
        return 'All';
      case 'active':
        return 'Active';
      case 'expired':
        return 'Expired';
      case 'suspended':
        return 'Suspended';
      case 'kill':
        return '⛔ Kill-Switched';
      default:
        return option;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AcColors.bg,
      appBar: AppBar(
        title: Text('All Subscribers', style: AcTextStyles.title),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          // ── Filter chips row ──
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              children: [
                for (final option in [
                  'all',
                  'active',
                  'expired',
                  'suspended',
                  'kill'
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_chipLabel(option)),
                      selected: _filterStatus == option,
                      onSelected: (_) => setState(() => _filterStatus = option),
                      selectedColor: AcColors.primary.withValues(alpha: 0.2),
                      backgroundColor: AcColors.elevation2,
                      side: BorderSide(
                        color: _filterStatus == option
                            ? AcColors.primary
                            : AcColors.border,
                      ),
                      labelStyle: AcTextStyles.bodySmall.copyWith(
                        color: _filterStatus == option
                            ? AcColors.primary
                            : AcColors.textSecondary,
                        fontWeight: _filterStatus == option
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Search bar ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: TextField(
              style: AcTextStyles.body,
              decoration: const InputDecoration(
                hintText: 'Search by business or owner name...',
                prefixIcon: Icon(Icons.search_rounded,
                    color: AcColors.textSecondary, size: 20),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              ),
              onChanged: (v) =>
                  setState(() => _searchQuery = v.toLowerCase().trim()),
            ),
          ),

          // ── List ──
          Expanded(
            child: ref.watch(allEntitlementsProvider).when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AcColors.primary),
                  ),
                  error: (e, _) => Center(
                    child: Text('Error: $e', style: AcTextStyles.bodySecondary),
                  ),
                  data: (list) {
                    // Apply filter
                    var filtered = list;
                    if (_filterStatus == 'kill') {
                      filtered =
                          filtered.where((r) => r.killSwitchActive).toList();
                    } else if (_filterStatus != 'all') {
                      filtered = filtered
                          .where((r) => r.status == _filterStatus)
                          .toList();
                    }
                    // Apply search
                    if (_searchQuery.isNotEmpty) {
                      filtered = filtered
                          .where((r) =>
                              r.businessName
                                  .toLowerCase()
                                  .contains(_searchQuery) ||
                              r.ownerName
                                  .toLowerCase()
                                  .contains(_searchQuery) ||
                              r.phone.contains(_searchQuery))
                          .toList();
                    }
                    // Sort by expiry ascending
                    filtered.sort((a, b) => a.expiresAt.compareTo(b.expiresAt));

                    if (filtered.isEmpty) {
                      return Center(
                        child: Text(
                          AcStrings.noSubscribers,
                          style: AcTextStyles.bodySecondary,
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => SubscriberTile(
                        record: filtered[i],
                        onTap: () =>
                            context.go('/subscriber/${filtered[i].userId}'),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AcColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('New',
            style: AcTextStyles.label.copyWith(color: Colors.white)),
        onPressed: () => context.go('/create-subscriber'),
      ),
    );
  }
}
