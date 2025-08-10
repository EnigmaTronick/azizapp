import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import '../providers/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final isSmallScreen = screenWidth < 360;
        final isVerySmallScreen = screenWidth < 320 || screenHeight < 600;
        
        // Responsive padding and spacing
        final padding = isVerySmallScreen ? 12.0 : (isSmallScreen ? 16.0 : 20.0);
        final sectionSpacing = isVerySmallScreen ? 12.0 : (isSmallScreen ? 16.0 : 24.0);
        
        return SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              _buildWelcomeSection(context, isDark, isSmallScreen),
              
              SizedBox(height: sectionSpacing),
              
              // Stats Cards
              _buildStatsCards(context, isDark, isSmallScreen),
              
              SizedBox(height: sectionSpacing),
              
              // Quick Actions
              _buildQuickActions(context, isDark, isSmallScreen),
              
              SizedBox(height: sectionSpacing),
              
              // Recent Activity
              _buildRecentActivity(context, isDark, isSmallScreen),
              
              // Bottom padding to ensure content doesn't get cut off by navigation
              SizedBox(height: isVerySmallScreen ? 80 : 100),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildWelcomeSection(BuildContext context, bool isDark, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.getPrimaryColor(context).withOpacity(0.1),
            AppColors.getAccentColor(context).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
        border: Border.all(
          color: AppColors.getPrimaryColor(context).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back!',
                  style: (isSmallScreen 
                    ? AppTextStyles.h3 
                    : AppTextStyles.h2).copyWith(
                    color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  ),
                ),
                
                SizedBox(height: isSmallScreen ? 4 : 8),
                
                Text(
                  'Ready to explore the future?',
                  style: (isSmallScreen 
                    ? AppTextStyles.bodyMedium 
                    : AppTextStyles.bodyLarge).copyWith(
                    color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.getPrimaryColor(context), AppColors.getAccentColor(context)],
              ),
              borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
            ),
            child: Icon(
              Iconsax.home,
              color: Colors.white,
              size: isSmallScreen ? 28 : 32,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatsCards(BuildContext context, bool isDark, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: (isSmallScreen 
            ? AppTextStyles.h4 
            : AppTextStyles.h3).copyWith(
            color: isDark
              ? AppColors.textPrimaryDark
              : AppColors.textPrimaryLight,
          ),
        ),
        
        SizedBox(height: isSmallScreen ? 12 : 16),
        
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context: context,
                icon: Iconsax.chart,
                title: 'Analytics',
                value: '2.4k',
                change: '+12%',
                isPositive: true,
                isDark: isDark,
                isSmallScreen: isSmallScreen,
              ),
            ),
            
            SizedBox(width: isSmallScreen ? 12 : 16),
            
            Expanded(
              child: _buildStatCard(
                context: context,
                icon: Iconsax.user_octagon,
                title: 'Users',
                value: '1.2k',
                change: '+8%',
                isPositive: true,
                isDark: isDark,
                isSmallScreen: isSmallScreen,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required String change,
    required bool isPositive,
    required bool isDark,
    required bool isSmallScreen,
  }) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: isDark
          ? AppColors.surfaceDark
          : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
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
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                decoration: BoxDecoration(
                  color: AppColors.getPrimaryColor(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(isSmallScreen ? 6 : 8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.getPrimaryColor(context),
                  size: isSmallScreen ? 16 : 18,
                ),
              ),
              
              const Spacer(),
              
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 6 : 8, 
                  vertical: isSmallScreen ? 2 : 4,
                ),
                decoration: BoxDecoration(
                  color: isPositive
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(isSmallScreen ? 6 : 8),
                ),
                child: Text(
                  change,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: isSmallScreen ? 9 : 10,
                    color: isPositive ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: isSmallScreen ? 8 : 12),
          
          Flexible(
            child: Text(
              value,
              style: (isSmallScreen 
                ? AppTextStyles.h4 
                : AppTextStyles.h3).copyWith(
                color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          SizedBox(height: isSmallScreen ? 2 : 4),
          
          Flexible(
            child: Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: isSmallScreen ? 10 : 11,
                color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickActions(BuildContext context, bool isDark, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: (isSmallScreen 
            ? AppTextStyles.h4 
            : AppTextStyles.h3).copyWith(
            color: isDark
              ? AppColors.textPrimaryDark
              : AppColors.textPrimaryLight,
          ),
        ),
        
        SizedBox(height: isSmallScreen ? 12 : 16),
        
        LayoutBuilder(
          builder: (context, constraints) {
            // Calculate optimal sizing based on available width
            final availableWidth = constraints.maxWidth;
            final spacing = isSmallScreen ? 8.0 : 12.0;
            final cardWidth = (availableWidth - spacing) / 2;
            final cardHeight = isSmallScreen ? 75.0 : 90.0; // Even more compact
            
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: cardWidth / cardHeight,
              children: [
                _buildActionCard(
                  context: context,
                  icon: Iconsax.scan,
                  title: 'Quick Scan',
                  subtitle: 'Scan something',
                  isDark: isDark,
                  isSmallScreen: isSmallScreen,
                ),
                _buildActionCard(
                  context: context,
                  icon: Iconsax.clock,
                  title: 'History',
                  subtitle: 'View past scans',
                  isDark: isDark,
                  isSmallScreen: isSmallScreen,
                ),
                _buildActionCard(
                  context: context,
                  icon: Iconsax.setting_2,
                  title: 'Settings',
                  subtitle: 'App preferences',
                  isDark: isDark,
                  isSmallScreen: isSmallScreen,
                ),
                _buildActionCard(
                  context: context,
                  icon: Iconsax.info_circle,
                  title: 'About',
                  subtitle: 'App information',
                  isDark: isDark,
                  isSmallScreen: isSmallScreen,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required bool isSmallScreen,
  }) {
    final primaryColor = AppColors.getPrimaryColor(context);
    final accentColor = AppColors.getAccentColor(context);
    
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.1),
            accentColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
        border: Border.all(
          color: primaryColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 4 : 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [primaryColor, accentColor]),
              borderRadius: BorderRadius.circular(isSmallScreen ? 4 : 6),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: isSmallScreen ? 14 : 18,
            ),
          ),
          
          SizedBox(height: isSmallScreen ? 4 : 8),
          
          Flexible(
            child: Text(
              title,
              style: (isSmallScreen 
                ? AppTextStyles.caption 
                : AppTextStyles.bodySmall).copyWith(
                color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
                fontSize: isSmallScreen ? 10 : 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          SizedBox(height: isSmallScreen ? 1 : 2),
          
          Flexible(
            child: Text(
              subtitle,
              style: (isSmallScreen 
                ? AppTextStyles.caption 
                : AppTextStyles.bodySmall).copyWith(
                color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
                fontSize: isSmallScreen ? 8 : 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecentActivity(BuildContext context, bool isDark, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: (isSmallScreen 
            ? AppTextStyles.h4 
            : AppTextStyles.h3).copyWith(
            color: isDark
              ? AppColors.textPrimaryDark
              : AppColors.textPrimaryLight,
          ),
        ),
        
        SizedBox(height: isSmallScreen ? 12 : 16),
        
        Container(
          decoration: BoxDecoration(
            color: isDark
              ? AppColors.surfaceDark
              : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
            border: Border.all(
              color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: [
              _buildActivityItem(
                icon: Iconsax.scan,
                title: 'Document Scanned',
                subtitle: '2 hours ago',
                isDark: isDark,
                isSmallScreen: isSmallScreen,
              ),
              Divider(
                color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
              ),
              _buildActivityItem(
                icon: Iconsax.user,
                title: 'Profile Updated',
                subtitle: '1 day ago',
                isDark: isDark,
                isSmallScreen: isSmallScreen,
              ),
              Divider(
                color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
              ),
              _buildActivityItem(
                icon: Iconsax.setting_2,
                title: 'Settings Changed',
                subtitle: '3 days ago',
                isDark: isDark,
                isSmallScreen: isSmallScreen,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required bool isSmallScreen,
  }) {
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(isSmallScreen ? 6 : 8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: isSmallScreen ? 14 : 16,
            ),
          ),
          
          SizedBox(width: isSmallScreen ? 8 : 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: (isSmallScreen 
                    ? AppTextStyles.bodySmall 
                    : AppTextStyles.bodyMedium).copyWith(
                    color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: (isSmallScreen 
                    ? AppTextStyles.caption 
                    : AppTextStyles.bodySmall).copyWith(
                    color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
