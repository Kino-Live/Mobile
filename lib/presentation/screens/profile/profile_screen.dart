import 'package:flutter/material.dart';
import 'package:kinolive_mobile/presentation/widgets/general/bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final String? name = null;
    final String? email = null;
    final String? phone = null;

    String fallback(String? value, String fallback) {
      if (value == null || value.trim().isEmpty) {
        return fallback;
      }
      return value;
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,

      appBar: const ProfileAppBar(),

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 32),

                // --- User Avatar with fallback icon ---
                CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.grey.shade800,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/profile.jpg',
                      fit: BoxFit.cover,
                      width: 88,
                      height: 88,
                      errorBuilder: (context, error, stackTrace) {
                        // If image fails to load, show default profile icon
                        return const Icon(
                          Icons.person,
                          size: 48,
                          color: Colors.white70,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // --- User Info (Name, Email, Phone) ---
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

                // --- Profile menu buttons ---
                ProfileMenuButton(
                  icon: Icons.confirmation_number_outlined,
                  title: 'My tickets',
                  onTap: () {
                    // TODO: navigate to tickets screen
                  },
                ),
                const SizedBox(height: 16),

                ProfileMenuButton(
                  icon: Icons.history,
                  title: 'History',
                  onTap: () {
                    // TODO: navigate to history screen
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

                // --- Logout button (red accent) ---
                ProfileMenuButton(
                  icon: Icons.logout,
                  title: 'Logout',
                  titleColor: const Color(0xFFFF5B5B),
                  iconColor: const Color(0xFFFF5B5B),
                  onTap: () {
                    // TODO: add actual logout handler
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logout tapped')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      // --- Bottom navigation bar ---
      bottomNavigationBar: BottomNavBar(
        initialIndex: 2, // 0 - Billboard, 1 - Coming Soon, 2 - Profile
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

/// A reusable widget for profile menu buttons
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
        // Uses app theme surfaceContainer color
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
