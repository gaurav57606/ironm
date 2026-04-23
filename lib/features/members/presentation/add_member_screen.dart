import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/member.dart';
import '../viewmodel/members_viewmodel.dart';

// 🔒 LOCKED SCREEN — AddMemberScreen
class AddMemberScreen extends ConsumerStatefulWidget {
  const AddMemberScreen({super.key});

  @override
  ConsumerState<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends ConsumerState<AddMemberScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedPlan = '3 Months';
  DateTime _startDate = DateTime.now();
  late DateTime _expiryDate;

  @override
  void initState() {
    super.initState();
    _calculateExpiry();
  }

  void _calculateExpiry() {
    int months = 1;
    if (_selectedPlan == '3 Months') months = 3;
    if (_selectedPlan == '6 Months') months = 6;
    if (_selectedPlan == '12 Months') months = 12;
    
    setState(() {
      _expiryDate = DateTime(_startDate.year, _startDate.month + months, _startDate.day);
    });
  }

  Future<void> _save() async {
    if (_nameController.text.isEmpty) return;

    final member = Member()
      ..name = _nameController.text
      ..phone = _phoneController.text
      ..planName = _selectedPlan
      ..joinDate = _startDate
      ..expiryDate = _expiryDate
      ..isActive = true;

    await ref.read(membersViewModelProvider.notifier).addMember(member);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(
        title: const Text('Add Member'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Basic Information'),
            const SizedBox(height: 16),
            _buildField('Full Name', 'e.g. Suresh Raina', _nameController),
            _buildField('Phone Number', 'e.g. +91 98765 43210', _phoneController),
            const SizedBox(height: 16),
            _buildSectionTitle('Plan Details'),
            const SizedBox(height: 16),
            _buildDropdown('Select Plan', ['Monthly', '3 Months', '6 Months', '12 Months']),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildDatePicker('Start Date', _startDate)),
                const SizedBox(width: 16),
                Expanded(child: _buildReadOnly('Expiry Date', _expiryDate)),
              ],
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Save Member'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.caption.copyWith(color: AppColors.orange),
    );
  }

  Widget _buildField(String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.label),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            style: AppTextStyles.body,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedPlan,
              isExpanded: true,
              dropdownColor: AppColors.bgCard,
              style: AppTextStyles.body,
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (val) {
                setState(() => _selectedPlan = val!);
                _calculateExpiry();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() => _startDate = picked);
              _calculateExpiry();
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDate(date), style: AppTextStyles.body),
                const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textTertiary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnly(String label, DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.bgAccent.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(_formatDate(date), style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonth(date.month)} ${date.year}';
  }

  String _getMonth(int m) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[m - 1];
  }
}
