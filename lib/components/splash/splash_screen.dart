import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'animated_3d_model.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onSplashComplete;
  
  const SplashScreen({
    super.key,
    required this.onSplashComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _textController;
  late Animation<double> _backgroundAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _backgroundAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
    
    _startBackgroundAnimation();
  }
  
  void _startBackgroundAnimation() async {
    _backgroundController.forward();
    await Future.delayed(const Duration(milliseconds: 1000));
    _textController.forward();
  }
  
  @override
  void dispose() {
    _backgroundController.dispose();
    _textController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.getPrimaryColor(context).withOpacity(0.8 + 0.2 * _backgroundAnimation.value),
                  AppColors.getAccentColor(context).withOpacity(0.6 + 0.4 * _backgroundAnimation.value),
                  AppColors.getPrimaryColor(context).withOpacity(0.9),
                ],
                stops: [
                  0.0,
                  0.5 + 0.3 * _backgroundAnimation.value,
                  1.0,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Animated background particles
                ...List.generate(isSmallScreen ? 15 : 20, (index) {
                  return AnimatedBuilder(
                    animation: _backgroundController,
                    builder: (context, child) {
                      final progress = _backgroundAnimation.value;
                      final x = (index * 50.0) % screenSize.width;
                      final y = (index * 80.0) % screenSize.height;
                      
                      return Positioned(
                        left: x + 50 * progress * (index % 2 == 0 ? 1 : -1),
                        top: y + 30 * progress * (index % 3 == 0 ? 1 : -1),
                        child: Opacity(
                          opacity: 0.1 + 0.2 * progress,
                          child: Container(
                            width: 4 + 6 * progress,
                            height: 4 + 6 * progress,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
                
                // Main content
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 3D Animated Model
                      Animated3DModel(
                        onAnimationComplete: widget.onSplashComplete,
                      ),
                      
                      SizedBox(height: isSmallScreen ? 30 : 40),
                      
                      // Animated App Name
                      FadeTransition(
                        opacity: _textController,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.3),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: _textController,
                            curve: Curves.easeOut,
                          )),
                          child: Column(
                            children: [
                              AnimatedTextKit(
                                animatedTexts: [
                                  TyperAnimatedText(
                                    'AzizApp',
                                    textStyle: (isSmallScreen 
                                      ? AppTextStyles.h2 
                                      : AppTextStyles.h1).copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    speed: const Duration(milliseconds: 100),
                                  ),
                                ],
                                repeatForever: false,
                              ),
                              
                              const SizedBox(height: 8),
                              
                              AnimatedTextKit(
                                animatedTexts: [
                                  FadeAnimatedText(
                                    'Future is here',
                                    textStyle: (isSmallScreen 
                                      ? AppTextStyles.bodyMedium 
                                      : AppTextStyles.bodyLarge).copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                      letterSpacing: 2,
                                    ),
                                    duration: const Duration(milliseconds: 1200),
                                  ),
                                ],
                                repeatForever: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      SizedBox(height: isSmallScreen ? 40 : 60),
                      
                      // Loading indicator
                      FadeTransition(
                        opacity: _textController,
                        child: Column(
                          children: [
                            SizedBox(
                              width: isSmallScreen ? 30 : 40,
                              height: isSmallScreen ? 30 : 40,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white.withOpacity(0.8),
                                ),
                                strokeWidth: 3,
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 12 : 16),
                            Text(
                              'Loading...',
                              style: (isSmallScreen 
                                ? AppTextStyles.bodySmall 
                                : AppTextStyles.bodyMedium).copyWith(
                                color: Colors.white.withOpacity(0.7),
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
