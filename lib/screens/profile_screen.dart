import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Header
              _buildProfileHeader(isDark, context),
              
              const SizedBox(height: 30),
              
              // Stats Row
              _buildStatsRow(isDark, context),
              
              const SizedBox(height: 30),
              
              // Menu Items
              _buildMenuItems(isDark, context),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildProfileHeader(bool isDark, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.getPrimaryColor(context).withOpacity(0.1),
            AppColors.getAccentColor(context).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.getPrimaryColor(context).withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          // Profile Image
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.getPrimaryColor(context), AppColors.getAccentColor(context)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.getPrimaryColor(context).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Iconsax.user,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              
              // Edit Button
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.getAccentColor(context), AppColors.getPrimaryColor(context)],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Iconsax.edit,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Name
          Text(
            'Aziz User',
            style: AppTextStyles.h2.copyWith(
              color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Email
          Text(
            'aziz.user@example.com',
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.success.withOpacity(0.2),
                  AppColors.success.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.success.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Premium User',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatsRow(bool isDark, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context: context,
            icon: Iconsax.scan,
            title: 'Scans',
            value: '148',
            isDark: isDark,
          ),
        ),
        
        const SizedBox(width: 16),
        
        Expanded(
          child: _buildStatCard(
            context: context,
            icon: Iconsax.award,
            title: 'Points',
            value: '2.4k',
            isDark: isDark,
          ),
        ),
        
        const SizedBox(width: 16),
        
        Expanded(
          child: _buildStatCard(
            context: context,
            icon: Iconsax.medal_star,
            title: 'Level',
            value: '12',
            isDark: isDark,
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.getPrimaryColor(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.getPrimaryColor(context),
              size: 20,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
            ),
          ),
          
          const SizedBox(height: 4),
          
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMenuItems(bool isDark, BuildContext context) {
    final menuItems = [
      {
        'icon': Iconsax.edit,
        'title': 'Edit Profile',
        'subtitle': 'Update your personal information',
        'action': () {},
      },
      {
        'icon': Iconsax.setting_2,
        'title': 'Settings',
        'subtitle': 'App preferences and configuration',
        'action': () {},
      },
      {
        'icon': Iconsax.notification,
        'title': 'Notifications',
        'subtitle': 'Manage your notification preferences',
        'action': () {},
      },
      {
        'icon': Iconsax.security,
        'title': 'Privacy & Security',
        'subtitle': 'Control your privacy settings',
        'action': () {},
      },
      {
        'icon': Iconsax.info_circle,
        'title': 'Help & Support',
        'subtitle': 'Get help or contact support',
        'action': () {},
      },
      {
        'icon': Iconsax.star,
        'title': 'Rate App',
        'subtitle': 'Rate us on the App Store',
        'action': () {},
      },
      {
        'icon': Iconsax.share,
        'title': 'Share App',
        'subtitle': 'Share with your friends',
        'action': () {},
      },
      {
        'icon': Iconsax.logout,
        'title': 'Sign Out',
        'subtitle': 'Sign out of your account',
        'action': () {},
        'isDestructive': true,
      },
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Settings',
          style: AppTextStyles.h4.copyWith(
            color: isDark
              ? AppColors.textPrimaryDark
              : AppColors.textPrimaryLight,
          ),
        ),
        
        const SizedBox(height: 16),
        
        Container(
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
          ),
          child: Column(
            children: menuItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == menuItems.length - 1;
              final isDestructive = item['isDestructive'] == true;
              
              return Column(
                children: [
                  _buildMenuItem(
                    context: context,
                    icon: item['icon'] as IconData,
                    title: item['title'] as String,
                    subtitle: item['subtitle'] as String,
                    onTap: item['action'] as VoidCallback,
                    isDestructive: isDestructive,
                    isDark: isDark,
                  ),
                  if (!isLast)
                    Divider(
                      color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.1),
                      height: 1,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
        
        const SizedBox(height: 30),
        
        // App Version
        Center(
          child: Text(
            'AzizApp Version 1.0.0',
            style: AppTextStyles.caption.copyWith(
              color: isDark
                ? AppColors.textSecondaryDark.withOpacity(0.7)
                : AppColors.textSecondaryLight.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDestructive,
    required bool isDark,
  }) {
    final color = isDestructive 
      ? AppColors.error 
      : AppColors.getPrimaryColor(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDestructive 
                        ? AppColors.error
                        : isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            
            Icon(
              Iconsax.arrow_right_2,
              color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
