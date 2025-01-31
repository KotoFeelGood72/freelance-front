import 'package:freelance/data/repositories/faq_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FaqsNotifier extends StateNotifier<AsyncValue<dynamic>> {
  final FaqsRepository _repository;

  FaqsNotifier(this._repository) : super(const AsyncLoading());

  Future<void> loadFaqs() async {
    state = const AsyncLoading();
    try {
      final faqs = await _repository.fetchFaqs();
      state = AsyncValue.data(faqs);
    } catch (e, stacktrace) {
      state = AsyncValue.error(e, stacktrace);
    }
  }

  Future<void> createFaq(String text, List<String> filePaths) async {
    try {
      await _repository.createFaq(text, filePaths);
    } catch (e, stacktrace) {
      state = AsyncValue.error(e, stacktrace);
    }
  }
}

final faqsRepositoryProvider = Provider<FaqsRepository>((ref) {
  return FaqsRepository();
});

final faqsProvider =
    StateNotifierProvider<FaqsNotifier, AsyncValue<dynamic>>((ref) {
  final repository = ref.read(faqsRepositoryProvider);

  return FaqsNotifier(repository)..loadFaqs();
});
