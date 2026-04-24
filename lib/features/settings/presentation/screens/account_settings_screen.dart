import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/status_bar_wrapper.dart';
import '../../../auth/viewmodel/auth_viewmodel.dart';
import '../../../../data/models/owner_profile.dart';

class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  final _gymNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _gstinController = TextEditingController();
  
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ifscController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final owner = ref.read(authProvider).owner;
      if (owner != null) {
        _gymNameController.text = owner.gymName;
        _ownerNameController.text = owner.ownerName;
        _phoneController.text = owner.phone ?? '';
        _addressController.text = owner.address ?? '';
        _gstinController.text = owner.gstin ?? '';
        _bankNameController.text = owner.bankName ?? '';
        _accountNumberController.text = owner.accountNumber ?? '';
        _ifscController.text = owner.ifsc ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.bg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StatusBarWrapper(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  children: [
                    _buildSectionHeader('Gym Profile'),
                    _buildTextField('Gym Name', _gymNameController),
                    _buildTextField('Owner Name', _ownerNameController),
                    _buildTextField('Phone Number', _phoneController),
                    _buildTextField('Address', _addressController),
                    _buildTextField('GSTIN', _gstinController),
                    
                    _buildSectionHeader('Bank Details (For Invoices)'),
                    _buildTextField('Bank Name', _bankNameController),
                    _buildTextField('Account Number', _accountNumberController),
                    _buildTextField('IFSC Code', _ifscController),
                    
                    const SizedBox(height: 30),
                    _buildSaveButton(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Row(
        children: [
          _buildIconButton(Icons.chevron_left, () => context.pop()),
          const SizedBox(width: 12),
          Text('Account Settings', style: AppTextStyles.h2.copyWith(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.bg3,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppColors.border),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 16, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 20, 6, 8),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.label.copyWith(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 4),
            child: Text(label, style: AppTextStyles.label.copyWith(fontSize: 10, color: AppColors.textSecondary)),
          ),
          TextField(
            controller: controller,
            style: AppTextStyles.body.copyWith(fontSize: 13),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.bg3,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.orange),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final updatedOwner = OwnerProfile(
            gymName: _gymNameController.text,
            ownerName: _ownerNameController.text,
            phone: _phoneController.text,
            address: _addressController.text,
            gstin: _gstinController.text,
            bankName: _bankNameController.text,
            accountNumber: _accountNumberController.text,
            ifsc: _ifscController.text,
          );
          
          await ref.read(authProvider.notifier).saveOwner(updatedOwner);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Settings saved successfully')),
            );
            context.pop();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: const Text('Save Changes', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
