import 'dart:io';

import 'package:freelance/providers/user_providers.dart';
import 'package:freelance/router/app_router.gr.dart';
import 'package:freelance/src/components/ui/Btn.dart';
import 'package:freelance/src/components/ui/Inputs.dart';
import 'package:freelance/src/constants/app_colors.dart';
import 'package:freelance/src/utils/clean_phone.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  // Контроллеры для ввода данных
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final MaskedTextController phoneController =
      MaskedTextController(mask: '+7 (000) 000-00-00');
  final TextEditingController aboutMySelfController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<String?> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image.path; // Возвращаем путь к выбранному изображению
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактирование'),
      ),
      body: userState.when(
        data: (user) {
          // Заполняем контроллеры значениями из состояния
          firstNameController.text = user.firstName ?? '';
          lastNameController.text = user.lastName ?? '';
          phoneController.text = user.phoneNumber ?? '';
          aboutMySelfController.text = user.aboutMySelf ?? '';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                SizedBox(
                  width: 50,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.yellow,
                        backgroundImage: _getImageProvider(user.photo ?? ''),
                      ),
                      // Кнопка удаления
                      Positioned(
                        top: 0,
                        right: 120,
                        child: GestureDetector(
                          onTap: () {
                            userNotifier.updateUser(
                              user.copyWith(photo: ''),
                            );
                          },
                          child: const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        right: 120,
                        child: GestureDetector(
                          onTap: () async {
                            final updatedPhoto = await _pickImage();
                            if (updatedPhoto != null) {
                              userNotifier.updateUser(
                                user.copyWith(photo: updatedPhoto),
                              );
                            }
                          },
                          child: const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Inputs(
                  controller: firstNameController,
                  backgroundColor: AppColors.ulight,
                  textColor: Colors.black,
                  label: 'Имя',
                  required: true,
                ),
                const SizedBox(height: 16),
                Inputs(
                  controller: lastNameController,
                  backgroundColor: AppColors.ulight,
                  textColor: Colors.black,
                  label: 'Фамилия',
                  required: true,
                ),
                const SizedBox(height: 16),
                Inputs(
                  controller: phoneController,
                  backgroundColor: AppColors.ulight,
                  textColor: Colors.black,
                  label: 'Телефон',
                  fieldType: 'phone',
                ),
                const SizedBox(height: 16),
                Inputs(
                  controller: aboutMySelfController,
                  backgroundColor: AppColors.ulight,
                  textColor: Colors.black,
                  label: 'О себе',
                  isMultiline: true,
                ),
                const SizedBox(height: 40),
                Btn(
                  text: 'Подтвердить',
                  onPressed: () async {
                    final cleanedPhoneNumber =
                        CleanPhone.cleanPhoneNumber(phoneController.text);
                    userNotifier.updateUser(
                      user.copyWith(
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        phoneNumber: cleanedPhoneNumber,
                        aboutMySelf: aboutMySelfController.text,
                      ),
                    );
                    await AutoRouter.of(context)
                        .replaceAll([const TaskRoute()]);
                  },
                  theme: 'violet',
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Ошибка: $error'),
        ),
      ),
    );
  }

  _getImageProvider(String imageUrl) {
    if (imageUrl.isNotEmpty &&
        Uri.tryParse(imageUrl)?.hasAbsolutePath == true) {
      return NetworkImage(imageUrl);
    } else {
      return const AssetImage('assets/images/splash.png'); // Заглушка
    }
  }
}
