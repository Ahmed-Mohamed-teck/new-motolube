import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:newmotorlube/core/providers/current_locale_provider.dart';
import 'package:newmotorlube/core/providers/global_lang_provider.dart';
import 'package:newmotorlube/features/user_cars/presentation/view_model/manufacturers_state.dart';
import 'package:newmotorlube/features/user_cars/provider/user_cars_provider.dart';
import 'package:newmotorlube/features/user_cars/domain/entity/car_entity.dart';
import 'package:newmotorlube/features/user_cars/presentation/view_model/add_user_car_state.dart';

import '../../../../core/providers/plate_chars_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../../core/widget/internal_app_bar.dart';
import '../view_model/car_brands_state.dart';

class AddNewCarScreen extends ConsumerStatefulWidget {
  const AddNewCarScreen({super.key});

  @override
  ConsumerState<AddNewCarScreen> createState() => _AddNewCarScreenState();
}

class _AddNewCarScreenState extends ConsumerState<AddNewCarScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  String? _selectedManufacturer;
  final _modelCtrl = TextEditingController();
  final _vinCtrl = TextEditingController();
  final _plateNumberCtrl = TextEditingController();

  // Simple dropdown state
  int? _selectedYear;
  String? _plateL1, _plateL2, _plateL3, _plateL4, _plateL5, _plateL6, _plateL7;

  // Image upload error state
  bool _imagesError = false;
  bool _isPreparingSubmission = false;

  // Images state
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _carImages = [];

  // Lists
  late final List<int> _years = List.generate(
    40,
    (i) => DateTime.now().year - i,
  );

  late final List<String> _plateChars;
  late final List<String> _plateNumbers;

  @override
  void initState() {
    super.initState();
    _plateChars = CharListProvider.getPlateChars(
      ref.read(currentLocaleProvider),
    );
    _plateNumbers = CharListProvider.getPlateNumbers(
      ref.read(currentLocaleProvider),
    );
    // fetch manufacturers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(manufacturersViewModelProvider.notifier).fetchManufacturers();
    });
  }

  @override
  void dispose() {
    _modelCtrl.dispose();
    _vinCtrl.dispose();
    _plateNumberCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickCamera() async {
    final x = await _picker.pickImage(source: ImageSource.camera);
    if (x != null) {
      setState(() => _carImages.add(x));
    }
  }

  Future<void> _pickGallery() async {
    final xs = await _picker.pickMultiImage();
    if (xs.isNotEmpty) {
      setState(() => _carImages.addAll(xs));
    }
  }

  Future<Uint8List> _compressImage(XFile file) async {
    final bytes = await file.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      return bytes;
    }

    const maxDimension = 1280;
    img.Image processed = decoded;
    if (decoded.width > maxDimension || decoded.height > maxDimension) {
      if (decoded.width >= decoded.height) {
        processed = img.copyResize(
          decoded,
          width: maxDimension,
          interpolation: img.Interpolation.cubic,
        );
      } else {
        processed = img.copyResize(
          decoded,
          height: maxDimension,
          interpolation: img.Interpolation.cubic,
        );
      }
    }

    final encoded = img.encodeJpg(processed, quality: 70);
    return Uint8List.fromList(encoded);
  }

  void _showImageSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(appLang.userCarsTakePhoto),
                onTap: () {
                  Navigator.pop(context);
                  _pickCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(appLang.userCarsChooseFromGallery),
                onTap: () {
                  Navigator.pop(context);
                  _pickGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeImage(int index) {
    setState(() => _carImages.removeAt(index));
  }

  void _save() async {
    if (_isPreparingSubmission) return;

    final manufacturersState = ref.read(manufacturersViewModelProvider);
    final carBrandsState = ref.read(carBrandsViewModelProvider);

    if (manufacturersState is ManufacturersError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLang.userCarsErrorLoadingManufacturers)),
      );
      return;
    }
    if (manufacturersState is! ManufacturersLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLang.selectManufacturer)),
      );
      return;
    }
    if (_selectedManufacturer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLang.selectManufacturer)),
      );
      return;
    }
    if (carBrandsState is CarBrandsError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLang.userCarsErrorLoadingModels)),
      );
      return;
    }
    if (_modelCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLang.selectModel)),
      );
      return;
    }

    final formOk = _formKey.currentState?.validate() ?? false;

    if (formOk) {
      if (_plateL1 == null ||
          _plateL2 == null ||
          _plateL3 == null ||
          _plateL4 == null ||
          _plateL5 == null ||
          _plateL6 == null ||
          _plateL7 == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(appLang.userCarsCompletePlateFields),
          ),
        );
        return;
      }
      if (_carImages.isEmpty) {
        setState(() => _imagesError = true);
        return;
      } else {
        setState(() => _imagesError = false);
      }

      // Build CarEntity and dispatch add
      try {
        setState(() => _isPreparingSubmission = true);
        final car = await _buildCarEntity();
        await ref.read(addUserCarViewModelProvider.notifier).addCar(car);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        if (mounted) {
          setState(() => _isPreparingSubmission = false);
        }
      }
    }
  }

  Future<CarEntity> _buildCarEntity() async {
    // Map selected letters/numbers to both Arabic and English
    String l1 = _plateL1!;
    String l2 = _plateL2!;
    String l3 = _plateL3!;
    String n1 = _plateL4!;
    String n2 = _plateL5!;
    String n3 = _plateL6!;
    String n4 = _plateL7!;

    String mapArabicLetter(String ch) {
      final iAr = CharListProvider.arabicChars.indexOf(ch);
      if (iAr != -1) return ch;
      final iEn = CharListProvider.englishChars.indexOf(ch);
      if (iEn != -1) return CharListProvider.arabicChars[iEn];
      throw Exception(appLang.userCarsInvalidPlateLetter);
    }

    String mapEnglishLetter(String ch) {
      final iEn = CharListProvider.englishChars.indexOf(ch);
      if (iEn != -1) return ch;
      final iAr = CharListProvider.arabicChars.indexOf(ch);
      if (iAr != -1) return CharListProvider.englishChars[iAr];
      throw Exception(appLang.userCarsInvalidPlateLetter);
    }

    String mapArabicNumber(String ch) {
      final iAr = CharListProvider.arabicNumbers.indexOf(ch);
      if (iAr != -1) return ch;
      final iEn = CharListProvider.numbers.indexOf(ch);
      if (iEn != -1) return CharListProvider.arabicNumbers[iEn];
      throw Exception(appLang.userCarsInvalidPlateNumber);
    }

    String mapEnglishNumber(String ch) {
      final iEn = CharListProvider.numbers.indexOf(ch);
      if (iEn != -1) return ch;
      final iAr = CharListProvider.arabicNumbers.indexOf(ch);
      if (iAr != -1) return CharListProvider.numbers[iAr];
      throw Exception(appLang.userCarsInvalidPlateNumber);
    }

    final arabicPlate = <String>[
      mapArabicLetter(l1),
      mapArabicLetter(l2),
      mapArabicLetter(l3),
      mapArabicNumber(n1),
      mapArabicNumber(n2),
      mapArabicNumber(n3),
      mapArabicNumber(n4),
    ];

    final englishPlate = <String>[
      mapEnglishLetter(l1),
      mapEnglishLetter(l2),
      mapEnglishLetter(l3),
      mapEnglishNumber(n1),
      mapEnglishNumber(n2),
      mapEnglishNumber(n3),
      mapEnglishNumber(n4),
    ];

    // Convert images to Base64
    final imagesBase64 = <String>[];
    for (final xf in _carImages) {
      final compressed = await _compressImage(xf);
      imagesBase64.add(base64Encode(compressed));
    }

    return CarEntity(
      vehicleId: '', // to be assigned by backend
      mileage: '0', // initial mileage
      arabicPlate: arabicPlate,
      englishPlate: englishPlate,
      carModel: _modelCtrl.text,
      manufacturer: _selectedManufacturer!,
      modelYear: _selectedYear!.toString(),
      carImages: imagesBase64,
      vinNumber: _vinCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final manufacturersState = ref.watch(manufacturersViewModelProvider);
    final carBrandsState = ref.watch(carBrandsViewModelProvider);
    final addState = ref.watch(addUserCarViewModelProvider);
    final isBusy = _isPreparingSubmission || addState is AddUserCarLoading;
    if (addState is AddUserCarSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
          SnackBar(content: Text(appLang.userCarsAddedSuccessfully)),
        );
        Navigator.of(context).pop(true);
      });
    } else if (addState is AddUserCarError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(addState.message)));
        // Reset to avoid repeated snackbars on rebuilds
        ref.read(addUserCarViewModelProvider.notifier).reset();
      });
    }
    return Scaffold(
      appBar: InternalAppBar(title: appLang.addCar),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _SectionCard(
                title: appLang.plate,
                icon: Icons.numbers,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Letters Section
                    Text(
                      appLang.plateLetters,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _PlateLetterDropdown(
                          value: _plateL1,
                          letters: _plateChars,
                          onChanged: (v) => setState(() => _plateL1 = v),
                        ),
                        _PlateLetterDropdown(
                          value: _plateL2,
                          letters: _plateChars,
                          onChanged: (v) => setState(() => _plateL2 = v),
                        ),
                        _PlateLetterDropdown(
                          value: _plateL3,
                          letters: _plateChars,
                          onChanged: (v) => setState(() => _plateL3 = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Numbers Section
                    Text(
                      appLang.plateNumbers,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _PlateLetterDropdown(
                          value: _plateL4,
                          letters: _plateNumbers,
                          onChanged: (v) => setState(() => _plateL4 = v),
                        ),
                        _PlateLetterDropdown(
                          value: _plateL5,
                          letters: _plateNumbers,
                          onChanged: (v) => setState(() => _plateL5 = v),
                        ),
                        _PlateLetterDropdown(
                          value: _plateL6,
                          letters: _plateNumbers,
                          onChanged: (v) => setState(() => _plateL6 = v),
                        ),
                        _PlateLetterDropdown(
                          value: _plateL7,
                          letters: _plateNumbers,
                          onChanged: (v) => setState(() => _plateL7 = v),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // === Car Info Section ===
              _SectionCard(
                title: appLang.carInfo,
                icon: Icons.directions_car_filled_outlined,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (manufacturersState is ManufacturersLoading ||
                          manufacturersState is ManufacturersInitial)
                        Column(
                          children: [
                            _LabeledField(
                              label: appLang.manufacturer,
                              child: SpinKitThreeBounce(
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              ),
                            ),
                          ],
                        )
                      else if (manufacturersState is ManufacturersError)
                        Text(appLang.userCarsErrorLoadingManufacturers)
                      else if (manufacturersState is ManufacturersLoaded) ...[
                        // compute a safe value that exists in the list
                        Builder(
                          builder: (context) {
                            final list = manufacturersState.manufacturers;
                            final String? safeValue =
                                list.any((m) => m.name == _selectedManufacturer)
                                    ? _selectedManufacturer
                                    : null;

                            return _LabeledField(
                              label: appLang.manufacturer,
                              child: DropdownButtonFormField2<String>(
                                value: safeValue,
                                isExpanded: true,
                                decoration: _input(null),
                                hint: Text(appLang.selectManufacturer),
                                dropdownStyleData: const DropdownStyleData(
                                  isOverButton: false, // don’t cover the button
                                  offset: Offset(0, 6), // small push downward
                                  useRootNavigator:
                                      true, // helpful in sheets/complex trees
                                  maxHeight:
                                      300, // optional: keep the list scrollable
                                ),
                                items:
                                    list
                                        .map(
                                          (m) => DropdownMenuItem<String>(
                                            value: m.name,
                                            child: Text(m.name),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedManufacturer = value;
                                    _modelCtrl.clear();
                                  });
                                  if (value != null) {
                                    ref
                                        .read(
                                          carBrandsViewModelProvider.notifier,
                                        )
                                        .fetCarBrands(carModelId: value);
                                  }
                                },
                                validator:
                                    (v) =>
                                        v == null
                                            ? appLang.selectManufacturer
                                            : null,
                              ),
                            );
                          },
                        ),
                      ] else
                        const SizedBox(),

                      const SizedBox(height: 12),
                      if (manufacturersState is ManufacturersLoaded &&
                          _selectedManufacturer != null) ...[
                        _LabeledField(
                          label: appLang.model,
                          child: Builder(
                            builder: (context) {
                              if (carBrandsState is CarBrandsLoading ||
                                  carBrandsState is CarBrandsInitial) {
                                return SpinKitThreeBounce(
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                );
                              } else if (carBrandsState is CarBrandsError) {
                                return Text(appLang.userCarsErrorLoadingModels);
                              } else if (carBrandsState is CarBrandsLoaded) {
                                final carBrands = carBrandsState.carBrands;
                                final hasBrands = carBrands.isNotEmpty;
                                final String? safeValue =
                                    carBrands.any(
                                      (brand) => brand.name == _modelCtrl.text,
                                    )
                                        ? _modelCtrl.text
                                        : null;
                                final shouldClearSelection =
                                    (!hasBrands || safeValue == null) &&
                                    _modelCtrl.text.isNotEmpty;
                                if (shouldClearSelection) {
                                  WidgetsBinding.instance.addPostFrameCallback(
                                    (_) {
                                      if (!mounted) return;
                                      setState(_modelCtrl.clear);
                                    },
                                  );
                                }

                                return DropdownButtonFormField<String>(
                                  value: safeValue,
                                  isExpanded: true,
                                  decoration: _input(null),
                                  hint: Text(appLang.selectModel),
                                  disabledHint: Text(appLang.selectModel),
                                  items:
                                      carBrands
                                          .map(
                                            (brand) => DropdownMenuItem<String>(
                                              value: brand.name,
                                              child: Text(brand.name),
                                            ),
                                          )
                                          .toList(),
                                  onChanged:
                                      hasBrands
                                          ? (value) {
                                            setState(() {
                                              _modelCtrl.text = value ?? '';
                                            });
                                          }
                                          : null,
                                  validator: (v) {
                                    if (!hasBrands) return null;
                                    return v == null
                                        ? appLang.selectModel
                                        : null;
                                  },
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      _LabeledField(
                        label: appLang.year,
                        child: DropdownButtonFormField<int>(
                          value: _selectedYear,
                          decoration: _input(null),
                          items:
                              _years
                                  .map(
                                    (y) => DropdownMenuItem(
                                      value: y,
                                      child: Text('$y'),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (v) => setState(() => _selectedYear = v),
                          validator:
                              (v) => v == null ? appLang.selectYear : null,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _LabeledField(
                        label: appLang.vin,
                        child: TextFormField(
                          controller: _vinCtrl,
                          textInputAction: TextInputAction.done,
                          decoration: _input(appLang.characterVinLimit),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty)
                              return appLang.characterVinLimitError;
                            if (v.length != 17)
                              return appLang.characterVinLimitError;
                            return null;
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                              17,
                            ), // Limit input to 17 characters
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // === Car Images Section ===
              _SectionCard(
                title: appLang.userCarsImagesSectionTitle,
                icon: Icons.photo_library_outlined,
                action: TextButton.icon(
                  onPressed: _showImageSheet,
                  icon: const Icon(Icons.add),
                  label: Text(appLang.userCarsAddPhotos),
                ),
                child: Column(
                  children: [
                    _ImagesGrid(
                      images: _carImages,
                      onAdd: _showImageSheet,
                      onRemove: _removeImage,
                    ),
                    Visibility(
                      visible: _imagesError,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            appLang.userCarsAddImageRequirement,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 48,
          child: FilledButton.icon(
            onPressed: isBusy ? null : _save,
            icon:
                isBusy
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Icon(Icons.save_outlined),
            label: Text(
              isBusy ? appLang.userCarsSaving : appLang.userCarsSaveVehicle,
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _input(String? hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.grey.shade50,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  );
}

/// Section card with header
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.action,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (action != null) action!,
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelLarge),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _PlateLetterDropdown extends StatelessWidget {
  const _PlateLetterDropdown({
    required this.value,
    required this.letters,
    required this.onChanged,
  });

  final String? value;
  final List<String> letters;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
        items:
            letters
                .map((l) => DropdownMenuItem<String>(value: l, child: Text(l)))
                .toList(),
        onChanged: onChanged,
        validator:
            (v) => v == null ? '' : null, // handled in the number validator
      ),
    );
  }
}

class _ImagesGrid extends StatelessWidget {
  const _ImagesGrid({
    required this.images,
    required this.onAdd,
    required this.onRemove,
  });

  final List<XFile> images;
  final VoidCallback onAdd;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      _AddTile(onTap: onAdd),
      ...List.generate(images.length, (i) {
        final xf = images[i];
        return _ImageTile(file: File(xf.path), onRemove: () => onRemove(i));
      }),
    ];

    return GridView.builder(
      itemCount: tiles.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (_, i) => tiles[i],
    );
  }
}

class _AddTile extends StatelessWidget {
  const _AddTile({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Center(child: Icon(Icons.add_a_photo_outlined, size: 28)),
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({required this.file, required this.onRemove});
  final File file;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(file, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Material(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: onRemove,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Single CRN image picker/preview field
class _CrnImageField extends StatelessWidget {
  const _CrnImageField({
    required this.file,
    required this.onPick,
    required this.onRemove,
  });

  final File? file;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPick,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.grey.shade50,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.upload_file_outlined),
                const SizedBox(width: 8),
                Text(appLang.userCarsAddCrnImage),
              ],
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        Container(
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.file(file!, fit: BoxFit.cover, width: double.infinity),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Row(
            children: [
              _CircleBtn(icon: Icons.edit_outlined, onTap: onPick),
              const SizedBox(width: 8),
              _CircleBtn(icon: Icons.delete_outline, onTap: onRemove),
            ],
          ),
        ),
      ],
    );
  }
}

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black45,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(6),
          child: Icon(Icons.edit, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}
