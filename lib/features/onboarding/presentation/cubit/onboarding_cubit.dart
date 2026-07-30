import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haditv/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final CompleteOnboardingUseCase completeOnboardingUseCase;

  OnboardingCubit({required this.completeOnboardingUseCase})
      : super(const OnboardingInitial());

  void onPageChanged(int index) {
    emit(OnboardingPageChanged(index));
  }

  Future<void> completeOnboarding() async {
    await completeOnboardingUseCase.execute();
    emit(const OnboardingCompletedState());
  }
}
