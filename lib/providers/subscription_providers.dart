import 'package:freelance/data/repositories/subscription_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionNotifier extends StateNotifier<AsyncValue<dynamic>> {
  final SubscriptionRepository _repository;

  SubscriptionNotifier(this._repository) : super(const AsyncLoading()) {
    _loadInitialData(); // Вызываем оба метода при инициализации
  }

  Future<void> _loadInitialData() async {
    state = const AsyncLoading();
    try {
      final history = await _repository.fetchHistory();
      final plans = await _repository.fetchPlans();
      state = AsyncValue.data({
        'history': history,
        'plans': plans,
      });
    } catch (e, stacktrace) {
      state = AsyncValue.error(e, stacktrace);
    }
  }

  Future<void> loadHistory() async {
    state = const AsyncLoading();
    try {
      final history = await _repository.fetchHistory();
      state = AsyncValue.data({'history': history});
    } catch (e, stacktrace) {
      state = AsyncValue.error(e, stacktrace);
    }
  }

  Future<void> loadPlans() async {
    state = const AsyncLoading();
    try {
      final plans = await _repository.fetchPlans();
      state = AsyncValue.data({'plans': plans});
      print(plans);
    } catch (e, stacktrace) {
      state = AsyncValue.error(e, stacktrace);
    }
  }
}

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepository();
});

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, AsyncValue<dynamic>>((ref) {
  final repository = ref.read(subscriptionRepositoryProvider);

  return SubscriptionNotifier(repository);
});
