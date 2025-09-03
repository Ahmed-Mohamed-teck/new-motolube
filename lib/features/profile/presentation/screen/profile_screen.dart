import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/core/providers/global_lang_provider.dart';
import 'package:newmotorlube/core/utils/extensions/extensions.dart';
import 'package:newmotorlube/features/auth/presentation/view_model/auth_state.dart';
import 'package:newmotorlube/features/auth/provider/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final authVm = ref.read(authViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(
          title: Text(appLang.profileAppbar,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),),
      leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
      ),),
          body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: authState is AuthenticatedState ? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Profile Photo
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: const AssetImage('assets/images/default_avatar.png'),
                  backgroundColor: Colors.grey[300],
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
                    child:  Icon(
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
          // User Information
          _buildInfoTile(Icons.person, 'Name', 'John Doe'),
          _buildInfoTile(Icons.phone, 'Phone', '+1234567890'),
          _buildInfoTile(Icons.email, 'Email', 'john.doe@example.com'),
          const SizedBox(height: 40),
          // Edit Profile Button
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to edit profile screen
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 45),
            ),
          ),
          const SizedBox(height: 16),
          // Logout Button
          OutlinedButton.icon(
            onPressed: () {
              authVm.unAuthenticate();
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 45),
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ):Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            'Please log in to view your profile',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to login screen
              Navigator.pushReplacementNamed(context, 'loginScreen');
            },
            child: const Text('Login'),
          ),
        ],
      )
    ),

    );
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}