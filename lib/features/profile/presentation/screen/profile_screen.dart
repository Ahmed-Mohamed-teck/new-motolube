import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:newmotorlube/core/providers/general_providers.dart';
import 'package:newmotorlube/core/providers/secure_storage.dart';
import 'package:newmotorlube/core/utils/extensions/extensions.dart';
import 'package:newmotorlube/features/auth/presentation/view_model/auth_state.dart';
import 'package:newmotorlube/features/auth/provider/auth_provider.dart';
import 'package:newmotorlube/generated/l10n.dart';

const _deleteAccountSubmittedKey = 'deleteAccountSubmittedKey';
const _deletedDateKey = 'deletedDate';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? _name;
  String? _phone;
  String? _email;
  String? _profilePhotoBase64;
  Uint8List? _profilePhotoBytes;
  bool _deleteAccountSubmitted = false;
  bool _isSubmittingDelete = false;
  bool _isUpdatingProfile = false;
  DateTime? _deletedDate;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final store = ref.read(secureStoreProvider);
    final authState = ref.read(authViewModelProvider);
    final authenticatedUser =
        authState is AuthenticatedState ? authState.user : null;
    final name = authenticatedUser?.name ?? await store.userName();
    final phone = authenticatedUser?.mobileNo ?? await store.phoneNumber();
    final email = authenticatedUser?.email ?? await store.userEmail();
    final profilePhotoBase64 =
        authenticatedUser == null
            ? null
            : authenticatedUser.photoBase64 ??
                appPrefsWithCache.getString(
                  _profilePhotoStorageKey(authenticatedUser.oracleId),
                );
    final deletedDateValue = appPrefsWithCache.getString(_deletedDateKey);
    final deletedDate =
        deletedDateValue == null ? null : DateTime.tryParse(deletedDateValue);
    if (mounted) {
      setState(() {
        _name = name;
        _phone = phone;
        _email = email;
        _profilePhotoBase64 = profilePhotoBase64;
        _profilePhotoBytes = _decodePhoto(profilePhotoBase64);
        _deleteAccountSubmitted =
            appPrefsWithCache.getBool(_deleteAccountSubmittedKey) ?? false;
        _deletedDate = deletedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLang = S.of(context);
    final authState = ref.watch(authViewModelProvider);
    final authVm = ref.read(authViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLang.profileAppbar,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            authState is AuthenticatedState
                ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey[300],
                              backgroundImage:
                                  _profilePhotoBytes == null
                                      ? null
                                      : MemoryImage(_profilePhotoBytes!),
                              child:
                                  _profilePhotoBytes == null
                                      ? const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.white,
                                      )
                                      : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap:
                                    _isUpdatingProfile
                                        ? null
                                        : () => _editProfile(authState),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: context.appColors.secondary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: context.appColors.surface,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildInfoTile(Icons.person, appLang.name, _name ?? ''),
                      _buildInfoTile(
                        Icons.phone,
                        appLang.phoneNumber,
                        _phone ?? '',
                      ),
                      _buildInfoTile(Icons.email, appLang.email, _email ?? ''),
                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed:
                            _isUpdatingProfile
                                ? null
                                : () => _editProfile(authState),
                        icon:
                            _isUpdatingProfile
                                ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Icon(Icons.edit),
                        label: Text(appLang.editProfile),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 45),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDeleteAccountSection(authState),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed:
                            _isUpdatingProfile
                                ? null
                                : () async {
                                  await authVm.unAuthenticate();
                                  if (!mounted) return;
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    'loginScreen',
                                    (route) => false,
                                  );
                                },
                        icon: const Icon(Icons.logout),
                        label: Text(appLang.logout),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 45),
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person, size: 100, color: Colors.grey),
                    const SizedBox(height: 20),
                    Text(
                      appLang.pleaseLogInToViewYourProfile,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, 'loginScreen');
                      },
                      child: Text(appLang.login),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildDeleteAccountSection(AuthenticatedState authState) {
    final appLang = S.of(context);
    if (_deleteAccountSubmitted) {
      final date =
          _deletedDate == null
              ? ''
              : DateFormat('dd/MM/yyyy').format(_deletedDate!);
      final message =
          date.isEmpty
              ? appLang.accountDeletionRequestSubmitted
              : appLang.accountDeletionSubmittedMessage(date);
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red[50],
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed:
          _isSubmittingDelete ? null : () => _confirmDeleteAccount(authState),
      icon:
          _isSubmittingDelete
              ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : const Icon(Icons.delete_outline),
      label: Text(appLang.deleteAccount),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 45),
        foregroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
      ),
    );
  }

  Future<void> _confirmDeleteAccount(AuthenticatedState authState) async {
    final appLang = S.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
          actionsPadding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          title: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red.shade700,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  appLang.confirmAccountDeletion,
                  style: Theme.of(dialogContext).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            appLang.accountDeletionIrreversible30Days,
            style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.onSurfaceVariant,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
              ),
              child: Text(
                appLang.cancel,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.delete_outline, size: 18),
              label: Text(appLang.delete),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    final email = _resolveAccountEmail(authState);
    if (email == null) {
      _showSnackBar(appLang.accountDeletionEmailMissing);
      return;
    }

    setState(() {
      _isSubmittingDelete = true;
    });

    try {
      await ref.read(deleteUserAccountUseCaseProvider).call(email);
      final now = DateTime.now();
      await appPrefsWithCache.setBool(_deleteAccountSubmittedKey, true);
      await appPrefsWithCache.setString(_deletedDateKey, now.toIso8601String());

      if (!mounted) return;
      setState(() {
        _deleteAccountSubmitted = true;
        _deletedDate = now;
      });
    } catch (_) {
      if (!mounted) return;
      _showSnackBar(appLang.accountDeletionFailed);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingDelete = false;
        });
      }
    }
  }

  String? _resolveAccountEmail(AuthenticatedState authState) {
    final stateEmail = authState.user.email?.trim();
    if (stateEmail != null && stateEmail.isNotEmpty) {
      return stateEmail;
    }

    final storedEmail = _email?.trim();
    if (storedEmail != null && storedEmail.isNotEmpty) {
      return storedEmail;
    }

    return null;
  }

  Future<void> _editProfile(AuthenticatedState authState) async {
    final draft = await showDialog<_ProfileUpdateDraft>(
      context: context,
      builder:
          (dialogContext) => _EditProfileDialog(
            initialEmail: _email ?? authState.user.email,
            initialPhotoBase64:
                _profilePhotoBase64 ?? authState.user.photoBase64,
          ),
    );
    if (draft == null || !mounted) return;

    setState(() {
      _isUpdatingProfile = true;
    });

    try {
      await ref
          .read(authViewModelProvider.notifier)
          .updateProfile(email: draft.email, photoBase64: draft.photoBase64);
      await appPrefsWithCache.setString(
        _profilePhotoStorageKey(authState.user.oracleId),
        draft.photoBase64,
      );

      if (!mounted) return;
      setState(() {
        _email = draft.email;
        _profilePhotoBase64 = draft.photoBase64;
        _profilePhotoBytes = _decodePhoto(draft.photoBase64);
      });
      _showSnackBar(S.of(context).profileUpdatedSuccessfully);
    } catch (_) {
      if (!mounted) return;
      _showSnackBar(S.of(context).profileUpdateFailed);
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingProfile = false;
        });
      }
    }
  }

  String _profilePhotoStorageKey(String oracleId) =>
      'profilePhotoBase64_$oracleId';

  Uint8List? _decodePhoto(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      final encoded = value.contains(',') ? value.split(',').last : value;
      return base64Decode(encoded);
    } on FormatException {
      return null;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: context.appColors.secondary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileUpdateDraft {
  final String? email;
  final String photoBase64;

  const _ProfileUpdateDraft({required this.email, required this.photoBase64});
}

class _EditProfileDialog extends StatefulWidget {
  final String? initialEmail;
  final String? initialPhotoBase64;

  const _EditProfileDialog({
    required this.initialEmail,
    required this.initialPhotoBase64,
  });

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  late final TextEditingController _emailController;
  String? _photoBase64;
  Uint8List? _photoBytes;
  String? _photoError;
  bool _isPickingPhoto = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    _photoBase64 = widget.initialPhotoBase64;
    _photoBytes = _decodePhoto(widget.initialPhotoBase64);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    if (_isPickingPhoto) return;
    setState(() {
      _isPickingPhoto = true;
      _photoError = null;
    });

    try {
      final photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (photo == null) return;
      final bytes = await photo.readAsBytes();
      if (!mounted) return;
      setState(() {
        _photoBytes = bytes;
        _photoBase64 = base64Encode(bytes);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _photoError = S.of(context).profilePhotoSelectionFailed;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isPickingPhoto = false;
        });
      }
    }
  }

  void _submit() {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    final hasPhoto = _photoBase64?.isNotEmpty ?? false;
    setState(() {
      _photoError = hasPhoto ? null : S.of(context).profilePhotoRequired;
    });
    if (!isFormValid || !hasPhoto) return;

    final email = _emailController.text.trim();
    Navigator.of(context).pop(
      _ProfileUpdateDraft(
        email: email.isEmpty ? null : email,
        photoBase64: _photoBase64!,
      ),
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return null;
    final isValid = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
    return isValid ? null : S.of(context).enterValidEmail;
  }

  Uint8List? _decodePhoto(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      final encoded = value.contains(',') ? value.split(',').last : value;
      return base64Decode(encoded);
    } on FormatException {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLang = S.of(context);
    return AlertDialog(
      title: Text(appLang.editProfile),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: _isPickingPhoto ? null : _pickPhoto,
                customBorder: const CircleBorder(),
                child: CircleAvatar(
                  radius: 52,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      _photoBytes == null ? null : MemoryImage(_photoBytes!),
                  child:
                      _isPickingPhoto
                          ? const CircularProgressIndicator()
                          : _photoBytes == null
                          ? const Icon(
                            Icons.add_a_photo_outlined,
                            size: 38,
                            color: Colors.white,
                          )
                          : null,
                ),
              ),
              TextButton.icon(
                onPressed: _isPickingPhoto ? null : _pickPhoto,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(appLang.changeProfilePhoto),
              ),
              if (_photoError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    _photoError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: appLang.email,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                validator: _validateEmail,
                onFieldSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(appLang.cancel),
        ),
        ElevatedButton.icon(
          onPressed: _isPickingPhoto ? null : _submit,
          icon: const Icon(Icons.save_outlined),
          label: Text(appLang.saveChanges),
        ),
      ],
    );
  }
}
