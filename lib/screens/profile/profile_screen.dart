import 'package:flutter/material.dart';
import 'package:mindpath/core/constants/app_colors.dart';
import 'package:mindpath/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.morningGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),

                // Profile Header
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: AppColors.pastelGreen,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  authService.currentUser?.email ?? 'Kullanıcı',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 32),

                // Stats Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          '0',
                          'Meditasyon\nDakikası',
                          Icons.self_improvement,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          '0',
                          'Günlük\nGiriş',
                          Icons.book,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          '0',
                          'Gün\nSeri',
                          Icons.local_fire_department,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          '0',
                          'Tamamlanan\nKurs',
                          Icons.school,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Menu Items
                Container(
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        context,
                        Icons.settings_outlined,
                        'Ayarlar',
                        () {},
                      ),
                      _buildMenuItem(
                        context,
                        Icons.notifications_outlined,
                        'Bildirimler',
                        () {},
                      ),
                      _buildMenuItem(
                        context,
                        Icons.help_outline,
                        'Yardım & Destek',
                        () {},
                      ),
                      _buildMenuItem(
                        context,
                        Icons.info_outline,
                        'Hakkında',
                        () {},
                      ),
                      _buildMenuItem(
                        context,
                        Icons.logout,
                        'Çıkış Yap',
                        () async {
                          await authService.signOut();
                          if (context.mounted) {
                            Navigator.of(context).pushReplacementNamed('/');
                          }
                        },
                        isDestructive: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: AppColors.pastelGreen,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.mediumGray,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppColors.darkGray,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : AppColors.darkGray,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

