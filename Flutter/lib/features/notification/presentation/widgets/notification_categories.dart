import 'package:flutter/material.dart';
import '../../data/notification_data.dart';
import '../../../../core/theme/appColors.dart';

class NotificationCategories extends StatelessWidget {
  final NotificationCategory? selectedCategory;
  final ValueChanged<NotificationCategory?> onCategorySelected;
  const NotificationCategories({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    });

    static const List<_NotificationFilter> _filters = [
      _NotificationFilter(
        label: 'Semua',
        icon: Icons.grid_view_rounded,
        category: null,
      ),
      _NotificationFilter(
        label: 'Pesanan',
        icon: Icons.local_shipping_outlined,
        category: NotificationCategory.order,
      ),
      _NotificationFilter(
        label: 'Promo',
        icon: Icons.local_offer_outlined,
        category: NotificationCategory.promo,
      ),
      _NotificationFilter(
        label: 'Live',
        icon: Icons.play_circle_outline_rounded,
        category: NotificationCategory.live,
      ),
      _NotificationFilter(
        label: 'Keuangan',
        icon: Icons.account_balance_wallet_outlined,
        category: NotificationCategory.finance,
      ),
      _NotificationFilter(
        label: 'Toko',
        icon: Icons.storefront_outlined,
        category: NotificationCategory.store,
      ),
    ];   
    
    @override
    Widget build(BuildContext context) {
      return SizedBox(
        height: 43,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          separatorBuilder: (context, index) {
            return const SizedBox(width: 8);
          },
          itemBuilder: (context, index){
            final filter = _filters[index];

            final isSelected = selectedCategory == filter.category;

            return ChoiceChip(
              selected: isSelected,
              showCheckmark: false,
              onSelected: (selected) {
                onCategorySelected(filter.category);
              },
              avatar: Icon(filter.icon,
              size: 17,
              color: isSelected ? Colors.white : AppColors.deepGreen,
              ),
              label: Text(filter.label),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.darkPine,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: Colors.white,
              selectedColor: AppColors.deepGreen,
              side: BorderSide(
                color: isSelected ? AppColors.deepGreen : AppColors.softMint,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 7,
              ),
            );
          },
        ),
      );
    }
  }
  
class _NotificationFilter {
  final String label;
  final IconData icon;
  final NotificationCategory? category;

  const _NotificationFilter({
    required this.label,
    required this.icon,
    required this.category,
  });
}