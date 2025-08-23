import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/features/contact_us/provider/contact_us_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/providers/global_lang_provider.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../app/app_color_theme.dart';
import '../../data/model/contact_us_model.dart';

class ContactUsScreen extends ConsumerStatefulWidget {
  const ContactUsScreen({super.key});

  @override
  ConsumerState<ContactUsScreen> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends ConsumerState<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // TextEditingControllers for each field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });

    // Handle save logic
    try {
      final doc =
      FirebaseFirestore.instance.collection('contactUs').doc();
      final rec = ContactUsModel(
        name: _nameController.text,
        email: _emailController.text,
        mobileNo: _mobileNumberController.text,
        comment: _descriptionController.text,
      );
      await doc.set(rec.toJson());

      // Clear the text fields
      _nameController.clear();
      _emailController.clear();
      _mobileNumberController.clear();
      _descriptionController.clear();

      if (mounted) {
        _showErrorSnackbar(context, 'successfullySaved');
      }
      //_sendEmail();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }



  Future<bool> _dialPhoneNumber() async {
    const phoneNumber = '+966920014257';
    final Uri uri = Uri.parse('tel:$phoneNumber');

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
      return false;
    } catch (e) {
      print('Error launching phone dialer: $e');
      return false;
    }
  }

  Future<bool> sendEmail({
    String? subject,
    String? body,
  }) async {
    final email = 'Info@motorlube-sa.com';
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
      return false;
    } catch (e) {
      print('Error launching email client: $e');
      return false;
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    _nameController.dispose();
    _emailController.dispose();
    _mobileNumberController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contactUsViewModelProvider);
    final vm = ref.read(contactUsViewModelProvider.notifier);

    return Scaffold(
      // Add a Floating Action Button to dial the phone number.
      floatingActionButton: FloatingActionButton(
        onPressed: _dialPhoneNumber,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.phone),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: appLang.name,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:  BorderSide(
                        color: AppColors.commonGreyText,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary, // Highlight color
                        width: 2.0, // Thicker border for focus
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return appLang.enterProperValue;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: appLang.email,
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: AppColors.commonGreyText,
                        width: 1.0,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        !value.contains('@')) {
                      return appLang.enterValidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _mobileNumberController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: appLang.phoneNumber,
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: AppColors.commonGreyText,
                        width: 1.0,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return appLang.enterProperValue;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: appLang.comment,
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: AppColors.commonGreyText,
                        width: 1.0,
                      ),
                    ),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return appLang.enterProperValue;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50),
                _isLoading
                    ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).extension<AppColorsTheme>()!.primary,
                    ))
                    : Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth * 0.9, // 90% width
                        child: ElevatedButton.icon(
                          onPressed: ()=>vm.sendContactUsMessage(
                            name: _nameController.text,
                            email: _emailController.text,
                            phoneNumber: _mobileNumberController.text,
                            message: _descriptionController.text,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Theme.of(context).colorScheme.primary,
                            foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                          ),
                          label: Text(
                            appLang.submit,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${appLang.mailUsAt} : ',style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),),
                    TextButton(onPressed: (){
                      sendEmail(subject: 'contact us');
                    }, child: const Text('Info@motorlube-sa.com',style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      decoration: TextDecoration.underline,

                    ),)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorSnackbar(BuildContext ctx, String message) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

