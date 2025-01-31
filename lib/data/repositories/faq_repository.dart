import 'package:dio/dio.dart';
import 'package:freelance/config/dio_config.dart';

class FaqsRepository {
  Future<dynamic> fetchFaqs() async {
    final response = await DioConfig().dio.get('/faqs/');
    return response.data; // Используйте соответствующую обработку данных
  }

  Future<void> createFaq(String text, List<String> filePaths) async {
    try {
      // Формируем FormData
      final formData = FormData();

      // Добавляем текст
      formData.fields.add(MapEntry('text', text));

      // Добавляем файлы
      for (String path in filePaths) {
        formData.files.add(MapEntry(
          'files',
          await MultipartFile.fromFile(path, filename: path.split('/').last),
        ));
      }

      // Отправляем запрос
      final response = await DioConfig().dio.post(
            '/faqs',
            data: formData,
            options: Options(
              headers: {
                'Content-Type': 'multipart/form-data',
              },
            ),
          );

      // Логируем успех
      print('Успешно отправлено: ${response.data}');
    } catch (e) {
      // Обрабатываем ошибки
      print('Ошибка при отправке: $e');
      rethrow;
    }
  }
}
