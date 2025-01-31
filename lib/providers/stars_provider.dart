import 'package:freelance/src/provider/auth/AuthProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freelance/data/repositories/stars_repository.dart';

class StarsNotifier extends StateNotifier<AsyncValue<dynamic>> {
  final StarsRepository _repository;
  final String _role;

  StarsNotifier(this._repository, this._role) : super(const AsyncLoading());

  Future<void> loadStars() async {
    state = const AsyncLoading();
    try {
      final stars = await _repository.fetchStars(role: _role);
      state = AsyncValue.data(stars);
    } catch (e, stacktrace) {
      state = AsyncValue.error(e, stacktrace);
    }
  }
}

final starsRepositoryProvider = Provider<StarsRepository>((ref) {
  return StarsRepository();
});

final starsProvider =
    StateNotifierProvider<StarsNotifier, AsyncValue<dynamic>>((ref) {
  final repository = ref.read(starsRepositoryProvider);
  final authState = ref.watch(authProvider);

  // Получаем роль пользователя из authProvider
  final role = authState.role ?? 'unknown';

  return StarsNotifier(repository, role)..loadStars();
});
