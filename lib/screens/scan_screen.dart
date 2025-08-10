import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import '../providers/theme_provider.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  bool _isScanning = false;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void _startScanning() {
    setState(() {
      _isScanning = !_isScanning;
    });
    
    if (_isScanning) {
      _animationController.repeat(reverse: true);
    } else {
      _animationController.stop();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Text(
                'Scan & Analyze',
                style: AppTextStyles.h2.copyWith(
                  color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Point your camera at any object',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Scanner View
              _buildScannerView(context, isDark),
              
              const SizedBox(height: 40),
              
              // Scan Controls
              _buildScanControls(context, isDark),
              
              const SizedBox(height: 30),
              
              // Quick Actions
              _buildQuickActions(context, isDark),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildScannerView(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
            ? [
                AppColors.backgroundDark,
                AppColors.surfaceDark,
              ]
            : [
                AppColors.backgroundLight,
                AppColors.surfaceLight,
              ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _isScanning
            ? AppColors.getPrimaryColor(context)
            : isDark
                ? Colors.white.withOpacity(0.2)
                : Colors.black.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _isScanning
              ? AppColors.getPrimaryColor(context).withOpacity(0.3)
              : Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: _isScanning ? 4 : 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Scanner Grid
          if (_isScanning) _buildScannerGrid(context),
          
          // Center Focus Area
          Center(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isScanning ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _isScanning
                          ? AppColors.getPrimaryColor(context)
                          : AppColors.getAccentColor(context).withOpacity(0.5),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        // Corner indicators
                        ...List.generate(4, (index) {
                          return Positioned(
                            top: index < 2 ? 0 : null,
                            bottom: index >= 2 ? 0 : null,
                            left: index % 2 == 0 ? 0 : null,
                            right: index % 2 == 1 ? 0 : null,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: _isScanning
                                  ? AppColors.getPrimaryColor(context)
                                  : AppColors.getAccentColor(context),
                                borderRadius: BorderRadius.only(
                                  topLeft: index == 0 ? const Radius.circular(8) : Radius.zero,
                                  topRight: index == 1 ? const Radius.circular(8) : Radius.zero,
                                  bottomLeft: index == 2 ? const Radius.circular(8) : Radius.zero,
                                  bottomRight: index == 3 ? const Radius.circular(8) : Radius.zero,
                                ),
                              ),
                            ),
                          );
                        }),
                        
                        // Center icon
                        Center(
                          child: Icon(
                            _isScanning ? Iconsax.scan5 : Iconsax.scan,
                            color: _isScanning
                              ? AppColors.getPrimaryColor(context)
                              : isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Status Text
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _isScanning
                    ? AppColors.getPrimaryColor(context).withOpacity(0.9)
                    : isDark
                        ? Colors.black.withOpacity(0.7)
                        : Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isScanning
                      ? Colors.white.withOpacity(0.3)
                      : Colors.transparent,
                  ),
                ),
                child: Text(
                  _isScanning ? 'Scanning...' : 'Ready to scan',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: _isScanning
                      ? Colors.white
                      : isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildScannerGrid(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 300),
      painter: ScannerGridPainter(gridColor: AppColors.getPrimaryColor(context)),
    );
  }
  
  Widget _buildScanControls(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Flash Toggle
        _buildControlButton(
          context: context,
          icon: Iconsax.flash,
          label: 'Flash',
          isActive: false,
          onTap: () {
            // Toggle flash
          },
          isDark: isDark,
        ),
        
        // Main Scan Button
        GestureDetector(
          onTap: _startScanning,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isScanning
                  ? [AppColors.error, AppColors.error.withOpacity(0.8)]
                  : [AppColors.getPrimaryColor(context), AppColors.getAccentColor(context)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (_isScanning ? AppColors.error : AppColors.getPrimaryColor(context))
                      .withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              _isScanning ? Iconsax.stop : Iconsax.scan,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        
        // Gallery Button
        _buildControlButton(
          context: context,
          icon: Iconsax.gallery,
          label: 'Gallery',
          isActive: false,
          onTap: () {
            // Open gallery
          },
          isDark: isDark,
        ),
      ],
    );
  }
  
  Widget _buildControlButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isActive
                ? AppColors.getPrimaryColor(context).withOpacity(0.2)
                : isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive
                  ? AppColors.getPrimaryColor(context)
                  : isDark
                      ? Colors.white.withOpacity(0.2)
                      : Colors.black.withOpacity(0.1),
              ),
            ),
            child: Icon(
              icon,
              color: isActive
                ? AppColors.getPrimaryColor(context)
                : isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              size: 24,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: isActive
                ? AppColors.primary
                : isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickActions(BuildContext context, bool isDark) {
    final actions = [
      {'icon': Iconsax.scan, 'title': 'QR Code', 'subtitle': 'Scan QR codes'},
      {'icon': Iconsax.document, 'title': 'Document', 'subtitle': 'Extract text'},
      {'icon': Iconsax.image, 'title': 'Image', 'subtitle': 'Analyze objects'},
      {'icon': Iconsax.barcode, 'title': 'Barcode', 'subtitle': 'Product info'},
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scan Types',
          style: AppTextStyles.h4.copyWith(
            color: isDark
              ? AppColors.textPrimaryDark
              : AppColors.textPrimaryLight,
          ),
        ),
        
        const SizedBox(height: 16),
        
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return _buildActionCard(
              context: context,
              icon: action['icon'] as IconData,
              title: action['title'] as String,
              subtitle: action['subtitle'] as String,
              isDark: isDark,
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
  }) {
    return Container(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.getPrimaryColor(context).withOpacity(0.2),
                  AppColors.getAccentColor(context).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.getPrimaryColor(context),
              size: 24,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 4),
          
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ScannerGridPainter extends CustomPainter {
  final Color gridColor;
  
  ScannerGridPainter({required this.gridColor});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor.withOpacity(0.3)
      ..strokeWidth = 1;
    
    const spacing = 20.0;
    
    // Draw vertical lines
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
