import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haditv/core/di/injection.dart';
import 'package:haditv/core/utils/extension.dart';
import 'package:haditv/features/onboarding/domain/usecases/get_onboarding_status_usecase.dart';
import 'package:haditv/gen/assets.gen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      final isCompleted = getIt<GetOnboardingStatusUseCase>().execute();
      if (isCompleted) {
        context.go('/home');
      } else {
        context.go('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: context.screenWidth,
        height: context.screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(Assets.images.splashHtv.path),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            LoadingAnimationWidget.staggeredDotsWave(
              color: context.accentBlue,
              size: 25,
            ),
            SizedBox(height: context.screenHeight * 0.065),
          ],
        ),
      ),
    );
  }
}
