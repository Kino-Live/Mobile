import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/app/router/router_path.dart';
import 'package:kinolive_mobile/presentation/viewmodels/auth_controller.dart';
import 'package:kinolive_mobile/presentation/viewmodels/profile/profile_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/general/bottom_nav_bar.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    useEffect(() {
      Future.microtask(
            () => ref.read(profileVmProvider.notifier).load(),
      );
      return null;
    }, const []);

    ref.listen(profileVmProvider, (prev, next) {
      if (next.hasError && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!, textAlign: TextAlign.center),
          ),
        );
        ref.read(profileVmProvider.notifier).clearError();
      }
    });

    final state = ref.watch(profileVmProvider);
    final profile = state.profile;

    String fallback(String? value, String fallback) {
      if (value == null || value.trim().isEmpty) return fallback;
      return value;
    }

    Future<void> logout() async {
      await ref.read(authStateProvider.notifier).logout();
    }

    Widget bodyContent;

    if (state.isLoading && profile == null) {
      bodyContent = const Center(child: CircularProgressIndicator());
    } else if (state.hasError && profile == null) {
      bodyContent = _ProfileErrorView(
        message: state.error ?? 'Error loading profile',
        onRetry: () =>
            ref.read(profileVmProvider.notifier).load(),
      );
    } else {
      final String? name = profile?.name;
      final String? email = profile?.email;
      final String? phone = profile?.phone;

      bodyContent = Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 32),

              // --- User Avatar ---
              CircleAvatar(
                radius: 44,
                backgroundColor: Colors.grey.shade800,
                child: const ClipOval(
                  child: Icon(
                    Icons.person,
                    size: 48,
                    color: Colors.white70,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // --- User Info ---
              Text(
                fallback(name, 'None'),
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                fallback(email, 'No email'),
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                fallback(phone, 'No phone'),
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 32),

              // --- Menu Buttons ---
              ProfileMenuButton(
                icon: Icons.confirmation_number_outlined,
                title: 'My tickets',
                onTap: () {
                  context.push(myTicketsPath);
                },
              ),
              const SizedBox(height: 16),

              ProfileMenuButton(
                icon: Icons.history,
                title: 'History',
                onTap: () {
                  context.push(historyPath);
                },
              ),
              const SizedBox(height: 16),

              ProfileMenuButton(
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () {
                  // TODO: navigate to settings
                },
              ),
              const SizedBox(height: 16),

              // --- Logout ---
              ProfileMenuButton(
                icon: Icons.logout,
                title: 'Logout',
                titleColor: const Color(0xFFFF5B5B),
                iconColor: const Color(0xFFFF5B5B),
                onTap: logout,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const ProfileAppBar(),
      body: SafeArea(child: bodyContent),

      // --- Bottom navigation bar ---
      bottomNavigationBar: BottomNavBar(
        initialIndex: 2,
        onResetUi: () {},
      ),
    );
  }
}

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 72,
      centerTitle: false,
      titleSpacing: 0,
      title: SizedBox(
        height: 72,
        child: Center(
          child: Text(
            'Profile',
            style: textTheme.headlineMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileMenuButton extends StatelessWidget {
  const ProfileMenuButton({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.titleColor,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color? titleColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Material(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: iconColor ?? Colors.white,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: titleColor ?? Colors.white,
                    fontWeight: FontWeight.w500,
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

class _ProfileErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ProfileErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error',
                      style: textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: onRetry,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
