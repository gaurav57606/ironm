import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/status_bar_wrapper.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StatusBarWrapper(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      _buildQuickAction('Assign New Plan', Icons.add_task_rounded, AppColors.blue),
                      const SizedBox(height: 32),
                      Text('Recent Clients', style: AppTextStyles.h3),
                      const SizedBox(height: 16),
                      _buildClientCard('John Doe', 'High Protein', '2,400 kcal', 0.85),
                      _buildClientCard('Sarah Jenkins', 'Keto Diet', '1,800 kcal', 0.45),
                      _buildClientCard('Mike Ross', 'Maintenance', '2,200 kcal', 0.95),
                      const SizedBox(height: 32),
                      Text('Diet Popularity', style: AppTextStyles.h3),
                      const SizedBox(height: 20),
                      _buildDietStats(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Nutrition Plans',
            style: AppTextStyles.h1.copyWith(fontSize: 24),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.elevation2,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.restaurant_menu_rounded, color: AppColors.orange, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.elevation2,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 18),
          Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
          const Spacer(),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        ],
      ),
    );
  }

  Widget _buildClientCard(String name, String plan, String kcal, double progress) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.elevation2,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.orange.withOpacity(0.2), AppColors.orange.withOpacity(0.05)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.orange.withOpacity(0.2)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    name[0],
                    style: AppTextStyles.h3.copyWith(color: AppColors.orange),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                      Text(plan, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                Text(kcal, style: AppTextStyles.bodySmall.copyWith(color: AppColors.orange, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: Colors.white.withOpacity(0.05),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress > 0.8 ? AppColors.active : AppColors.orange,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildDietCircle('Keto', 0.45, AppColors.blue),
        _buildDietCircle('Vegan', 0.25, AppColors.active),
        _buildDietCircle('Palio', 0.30, Colors.purple),
      ],
    );
  }

  Widget _buildDietCircle(String name, double percent, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                value: percent,
                strokeWidth: 6,
                backgroundColor: Colors.white.withOpacity(0.05),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeCap: StrokeCap.round,
              ),
            ),
            Text(
              '${(percent * 100).toInt()}%',
              style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(name, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
