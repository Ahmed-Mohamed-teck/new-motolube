import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:newmotorlube/features/user_cars/presentation/widget/user_car_list_item.dart';
import 'package:newmotorlube/features/user_cars/provider/user_cars_provider.dart';
import 'package:newmotorlube/features/user_cars/presentation/view_model/user_cars_state.dart';

class BookServiceScreen extends ConsumerStatefulWidget {
  const BookServiceScreen({super.key});

  @override
  ConsumerState<BookServiceScreen> createState() => _HorizontalStepperScreenState();
}

class _HorizontalStepperScreenState extends ConsumerState<BookServiceScreen> {
  int _currentStep = 0;
  int? _selectedCar;
  int? _selectedService;
  LatLng? _selectedLocation;
  final MapController _mapController = MapController();

  // Cars are now provided by userCarsViewModelProvider

  final List<String> _services = [
    'Basic Services',
    'Major Services',
    'Car Repair',
    'Batteries',
    'Car Wash',
  ];

  List<Widget> get _stepContents => [
        _buildCarStep(),
        _buildServiceStep(),
        _buildLocationStep(),
        const Center(child: Text('Step 4 Content', style: TextStyle(fontSize: 20))),
      ];

  void _goToNext() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _goToPrevious() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Widget _buildCarStep() {
    // Use the shared user cars ViewModel
    return Consumer(builder: (context, ref, _) {
      final state = ref.watch(userCarsViewModelProvider);

      if (state is UserCarsInitial) {
        Future.microtask(
            () => ref.read(userCarsViewModelProvider.notifier).fetchUserCars());
      }

      if (state is UserCarsLoading || state is UserCarsInitial) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is UserCarsLoaded) {
        final cars = state.cars;
        if (cars.isEmpty) {
          return const Center(child: Text('No cars found'));
        }
        return ListView.separated(
          itemCount: cars.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final car = cars[index];
            final isSelected = _selectedCar == index;
            final imageUrl = car.carImages.isNotEmpty ? car.carImages.first : '';
            final model = '${car.manufacturer} ${car.modelYear}'.trim();
            final plate = car.englishPlate.join();
            final chassis = car.vinNumber;

            return GestureDetector(
              onTap: () => setState(() => _selectedCar = index),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.amber : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CarCard(
                  car: CarInfo(
                    imageUrl: imageUrl,
                    model: model,
                    plate: plate,
                    chassis: chassis,
                  ),
                  heroTag: 'maint-car-${car.vehicleId}-$index',
                ),
              ),
            );
          },
        );
      } else if (state is UserCarsError) {
        return Center(
          child: Text(
            state.message,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.error),
          ),
        );
      }

      return const SizedBox.shrink();
    });
  }

  Widget _buildServiceStep() {
    return ListView.separated(
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final isSelected = _selectedService == index;
        return Card(
          color: isSelected ? Colors.amber[100] : null,
          child: ListTile(
            title: Text(_services[index]),
            subtitle: const Text('17 SAR'),
            leading: Icon(
              Icons.build_circle,
              color: isSelected ? Colors.amber : Colors.grey[600],
              size: 40,
            ),
            onTap: () => setState(() => _selectedService = index),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
    );
  }

  Widget _buildLocationStep() {
    final markers = <Marker>[
      if (_selectedLocation != null)
        Marker(
          point: _selectedLocation!,
          width: 40,
          height: 40,
          child: const Icon(
            Icons.location_pin,
            size: 40,
            color: Colors.red,
          ),
        ),
    ];

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _selectedLocation ?? const LatLng(24.7136, 46.6753),
            initialZoom: 13,
            onTap: (tapPos, latlng) => setState(() => _selectedLocation = latlng),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              // Use the real applicationId to avoid OSM tile server blocks
              userAgentPackageName: 'com.example.newmotorlube',
            ),
            MarkerLayer(markers: markers),
          ],
        ),
        Positioned(
          top: 16,
          right: 16,
          child: FloatingActionButton.small(
            onPressed: _requestCurrentLocation,
            child: const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }

  Future<void> _requestCurrentLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      final allow = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Location Permission'),
          content: const Text(
              'We need your location to show it on the map.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Deny'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Allow'),
            ),
          ],
        ),
      );
      if (allow != true) {
        return;
      }
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
    }

    final position = await Geolocator.getCurrentPosition();
    final latlng = LatLng(position.latitude, position.longitude);
    setState(() => _selectedLocation = latlng);
    _mapController.move(latlng, 15);
  }

  @override
  Widget build(BuildContext context) {
    final steps = _stepContents;
    final isLast = _currentStep == steps.length - 1;
    final isFirst = _currentStep == 0;

    return Scaffold(
      body: Column(
        children: [
          // Horizontal Step Indicator
          SizedBox(
            height: 72,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(steps.length, (index) {
                final isActive = index == _currentStep;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: isActive ? 18 : 14,
                      backgroundColor: isActive ? Colors.amber : Colors.grey[400],
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Step ${index + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),

          const Divider(thickness: 1),

          // Step Content
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
              child: Container(
                key: ValueKey<int>(_currentStep),
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                child: steps[_currentStep],
              ),
            ),
          ),

          // Buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isFirst)
                    OutlinedButton(
                      onPressed: _goToPrevious,
                      child: const Text('Back'),
                    ),
                  ElevatedButton(
                    onPressed: isLast ? null : _goToNext,
                    child: Text(isLast ? 'Done' : 'Next'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
