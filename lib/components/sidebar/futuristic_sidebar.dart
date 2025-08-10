import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';
import 'color_picker_dialog.dart';

class FuturisticSidebar extends StatefulWidget {
  final VoidCallback onClose;

  const FuturisticSidebar({
    super.key,
    required this.onClose,
  });

  @override
  State<FuturisticSidebar> createState() => _FuturisticSidebarState();
}

class _FuturisticSidebarState extends State<FuturisticSidebar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.98, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _closeSidebar() async {
    await _controller.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDark = themeProvider.isDarkMode;

        return FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onTap: _closeSidebar,
            child: Container(
              color: Colors.black.withOpacity(0.4),
              child: SlideTransition(
                position: _slideAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          width: 300,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [
                                      AppColors.backgroundDark.withOpacity(0.85),
                                      AppColors.surfaceDark.withOpacity(0.7)
                                    ]
                                  : [
                                      AppColors.backgroundLight.withOpacity(0.85),
                                      AppColors.surfaceLight.withOpacity(0.7)
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border(
                              right: BorderSide(
                                color: AppColors.getPrimaryColor(context).withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 25,
                                offset: const Offset(5, 0),
                              ),
                            ],
                          ),
                          child: SafeArea(
                            child: Column(
                              children: [
                                _buildHeader(themeProvider),
                                Expanded(
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Column(
                                      children: [
                                        _buildProfileSection(themeProvider),
                                        const SizedBox(height: 30),
                                        _buildThemeSettings(themeProvider),
                                        const SizedBox(height: 30),
                                        _buildFooter(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Settings',
            style: AppTextStyles.h3.copyWith(
              color: themeProvider.isDarkMode
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          GestureDetector(
            onTap: _closeSidebar,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeProvider.isDarkMode
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Iconsax.close_square,
                  color: themeProvider.isDarkMode
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(ThemeProvider themeProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.getPrimaryColor(context).withOpacity(0.15),
            AppColors.getAccentColor(context).withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.getPrimaryColor(context).withOpacity(0.25),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.getPrimaryColor(context),
                  AppColors.getAccentColor(context)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.getPrimaryColor(context).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Iconsax.user,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Aziz User',
            style: AppTextStyles.h4.copyWith(
              color: themeProvider.isDarkMode
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'aziz.user@example.com',
            style: AppTextStyles.bodyMedium.copyWith(
              color: themeProvider.isDarkMode
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSettings(ThemeProvider themeProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Theme Settings',
            style: AppTextStyles.h4.copyWith(
              color: themeProvider.isDarkMode
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 16),
          _buildThemeOption(
            icon: themeProvider.isDarkMode ? Iconsax.moon : Iconsax.sun_1,
            title: themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
            subtitle: 'Toggle between light and dark theme',
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleTheme(),
              activeColor: AppColors.getPrimaryColor(context),
              activeTrackColor:
                  AppColors.getPrimaryColor(context).withOpacity(0.3),
            ),
            themeProvider: themeProvider,
          ),
          const SizedBox(height: 12),
          _buildThemeOption(
            icon: Iconsax.color_swatch,
            title: 'Custom Colors',
            subtitle: 'Choose your own color scheme',
            trailing: Icon(
              Iconsax.arrow_right_2,
              color: themeProvider.isDarkMode
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              size: 16,
            ),
            onTap: () => _showColorPicker(themeProvider),
            themeProvider: themeProvider,
          ),
          if (themeProvider.isCustomMode) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: themeProvider.isDarkMode
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    'Custom Theme Active',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.getPrimaryColor(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildColorDot(themeProvider.customPrimaryColor),
                  const SizedBox(width: 4),
                  _buildColorDot(themeProvider.customAccentColor),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => themeProvider.resetToSystemTheme(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Iconsax.close_circle,
                        color: Colors.red,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildColorDot(Color color) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }

  Widget _buildThemeOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    required ThemeProvider themeProvider,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeProvider.isDarkMode
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: themeProvider.isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.getPrimaryColor(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon,
                  color: AppColors.getPrimaryColor(context), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: themeProvider.isDarkMode
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w600,
                      )),
                  Text(subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: themeProvider.isDarkMode
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      )),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Divider(
            color: AppColors.getPrimaryColor(context).withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'AzizApp v1.0.0',
            style: AppTextStyles.caption
                .copyWith(color: AppColors.textSecondaryLight.withOpacity(0.7)),
          ),
          const SizedBox(height: 4),
          Text(
            'Built with Flutter',
            style: AppTextStyles.caption
                .copyWith(color: AppColors.textSecondaryLight.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => ColorPickerDialog(
        initialPrimaryColor: themeProvider.customPrimaryColor,
        initialAccentColor: themeProvider.customAccentColor,
        onColorsSelected: (primary, accent) {
          themeProvider.setCustomColors(
            primaryColor: primary,
            accentColor: accent,
          );
        },
      ),
    );
  }
}
