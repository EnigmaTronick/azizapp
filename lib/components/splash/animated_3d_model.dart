import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'dart:math' as math;

class Animated3DModel extends StatefulWidget {
  final VoidCallback? onAnimationComplete;
  
  const Animated3DModel({
    super.key,
    this.onAnimationComplete,
  });

  @override
  State<Animated3DModel> createState() => _Animated3DModelState();
}

class _Animated3DModelState extends State<Animated3DModel>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  Object? mesh;
  Scene? scene;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Create animations
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: math.pi * 4, // 2 full rotations
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOutCubic,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
    
    _startAnimations();
  }
  
  void _startAnimations() async {
    // Start fade in
    _fadeController.forward();
    
    // Wait a bit then start scale and rotation
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();
    _rotationController.forward();
    
    // Complete after 5 seconds
    await Future.delayed(const Duration(seconds: 4));
    
    // Fade out
    await _fadeController.reverse();
    
    if (widget.onAnimationComplete != null) {
      widget.onAnimationComplete!();
    }
  }
  
  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
  
  Widget _buildCustom3DModel() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _rotationAnimation,
        _scaleAnimation,
        _fadeAnimation,
      ]),
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateY(_rotationAnimation.value)
                ..rotateX(_rotationAnimation.value * 0.3),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF6C5CE7),
                      const Color(0xFF00D4AA),
                      const Color(0xFF6C5CE7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C5CE7).withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 10,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Inner geometric shape
                    Center(
                      child: Transform.rotate(
                        angle: _rotationAnimation.value * 2,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Transform.rotate(
                              angle: -_rotationAnimation.value * 1.5,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.flutter_dash,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Floating particles effect
                    ...List.generate(8, (index) {
                      final angle = (index * math.pi * 2 / 8) + _rotationAnimation.value;
                      final radius = 80 + (20 * math.sin(_rotationAnimation.value * 2));
                      return Positioned(
                        left: 100 + math.cos(angle) * radius,
                        top: 100 + math.sin(angle) * radius,
                        child: Transform.scale(
                          scale: 0.5 + 0.5 * math.sin(_rotationAnimation.value * 3 + index),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: _buildCustom3DModel(),
    );
  }
}
