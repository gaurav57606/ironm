// ═══════════════════════════════════════════════════════════════════
// 🔒 LOCKED — PlansScreen | Verified: 2026-04-24 | DO NOT EDIT
// ═══════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/plan.dart';
import '../viewmodel/plans_viewmodel.dart';

class PlansScreen extends ConsumerWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(plansStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg2,
        title: const Text('Plans', style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.orange),
            onPressed: () => _showPlanDialog(context, ref, null),
          ),
        ],
      ),
      body: plansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.orange)),
        error: (e, _) => Center(child: Text('$e', style: const TextStyle(color: AppColors.expired))),
        data: (plans) {
          if (plans.isEmpty) return const _EmptyState();
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: plans.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _PlanCard(
              plan: plans[i],
              onEdit: () => _showPlanDialog(context, ref, plans[i]),
              onDelete: () => _confirmDelete(context, ref, plans[i]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.orange,
        onPressed: () => _showPlanDialog(context, ref, null),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showPlanDialog(BuildContext context, WidgetRef ref, Plan? existing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg2,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _PlanFormSheet(existing: existing),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Plan plan) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bg3,
        title: const Text('Delete Plan?', style: TextStyle(color: AppColors.textPrimary)),
        content: Text('Remove "${plan.name}"? This cannot be undone.',
            style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(plansNotifierProvider.notifier).deletePlan(plan.id);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.expired)),
          ),
        ],
      ),
    );
  }
}

// ── Plan Card ────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final Plan plan;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _PlanCard({required this.plan, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bg2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: plan.active ? AppColors.border : AppColors.border.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.fitness_center, color: AppColors.orange, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan.name,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                const SizedBox(height: 3),
                Text('${plan.durationMonths} month(s) · ${plan.components.length} component(s)',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${plan.totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                      color: AppColors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (plan.active ? AppColors.active : AppColors.textSecondary)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  plan.active ? 'ACTIVE' : 'INACTIVE',
                  style: TextStyle(
                      color: plan.active ? AppColors.active : AppColors.textSecondary,
                      fontSize: 9,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
            color: AppColors.bg3,
            onSelected: (v) {
              if (v == 'edit') onEdit();
              if (v == 'delete') onDelete();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit',
                  child: Text('Edit', style: TextStyle(color: AppColors.textPrimary))),
              const PopupMenuItem(value: 'delete',
                  child: Text('Delete', style: TextStyle(color: AppColors.expired))),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Plan Form Sheet ──────────────────────────────────────────────────

class _PlanFormSheet extends ConsumerStatefulWidget {
  final Plan? existing;
  const _PlanFormSheet({this.existing});

  @override
  ConsumerState<_PlanFormSheet> createState() => _PlanFormSheetState();
}

class _PlanFormSheetState extends ConsumerState<_PlanFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _durationCtrl;
  final List<_ComponentEntry> _components = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl     = TextEditingController(text: widget.existing?.name ?? '');
    _durationCtrl = TextEditingController(
        text: (widget.existing?.durationMonths ?? 1).toString());
    if (widget.existing != null) {
      for (final c in widget.existing!.components) {
        _components.add(_ComponentEntry(
          nameCtrl:  TextEditingController(text: c.name),
          priceCtrl: TextEditingController(text: c.price.toStringAsFixed(0)),
        ));
      }
    } else {
      _addComponent();
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _durationCtrl.dispose();
    for (final c in _components) {
      c.nameCtrl.dispose();
      c.priceCtrl.dispose();
    }
    super.dispose();
  }

  void _addComponent() {
    setState(() => _components
        .add(_ComponentEntry(nameCtrl: TextEditingController(), priceCtrl: TextEditingController())));
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomPad),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.existing == null ? 'New Plan' : 'Edit Plan',
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _Field(controller: _nameCtrl, label: 'Plan Name',
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
            const SizedBox(height: 12),
            _Field(
              controller: _durationCtrl,
              label: 'Duration (months)',
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse(v ?? '');
                return (n == null || n < 1) ? 'Enter valid months' : null;
              },
            ),
            const SizedBox(height: 16),
            const Text('Components',
                style: TextStyle(color: AppColors.orange, fontSize: 11,
                    fontWeight: FontWeight.w700, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            ..._components.asMap().entries.map((e) => _ComponentRow(
                  entry: e.value,
                  onRemove: _components.length > 1
                      ? () => setState(() => _components.removeAt(e.key))
                      : null,
                )),
            TextButton.icon(
              onPressed: _addComponent,
              icon: const Icon(Icons.add, color: AppColors.orange, size: 18),
              label: const Text('Add Component',
                  style: TextStyle(color: AppColors.orange, fontSize: 13)),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Save Plan',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final comps = _components.map((c) => PlanComponent(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: c.nameCtrl.text.trim(),
            price: double.tryParse(c.priceCtrl.text) ?? 0,
          )).toList();

      if (widget.existing == null) {
        await ref.read(plansNotifierProvider.notifier).addPlan(
              name: _nameCtrl.text.trim(),
              durationMonths: int.parse(_durationCtrl.text),
              components: comps,
            );
      } else {
        final updated = widget.existing!
          ..name = _nameCtrl.text.trim()
          ..durationMonths = int.parse(_durationCtrl.text)
          ..components = comps;
        await ref.read(plansNotifierProvider.notifier).updatePlan(updated);
      }
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}

class _ComponentEntry {
  final TextEditingController nameCtrl;
  final TextEditingController priceCtrl;
  _ComponentEntry({required this.nameCtrl, required this.priceCtrl});
}

class _ComponentRow extends StatelessWidget {
  final _ComponentEntry entry;
  final VoidCallback? onRemove;
  const _ComponentRow({required this.entry, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _Field(controller: entry.nameCtrl, label: 'Name',
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _Field(
              controller: entry.priceCtrl,
              label: '₹ Price',
              keyboardType: TextInputType.number,
              validator: (v) =>
                  (double.tryParse(v ?? '') == null) ? 'Invalid' : null,
            ),
          ),
          if (onRemove != null)
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: AppColors.expired, size: 20),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  const _Field(
      {required this.controller,
      required this.label,
      this.keyboardType,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        filled: true,
        fillColor: AppColors.bg3,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.orange)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.expired)),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.fitness_center, color: AppColors.textMuted, size: 64),
          SizedBox(height: 16),
          Text('No plans yet',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text('Tap + to create your first membership plan',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}
