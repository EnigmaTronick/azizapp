import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

enum NavItem { home, history, scan, profile }

class FuturisticNavBar extends StatelessWidget {
  final NavItem currentIndex;
  final Function(NavItem) onTap;
  
  const FuturisticNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    // Responsive sizing
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth < 600;
    final margin = isSmallScreen ? 12.0 : isMediumScreen ? 16.0 : 20.0;
    final verticalPadding = isSmallScreen ? 6.0 : 8.0;
    final borderRadius = isSmallScreen ? 20.0 : isMediumScreen ? 25.0 : 30.0;
    
    return Container(
      margin: EdgeInsets.only(
        left: margin,
        right: margin,
        bottom: bottomPadding > 0 ? margin / 2 : margin, // Adjust for safe area
      ),
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
            ? [
                AppColors.surfaceDark.withOpacity(0.95),
                AppColors.backgroundDark.withOpacity(0.9),
              ]
            : [
                AppColors.surfaceLight.withOpacity(0.95),
                AppColors.backgroundLight.withOpacity(0.9),
              ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isDark 
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark 
              ? Colors.black.withOpacity(0.4)
              : Colors.black.withOpacity(0.15),
            blurRadius: isSmallScreen ? 15 : 20,
            spreadRadius: 0,
            offset: Offset(0, isSmallScreen ? 5 : 10),
          ),
          BoxShadow(
            color: isDark 
              ? Colors.white.withOpacity(0.05)
              : Colors.white.withOpacity(0.8),
            blurRadius: 1,
            spreadRadius: 0,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ColorFilter.mode(
            Colors.white.withOpacity(0.1),
            BlendMode.overlay,
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _NavBarItem(
                    icon: Iconsax.home,
                    activeIcon: Iconsax.home_15,
                    label: 'Home',
                    isActive: currentIndex == NavItem.home,
                    onTap: () => onTap(NavItem.home),
                    isSmallScreen: isSmallScreen,
                  ),
                ),
                Expanded(
                  child: _NavBarItem(
                    icon: Iconsax.clock,
                    activeIcon: Iconsax.clock5,
                    label: 'History',
                    isActive: currentIndex == NavItem.history,
                    onTap: () => onTap(NavItem.history),
                    isSmallScreen: isSmallScreen,
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: _ScanButton(
                      isActive: currentIndex == NavItem.scan,
                      onTap: () => onTap(NavItem.scan),
                      isSmallScreen: isSmallScreen,
                    ),
                  ),
                ),
                Expanded(
                  child: _NavBarItem(
                    icon: Iconsax.user,
                    activeIcon: Iconsax.profile_circle,
                    label: 'Profile',
                    isActive: currentIndex == NavItem.profile,
                    onTap: () => onTap(NavItem.profile),
                    isSmallScreen: isSmallScreen,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isSmallScreen;
  
  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isSmallScreen = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconSize = isSmallScreen ? 20.0 : 24.0;
    final horizontalPadding = isSmallScreen ? 8.0 : 12.0;
    final verticalPadding = isSmallScreen ? 8.0 : 12.0;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
        splashColor: AppColors.getPrimaryColor(context).withOpacity(0.2),
        highlightColor: AppColors.getPrimaryColor(context).withOpacity(0.1),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
            gradient: isActive
              ? LinearGradient(
                  colors: [
                    AppColors.getPrimaryColor(context).withOpacity(0.2),
                    AppColors.getAccentColor(context).withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isActive ? activeIcon : icon,
                  key: ValueKey(isActive),
                  size: iconSize,
                  color: isActive 
                    ? AppColors.getPrimaryColor(context)
                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                ),
              ),
              SizedBox(height: isSmallScreen ? 2 : 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: AppTextStyles.navLabel.copyWith(
                  fontSize: isSmallScreen ? 9 : 10,
                  color: isActive 
                    ? AppColors.getPrimaryColor(context)
                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Active indicator dot - always present but transparent when inactive
              Container(
                margin: EdgeInsets.only(top: isSmallScreen ? 2 : 4),
                width: isSmallScreen ? 16 : 20,
                height: 2,
                decoration: BoxDecoration(
                  gradient: isActive 
                    ? LinearGradient(
                        colors: [AppColors.getPrimaryColor(context), AppColors.getAccentColor(context)],
                      )
                    : null,
                  color: isActive ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;
  final bool isSmallScreen;
  
  const _ScanButton({
    required this.isActive,
    required this.onTap,
    this.isSmallScreen = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final buttonSize = isSmallScreen ? 48.0 : 56.0;
    final iconSize = isSmallScreen ? 22.0 : 26.0;
    
    // Get theme-aware colors
    final primaryColor = AppColors.getPrimaryColor(context);
    final accentColor = AppColors.getAccentColor(context);
    
    return Container(
      width: buttonSize + 12, // Fixed outer container
      height: buttonSize + 12, // Fixed outer container
      alignment: Alignment.center, // Center the button
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(buttonSize / 2),
          splashColor: primaryColor.withOpacity(0.3),
          highlightColor: primaryColor.withOpacity(0.1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isActive
                  ? [primaryColor, accentColor]
                  : [
                      primaryColor.withOpacity(0.9),
                      accentColor.withOpacity(0.7),
                    ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(isActive ? 0.4 : 0.3),
                  blurRadius: isActive ? 12 : 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isActive ? Iconsax.scanning : Iconsax.scan,
                  key: ValueKey(isActive),
                  size: iconSize,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
