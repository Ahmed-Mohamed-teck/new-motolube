import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:newmotorlube/core/providers/global_lang_provider.dart';
import 'package:newmotorlube/core/widget/error_widget.dart';
import 'package:newmotorlube/core/widget/login_prompt_card.dart';
import 'package:newmotorlube/features/auth/provider/auth_provider.dart';
import 'package:newmotorlube/features/book_service/domain/entity/create_appointment_result.dart';
import 'package:newmotorlube/features/book_service/presentation/view_model/service_packages_state.dart';
import 'package:newmotorlube/features/book_service/provider/book_service_provider.dart';
import 'package:newmotorlube/features/book_service/domain/entity/service_package_entity.dart';
import 'package:newmotorlube/features/user_cars/domain/entity/car_entity.dart';
import 'package:newmotorlube/features/user_cars/presentation/widget/user_cars_empty_state.dart';
import 'package:newmotorlube/features/user_cars/presentation/widget/user_car_list_item.dart';
import 'package:newmotorlube/features/user_cars/provider/user_cars_provider.dart';
import 'package:newmotorlube/features/user_cars/presentation/view_model/user_cars_state.dart';
import 'package:newmotorlube/features/home/presentaion/screen/base_home_screen.dart';
import 'package:newmotorlube/features/auth/presentation/view_model/auth_state.dart';
import 'package:newmotorlube/features/home/domain/entity/main_category_entity.dart';
import 'package:newmotorlube/features/home/provider/home_provider.dart';
import 'package:newmotorlube/features/technician/provider/technician_provider.dart';
import 'package:newmotorlube/features/technician/presentation/view_model/technician_search_state.dart';
import 'package:newmotorlube/features/technician/presentation/view_model/technician_slots_state.dart';
import 'package:newmotorlube/features/technician/domain/entity/technician_slot_entity.dart';
import 'package:newmotorlube/features/technician/domain/entity/technician_summary_entity.dart';
import 'package:newmotorlube/features/upcoming_service/provider/upcoming_service_provider.dart';
import 'package:newmotorlube/generated/l10n.dart';
import 'package:newmotorlube/main.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../home/provider/home_provider.dart' as home;

class BookServiceScreen extends ConsumerStatefulWidget {
  const BookServiceScreen({super.key});

  @override
  ConsumerState<BookServiceScreen> createState() =>
      _HorizontalStepperScreenState();
}

class _CarStepSkeletonList extends StatelessWidget {
  const _CarStepSkeletonList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const _CarStepSkeleton(),
    );
  }
}

class _CarStepSkeleton extends StatelessWidget {
  const _CarStepSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.surfaceVariant.withOpacity(0.5);

    return Skeletonizer(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Skeleton.leaf(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: baseColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeleton.leaf(
                      child: Container(
                        height: 14,
                        width: double.infinity,
                        color: baseColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Skeleton.leaf(
                      child: Container(
                        height: 12,
                        width: 140,
                        color: baseColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Skeleton.leaf(
                      child: Container(
                        height: 12,
                        width: 110,
                        color: baseColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Skeleton.leaf(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: baseColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServicePackagesSkeletonList extends StatelessWidget {
  const _ServicePackagesSkeletonList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const _ServicePackageSkeleton(),
    );
  }
}

class _ServicePackageSkeleton extends StatelessWidget {
  const _ServicePackageSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.surfaceVariant.withOpacity(0.5);

    return Skeletonizer(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: Skeleton.leaf(
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: baseColor,
              ),
            ),
          ),
          title: Skeleton.leaf(
            child: Container(
              height: 14,
              width: double.infinity,
              color: baseColor,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Skeleton.leaf(
                  child: Container(height: 12, width: 160, color: baseColor),
                ),
                const SizedBox(height: 8),
                Skeleton.leaf(
                  child: Container(height: 12, width: 90, color: baseColor),
                ),
              ],
            ),
          ),
          trailing: Skeleton.leaf(
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: baseColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TechnicianGridSkeleton extends StatelessWidget {
  const _TechnicianGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 16, top: 8, left: 4, right: 4),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.78,
      ),
      itemCount: 4,
      itemBuilder: (_, __) => const _TechnicianCardSkeleton(),
    );
  }
}

class _TechnicianCardSkeleton extends StatelessWidget {
  const _TechnicianCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.surfaceVariant.withOpacity(0.5);

    return Skeletonizer(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Skeleton.leaf(
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: baseColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Skeleton.leaf(
                          child: Container(
                            height: 14,
                            width: double.infinity,
                            color: baseColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Skeleton.leaf(
                          child: Container(
                            height: 12,
                            width: 100,
                            color: baseColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Skeleton.leaf(
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: baseColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Skeleton.leaf(
                child: Container(
                  height: 12,
                  width: double.infinity,
                  color: baseColor,
                ),
              ),
              const SizedBox(height: 8),
              Skeleton.leaf(
                child: Container(height: 12, width: 140, color: baseColor),
              ),
              const Spacer(),
              Row(
                children: [
                  Skeleton.leaf(
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: baseColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Skeleton.leaf(
                    child: Container(height: 12, width: 80, color: baseColor),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Skeleton.leaf(
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: baseColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Skeleton.leaf(
                    child: Container(height: 12, width: 56, color: baseColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlotChipsSkeleton extends StatelessWidget {
  const _SlotChipsSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.surfaceVariant.withOpacity(0.5);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Skeletonizer(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(5, (index) {
              final width = 60 + (index * 12);
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Chip(
                  label: Skeleton.leaf(
                    child: Container(
                      width: width.toDouble(),
                      height: 16,
                      color: baseColor,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _HorizontalStepperScreenState extends ConsumerState<BookServiceScreen> {
  int _currentStep = 0;
  int? _selectedCar;
  int? _selectedService;
  ServicePackageEntity? _selectedPackage;
  CarEntity? _selectedCarEntity;
  MainCategoryEntity? _selectedMainCategory;
  String? _customerId;
  LatLng? _selectedLocation;
  TechnicianSummaryEntity? _selectedTechnician;
  TechnicianSlotEntity? _selectedSlot;
  DateTime _selectedSlotDate = DateTime.now();
  bool _isBooking = false;
  bool _didLoadInitialCategory = false;
  final MapController _mapController = MapController();
  static const int _maxTechnicianResults = 20;
  static const double _searchRadiusKm = 25;

  @override
  void initState() {
    super.initState();

    final preselected = ref.read(preselectedBookServiceCarProvider);
    if (preselected != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _applyPreselectedCar(preselected);
        ref.read(preselectedBookServiceCarProvider.notifier).state = null;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLoadInitialCategory) {
      return;
    }
    _didLoadInitialCategory = true;

    MainCategoryEntity? incomingCategory;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['selectedCategory'] is MainCategoryEntity) {
      incomingCategory = args['selectedCategory'] as MainCategoryEntity;
    }

    incomingCategory ??= ref.read(selectedMainCategoryProvider);

    if (incomingCategory != null) {
      setState(() {
        _selectedMainCategory = incomingCategory;
      });
    }
  }

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
        SnackBar(
          content: Text(S.of(context).bookServiceCustomerInfoUnavailable),
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
        .fetchPackages(
          customerId: customerId,
          vehicleId: car.vehicleId,
          category: _categoryQueryValue(),
        );
  }

  String? _categoryQueryValue() {
    final category = _selectedMainCategory;
    if (category == null) return null;
    final id = category.id.trim();
    if (id.isNotEmpty) return id;
    final titleEn = category.titleEn.trim();
    if (titleEn.isNotEmpty) return titleEn;
    final titleAr = category.titleAr.trim();
    if (titleAr.isNotEmpty) return titleAr;
    return null;
  }

  Widget _wrapWithCategoryBanner(BuildContext context, Widget child) {
    final banner = _buildCategoryBanner(context);
    if (banner == null) {
      return child;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        banner,
        const SizedBox(height: 8),
        Expanded(child: child),
      ],
    );
  }

  Widget? _buildCategoryBanner(BuildContext context) {
    final l10n = S.of(context);
    // _selectedMainCategory = ref.watch(selectedMainCategoryProvider);
    ref.listen(selectedMainCategoryProvider, (_,nex) {
      setState(() {
        _selectedMainCategory = nex;
      });
      _fetchPackagesForSelectedCar();
    });
    final category = _selectedMainCategory;
    if (category == null) return null;
    final label =
        category.titleForLocale(Localizations.localeOf(context)).trim();
    if (label.isEmpty) return null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.category_outlined,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.bookServiceSelectedCategory(label),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: _clearSelectedCategory,
            icon: const Icon(Icons.close),
            label: Text(l10n.bookServiceReset),
          ),
        ],
      ),
    );
  }

  Future<void> _clearSelectedCategory() async {
    ref.read(home.selectedMainCategoryProvider.notifier).state = null;
    setState(() {
      _selectedMainCategory = null;
    });
    await _fetchPackagesForSelectedCar();
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

  void _resetBookingFlow() {
    ref.read(servicePackagesViewModelProvider.notifier).reset();
    ref.read(technicianSearchViewModelProvider.notifier).reset();
    ref.read(technicianSlotsViewModelProvider.notifier).reset();
    if (!mounted) {
      return;
    }
    setState(() {
      _currentStep = 0;
      _selectedCar = null;
      _selectedService = null;
      _selectedPackage = null;
      _selectedCarEntity = null;
      _selectedLocation = null;
      _selectedTechnician = null;
      _selectedSlot = null;
      _selectedSlotDate = DateTime.now();
    });
  }

  void _applyPreselectedCar(CarEntity car) {
    ref.read(servicePackagesViewModelProvider.notifier).reset();
    ref.read(technicianSearchViewModelProvider.notifier).reset();
    ref.read(technicianSlotsViewModelProvider.notifier).reset();
    setState(() {
      _selectedCarEntity = car;
      _selectedCar = null; // Sync with index once cars load.
      _selectedService = null;
      _selectedPackage = null;
      _selectedLocation = null;
      _selectedTechnician = null;
      _selectedSlot = null;
      _selectedSlotDate = DateTime.now();
      _currentStep = 1; // Jump to "Choose Package".
    });
    _fetchPackagesForSelectedCar();
  }

  void _handleLocationSelection(LatLng latlng) {
    setState(() => _selectedLocation = latlng);
    _resetTechnicianSearch();
  }

  String _formatDateForApi(DateTime date) {
    final formatter = DateFormat('dd-MMM-yyyy');
    return formatter.format(date).toUpperCase();
  }

  String _formatDateForAppointment(DateTime date) {
    return DateFormat('dd-MMM-yyyy').format(date).toLowerCase();
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
    final l10n = S.of(context);
    if (_currentStep == 0) {
      if (_selectedCarEntity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.bookServiceSelectCarBeforeContinuing),
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
            category: _categoryQueryValue(),
          );
      return;
    }

    if (_currentStep == 1) {
      if (_selectedPackage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.bookServiceSelectPackageBeforeContinuing),
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
          SnackBar(
            content: Text(l10n.bookServiceSelectLocationBeforeContinuing),
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

  Future<void> _handleBooking() async {
    final l10n = S.of(context);
    final car = _selectedCarEntity;
    final package = _selectedPackage;
    final location = _selectedLocation;
    final technician = _selectedTechnician;
    final slot = _selectedSlot;

    if (car == null ||
        package == null ||
        location == null ||
        technician == null ||
        slot == null) {
      _showSnack(l10n.bookServiceCompleteAllStepsBeforeBooking);
      return;
    }

    final customerId = await _ensureCustomerId();
    if (customerId == null || customerId.isEmpty) {
      return;
    }

    final packageId =
        package.packageId.trim().isNotEmpty
            ? package.packageId.trim()
            : package.packageCode.trim();
    if (packageId.isEmpty) {
      _showSnack(l10n.bookServiceSelectedPackageUnavailable);
      return;
    }

    final branchId = technician.branchId.trim();
    if (branchId.isEmpty) {
      _showSnack(l10n.bookServiceTechnicianBranchUnavailable);
      return;
    }

    final userId = technician.techId.trim();
    if (userId.isEmpty) {
      _showSnack(l10n.bookServiceTechnicianInfoUnavailable);
      return;
    }

    final vehicleId = car.vehicleId.trim();
    if (vehicleId.isEmpty) {
      _showSnack(l10n.bookServiceSelectedVehicleUnavailable);
      return;
    }

    final bookingDate = _formatDateForAppointment(_selectedSlotDate);
    final slotLabel = _slotLabel(slot);
    final slotTimeRaw = slot.slotTime?.trim();
    final slotValue =
        slotTimeRaw != null && slotTimeRaw.isNotEmpty ? slotTimeRaw : slotLabel;
    final mileage = car.mileage.trim().isNotEmpty ? car.mileage.trim() : '0';
    final latitude = location.latitude.toStringAsFixed(6);
    final longitude = location.longitude.toStringAsFixed(6);

    setState(() {
      _isBooking = true;
    });

    try {
      final createAppointment = ref.read(createAppointmentUseCaseProvider);
      final CreateAppointmentResult result = await createAppointment(
        bookingDate: bookingDate,
        branchId: branchId,
        userId: userId,
        latitude: latitude,
        longitude: longitude,
        mileage: mileage,
        partyId: customerId,
        vehicleId: vehicleId,
        packageId: packageId,
        selectedSlot: slotValue,
        isImmediateAppointment: false,
        slotTime: slotValue,
      );

      if (!mounted) {
        return;
      }

      if (result.isSuccessful) {
        await showDialog<void>(
          context: context,
          builder:
              (dialogContext) => AlertDialog(
                title: Text(l10n.bookServiceAppointmentConfirmedTitle),
                content: Text(result.displayMessage),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(l10n.bookServiceOk),
                  ),
                ],
              ),
        );
        if (!mounted) {
          return;
        }
        ref.invalidate(upcomingServiceViewModelProvider);
        await ref
            .read(upcomingServiceViewModelProvider.notifier)
            .fetchUpcomingServices();
        _resetBookingFlow();
        ref.read(currentNavBottomIndexProvider.notifier).state = 0;
      } else {
        _showSnack(result.displayMessage);
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showSnack(
        error.toString().isNotEmpty
            ? error.toString()
            : l10n.bookServiceCreateAppointmentFailed,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isBooking = false;
        });
      }
    }
  }

  void _showSnack(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _syncSelectedCarSelection(List<CarEntity> cars) {
    final selectedCar = _selectedCarEntity;
    if (selectedCar == null) {
      return;
    }
    final matchIndex =
        cars.indexWhere((car) => car.vehicleId == selectedCar.vehicleId);
    if (matchIndex != -1 && _selectedCar != matchIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _selectedCar = matchIndex;
        });
      });
    }
  }

  Widget _buildCarStep() {
    // Use the shared user cars ViewModel
    return Consumer(
      builder: (context, ref, _) {
        final authState = ref.watch(authViewModelProvider);
        final state = ref.watch(userCarsViewModelProvider);

        if (authState is AuthenticatedState && state is UserCarsInitial) {
          final customerId = authState.user.oracleId;
          if (customerId.isNotEmpty) {
            Future.microtask(
              () => ref
                  .read(userCarsViewModelProvider.notifier)
                  .fetchUserCars(customerId: customerId),
            );
          }
        }

        if (authState is! AuthenticatedState) {
          return LoginPromptCard(
            message: S.of(context).bookServiceSignInToSelectCar,
            buttonText: S.of(context).upcomingServicesViewButton,
            centered: true,
            onLogin: () {
              navigatorKey.currentState?.pushNamed('loginScreen');
            },
          );
        }

        if (state is UserCarsLoading || state is UserCarsInitial) {
          return const _CarStepSkeletonList();
        } else if (state is UserCarsLoaded) {
          final cars = state.cars;
          if (cars.isEmpty) {
            return UserCarsEmptyState(
              onAddCar: () {
                Navigator.of(context).pushNamed('addNewCarScreen');
              },
            );
          }
          _syncSelectedCarSelection(cars);
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
      return _wrapWithCategoryBanner(
        context,
        Center(
          child: Text(
            S.of(context).bookServiceSelectCarInStepOne,
          ),
        ),
      );
    }

    if (packagesState is ServicePackagesInitial ||
        packagesState is ServicePackagesLoading) {
      return _wrapWithCategoryBanner(
        context,
        const _ServicePackagesSkeletonList(),
      );
    }

    if (packagesState is ServicePackagesError) {
      final l10n = S.of(context);
      return _wrapWithCategoryBanner(
        context,
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.bookServiceFailedToLoadPackages(packagesState.message),
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
                child: Text(l10n.bookServiceTryAgain),
              ),
            ],
          ),
        ),
      );
    }

    if (packagesState is ServicePackagesEmpty) {
      final l10n = S.of(context);
      return _wrapWithCategoryBanner(
        context,
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.car_repair, size: 64, color: Colors.grey[400]),

                SizedBox(height: 16),

                Text(
                  l10n.bookServiceNoPackagesFoundTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  l10n.bookServiceNoPackagesFoundDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),

                SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _fetchPackagesForSelectedCar();
                        },
                        child: Text(l10n.commonRetry),
                      ),
                    ),

                  ],
                )
              ],
            ),
          ),
        ),
      );
    }

    if (packagesState is ServicePackagesLoaded) {
      final l10n = S.of(context);
      final packages = packagesState.packages;

      return _wrapWithCategoryBanner(
        context,
        ListView.separated(
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
                subtitle: Text(l10n.bookServicePriceSar(displayPrice)),
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
        ),
      );
    }

    return Center(child: Text(S.of(context).bookServicePackagesLoadAfterContinue));
  }

  Widget _buildLocationStep() {
    final l10n = S.of(context);
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
                    ? l10n.bookServiceTapMapToSelectLocation
                    : l10n.bookServiceSelectedLocation(
                      _selectedLocation!.latitude.toStringAsFixed(6),
                      _selectedLocation!.longitude.toStringAsFixed(6),
                    ),
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
    final l10n = S.of(context);
    final searchState = ref.watch(technicianSearchViewModelProvider);
    final hasPrerequisites =
        _selectedLocation != null && _selectedPackage != null;

    if (!hasPrerequisites) {
      return Center(
        child: Text(
          l10n.bookServiceSelectPackageAndLocation,
          textAlign: TextAlign.center,
        ),
      );
    }

    Widget buildBody(Widget child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [const SizedBox(height: 12), Expanded(child: child)],
      );
    }

    if (searchState is TechnicianSearchLoading) {
      return buildBody(const _TechnicianGridSkeleton());
    }

    if (searchState is TechnicianSearchError) {
      return buildBody(ErrorStateWidget(onRetry: _retryTechnicianSearch));
    }

    if (searchState is TechnicianSearchEmpty) {
      return buildBody(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              l10n.bookServiceNoTechniciansInRegion,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _retryTechnicianSearch,
              child: Text(l10n.bookServiceRefresh),
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
          Text(
            l10n.bookServiceReadyToFindTechnicians,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _retryTechnicianSearch,
            child: Text(l10n.bookServiceSearchTechnicians),
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
    final l10n = S.of(context);
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
              Row(
                children: [
                  const Icon(Icons.place, size: 18, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    l10n.bookServiceDistanceAway(
                      distance.toStringAsFixed(distance >= 10 ? 0 : 1),
                    ),
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
    final l10n = S.of(context);
    final technician = _selectedTechnician;
    final slotsState = ref.watch(technicianSlotsViewModelProvider);

    if (technician == null) {
      return Text(l10n.bookServiceTapTechnicianForSlots);
    }

    bool matchesCurrentTech(String technicianId) =>
        technician.techId == technicianId;

    Widget content;
    if (slotsState is TechnicianSlotsInitial) {
      content = Text(l10n.bookServiceTapTechnicianForSlots);
    } else if (slotsState is TechnicianSlotsLoading) {
      content =
          matchesCurrentTech(slotsState.technicianId)
              ? const _SlotChipsSkeleton()
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
                  Text(l10n.bookServiceNoSlotsForSelectedDate),
                  TextButton(
                    onPressed: _fetchSlotsForTechnician,
                    child: Text(l10n.bookServiceRefresh),
                  ),
                ],
              )
              : const SizedBox.shrink();
    } else if (slotsState is TechnicianSlotsError) {
      content =
          matchesCurrentTech(slotsState.technicianId)
              ? ErrorStateWidget(onRetry: _fetchSlotsForTechnician)
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
                l10n.bookServiceAvailableSlotsFor(displayName),
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
      return Text(S.of(context).bookServiceNoSlotsForSelectedDate);
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
    final l10n = S.of(context);
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      final allow = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(l10n.bookServiceLocationPermissionTitle),
              content: Text(l10n.bookServiceLocationPermissionMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l10n.bookServiceDeny),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(l10n.bookServiceAllow),
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
    ref.listen<CarEntity?>(
      preselectedBookServiceCarProvider,
      (previous, next) {
        if (next != null) {
          _applyPreselectedCar(next);
          ref.read(preselectedBookServiceCarProvider.notifier).state = null;
        }
      },
    );

    final steps = _stepContents;
    final l10n = S.of(context);
    final stepLabels = <String>[
      l10n.bookServiceStepSelectVehicle,
      l10n.bookServiceStepChoosePackage,
      l10n.bookServiceStepPickLocation,
      l10n.bookServiceStepSelectTechnician,
    ];
    assert(
      stepLabels.length == steps.length,
      'Step labels should match the number of step contents.',
    );
    final isLast = _currentStep == steps.length - 1;
    final isFirst = _currentStep == 0;
    final canSubmit = _selectedTechnician != null && _selectedSlot != null;

    final actionButtons = <Widget>[];
    if (!isFirst) {
      actionButtons.add(
        OutlinedButton(onPressed: _goToPrevious, child:  Text(appLang.back)),
      );
    }

    if (isLast) {
      actionButtons.add(
        ElevatedButton(
          onPressed: (!canSubmit || _isBooking) ? null : _handleBooking,
          child:
              _isBooking
                  ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  :  Text(appLang.book),
        ),
      );
    } else {
      actionButtons.add(
        ElevatedButton(onPressed: _goToNext, child:  Text(appLang.next)),
      );
    }

    final mainAxisAlignment =
        actionButtons.length > 1
            ? MainAxisAlignment.spaceBetween
            : (!isFirst ? MainAxisAlignment.start : MainAxisAlignment.end);

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
                      stepLabels[index],
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
                mainAxisAlignment: mainAxisAlignment,
                children: actionButtons,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
