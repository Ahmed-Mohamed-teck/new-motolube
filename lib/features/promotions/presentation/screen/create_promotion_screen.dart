import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/providers/global_lang_provider.dart';
import '../../../app/app_color_theme.dart';
import '../../domain/entity/promotion_entity.dart';
import '../view_model/promotion_view_model.dart';

class CreatePromotionScreen extends ConsumerStatefulWidget {
  const CreatePromotionScreen({super.key});

  @override
  ConsumerState<CreatePromotionScreen> createState() => _CreatePromotionScreenState();
}

class _CreatePromotionScreenState extends ConsumerState<CreatePromotionScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _promotionImageFile;
  String _promotionName = '';
  String _promotionDescription = '';
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _promotionImageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _pickDate({required bool isStartDate}) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = selectedDate;
        } else {
          _endDate = selectedDate;
        }
      });
    }
  }

  Future<void>  _submitForm() async {
    final viewModel = ref.read(promotionViewModelProvider.notifier);

    if (!_formKey.currentState!.validate() || _promotionImageFile == null || _startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLang.fillAllFields)),
      );
      return;
    }

    _formKey.currentState!.save();

    try {
      final imageUrl = await viewModel.uploadImage(_promotionImageFile!);

      final promotion = PromotionEntity(
        id: const Uuid().v4(),
        name: _promotionName,
        description: _promotionDescription,
        startDate: _startDate!,
        endDate: _endDate!,
        imageUrl: imageUrl,
      );

      await viewModel.savePromotion(promotion);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLang.promotionSavedSuccessfully)),
      );

      _formKey.currentState!.reset();
      setState(() {
        _promotionImageFile = null;
        _startDate = null;
        _endDate = null;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLang.errorSavingPromotion)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(promotionViewModelProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('promotion',style: Theme.of(context).textTheme.headlineMedium,)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: _promotionImageFile != null
                      ? Image.file(_promotionImageFile!, height: 150, fit: BoxFit.cover)
                      : Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: Icon(Icons.image, size: 50, color: Colors.grey[700]),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: appLang.promotionName),
                  validator: (value) => value == null || value.trim().isEmpty ? appLang.enterPromotionNameHint : null,
                  onSaved: (value) => _promotionName = value!.trim(),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: appLang.promotionDescription),
                  maxLines: 3,
                  onSaved: (value) => _promotionDescription = value!.trim(),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(_startDate == null
                          ? appLang.selectStartDate
                          : '${appLang.startDate}: ${_startDate!.toLocal().toString().split(' ')[0]}'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.date_range),
                      onPressed: () => _pickDate(isStartDate: true),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(_endDate == null
                          ? appLang.selectEndDate
                          : '${appLang.endDate}: ${_endDate!.toLocal().toString().split(' ')[0]}'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.date_range),
                      onPressed: () => _pickDate(isStartDate: false),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                isLoading
                    ? Center(child: CircularProgressIndicator(color: Theme.of(context).extension<AppColorsTheme>()!.primary))
                    : ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.save),
                  label: Text(appLang.savePromotion),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).extension<AppColorsTheme>()!.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
