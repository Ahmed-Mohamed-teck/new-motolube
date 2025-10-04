import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:newmotorlube/features/auth/provider/auth_provider.dart';
import 'package:newmotorlube/features/book_service/presentation/view_model/service_packages_state.dart';
import 'package:newmotorlube/features/book_service/provider/book_service_provider.dart';
import 'package:newmotorlube/features/book_service/domain/entity/service_package_entity.dart';
import 'package:newmotorlube/features/user_cars/domain/entity/car_entity.dart';
import 'package:newmotorlube/features/user_cars/presentation/widget/user_car_list_item.dart';
import 'package:newmotorlube/features/user_cars/provider/user_cars_provider.dart';
import 'package:newmotorlube/features/user_cars/presentation/view_model/user_cars_state.dart';
import 'package:newmotorlube/features/technician/provider/technician_provider.dart';
import 'package:newmotorlube/features/technician/presentation/view_model/technician_search_state.dart';
import 'package:newmotorlube/features/technician/presentation/view_model/technician_slots_state.dart';
import 'package:newmotorlube/features/technician/domain/entity/technician_slot_entity.dart';
import 'package:newmotorlube/features/technician/domain/entity/technician_summary_entity.dart';

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
  ServicePackageEntity? _selectedPackage;
  CarEntity? _selectedCarEntity;
  String? _customerId;
  LatLng? _selectedLocation;
  TechnicianSummaryEntity? _selectedTechnician;
  TechnicianSlotEntity? _selectedSlot;
  DateTime _selectedSlotDate = DateTime.now();
  final MapController _mapController = MapController();
  static const int _maxTechnicianResults = 20;
  static const double _searchRadiusKm = 25;

  // Cars are now provided by userCarsViewModelProvider

  List<Widget> get _stepContents => [
    _buildCarStep(),
    _buildServiceStep(),
    _buildLocationStep(),
    _buildTechnicianStep(),
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

  Future<void> _fetchTechniciansForSelection() async {
    final location = _selectedLocation;
    final package = _selectedPackage;
    if (location == null || package == null) {
      return;
    }
    final serviceId = _resolveServiceId(package);
    if (serviceId.isEmpty) {
      return;
    }
    await ref
        .read(technicianSearchViewModelProvider.notifier)
        .search(
          latitude: location.latitude,
          longitude: location.longitude,
          serviceId: serviceId,
          maxResults: _maxTechnicianResults,
          radiusKm: _searchRadiusKm,
        );
  }

  Future<void> _retryTechnicianSearch() {
    return _fetchTechniciansForSelection();
  }

  void _resetTechnicianSearch() {
    ref.read(technicianSearchViewModelProvider.notifier).reset();
    ref.read(technicianSlotsViewModelProvider.notifier).reset();
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedTechnician = null;
      _selectedSlot = null;
    });
  }

  void _handleLocationSelection(LatLng latlng) {
    setState(() => _selectedLocation = latlng);
    _resetTechnicianSearch();
  }

  String _formatDateForApi(DateTime date) {
    final formatter = DateFormat('dd-MMM-yyyy');
    return formatter.format(date).toUpperCase();
  }

  String _formatDateForDisplay(DateTime date) {
    return DateFormat('EEE, dd MMM yyyy').format(date);
  }

  void _fetchSlotsForTechnician({String? technicianId}) {
    final targetTechnicianId = technicianId ?? _selectedTechnician?.techId;
    if (targetTechnicianId == null || targetTechnicianId.isEmpty) {
      return;
    }
    final formattedDate = _formatDateForApi(_selectedSlotDate);
    ref
        .read(technicianSlotsViewModelProvider.notifier)
        .fetch(technicianId: targetTechnicianId, date: formattedDate);
  }

  void _onTechnicianSelected(TechnicianSummaryEntity technician) {
    setState(() {
      _selectedTechnician = technician;
      _selectedSlot = null;
    });
    _fetchSlotsForTechnician(technicianId: technician.techId);
  }

  void _onSlotSelected(TechnicianSlotEntity slot) {
    setState(() {
      _selectedSlot = slot;
    });
  }

  Future<void> _pickSlotDate() async {
    final now = DateTime.now();
    final initialDate =
        _selectedSlotDate.isBefore(now) ? now : _selectedSlotDate;
    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (selected != null) {
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedSlotDate = selected;
        _selectedSlot = null;
      });
      _fetchSlotsForTechnician();
    }
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
        _selectedPackage = null;
      });
      await ref
          .read(servicePackagesViewModelProvider.notifier)
          .fetchPackages(
            customerId: customerId,
            vehicleId: _selectedCarEntity!.vehicleId,
          );
      return;
    }

    if (_currentStep == 1) {
      if (_selectedPackage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a service package before continuing.'),
          ),
        );
        return;
      }
      setState(() {
        _currentStep++;
      });
      return;
    }

    if (_currentStep == 2) {
      if (_selectedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please choose a location on the map before continuing.',
            ),
          ),
        );
        return;
      }
      setState(() {
        _currentStep++;
      });
      await _fetchTechniciansForSelection();
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
                    _selectedPackage = null;
                  });
                  ref.read(servicePackagesViewModelProvider.notifier).reset();
                  _resetTechnicianSearch();
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
                  _selectedPackage = package;
                });
                _resetTechnicianSearch();
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
            onTap: (tapPos, latlng) => _handleLocationSelection(latlng),
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
          left: 16,
          right: 16,
          bottom: 24,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _selectedLocation == null
                    ? 'Tap anywhere on the map to select a service location.'
                    : 'Selected location: (${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)})',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
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

  Widget _buildTechnicianStep() {
    final searchState = ref.watch(technicianSearchViewModelProvider);
    final hasPrerequisites =
        _selectedLocation != null && _selectedPackage != null;

    if (!hasPrerequisites) {
      return const Center(
        child: Text(
          'Select a service package and location to discover nearby technicians.',
          textAlign: TextAlign.center,
        ),
      );
    }

    final location = _selectedLocation!;
    final selectedPackage = _selectedPackage!;

    final header = Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Searching within ${_searchRadiusKm.toStringAsFixed(0)} km of '
            '(${location.latitude.toStringAsFixed(6)}, '
            '${location.longitude.toStringAsFixed(6)})',
          ),
          const SizedBox(height: 4),
          Text(
            'Service: ${selectedPackage.packageNameEn.isNotEmpty ? selectedPackage.packageNameEn : selectedPackage.packageNameAr}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );

    Widget buildBody(Widget child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [header, const SizedBox(height: 12), Expanded(child: child)],
      );
    }

    if (searchState is TechnicianSearchLoading) {
      return buildBody(const Center(child: CircularProgressIndicator()));
    }

    if (searchState is TechnicianSearchError) {
      return buildBody(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Could not load technicians.\n${searchState.message}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _retryTechnicianSearch,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (searchState is TechnicianSearchEmpty) {
      return buildBody(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No technicians were found within the selected radius.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _retryTechnicianSearch,
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    if (searchState is TechnicianSearchLoaded) {
      return buildBody(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildTechnicianGrid(searchState.technicians)),
            const SizedBox(height: 16),
            _buildTechnicianSlotsSection(),
          ],
        ),
      );
    }

    return buildBody(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Ready to find technicians near your chosen location?',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _retryTechnicianSearch,
            child: const Text('Search Technicians'),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicianGrid(List<TechnicianSummaryEntity> technicians) {
    return RefreshIndicator(
      onRefresh: _retryTechnicianSearch,
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 16, top: 8, left: 4, right: 4),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: technicians.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.78,
        ),
        itemBuilder: (context, index) {
          final technician = technicians[index];
          final isSelected = _selectedTechnician?.techId == technician.techId;
          return _buildTechnicianCard(
            technician,
            isSelected: isSelected,
            onTap: () => _onTechnicianSelected(technician),
          );
        },
      ),
    );
  }

  Widget _buildTechnicianCard(
    TechnicianSummaryEntity technician, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final distance = technician.calculatedDistance;
    final rating = technician.rating;
    final primaryName =
        technician.techNameEn.isNotEmpty
            ? technician.techNameEn
            : technician.techNameAr;
    final secondaryName =
        technician.techNameEn.isNotEmpty
            ? technician.techNameAr
            : technician.techNameEn;
    final photoUrl = technician.techPhotoUrl.trim();
    final hasPhoto = photoUrl.isNotEmpty;

    return Card(
      elevation: isSelected ? 4 : 2,
      color: isSelected ? Colors.amber.shade50 : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? Colors.amber : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage:
                        hasPhoto
                            ? NetworkImage(photoUrl) as ImageProvider
                            : null,
                    backgroundColor: Colors.grey.shade200,
                    child:
                        hasPhoto
                            ? null
                            : const Icon(Icons.person, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      primaryName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle, color: Colors.amber),
                ],
              ),
              const SizedBox(height: 12),
              if (secondaryName.isNotEmpty && secondaryName != primaryName)
                Text(
                  secondaryName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                ),
              const Spacer(),
              if (distance != null)
                Row(
                  children: [
                    const Icon(Icons.place, size: 18, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${distance.toStringAsFixed(distance >= 10 ? 0 : 1)} km away',
                    ),
                  ],
                ),
              if (rating != null)
                Row(
                  children: [
                    const Icon(Icons.star, size: 18, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(rating.toStringAsFixed(1)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTechnicianSlotsSection() {
    final technician = _selectedTechnician;
    final slotsState = ref.watch(technicianSlotsViewModelProvider);

    if (technician == null) {
      return const Text('Tap a technician to see their available time slots.');
    }

    bool matchesCurrentTech(String technicianId) =>
        technician.techId == technicianId;

    Widget content;
    if (slotsState is TechnicianSlotsInitial) {
      content = const Text(
        'Tap a technician to see their available time slots.',
      );
    } else if (slotsState is TechnicianSlotsLoading) {
      content =
          matchesCurrentTech(slotsState.technicianId)
              ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              )
              : const SizedBox.shrink();
    } else if (slotsState is TechnicianSlotsLoaded) {
      content =
          matchesCurrentTech(slotsState.technicianId)
              ? _buildSlotChips(slotsState.slots)
              : const SizedBox.shrink();
    } else if (slotsState is TechnicianSlotsEmpty) {
      content =
          matchesCurrentTech(slotsState.technicianId)
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('No slots available for the selected date.'),
                  TextButton(
                    onPressed: _fetchSlotsForTechnician,
                    child: const Text('Refresh'),
                  ),
                ],
              )
              : const SizedBox.shrink();
    } else if (slotsState is TechnicianSlotsError) {
      content =
          matchesCurrentTech(slotsState.technicianId)
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Could not load slots.\n${slotsState.message}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  TextButton(
                    onPressed: _fetchSlotsForTechnician,
                    child: const Text('Try Again'),
                  ),
                ],
              )
              : const SizedBox.shrink();
    } else {
      content = const SizedBox.shrink();
    }

    final displayName =
        technician.techNameEn.isNotEmpty
            ? technician.techNameEn
            : technician.techNameAr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Available slots for $displayName',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextButton.icon(
              onPressed: _pickSlotDate,
              icon: const Icon(Icons.calendar_today, size: 18),
              label: Text(_formatDateForDisplay(_selectedSlotDate)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildSlotChips(List<TechnicianSlotEntity> slots) {
    if (slots.isEmpty) {
      return const Text('No slots available for the selected date.');
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            slots.map((slot) {
              final label = _slotLabel(slot);
              final isSelected = _isSlotSelected(slot);
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(label),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      _onSlotSelected(slot);
                    }
                  },
                ),
              );
            }).toList(),
      ),
    );
  }

  bool _isSlotSelected(TechnicianSlotEntity slot) {
    final current = _selectedSlot;
    if (current == null) {
      return false;
    }
    if (current.slotTime?.isNotEmpty == true &&
        slot.slotTime?.isNotEmpty == true) {
      if (current.slotTime == slot.slotTime) {
        return true;
      }
    }
    if (current.slotId.isNotEmpty && slot.slotId.isNotEmpty) {
      return current.slotId == slot.slotId;
    }
    return current.label == slot.label;
  }

  String _slotLabel(TechnicianSlotEntity slot) {
    final slotTime = slot.slotTime?.trim();
    if (slotTime != null && slotTime.isNotEmpty) {
      return slotTime;
    }
    final start = slot.startTime?.trim();
    final end = slot.endTime?.trim();
    if (start != null && start.isNotEmpty && end != null && end.isNotEmpty) {
      return '$start - $end';
    }
    if (start != null && start.isNotEmpty) {
      return start;
    }
    if (end != null && end.isNotEmpty) {
      return end;
    }
    return slot.label;
  }

  String _resolveServiceId(ServicePackageEntity package) {
    final primary = package.packageId.trim();
    if (primary.isNotEmpty) {
      return primary;
    }
    final fallback = package.packageCode.trim();
    if (fallback.isNotEmpty) {
      return fallback;
    }
    return '';
  }

  String? _resolveServiceName(Map<String, dynamic> raw) {
    const keys = [
      'serviceNameEn',
      'serviceNameAr',
      'serviceName',
      'packageNameEn',
      'packageNameAr',
      'packageName',
      'description',
    ];
    for (final key in keys) {
      final value = raw[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
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
    _handleLocationSelection(latlng);
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
