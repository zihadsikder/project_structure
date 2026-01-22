import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../utils/constants/app_colors.dart';

/// A primary button for authentication screens with enhanced animations.
///
/// Features:
/// - 56px height
/// - Pill shape (28px border radius)
/// - Press animation (scale to 0.96)
/// - Ripple effect
/// - Shine animation on hover/tap
/// - Loading state support
/// - Staggered fade-in and slide-up animations
class AuthPrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final int animationIndex;

  const AuthPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.animationIndex = 0,
  });

  @override
  State<AuthPrimaryButton> createState() => _AuthPrimaryButtonState();
}

class _AuthPrimaryButtonState extends State<AuthPrimaryButton>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // Press animation - more dramatic scale effect
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeInOut,
      ),
    );

    // Fade-in animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Slide-up animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOutBack,
      ),
    );

    // Shimmer effect animation
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _shimmerController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Delay based on animation index for staggered effect
    Future.delayed(Duration(milliseconds: 80 * widget.animationIndex), () {
      if (mounted) {
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _pressController.dispose();
    _fadeController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isLoading && widget.onPressed != null) {
      _pressController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _pressController.reverse();
  }

  void _onTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onTap: widget.isLoading ? null : widget.onPressed,
          child: AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, child) {
              return ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: widget.onPressed != null
                          ? [
                        AppColors.authButtonPrimary,
                        AppColors.authButtonPrimary.withValues(alpha: 0.95),
                      ]
                          : [
                        AppColors.authButtonPrimary.withValues(alpha: 0.5),
                        AppColors.authButtonPrimary.withValues(alpha: 0.5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    // Blurry border effect using multiple box shadows
                    border: Border.all(
                      color: AppColors.jasmine.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      // Outer blurry glow
                      BoxShadow(
                        color: AppColors.jasmine.withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 0),
                      ),
                      // Inner blurry border effect
                      BoxShadow(
                        color: AppColors.jasmine.withValues(alpha: 0.2),
                        blurRadius: 15,
                        spreadRadius: -2,
                        offset: const Offset(0, 0),
                      ),
                      // Standard shadow for depth
                      BoxShadow(
                        color: widget.onPressed != null
                            ? AppColors.authButtonPrimary.withValues(alpha: 0.4)
                            : AppColors.authButtonPrimary.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                        spreadRadius: widget.onPressed != null ? 1 : 0,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Shimmer effect overlay
                      if (widget.onPressed != null && !widget.isLoading)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Opacity(
                              opacity: 0.1,
                              child: Transform.translate(
                                offset: Offset(_shimmerAnimation.value * 200, 0),
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.transparent,
                                        AppColors.cream.withValues(alpha: 0.8),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      // Button content
                      Center(
                        child: widget.isLoading
                            ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.textWhite,
                            ),
                          ),
                        )
                            : Text(
                          widget.text,
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
