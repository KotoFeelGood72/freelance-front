import 'package:freelance/providers/faqs_providers.dart';
import 'package:freelance/router/app_router.gr.dart';
import 'package:freelance/src/components/ui/Btn.dart';
import 'package:freelance/src/components/ui/Divider.dart';
import 'package:freelance/src/components/ui/Icons.dart';
import 'package:freelance/src/constants/app_colors.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

@RoutePage()
class ProfileFeedbackScreen extends ConsumerStatefulWidget {
  const ProfileFeedbackScreen({super.key});

  @override
  ConsumerState<ProfileFeedbackScreen> createState() =>
      _ProfileFeedbackScreenState();
}

class _ProfileFeedbackScreenState extends ConsumerState<ProfileFeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  final List<File> _attachedFiles = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSendButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _feedbackController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _feedbackController.removeListener(_onTextChanged);
    _feedbackController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isSendButtonEnabled = _feedbackController.text.isNotEmpty;
    });
  }

  void _pickFile() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _attachedFiles.add(File(pickedFile.path));
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _attachedFiles.removeAt(index);
    });
  }

  void _sendFeedback() async {
    if (_feedbackController.text.isNotEmpty) {
      final filePaths = _attachedFiles.map((file) => file.path).toList();
      try {
        await ref.read(faqsProvider.notifier).createFaq(
              _feedbackController.text,
              filePaths,
            );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Обратная связь отправлена")),
        );

        // Очистка формы после успешной отправки
        _feedbackController.clear();
        setState(() {
          _attachedFiles.clear();
        });
        await AutoRouter.of(context).replace(const ProfileHelpRoute());
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ошибка при отправке обратной связи")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Пожалуйста, введите текст сообщения")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Обратная связь'),
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: AppColors.bg,
            border: Border(top: BorderSide(width: 1, color: AppColors.border))),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _feedbackController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      maxLength: 300,
                      decoration: const InputDecoration(
                        hintText:
                            "Опишите ваше обращение максимально подробно и понятно...",
                        hintStyle: TextStyle(color: AppColors.light),
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  ),
                  const Square(),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _attachedFiles
                        .asMap()
                        .entries
                        .map(
                          (entry) => Stack(
                            children: [
                              ClipOval(
                                child: Image.file(
                                  entry.value,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => _removeFile(entry.key),
                                  child: const CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.red,
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _pickFile,
                        child: Container(
                          child: const IconWidget(
                            iconName: 'clip',
                            color: AppColors.violet,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Btn(
                          text: 'Отправить',
                          theme: 'violet',
                          onPressed:
                              _isSendButtonEnabled ? _sendFeedback : null,
                        ),
                      ),
                    ],
                  ),
                  const Square(
                    height: 32,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
