import 'package:freelance/router/app_router.gr.dart';
import 'package:freelance/src/components/ui/Btn.dart';
import 'package:freelance/src/components/ui/Divider.dart';
import 'package:freelance/src/components/ui/Inputs.dart';
import 'package:freelance/src/components/ui/location_picker.dart';
import 'package:freelance/src/components/ui/pick_date.dart';

import 'package:freelance/src/constants/app_colors.dart';
import 'package:freelance/src/provider/consumer/TaskNotifier.dart';
import 'package:freelance/src/utils/task_confirmation.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

@RoutePage()
class NewTaskCreateScreen extends ConsumerStatefulWidget {
  const NewTaskCreateScreen({super.key});

  @override
  _NewTaskCreateScreenState createState() => _NewTaskCreateScreenState();
}

class _NewTaskCreateScreenState extends ConsumerState<NewTaskCreateScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  LatLng? _selectedLocation;
  String? _selectedAddress;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Устанавливаем текущую дату
      final initialDate = DateTime.now();
      setState(() {
        _selectedDate = initialDate;
      });
      ref.read(taskNotifierProvider.notifier).updateTaskTerm(initialDate);

      // Получаем текущую локацию
      await _getCurrentLocation();
    });

    _nameController.addListener(() {
      ref
          .read(taskNotifierProvider.notifier)
          .updateTaskName(_nameController.text);
    });

    _priceController.addListener(() {
      final price = int.tryParse(_priceController.text) ?? 0;
      ref.read(taskNotifierProvider.notifier).updateTaskPrice(price);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Проверяем включение службы геолокации
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Служба геолокации отключена")),
      );
      return;
    }

    // Проверяем разрешения
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Разрешение на геолокацию отклонено")),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Геолокация заблокирована")),
      );
      return;
    }

    // Получаем текущую позицию
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    LatLng currentLocation = LatLng(position.latitude, position.longitude);

    setState(() {
      _selectedLocation = currentLocation;
    });

    // Получаем адрес по координатам
    await _getAddressFromLatLng(currentLocation);
  }

  Future<void> _getAddressFromLatLng(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        final address = "${place.street}, ${place.locality}";
        setState(() {
          _selectedAddress = address;
        });
        ref.read(taskNotifierProvider.notifier).updateTaskCity(address);
      }
    } catch (e) {
      setState(() {
        _selectedAddress = "Ошибка определения адреса";
      });
    }
  }

  void _openLocationPicker() async {
    final initialLocation = _selectedLocation ??
        const LatLng(55.7558, 37.6173); // Москва по умолчанию
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LocationPickerMap(
          initialLocation: initialLocation,
          onLocationSelected: (LatLng location, String address) {
            setState(() {
              _selectedLocation = location;
              _selectedAddress = address;
            });
            ref.read(taskNotifierProvider.notifier).updateTaskCity(address);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showExitConfirmation(context);
        return shouldExit;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.bg,
          title: const Text(
            "Новое задание",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Consumer(
          builder: (context, ref, child) {
            final taskState = ref.watch(taskNotifierProvider);

            if (taskState.errorMessage != null && !taskState.isErrorShown) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (ScaffoldMessenger.of(context).mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(taskState.errorMessage!)),
                  );
                  ref.read(taskNotifierProvider.notifier).clearError();
                }
              });
            }

            return Container(
              color: AppColors.bg,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Поле для имени
                    Inputs(
                      controller: _nameController,
                      backgroundColor: AppColors.ulight,
                      textColor: AppColors.gray,
                      label: 'Название',
                      required: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 16,
                      ),
                    ),
                    const Square(),

                    // Поле для стоимости
                    Inputs(
                      controller: _priceController,
                      backgroundColor: AppColors.ulight,
                      textColor: AppColors.gray,
                      label: 'Стоимость',
                      fieldType: 'number',
                      maxLength: 9,
                      required: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 16,
                      ),
                    ),
                    const Square(),

                    // Выбор даты
                    PickDate(
                      initialDate: taskState.taskTerm ??
                          DateTime.now(), // Берем дату из состояния
                      onDatePicked: (DateTime date) {
                        ref
                            .read(taskNotifierProvider.notifier)
                            .updateTaskTerm(date); // Обновляем состояние
                      },
                    ),
                    const Square(),

                    // Локация
                    const Text("Локация", style: TextStyle(fontSize: 16)),
                    const Square(height: 8),
                    GestureDetector(
                      onTap: _openLocationPicker,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.ulight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedAddress ?? "Определение адреса...",
                              style: const TextStyle(
                                color: AppColors.gray,
                                fontSize: 16,
                              ),
                            ),
                            const Icon(
                              Icons.map_outlined,
                              color: AppColors.gray,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Square(),

                    // Кнопка продолжения
                    SizedBox(
                      width: double.infinity,
                      child: Btn(
                        text: 'Продолжить',
                        onPressed: () {
                          ref
                              .read(taskNotifierProvider.notifier)
                              .validateTaskForm();
                          final currentState = ref.read(taskNotifierProvider);

                          if (currentState.isValid) {
                            AutoRouter.of(context).push(const NewDescRoute());
                          }
                        },
                        theme: 'violet',
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
