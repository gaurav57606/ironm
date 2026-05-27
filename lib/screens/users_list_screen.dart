import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../core/constants/ac_colors.dart';
import '../core/constants/ac_text_styles.dart';
import '../core/constants/ac_strings.dart';
import '../providers/entitlements_provider.dart';

class UsersListScreen extends ConsumerStatefulWidget {
  const UsersListScreen({super.key});

  @override
  ConsumerState<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends ConsumerState<UsersListScreen> {
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
        return '⛔ Locked';
      default:
        return option;
    }
  }

  // Pick a beautiful color gradient for user avatars based on name hash
  LinearGradient _avatarGradient(String name) {
    final code = name.isEmpty ? 0 : name.codeUnitAt(0) % 5;
    switch (code) {
      case 0:
        return const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 1:
        return const LinearGradient(
          colors: [Color(0xFFA78BFA), Color(0xFFEC4899)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 2:
        return const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 3:
        return const LinearGradient(
          colors: [Color(0xFF22C55E), Color(0xFF06B6D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFFF97316), Color(0xFFBE185D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final recordsAsync = ref.watch(allEntitlementsProvider);

    return Scaffold(
      backgroundColor: AcColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── TOP BAR ──
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        recordsAsync.when(
                          loading: () => Text('Loading directory...', style: AcTextStyles.subtext),
                          error: (_, __) => Text('Error', style: AcTextStyles.subtext),
                          data: (list) => Text(
                            '${list.length} registered',
                            style: AcTextStyles.subtext.copyWith(
                              fontSize: 12,
                              color: AcColors.textMuted,
                            ),
                          ),
                        ),
                        Text(
                          'All Users',
                          style: AcTextStyles.h2.copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Trigger refresh
                      ref.invalidate(allEntitlementsProvider);
                    },
                    icon: const Icon(Icons.refresh_rounded, color: AcColors.textSecondary),
                    style: IconButton.styleFrom(
                      backgroundColor: AcColors.s2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AcColors.rim2, width: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── SEARCH BAR ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: AcColors.s2,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AcColors.rim2, width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      color: AcColors.textMuted,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        style: AcTextStyles.body.copyWith(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Search name, email, gym…',
                          hintStyle: TextStyle(color: AcColors.textMuted.withOpacity(0.5)),
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onChanged: (v) => setState(() => _searchQuery = v.toLowerCase().trim()),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── HORIZONTAL FILTER CHIPS ROW ──
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  for (final option in ['all', 'active', 'expired', 'suspended', 'kill'])
                    GestureDetector(
                      onTap: () => setState(() => _filterStatus = option),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: _filterStatus == option ? AcColors.brandL : AcColors.s2,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _filterStatus == option ? AcColors.brandD : AcColors.rim2,
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _chipLabel(option),
                          style: AcTextStyles.label.copyWith(
                            color: _filterStatus == option ? AcColors.primary : AcColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── USERS DIRECTORY LIST ──
            Expanded(
              child: recordsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AcColors.primary),
                ),
                error: (e, _) => Center(
                  child: Text('Error: $e', style: AcTextStyles.bodySecondary),
                ),
                data: (list) {
                  // Apply filters
                  var filtered = list;
                  if (_filterStatus == 'kill') {
                    filtered = filtered.where((r) => r.killSwitchActive).toList();
                  } else if (_filterStatus != 'all') {
                    filtered = filtered.where((r) => r.status == _filterStatus).toList();
                  }

                  // Apply search query
                  if (_searchQuery.isNotEmpty) {
                    filtered = filtered.where((r) {
                      return r.businessName.toLowerCase().contains(_searchQuery) ||
                          r.ownerName.toLowerCase().contains(_searchQuery) ||
                          r.phone.contains(_searchQuery);
                    }).toList();
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

                  // Virtualized list layout matching premium rows
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80), // extra padding for FAB
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final record = filtered[i];
                      final initials = record.ownerName.length >= 2
                          ? record.ownerName.substring(0, 2).toUpperCase()
                          : record.ownerName.isNotEmpty
                              ? record.ownerName[0].toUpperCase()
                              : 'Gym';

                      // Status Badge configuration
                      Color tagColor = AcColors.active;
                      String tagText = 'Active';

                      if (record.killSwitchActive) {
                        tagColor = AcColors.expired;
                        tagText = 'Locked';
                      } else if (record.status == 'suspended') {
                        tagColor = AcColors.expired;
                        tagText = 'Suspended';
                      } else if (record.isEffectivelyExpired) {
                        tagColor = AcColors.expired;
                        tagText = 'Expired';
                      } else if (record.daysUntilExpiry <= 7 && record.daysUntilExpiry >= 0) {
                        tagColor = AcColors.warning;
                        tagText = 'Grace';
                      } else if (record.planId.contains('trial')) {
                        tagColor = AcColors.warning;
                        tagText = 'Trial';
                      }

                      final expiryLabel = DateFormat('MMM yyyy').format(record.expiresAt);

                      return InkWell(
                        onTap: () {
                          // Route directly to detail screen
                          context.go('/subscriber/${record.userId}');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AcColors.rim, width: 1),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Avatar circle with dynamic name gradient
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: _avatarGradient(record.ownerName),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  initials,
                                  style: AcTextStyles.label.copyWith(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Info text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      record.ownerName,
                                      style: AcTextStyles.label.copyWith(fontSize: 14),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${record.businessName} · ${record.phone.isEmpty ? 'No phone' : record.phone}',
                                      style: AcTextStyles.bodySmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Tag + Plan info
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Outline Tag
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: tagColor.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: tagColor.withValues(alpha: 0.25), width: 1),
                                    ),
                                    child: Text(
                                      tagText,
                                      style: AcTextStyles.bodySmall.copyWith(
                                        color: tagColor,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${record.planId.toUpperCase()} · $expiryLabel',
                                    style: AcTextStyles.mono(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AcColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AcColors.primary,
        onPressed: () => context.go('/create-subscriber'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
