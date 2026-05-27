import 'package:flutter/material.dart';
import '../core/constants/ac_colors.dart';
import '../core/constants/ac_text_styles.dart';

class ActionSheetItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const ActionSheetItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}

class ActionSheet extends StatelessWidget {
  final String title;
  final List<ActionSheetItem> items;

  const ActionSheet({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AcColors.s1,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(color: AcColors.rim2, width: 1),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AcColors.rim2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
            child: Text(
              title,
              style: AcTextStyles.h3.copyWith(letterSpacing: -0.2),
            ),
          ),
          // Items
          ...items.map((item) => InkWell(
                onTap: () {
                  Navigator.pop(context);
                  item.onTap();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      // Icon Container
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          item.icon,
                          color: item.color,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Text block
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.label,
                              style: AcTextStyles.label.copyWith(fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.subtitle,
                              style: AcTextStyles.subtext,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

void showAppActionSheet({
  required BuildContext context,
  required String title,
  required List<ActionSheetItem> items,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    elevation: 0,
    barrierColor: Colors.black.withOpacity(0.6),
    isScrollControlled: true,
    builder: (context) => ActionSheet(title: title, items: items),
  );
}
