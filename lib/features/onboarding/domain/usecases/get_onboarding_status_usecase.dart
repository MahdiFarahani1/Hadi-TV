import 'package:haditv/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetOnboardingStatusUseCase {
  final OnboardingRepository repository;

  GetOnboardingStatusUseCase(this.repository);

  bool execute() => repository.isOnboardingCompleted();
}
