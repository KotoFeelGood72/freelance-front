import 'package:freelance/router/app_router.gr.dart';
import 'package:freelance/src/components/ui/Divider.dart';
import 'package:freelance/src/layouts/empty_layout.dart';
import 'package:freelance/src/components/ui/Btn.dart';
import 'package:freelance/src/constants/app_colors.dart';
import 'package:freelance/src/provider/auth/AuthProvider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ConfirmScreen extends ConsumerWidget {
  const ConfirmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    // Проверяем, есть ли ошибка, связанная с неверным кодом
    final bool hasOtpError =
        authState.error != null && authState.error!.contains('Неверный код');

    return EmptyLayout(
      title: 'Ввод кода',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Поля для ввода OTP кода
            OtpTextField(
              filled: true,
              fillColor: AppColors.ulight,
              numberOfFields: 4,
              borderColor: hasOtpError ? Colors.red : AppColors.border,
              borderWidth: 1,
              focusedBorderColor: hasOtpError ? Colors.red : AppColors.violet,
              showFieldAsBox: true,
              fieldWidth: 70,
              fieldHeight: 48,
              onSubmit: (code) async {
                if (code.length == 4) {
                  await authNotifier.verifyCode(code);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Введите полный код!')),
                  );
                }
              },
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            const SizedBox(height: 12),
            // Сообщение об ошибке
            if (hasOtpError)
              Text(
                authState.error ?? 'Произошла ошибка',
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 12),
            // Таймер для запроса нового кода
            Text(
              'Вы сможете запросить код через ${authNotifier.remainingSeconds} секунд',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            // Кнопка для повторной отправки кода
            Btn(
              disabled: authNotifier.remainingSeconds > 0,
              text: 'Выслать код ещё раз',
              theme: 'violet',
              onPressed: authNotifier.remainingSeconds > 0
                  ? null
                  : authNotifier.resendCode,
            ),
          ],
        ),
      ),
    );
  }
}
