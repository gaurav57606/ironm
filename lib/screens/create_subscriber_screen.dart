import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/ac_colors.dart';
import '../core/constants/ac_text_styles.dart';
import '../core/constants/ac_strings.dart';
import '../models/entitlement_record.dart';
import '../providers/entitlements_provider.dart';

class CreateSubscriberScreen extends ConsumerStatefulWidget {
  const CreateSubscriberScreen({super.key});

  @override
  ConsumerState<CreateSubscriberScreen> createState() => _CreateSubscriberScreenState();
}

class _CreateSubscriberScreenState extends ConsumerState<CreateSubscriberScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  // Controllers for each field
  final TextEditingController _uidCtrl = TextEditingController();
  final TextEditingController _ownerCtrl = TextEditingController();
  final TextEditingController _businessCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  String _selectedPlan = 'monthly'; // dropdown
  int _selectedDays = 30; // plan duration in days
  int _gracePeriod = 7;

  @override
  void dispose() {
    _uidCtrl.dispose();
    _ownerCtrl.dispose();
    _businessCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final now = DateTime.now();
    final record = EntitlementRecord(
      userId: _uidCtrl.text.trim(),
      appId: AcStrings.targetAppId,
      status: 'active',
      expiresAt: now.add(Duration(days: _selectedDays)),
      startDate: now,
      planId: _selectedPlan,
      gracePeriodDays: _gracePeriod,
      killSwitchActive: false,
      ownerName: _ownerCtrl.text.trim(),
      businessName: _businessCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      notes: '',
      createdAt: now,
    );
    try {
      await ref.read(entitlementWriteServiceProvider).createEntitlement(record);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Subscriber created successfully.'),
          backgroundColor: AcColors.active,
        ));
        context.pop(); // go_router pop back to previous screen
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to create: $e'),
          backgroundColor: AcColors.expired,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AcColors.bg,
      appBar: AppBar(
        title: Text('New Subscriber', style: AcTextStyles.title),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const _FormSection('Identity'),

              // Firebase UID
              TextFormField(
                controller: _uidCtrl,
                style: AcTextStyles.body,
                decoration: InputDecoration(
                  labelText: 'Firebase Auth UID *',
                  hintText: 'Paste the gym owner Firebase UID here',
                  helperText: 'Find it in Firebase Console → Auth → Users',
                  helperStyle: AcTextStyles.subtext,
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'UID is required' : null,
              ),
              const SizedBox(height: 12),

              // Owner name
              TextFormField(
                controller: _ownerCtrl,
                style: AcTextStyles.body,
                decoration: const InputDecoration(labelText: 'Owner Full Name *'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),

              // Business name
              TextFormField(
                controller: _businessCtrl,
                style: AcTextStyles.body,
                decoration: const InputDecoration(labelText: 'Gym / Business Name *'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Business name is required' : null,
              ),
              const SizedBox(height: 12),

              // Phone
              TextFormField(
                controller: _phoneCtrl,
                style: AcTextStyles.body,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              const SizedBox(height: 20),

              const _FormSection('Plan'),

              // Plan dropdown
              DropdownButtonFormField<String>(
                value: _selectedPlan,
                dropdownColor: AcColors.bg3,
                style: AcTextStyles.body,
                decoration: const InputDecoration(labelText: 'Plan'),
                items: ['monthly', 'quarterly', 'biannual', 'yearly']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedPlan = val!;
                    // Auto-set duration
                    switch (val) {
                      case 'monthly': _selectedDays = 30; break;
                      case 'quarterly': _selectedDays = 90; break;
                      case 'biannual': _selectedDays = 180; break;
                      case 'yearly': _selectedDays = 365; break;
                    }
                  });
                },
              ),
              const SizedBox(height: 12),

              // Duration display (read-only, auto-set by dropdown)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AcColors.bg2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AcColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        color: AcColors.textSecondary, size: 16),
                    const SizedBox(width: 10),
                    Text('Duration: $_selectedDays days',
                        style: AcTextStyles.body),
                    const Spacer(),
                    Text(
                        'Expires: ${_formatDate(DateTime.now().add(Duration(days: _selectedDays)))}',
                        style: AcTextStyles.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Grace period
              Row(
                children: [
                  Text('Grace Period (days):', style: AcTextStyles.body),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline,
                        color: AcColors.textSecondary),
                    onPressed: _gracePeriod > 0
                        ? () => setState(() => _gracePeriod--)
                        : null,
                  ),
                  SizedBox(
                    width: 32,
                    child: Text('$_gracePeriod',
                        style: AcTextStyles.label, textAlign: TextAlign.center),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline,
                        color: AcColors.primary),
                    onPressed: _gracePeriod < 30
                        ? () => setState(() => _gracePeriod++)
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : Text('Create Subscriber',
                          style: AcTextStyles.label.copyWith(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  final String title;
  const _FormSection(this.title);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Text(title.toUpperCase(), style: AcTextStyles.sectionTitle),
            const SizedBox(width: 12),
            const Expanded(child: Divider(color: AcColors.border)),
          ],
        ),
      );
}
