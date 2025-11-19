import 'package:flutter/material.dart';
import 'package:kinolive_mobile/presentation/widgets/general/bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF111218),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 32),

                // --- Page Title ---
                Text(
                  'Profile',
                  style: textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF04D361), // green accent color
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 32),

                // --- User Avatar ---
                const CircleAvatar(
                  radius: 44,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                  // Replace with Icon(...) if no image available
                ),

                const SizedBox(height: 16),

                // --- User Info (Name, Email, Phone) ---
                Text(
                  'Marybeth Walker',
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'marybethwalker@gmail.com',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '+268 000000000',
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
                  icon: Icons.credit_card_outlined,
                  title: 'My credit cards',
                  onTap: () {
                    // TODO: navigate to credit cards screen
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

                // --- Logout button (red color) ---
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
    final background = const Color(0xFF242633);

    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Material(
        color: background,
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
