import 'package:freelance/data/repositories/user_repository.dart';
import 'package:freelance/src/models/UserModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<AsyncValue<Users>> {
  final UserRepository _repository;

  UserNotifier(this._repository) : super(const AsyncLoading());

  Future<void> loadUser() async {
    state = const AsyncLoading();
    try {
      final user = await _repository.fetchUser();
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateUser(Users updatedUser) async {
    try {
      await _repository.updateUser(updatedUser);

      await loadUser();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> loadUserCustomer(String profileCustomerId) async {
    state = const AsyncLoading();
    try {
      final user = await _repository.fetchUserById(profileCustomerId);
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<Users>>((ref) {
  final repository = UserRepository();
  return UserNotifier(repository)..loadUser();
});
