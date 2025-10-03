import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:newmotorlube/features/auth/provider/auth_provider.dart';
import 'package:newmotorlube/features/book_service/presentation/view_model/service_packages_state.dart';
import 'package:newmotorlube/features/book_service/provider/book_service_provider.dart';
import 'package:newmotorlube/features/user_cars/domain/entity/car_entity.dart';
import 'package:newmotorlube/features/user_cars/presentation/widget/user_car_list_item.dart';
import 'package:newmotorlube/features/user_cars/provider/user_cars_provider.dart';
import 'package:newmotorlube/features/user_cars/presentation/view_model/user_cars_state.dart';

class BookServiceScreen extends ConsumerStatefulWidget {
  const BookServiceScreen({super.key});

  @override
  ConsumerState<BookServiceScreen> createState() =>
      _HorizontalStepperScreenState();
}

class _HorizontalStepperScreenState extends ConsumerState<BookServiceScreen> {
  int _currentStep = 0;
  int? _selectedCar;
  int? _selectedService;
  CarEntity? _selectedCarEntity;
  String? _customerId;
  LatLng? _selectedLocation;
  final MapController _mapController = MapController();

  // Cars are now provided by userCarsViewModelProvider

  List<Widget> get _stepContents => [
    _buildCarStep(),
    _buildServiceStep(),
    _buildLocationStep(),
    const Center(child: Text('Step 4 Content', style: TextStyle(fontSize: 20))),
  ];

  Future<String?> _ensureCustomerId() async {
    if (_customerId != null && _customerId!.isNotEmpty) {
      return _customerId;
    }
    final storedAuth =
        await ref.read(authLocalRepositoryProvider).getStoredAuth();
    final id = storedAuth?.oracleId ?? '';
    if (id.isEmpty) {
      if (!mounted) {
        return null;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to determine customer information.'),
        ),
      );
      return null;
    }
    _customerId = id;
    return id;
  }

  Future<void> _fetchPackagesForSelectedCar() async {
    final car = _selectedCarEntity;
    if (car == null) {
      return;
    }
    final customerId = await _ensureCustomerId();
    if (customerId == null) {
      return;
    }
    await ref
        .read(servicePackagesViewModelProvider.notifier)
        .fetchPackages(customerId: customerId, vehicleId: car.vehicleId);
  }

  Future<void> _goToNext() async {
    if (_currentStep == 0) {
      if (_selectedCarEntity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a car before continuing.'),
          ),
        );
        return;
      }
      final customerId = await _ensureCustomerId();
      if (customerId == null) {
        return;
      }
      setState(() {
        _currentStep++;
        _selectedService = null;
      });
      await ref
          .read(servicePackagesViewModelProvider.notifier)
          .fetchPackages(
            customerId: customerId,
            vehicleId: _selectedCarEntity!.vehicleId,
          );
      return;
    }

    if (_currentStep < _stepContents.length - 1) {
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
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(userCarsViewModelProvider);

        if (state is UserCarsInitial) {
          Future.microtask(
            () => ref.read(userCarsViewModelProvider.notifier).fetchUserCars(),
          );
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
              final imageUrl =
                  car.carImages.isNotEmpty ? car.carImages.first : '';
              final model = '${car.manufacturer} ${car.modelYear}'.trim();
              final plate = car.englishPlate.join();
              final chassis = car.vinNumber;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCar = index;
                    _selectedCarEntity = car;
                    _selectedService = null;
                  });
                  ref.read(servicePackagesViewModelProvider.notifier).reset();
                },
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildServiceStep() {
    final packagesState = ref.watch(servicePackagesViewModelProvider);

    if (_selectedCarEntity == null) {
      return const Center(
        child: Text(
          'Please select a car in Step 1 to view available packages.',
        ),
      );
    }

    if (packagesState is ServicePackagesInitial ||
        packagesState is ServicePackagesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (packagesState is ServicePackagesError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Failed to load packages.\n${packagesState.message}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                _fetchPackagesForSelectedCar();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (packagesState is ServicePackagesEmpty) {
      return const Center(
        child: Text('No packages available for the selected vehicle.'),
      );
    }

    if (packagesState is ServicePackagesLoaded) {
      final packages = packagesState.packages;

      return ListView.separated(
        itemCount: packages.length,
        itemBuilder: (context, index) {
          final package = packages[index];
          final isSelected = _selectedService == index;
          final price = package.linePrice;
          final rounded = price.roundToDouble();
          final displayPrice =
              price == rounded
                  ? rounded.toStringAsFixed(0)
                  : price.toStringAsFixed(2);
          final title =
              package.packageNameEn.isNotEmpty
                  ? package.packageNameEn
                  : package.packageNameAr;

          return Card(
            color: isSelected ? Colors.amber[100] : null,
            child: ListTile(
              title: Text(title),
              subtitle: Text('$displayPrice SAR'),
              leading: Icon(
                Icons.build_circle,
                color: isSelected ? Colors.amber : Colors.grey[600],
                size: 40,
              ),
              trailing:
                  package.isEmergency
                      ? const Icon(Icons.warning, color: Colors.red)
                      : null,
              onTap: () {
                setState(() {
                  _selectedService = index;
                });
              },
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
      );
    }

    return const Center(child: Text('Packages will load once you continue.'));
  }

  Widget _buildLocationStep() {
    final markers = <Marker>[
      if (_selectedLocation != null)
        Marker(
          point: _selectedLocation!,
          width: 40,
          height: 40,
          child: const Icon(Icons.location_pin, size: 40, color: Colors.red),
        ),
    ];

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _selectedLocation ?? const LatLng(24.7136, 46.6753),
            initialZoom: 13,
            onTap:
                (tapPos, latlng) => setState(() => _selectedLocation = latlng),
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
        builder:
            (context) => AlertDialog(
              title: const Text('Location Permission'),
              content: const Text(
                'We need your location to show it on the map.',
              ),
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
                      backgroundColor:
                          isActive ? Colors.amber : Colors.grey[400],
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Step ${index + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.normal,
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
              transitionBuilder:
                  (child, anim) => FadeTransition(opacity: anim, child: child),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isFirst)
                    OutlinedButton(
                      onPressed: _goToPrevious,
                      child: const Text('Back'),
                    ),
                  ElevatedButton(
                    onPressed:
                        isLast
                            ? null
                            : () {
                              _goToNext();
                            },
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
