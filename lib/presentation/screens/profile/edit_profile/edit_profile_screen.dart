import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/presentation/screens/profile/edit_profile/edit_profile_form.dart';
import 'package:kinolive_mobile/presentation/viewmodels/profile/edit_profile_vm.dart';
import 'package:kinolive_mobile/presentation/viewmodels/profile/profile_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/general/loading_overlay.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  bool _hasUnsavedChanges = false;
  String? _lastInitializedEmail;
  bool _statusReset = false;

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) {
      return true;
    }

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text('You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileVmProvider);
    final editState = ref.watch(editProfileVmProvider);

    // Reset any old success/error status when opening the screen (only once)
    if (!_statusReset && 
        (editState.status == EditProfileStatus.success || 
         editState.status == EditProfileStatus.error)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _statusReset = true;
          ref.read(editProfileVmProvider.notifier).resetStatus();
        }
      });
    }

    // Initialize profile only once per user (when email changes or first time)
    if (profileState.profile != null) {
      final currentProfile = profileState.profile!;
      final currentEmail = currentProfile.email;
      
      // Only update if this is a different user (email changed) or first initialization
      if (_lastInitializedEmail != currentEmail) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _lastInitializedEmail != currentEmail) {
            _lastInitializedEmail = currentEmail;
            ref.read(editProfileVmProvider.notifier).setInitialProfile(currentProfile);
          }
        });
      }
    }

    ref.listen(editProfileVmProvider, (prev, next) {
      // Only handle new success status (not old ones from previous sessions)
      if (prev?.status != EditProfileStatus.success && 
          next.status == EditProfileStatus.success) {
        if (mounted) {
          setState(() {
            _hasUnsavedChanges = false;
          });
        }
        
        final navigatorContext = context;
        final scaffoldMessenger = ScaffoldMessenger.of(navigatorContext);
        
        Future.microtask(() {
          ref.read(profileVmProvider.notifier).load();
        });
        
        if (mounted && navigatorContext.mounted) {
          Navigator.of(navigatorContext).pop();
        }
        
        Future.delayed(const Duration(milliseconds: 300), () {
          if (scaffoldMessenger.mounted) {
            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully', textAlign: TextAlign.center),
                duration: Duration(seconds: 2),
              ),
            );
          }
        });
      }
      
      // Handle errors
      if (prev?.status != EditProfileStatus.error && 
          next.status == EditProfileStatus.error && 
          next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!, textAlign: TextAlign.center),
            duration: const Duration(seconds: 4),
          ),
        );
        ref.read(editProfileVmProvider.notifier).clearError();
      }
    });

    final isLoading = editState.status == EditProfileStatus.loading;

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (!didPop && _hasUnsavedChanges) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(
            'Edit Profile',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          centerTitle: true,
        ),
      body: SafeArea(
        child: LoadingOverlay(
          loading: isLoading,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: profileState.profile != null
                ? EditProfileForm(
                    onChanged: () {
                      setState(() {
                        _hasUnsavedChanges = true;
                      });
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
      ),
    );
  }
}

