import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color initialPrimaryColor;
  final Color initialAccentColor;
  final Function(Color primary, Color accent) onColorsSelected;
  
  const ColorPickerDialog({
    super.key,
    required this.initialPrimaryColor,
    required this.initialAccentColor,
    required this.onColorsSelected,
  });

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Color _selectedPrimaryColor;
  late Color _selectedAccentColor;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedPrimaryColor = widget.initialPrimaryColor;
    _selectedAccentColor = widget.initialAccentColor;
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 350,
        height: 500,
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
            color: isDark 
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.5 : 0.2),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _selectedPrimaryColor.withOpacity(0.1),
                    _selectedAccentColor.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Choose Custom Colors',
                      style: AppTextStyles.h4.copyWith(
                        color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.close,
                        color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Tab Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [_selectedPrimaryColor, _selectedAccentColor],
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
                labelStyle: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'Primary'),
                  Tab(text: 'Accent'),
                ],
              ),
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Primary Color Picker
                  _buildColorPicker(
                    currentColor: _selectedPrimaryColor,
                    onColorChanged: (color) {
                      setState(() {
                        _selectedPrimaryColor = color;
                      });
                    },
                  ),
                  
                  // Accent Color Picker
                  _buildColorPicker(
                    currentColor: _selectedAccentColor,
                    onColorChanged: (color) {
                      setState(() {
                        _selectedAccentColor = color;
                      });
                    },
                  ),
                ],
              ),
            ),
            
            // Preview Section
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _selectedPrimaryColor.withOpacity(0.2),
                    _selectedAccentColor.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _selectedPrimaryColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _selectedPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _selectedAccentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Preview',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: _selectedPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Action Buttons
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: _selectedPrimaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.buttonText.copyWith(
                          color: _selectedPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onColorsSelected(
                          _selectedPrimaryColor,
                          _selectedAccentColor,
                        );
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedPrimaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Apply',
                        style: AppTextStyles.buttonText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildColorPicker({
    required Color currentColor,
    required Function(Color) onColorChanged,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Color Wheel
          ColorPicker(
            pickerColor: currentColor,
            onColorChanged: onColorChanged,
            showLabel: false,
            pickerAreaHeightPercent: 0.7,
            enableAlpha: false,
            displayThumbColor: true,
            colorPickerWidth: 280,
            pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          
          const SizedBox(height: 16),
          
          // Predefined Colors
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const Color(0xFF6C5CE7),
              const Color(0xFF00D4AA),
              const Color(0xFFFF6B6B),
              const Color(0xFFFEBB00),
              const Color(0xFF00E676),
              const Color(0xFF03A9F4),
              const Color(0xFFE91E63),
              const Color(0xFF9C27B0),
              const Color(0xFF673AB7),
              const Color(0xFF3F51B5),
              const Color(0xFF2196F3),
              const Color(0xFF00BCD4),
              const Color(0xFF009688),
              const Color(0xFF4CAF50),
              const Color(0xFF8BC34A),
              const Color(0xFFCDDC39),
              const Color(0xFFFFEB3B),
              const Color(0xFFFFC107),
              const Color(0xFFFF9800),
              const Color(0xFFFF5722),
            ].map((color) => GestureDetector(
              onTap: () => onColorChanged(color),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: currentColor == color 
                      ? Colors.white 
                      : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
