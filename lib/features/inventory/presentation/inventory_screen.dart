import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/status_bar_wrapper.dart';
import '../viewmodel/inventory_viewmodel.dart';
import '../../../../data/models/product.dart';
import 'package:uuid/uuid.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);

    return Container(
      decoration: const BoxDecoration(color: AppColors.bg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StatusBarWrapper(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: products.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return _buildProductCard(context, ref, product);
                        },
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddProductSheet(context, ref),
          backgroundColor: AppColors.orange,
          child: const Icon(Icons.add, color: Colors.white),
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
          Text('Inventory', style: AppTextStyles.h2.copyWith(fontSize: 18)),
          const Spacer(),
          _buildIconButton(Icons.history_rounded, () => context.push('/pos/sales-history')),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.textMuted.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text('No products found', style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text('Add products like Supplements, Water, etc.', 
            style: AppTextStyles.label.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, WidgetRef ref, Product product) {
    final isLowStock = product.stock <= product.minStock;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg3,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.bg4,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.shopping_bag_outlined, color: AppColors.orange, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
                Text('₹${product.price}', style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, fontSize: 10)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${product.stock} in stock', 
                style: AppTextStyles.body.copyWith(
                  fontSize: 11, 
                  fontWeight: FontWeight.w700,
                  color: isLowStock ? AppColors.expired : AppColors.active,
                )),
              if (isLowStock)
                Text('Low Stock', style: AppTextStyles.label.copyWith(color: AppColors.expired, fontSize: 8)),
            ],
          ),
          const SizedBox(width: 8),
          _buildIconButton(Icons.delete_outline_rounded, () {
            ref.read(inventoryNotifierProvider.notifier).deleteProduct(product.id);
          }),
        ],
      ),
    );
  }

  void _showAddProductSheet(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    final minStockController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: const BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add New Product', style: AppTextStyles.h2),
              const SizedBox(height: 20),
              _buildSheetField('Product Name', nameController, 'e.g. Whey Protein'),
              _buildSheetField('Price (₹)', priceController, '0.00', keyboardType: TextInputType.number),
              Row(
                children: [
                  Expanded(child: _buildSheetField('Initial Stock', stockController, '0', keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildSheetField('Min Stock Alert', minStockController, '5', keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                      final product = Product(
                        id: const Uuid().v4(),
                        name: nameController.text.trim(),
                        price: double.tryParse(priceController.text) ?? 0.0,
                        category: 'General',
                        stock: int.tryParse(stockController.text) ?? 0,
                        minStock: int.tryParse(minStockController.text) ?? 5,
                      );
                      ref.read(inventoryNotifierProvider.notifier).addProduct(product);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Add Product', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSheetField(String label, TextEditingController controller, String hint, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.label.copyWith(fontSize: 10, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
              filled: true,
              fillColor: AppColors.bg3,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
