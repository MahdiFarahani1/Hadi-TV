import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/core/di/injection.dart';
import 'package:haditv/core/utils/extension.dart';
import 'package:haditv/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:haditv/gen/assets.gen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'cubit/onboarding_cubit.dart';
import 'cubit/onboarding_state.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(
        completeOnboardingUseCase: getIt<CompleteOnboardingUseCase>(),
      ),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late final PageController _pageController;

  List<_OnboardingItem> _getSlides(BuildContext context) => [
        _OnboardingItem(
          badge: context.tr('onboarding_badge_1'),
          title: context.tr('onboarding_title_1'),
          subtitle: context.tr('onboarding_sub_1'),
          image: Assets.images.ramadanKareemBro,
        ),
        _OnboardingItem(
          badge: context.tr('onboarding_badge_2'),
          title: context.tr('onboarding_title_2'),
          subtitle: context.tr('onboarding_sub_2'),
          image: Assets.images.videoFilesAmico,
        ),
        _OnboardingItem(
          badge: context.tr('onboarding_badge_3'),
          title: context.tr('onboarding_title_3'),
          subtitle: context.tr('onboarding_sub_3'),
          image: Assets.images.onlineArticleRafiki1,
        ),
      ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext(BuildContext context, int currentIndex) {
    if (currentIndex < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      context.read<OnboardingCubit>().completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompletedState) {
          context.go('/home');
        }
      },
      child: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          final slides = _getSlides(context);
          final isLastPage = state.pageIndex == slides.length - 1;

          return Scaffold(
            body: Stack(
              children: [
                // ── Ambient Glowing Background ────────────────────────────────
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF0F172A),
                                Color(0xFF1E293B),
                                Color(0xFF0F172A),
                              ],
                            )
                          : const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFFFFFF),
                                Color(0xFFF8FAFC),
                                Color(0xFFF1F5F9),
                              ],
                            ),
                    ),
                  ),
                ),

                // Ambient glow circle accent
                Positioned(
                  top: -60,
                  right: -40,
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryColor.withValues(
                        alpha: isDark ? 0.18 : 0.1,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: -80,
                  left: -60,
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryColor.withValues(
                        alpha: isDark ? 0.12 : 0.06,
                      ),
                    ),
                  ),
                ),

                // ── Main SafeArea Content ────────────────────────────────────
                SafeArea(
                  child: Column(
                    children: [
                      // ── Top Bar ──────────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Logo & App Name
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.primaryColor,
                                        AppTheme.primaryColor.withValues(
                                          alpha: 0.4,
                                        ),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      color: isDark
                                          ? const Color(0xFF0F172A)
                                          : Colors.white,
                                      padding: const EdgeInsets.all(4),
                                      child: Assets.images.coHaditv512.image(
                                        width: 26,
                                        height: 26,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Hadi TV',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: context.textPrimary,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ],
                            ),

                            // Skip Button
                            if (!isLastPage)
                              ZoomTapAnimation(
                                onTap: () => context
                                    .read<OnboardingCubit>()
                                    .completeOnboarding(),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.08)
                                        : Colors.black.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.1)
                                          : Colors.black.withValues(
                                              alpha: 0.06,
                                            ),
                                    ),
                                  ),
                                  child: Text(
                                    context.tr('skip'),
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: context.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // ── PageView ──────────────────────────────────────────
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: slides.length,
                          onPageChanged: (index) {
                            context.read<OnboardingCubit>().onPageChanged(
                              index,
                            );
                          },
                          itemBuilder: (context, index) {
                            final item = slides[index];
                            return _OnboardingSlideWidget(
                              item: item,
                              isDark: isDark,
                            );
                          },
                        ),
                      ),

                      // ── Bottom Navigation & Indicator Controls ───────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Animated Page Indicator Dots
                            SmoothPageIndicator(
                              controller: _pageController,
                              count: slides.length,
                              effect: const WormEffect(
                                dotWidth: 10,
                                dotHeight: 10,
                              ),
                            ),
                            // Next / Get Started Button
                            ZoomTapAnimation(
                              onTap: () => _onNext(context, state.pageIndex),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: EdgeInsets.symmetric(
                                  horizontal: isLastPage ? 24 : 20,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppTheme.primaryColor,
                                      AppTheme.primaryLight,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryColor.withValues(
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      isLastPage
                                          ? context.tr('get_started')
                                          : context.tr('next'),
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      isLastPage
                                          ? Icons.check_circle_rounded
                                          : Icons.arrow_forward_rounded,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                  ],
                                ),
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

// ─────────────────────────────────────────────────────────────────────────────

class _OnboardingSlideWidget extends StatelessWidget {
  final _OnboardingItem item;
  final bool isDark;

  const _OnboardingSlideWidget({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration Image with Glass Card Backdrop
          Container(
            height: context.screenHeight * 0.38,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.03)
                  : Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.05),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: item.image
                  .image(fit: BoxFit.contain)
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1.0, 1.0),
                  ),
            ),
          ),

          const SizedBox(height: 32),

          // Category Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              item.badge,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: AppTheme.primaryColor,
                letterSpacing: 1.2,
              ),
            ),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0),

          const SizedBox(height: 14),

          // Slide Title
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: context.textPrimary,
              letterSpacing: -0.4,
              height: 1.2,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

          const SizedBox(height: 12),

          // Slide Subtitle
          Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: context.textSecondary,
              height: 1.5,
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}

class _OnboardingItem {
  final String badge;
  final String title;
  final String subtitle;
  final AssetGenImage image;

  const _OnboardingItem({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.image,
  });
}
