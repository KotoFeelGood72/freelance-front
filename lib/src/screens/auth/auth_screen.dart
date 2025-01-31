import 'package:freelance/router/app_router.gr.dart';
import 'package:freelance/src/components/ui/Btn.dart';
import 'package:freelance/src/components/ui/Divider.dart';
import 'package:freelance/src/components/ui/Inputs.dart';
import 'package:freelance/src/constants/app_colors.dart';
import 'package:freelance/src/layouts/empty_layout.dart';
import 'package:freelance/src/provider/auth/AuthProvider.dart';
import 'package:freelance/src/utils/clean_phone.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freelance/config/token_storage.dart';

final signInControllerProvider = Provider<MaskedTextController>(
    (ref) => MaskedTextController(mask: '+7 (000) 000-00-00'));

final isButtonEnabledProvider = StateProvider<bool>((_) => false);

// 🔹 Асинхронный провайдер для получения и сохранения deviceToken
final deviceTokenProvider = FutureProvider<void>((ref) async {
  String? role = await TokenStorage.getRole();

  if (role != null) {
    final deviceToken = await FirebaseMessaging.instance.getToken();
    if (deviceToken != null) {
      await TokenStorage.saveDeviceToken(role, deviceToken);
      print("Saved Device Token for $role: $deviceToken");
    }
  }
});

@RoutePage()
class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInController = ref.watch(signInControllerProvider);
    final isButtonEnabled = ref.watch(isButtonEnabledProvider);
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    // 🔹 Запускаем сохранение deviceToken при рендере экрана
    ref.watch(deviceTokenProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.error != null) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(next.error!)),
        // );
      }

      if (next.codeSent && previous?.codeSent != true) {
        AutoRouter.of(context).push(const ConfirmRoute());
      }
    });

    return EmptyLayout(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Inputs(
              controller: signInController,
              backgroundColor: AppColors.ulight,
              textColor: Colors.black,
              errorMessage: 'Поле обязательно для заполнения',
              fieldType: 'phone',
              onChanged: (value) {
                final isEnabled = value.length == 18; // Длина полного номера
                ref.read(isButtonEnabledProvider.notifier).state = isEnabled;
              },
            ),
            const Square(),
            if (authState.isLoading)
              const CircularProgressIndicator()
            else
              SizedBox(
                width: double.infinity,
                child: Btn(
                  text: 'Выслать код',
                  onPressed: isButtonEnabled
                      ? () {
                          final phoneNumber = CleanPhone.cleanPhoneNumber(
                              signInController.text);
                          authNotifier.setPhoneNumber(phoneNumber);
                          authNotifier.requestCode();
                        }
                      : null,
                  theme: 'violet',
                  disabled: !isButtonEnabled,
                ),
              ),
          ],
        ),
      ),
      title: 'Вход',
    );
  }
}
