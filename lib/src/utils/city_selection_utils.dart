import 'package:freelance/src/constants/app_colors.dart';
import 'package:flutter/material.dart';

Future<void> showCitySelectionModal({
  required BuildContext context,
  required List<String> cities,
  required String? selectedCity,
  required Function(String) onCitySelected,
}) async {
  await showModalBottomSheet(
    backgroundColor: Colors.white, // Можно заменить на вашу кастомную тему
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Wrap(
          children: cities.map((city) {
            int index = cities.indexOf(city);
            bool isActive =
                city == selectedCity; // Проверяем, активен ли элемент
            return Container(
              decoration: BoxDecoration(
                border: index == cities.length - 1
                    ? null // Убираем border у последнего элемента
                    : Border(
                        bottom: BorderSide(
                          color: isActive
                              ? AppColors.violet
                              : AppColors.gray, // Цвет границы
                          width: 0.5, // Толщина границы
                        ),
                      ),
              ),
              child: ListTile(
                title: Text(
                  city,
                  style: TextStyle(
                    color: isActive
                        ? AppColors.violet
                        : AppColors.black, // Цвет текста для активного элемента
                    fontWeight: isActive
                        ? FontWeight.bold
                        : FontWeight.normal, // Выделение активного текста
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onCitySelected(
                      city); // Вызываем callback для выбранного города
                },
              ),
            );
          }).toList(),
        ),
      );
    },
  );
}
