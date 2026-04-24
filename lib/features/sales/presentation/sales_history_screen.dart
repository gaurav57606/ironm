import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/status_bar_wrapper.dart';
import '../viewmodel/sales_viewmodel.dart';
import '../../../../data/models/sale.dart';

class SalesHistoryScreen extends ConsumerWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsync = ref.watch(salesStreamProvider);

    return Container(
      decoration: const BoxDecoration(color: AppColors.bg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StatusBarWrapper(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: salesAsync.when(
                  data: (sales) => sales.isEmpty 
                    ? _buildEmptyState() 
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        itemCount: sales.length,
                        itemBuilder: (context, index) {
                          final sale = sales[index];
                          return _buildSaleCard(sale);
                        },
                      ),
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.orange)),
                  error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.expired))),
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
          Text('Sales History', style: AppTextStyles.h2.copyWith(fontSize: 18)),
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
          Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.textMuted.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text('No sales records', style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text('Your point-of-sale transactions will appear here.', 
            style: AppTextStyles.label.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildSaleCard(Sale sale) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg3,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sale.invoiceNumber, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.orange)),
                  Text(DateFormat('dd MMM yyyy · hh:mm a').format(sale.date), 
                    style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹${sale.totalAmount.toStringAsFixed(2)}', 
                    style: AppTextStyles.h3.copyWith(fontSize: 14)),
                  Text(sale.paymentMethod, style: AppTextStyles.label.copyWith(color: AppColors.active, fontSize: 9, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1, color: AppColors.border)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sale.items.length,
            itemBuilder: (context, idx) {
              final item = sale.items[idx];
              return Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${item.quantity}x ${item.productName}', style: AppTextStyles.label.copyWith(fontSize: 10, color: AppColors.textSecondary)),
                    Text('₹${item.price.toStringAsFixed(2)}', style: AppTextStyles.label.copyWith(fontSize: 10)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
