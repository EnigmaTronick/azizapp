import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import '../providers/theme_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<String> _filterTabs = ['All', 'QR Code', 'Document', 'Image', 'Barcode'];
  int _selectedFilter = 0;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filterTabs.length, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;
        
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildFilterTabs(context, isDark),
              const SizedBox(height: 20),
              _buildHistoryList(context, isDark),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildFilterTabs(BuildContext context, bool isDark) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterTabs.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedFilter;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        AppColors.getPrimaryColor(context),
                        AppColors.getAccentColor(context),
                      ],
                    )
                  : null,
                color: isSelected
                  ? null
                  : isDark
                      ? AppColors.surfaceDark
                      : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                    ? Colors.transparent
                    : isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.1),
                ),
                boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.getPrimaryColor(context).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
              ),
              child: Text(
                _filterTabs[index],
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected
                    ? Colors.white
                    : isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildHistoryList(BuildContext context, bool isDark) {
    // Mock data for history items
    final historyItems = [
      {
        'type': 'QR Code',
        'title': 'Restaurant Menu',
        'subtitle': 'https://restaurant.com/menu',
        'time': '2 hours ago',
        'icon': Iconsax.scan,
        'status': 'success',
      },
      {
        'type': 'Document',
        'title': 'Business Card',
        'subtitle': 'Contact information extracted',
        'time': '1 day ago',
        'icon': Iconsax.document,
        'status': 'success',
      },
      {
        'type': 'Image',
        'title': 'Product Analysis',
        'subtitle': 'Electronics - Smartphone detected',
        'time': '2 days ago',
        'icon': Iconsax.image,
        'status': 'warning',
      },
      {
        'type': 'QR Code',
        'title': 'WiFi Network',
        'subtitle': 'Connected to "HomeWiFi"',
        'time': '3 days ago',
        'icon': Iconsax.scan,
        'status': 'success',
      },
      {
        'type': 'Barcode',
        'title': 'Product Info',
        'subtitle': 'ISBN: 978-0-123456-78-9',
        'time': '1 week ago',
        'icon': Iconsax.barcode,
        'status': 'success',
      },
      {
        'type': 'Document',
        'title': 'Receipt Scan',
        'subtitle': 'Total: \$45.99 - Grocery Store',
        'time': '1 week ago',
        'icon': Iconsax.document,
        'status': 'error',
      },
    ];
    
    final filteredItems = _selectedFilter == 0
        ? historyItems
        : historyItems.where((item) => item['type'] == _filterTabs[_selectedFilter]).toList();
    
    if (filteredItems.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 80),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.document_text,
              size: 64,
              color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No history found',
              style: AppTextStyles.h3.copyWith(
                color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your scan history will appear here',
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return _buildHistoryItem(context, item, isDark);
      },
    );
  }
  
  Widget _buildHistoryItem(BuildContext context, Map<String, dynamic> item, bool isDark) {
    Color statusColor;
    switch (item['status']) {
      case 'success':
        statusColor = AppColors.success;
        break;
      case 'warning':
        statusColor = AppColors.warning;
        break;
      case 'error':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.getPrimaryColor(context);
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Handle history item tap
            _showHistoryDetails(context, item);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                ? AppColors.surfaceDark
                : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                    ? Colors.black.withOpacity(0.2)
                    : Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon with status indicator
                Stack(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.getPrimaryColor(context).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: AppColors.getPrimaryColor(context),
                        size: 24,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                              ? AppColors.backgroundDark
                              : AppColors.backgroundLight,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(width: 16),
                
                // Content
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.getPrimaryColor(context).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item['type'] as String,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.getPrimaryColor(context),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            item['time'] as String,
                            style: AppTextStyles.caption.copyWith(
                              color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        item['title'] as String,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      Text(
                        item['subtitle'] as String,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Arrow icon
                Icon(
                  Iconsax.arrow_right_3,
                  color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _showHistoryDetails(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            final isDark = themeProvider.isDarkMode;
            
            return Container(
          decoration: BoxDecoration(
            color: isDark
              ? AppColors.surfaceDark
              : AppColors.surfaceLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                      ? Colors.white.withOpacity(0.3)
                      : Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.getPrimaryColor(context).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: AppColors.getPrimaryColor(context),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: AppTextStyles.h3.copyWith(
                            color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          item['type'] as String,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.getPrimaryColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              Text(
                'Details',
                style: AppTextStyles.h4.copyWith(
                  color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                ),
              ),
              
              const SizedBox(height: 12),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                    ? AppColors.backgroundDark
                    : AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.1),
                  ),
                ),
                child: Text(
                  item['subtitle'] as String,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.getPrimaryColor(context),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Share',
                        style: TextStyle(
                          color: AppColors.getPrimaryColor(context),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.getPrimaryColor(context),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
          },
        );
      },
    );
  }
}
