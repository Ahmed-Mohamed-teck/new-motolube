import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  bool _deleteAccountSubmitted = false;
  bool _isSubmittingDelete = false;
  DateTime? _deletedDate;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final store = ref.read(secureStoreProvider);
    final name = await store.userName();
    final phone = await store.phoneNumber();
    final email = await store.userEmail();
    final deletedDateValue = appPrefsWithCache.getString(_deletedDateKey);
    final deletedDate =
        deletedDateValue == null ? null : DateTime.tryParse(deletedDateValue);
    if (mounted) {
      setState(() {
        _name = name;
        _phone = phone;
        _email = email;
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
                              child: const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
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
                        onPressed: () {
                          // Navigate to edit profile screen
                        },
                        icon: const Icon(Icons.edit),
                        label: Text(appLang.editProfile),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 45),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDeleteAccountSection(authState),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () async {
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
        return AlertDialog(
          title: Text(appLang.confirmAccountDeletion),
          content: Text(appLang.accountDeletionIrreversible30Days),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(appLang.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                appLang.delete,
                style: const TextStyle(color: Colors.red),
              ),
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
