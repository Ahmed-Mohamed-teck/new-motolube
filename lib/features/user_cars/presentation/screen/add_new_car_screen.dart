import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newmotorlube/core/providers/current_locale_provider.dart';
import 'package:newmotorlube/core/providers/global_lang_provider.dart';
import 'package:newmotorlube/features/user_cars/presentation/view_model/manufacturers_state.dart';
import 'package:newmotorlube/features/user_cars/provider/user_cars_provider.dart';

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

  // Owner/company controllers
  final _companyNameCtrl = TextEditingController();
  final _crnCtrl = TextEditingController();

  // Simple dropdown state
  int? _selectedYear;
  String? _plateL1, _plateL2, _plateL3 ,_plateL4, _plateL5, _plateL6, _plateL7;

  // Ownership
  bool _ownsThisCar = true; // if false => show company + CRN fields
  XFile? _crnImage;

  // Image upload error state
  bool _imagesError = false;

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
    _plateChars = CharListProvider.getPlateChars(ref.read(currentLocaleProvider));
    _plateNumbers = CharListProvider.getPlateNumbers(ref.read(currentLocaleProvider));
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
    _companyNameCtrl.dispose();
    _crnCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickCamera() async {
    final x = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (x != null) {
      setState(() => _carImages.add(x));
    }
  }

  Future<void> _pickGallery() async {
    final xs = await _picker.pickMultiImage(imageQuality: 85);
    if (xs.isNotEmpty) {
      setState(() => _carImages.addAll(xs));
    }
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
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from gallery (multiple)'),
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

  // --- CRN Image pickers -----------------------------------------------------

  Future<void> _pickCrn(ImageSource source) async {
    final x = await _picker.pickImage(source: source, imageQuality: 90);
    if (x != null) {
      setState(() => _crnImage = x);
    }
  }

  void _showCrnSheet() {
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
                title: const Text('Scan CRN with camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickCrn(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Upload CRN from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickCrn(ImageSource.gallery);
                },
              ),
              if (_crnImage != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: const Text('Remove CRN image'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _crnImage = null);
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

  void _save() {
    final formOk = _formKey.currentState?.validate() ?? false;

    // Extra validation when “owns this car” is YES
    if (!_ownsThisCar) {
      if (_crnImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please attach the CRN image.')),
        );
        return;
      }
    }

    if (formOk) {

      if(_carImages.isEmpty) {
        setState(() => _imagesError = true);
        return;
      } else {
        setState(() => _imagesError = false);
      }

      // TODO: hook into your ViewModel/use case layer
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vehicle saved (UI demo).')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final manufacturersState = ref.watch(manufacturersViewModelProvider);
    final carBrandsState = ref.watch(carBrandsViewModelProvider);
    return Scaffold(
      appBar: InternalAppBar(title: appLang.addCar,),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:  EdgeInsets.all(16),
          child: Column(
            children: [
              _SectionCard(
                title: appLang.plate, icon: Icons.numbers, child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Letters Section
                  Text(appLang.plateLetters, style: TextStyle(fontWeight: FontWeight.bold)),
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
                  Text(appLang.plateNumbers, style: TextStyle(fontWeight: FontWeight.bold)),
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
              ),),
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
                      if (manufacturersState is ManufacturersLoading || manufacturersState is ManufacturersInitial)
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
                        Text('Error loading manufacturers')
                      else if (manufacturersState is ManufacturersLoaded) ...[
                          // compute a safe value that exists in the list
                          Builder(builder: (context) {
                            final list = manufacturersState.manufacturers;
                            final String? safeValue = list.any((m) => m.name == _selectedManufacturer)
                                ? _selectedManufacturer
                                : null;

                             return _LabeledField(
                                label: appLang.manufacturer,
                               child: DropdownButtonFormField2<String>(
                                value: safeValue,
                                isExpanded: true,
                                decoration: _input(null),
                                hint:  Text(appLang.selectManufacturer),
                                 dropdownStyleData: const DropdownStyleData(
                                   isOverButton: false,                // don’t cover the button
                                   offset: Offset(0, 6),               // small push downward
                                   useRootNavigator: true,             // helpful in sheets/complex trees
                                   maxHeight: 300,                     // optional: keep the list scrollable
                                 ),
                                items: list
                                    .map((m) => DropdownMenuItem<String>(
                                  value: m.name,
                                  child: Text(m.name),
                                ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedManufacturer = value;
                                    ref.read(carBrandsViewModelProvider.notifier).fetCarBrands(carModelId: value ?? '');
                                  });
                                },
                                validator: (v) => v == null ? appLang.selectManufacturer : null,
                                                           ),
                             );
                          }),
                        ]
                      else
                        const SizedBox(),

                      const SizedBox(height: 12),
                      if (manufacturersState is ManufacturersLoaded && _selectedManufacturer != null) ...[
                        _LabeledField(
                          label: appLang.model,
                          child: Builder(
                            builder: (context) {
                              if (carBrandsState is CarBrandsLoading || carBrandsState is CarBrandsInitial) {
                                return SpinKitThreeBounce(
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                );
                              } else if (carBrandsState is CarBrandsError) {
                                return const Text('Error loading car models');
                              } else if (carBrandsState is CarBrandsLoaded) {
                                final carBrands = carBrandsState.carBrands;
                                final String? safeValue = carBrands.any((brand) => brand.name == _modelCtrl.text)
                                    ? _modelCtrl.text
                                    : null;

                                return DropdownButtonFormField<String>(
                                  value: safeValue,
                                  isExpanded: true,
                                  decoration: _input(null),
                                  hint: Text(appLang.selectModel),
                                  items: carBrands
                                      .map((brand) => DropdownMenuItem<String>(
                                    value: brand.name,
                                    child: Text(brand.name),
                                  ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _modelCtrl.text = value ?? '';
                                    });
                                  },
                                  validator: (v) => v == null ? appLang.selectModel : null,
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
                          items: _years
                              .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                              .toList(),
                          onChanged: (v) => setState(() => _selectedYear = v),
                          validator: (v) => v == null ? appLang.selectYear : null,
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
                            if (v == null || v.trim().isEmpty) return appLang.characterVinLimitError;
                            if (v.length != 17) return appLang.characterVinLimitError;
                            return null;
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(17), // Limit input to 17 characters
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                      // --- Ownership question -------------------------------------------------
                      _LabeledField(
                        label: appLang.areYouOwnerThisCar,
                        child: Wrap(
                          spacing: 8,
                          children: [
                            ChoiceChip(
                              label:  Text(appLang.no),
                              selected: !_ownsThisCar,
                              onSelected: (_) => setState(() => _ownsThisCar = false),
                            ),
                            ChoiceChip(
                              label:  Text(appLang.yes),
                              selected: _ownsThisCar,
                              onSelected: (_) => setState(() => _ownsThisCar = true),
                            ),
                          ],
                        ),
                      ),

                      // --- Extra fields when YES ----------------------------------------------
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        child: !_ownsThisCar
                            ? Column(
                          key: const ValueKey('owner-extra'),
                          children: [
                            const SizedBox(height: 12),
                            _LabeledField(
                              label: appLang.companyName,
                              child: TextFormField(
                                controller: _companyNameCtrl,
                                textInputAction: TextInputAction.next,
                                decoration: _input(appLang.companyNameHint),
                                validator: (v) {
                                  if (_ownsThisCar) return null;
                                  return (v == null || v.trim().isEmpty) ? appLang.companyNameError : null;
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            _LabeledField(
                              label: appLang.crn,
                              child: TextFormField(
                                controller: _crnCtrl,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10), // typical KSA length
                                ],
                                decoration: _input(appLang.crnHint),
                                validator: (v) {
                                  if (_ownsThisCar) return null;
                                  if (v == null || v.isEmpty) return appLang.crnError;
                                  if (v.length < 8) return appLang.crnLengthError;
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            _LabeledField(
                              label: 'CRN Image',
                              child: _CrnImageField(
                                file: _crnImage != null ? File(_crnImage!.path) : null,
                                onPick: _showCrnSheet,
                                onRemove: () => setState(() => _crnImage = null),
                              ),
                            ),
                          ],
                        )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),



              // === Car Images Section ===
              _SectionCard(
                title: 'Car Images',
                icon: Icons.photo_library_outlined,
                action: TextButton.icon(
                  onPressed: _showImageSheet,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Photos'),
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
                        child: const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Please add at least one image.',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        )),
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
            onPressed: _save,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save Vehicle'),
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
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        items: letters
            .map((l) => DropdownMenuItem<String>(value: l, child: Text(l)))
            .toList(),
        onChanged: onChanged,
        validator: (v) => v == null ? '' : null, // handled in the number validator
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
        return _ImageTile(
          file: File(xf.path),
          onRemove: () => onRemove(i),
        );
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
        child: const Center(
          child: Icon(Icons.add_a_photo_outlined, size: 28),
        ),
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
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.upload_file_outlined),
                SizedBox(width: 8),
                Text('Add CRN image'),
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



