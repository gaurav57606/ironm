import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/status_bar_wrapper.dart';
import '../../inventory/viewmodel/inventory_viewmodel.dart';
import '../../sales/viewmodel/sales_viewmodel.dart';
import '../../members/viewmodel/members_viewmodel.dart';
import '../../payments/viewmodel/payments_viewmodel.dart';
import '../../../data/models/product.dart';
import '../../../data/models/sale.dart';
import '../../../data/models/member.dart';
import '../../dashboard/presentation/widgets/stat_card.dart';



class POSScreen extends ConsumerStatefulWidget {
  const POSScreen({super.key});

  @override
  ConsumerState<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends ConsumerState<POSScreen> {
  final Map<String, int> _cart = {};
  String _selectedCategory = 'All';

  double _calculateTotal(List<Product> products) {
    double total = 0;
    _cart.forEach((productId, qty) {
      final product = products.firstWhere((p) => p.id == productId);
      total += product.price * qty;
    });
    return total;
  }


  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsProvider);
    final total = _calculateTotal(products);
    final categories = ['All', ...{for (var p in products) p.category}];
    
    final filtered = _selectedCategory == 'All' 
      ? products 
      : products.where((p) => p.category == _selectedCategory).toList();


    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StatusBarWrapper(
          child: Column(
            children: [
              _buildAppBar(),
              _buildStatsHeader(ref),
              _buildCategoryFilter(categories),
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildProductGrid(filtered)),
                    _buildCartSidebar(total, products),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.elevation2,
              padding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Point of Sale',
            style: AppTextStyles.h1.copyWith(fontSize: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader(WidgetRef ref) {
    final payments = ref.watch(paymentsStreamProvider).value ?? [];
    final members = ref.watch(membersProvider);
    
    final now = DateTime.now();
    final mtdTotal = payments.where((p) => p.date.month == now.month && p.date.year == now.year)
                             .fold(0.0, (sum, p) => sum + p.amount);
    final activeCount = members.where((m) => m.getStatus(now) == MemberStatus.active).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              label: 'Membership Revenue',
              value: '₹${mtdTotal.toInt()}',
              icon: Icons.payments_rounded,
              iconColor: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: StatCard(
              label: 'Active Members',
              value: activeCount.toString(),
              icon: Icons.people_alt_rounded,
              iconColor: AppColors.active,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(List<String> categories) {

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: categories.map((cat) {
          bool active = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : AppColors.elevation2,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: active ? AppColors.primary : AppColors.border),
                boxShadow: active ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ] : [],
              ),
              child: Text(
                cat,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: active ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Container(
          decoration: BoxDecoration(
            color: AppColors.elevation2,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(IconData(product.iconCodePoint, fontFamily: 'MaterialIcons'), color: AppColors.primary, size: 32),
              ),

              const SizedBox(height: 16),
              Text(
                product.name,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                '₹${product.price}',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => setState(() => _cart[product.id] = (_cart[product.id] ?? 0) + 1),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    'Add',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCartSidebar(double total, List<Product> products) {

    return Container(
      width: 160,
      decoration: const BoxDecoration(
        color: AppColors.elevation1,
        border: Border(left: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Your Cart',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: _cart.entries.map((entry) {
                final product = products.firstWhere((p) => p.id == entry.key);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name, 
                              maxLines: 1, 
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '₹${product.price} x ${entry.value}',
                              style: AppTextStyles.bodySmall.copyWith(fontSize: 8, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (_cart[product.id]! > 1) {
                              _cart[product.id] = _cart[product.id]! - 1;
                            } else {
                              _cart.remove(product.id);
                            }
                          });
                        },
                        icon: const Icon(Icons.remove_circle_outline, size: 14, color: AppColors.expired),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    Text('₹${total.toInt()}', style: AppTextStyles.h3.copyWith(color: AppColors.primary, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 20),
                AppButton(
                  text: 'Checkout',
                  onPressed: _cart.isEmpty ? null : () => _handleCheckout(total, products),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCheckout(double total, List<Product> products) async {
    final selectedMethod = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bg3,
        title: Text('Select Payment Method', style: AppTextStyles.h3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Cash', 'UPI', 'Card', 'Bank'].map((m) => ListTile(
            title: Text(m, style: AppTextStyles.body),
            onTap: () => Navigator.pop(context, m),
          )).toList(),
        ),
      ),
    );

    if (selectedMethod == null) return;

    final saleItems = _cart.entries.map((entry) {
      final product = products.firstWhere((p) => p.id == entry.key);
      return SaleItem(
        productId: product.id,
        productName: product.name,
        price: product.price,
        quantity: entry.value,
      );
    }).toList();

    try {
      await ref.read(salesProvider.notifier).recordSale(
        items: saleItems,
        paymentMethod: selectedMethod,
        totalAmount: total,
      );
      if (mounted) {
        setState(() => _cart.clear());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sale Recorded Successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.expired),
        );
      }
    }
  }
}


