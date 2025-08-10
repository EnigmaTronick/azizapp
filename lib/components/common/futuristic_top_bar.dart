import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

class FuturisticTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onMenuTap;
  final List<Widget>? actions;
  
  const FuturisticTopBar({
    super.key,
    required this.title,
    required this.onMenuTap,
    this.actions,
  });
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
            ? [
                AppColors.backgroundDark.withOpacity(0.95),
                AppColors.surfaceDark.withOpacity(0.9),
              ]
            : [
                AppColors.backgroundLight.withOpacity(0.95),
                AppColors.surfaceLight.withOpacity(0.9),
              ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark 
              ? Colors.black.withOpacity(0.2)
              : AppColors.getPrimaryColor(context).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          bottom: BorderSide(
            color: AppColors.getPrimaryColor(context).withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: 8,
        ),
        child: Row(
          children: [
            // Menu Button
            GestureDetector(
              onTap: onMenuTap,
              child: Container(
                width: isSmallScreen ? 36 : 40,
                height: isSmallScreen ? 36 : 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.getPrimaryColor(context).withOpacity(0.15),
                      AppColors.getAccentColor(context).withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.getPrimaryColor(context).withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
                child: Icon(
                  Iconsax.menu_1,
                  color: AppColors.getPrimaryColor(context),
                  size: isSmallScreen ? 18 : 20,
                ),
              ),
            ),
            
            SizedBox(width: isSmallScreen ? 8 : 16),
            
            // Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: (isSmallScreen ? AppTextStyles.bodyLarge : AppTextStyles.h4).copyWith(
                      color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2),
                  Container(
                    height: 2,
                    width: isSmallScreen ? 30 : 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.getPrimaryColor(context),
                          AppColors.getAccentColor(context),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(width: isSmallScreen ? 8 : 12),
            
            // Right side actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Notification Button
                GestureDetector(
                  onTap: () {
                    // Handle notification tap
                  },
                  child: Container(
                    width: isSmallScreen ? 36 : 40,
                    height: isSmallScreen ? 36 : 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.getAccentColor(context).withOpacity(0.15),
                          AppColors.getPrimaryColor(context).withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.getAccentColor(context).withOpacity(0.2),
                        width: 0.5,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Iconsax.notification,
                            color: AppColors.getAccentColor(context),
                            size: isSmallScreen ? 16 : 18,
                          ),
                        ),
                        // Notification dot
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Custom actions
                if (actions != null) ...[
                  SizedBox(width: isSmallScreen ? 8 : 12),
                  ...actions!,
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
