import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:para/utils/colors.dart';
import 'package:para/utils/constants.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4834DF),
              Color(0xFF3422F2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with profile
              Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  children: [
                    // Close button
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.bars,
                          color: AppColors.white,
                          size: 24,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    // Profile Image
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.white,
                          width: 3,
                        ),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://ui-avatars.com/api/?name=Frank+Smith&size=200&background=random',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    // Name
                    const Text(
                      'Frank Smith',
                      style: TextStyle(
                        fontFamily: 'Bold',
                        fontSize: 22,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              // Menu Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingLarge,
                  ),
                  children: [
                    _buildMenuItem(
                      icon: FontAwesomeIcons.user,
                      title: 'My Account',
                      onTap: () {
                        // TODO: Navigate to My Account
                      },
                    ),
                    _buildMenuItem(
                      icon: FontAwesomeIcons.heart,
                      title: 'Favourites',
                      onTap: () {
                        // TODO: Navigate to Favourites
                      },
                    ),
                    _buildMenuItem(
                      icon: FontAwesomeIcons.circleQuestion,
                      title: 'FAQ',
                      onTap: () {
                        // TODO: Navigate to FAQ
                      },
                    ),
                    _buildMenuItem(
                      icon: FontAwesomeIcons.fileLines,
                      title: 'Make Complaints',
                      onTap: () {
                        // TODO: Navigate to Make Complaints
                      },
                    ),
                    _buildMenuItem(
                      icon: FontAwesomeIcons.bell,
                      title: 'Notification',
                      onTap: () {
                        // TODO: Navigate to Notification
                      },
                    ),
                    _buildMenuItem(
                      icon: FontAwesomeIcons.circleInfo,
                      title: 'About',
                      onTap: () {
                        // TODO: Navigate to About
                      },
                    ),
                    _buildMenuItem(
                      icon: FontAwesomeIcons.shield,
                      title: 'Privacy Policy',
                      onTap: () {
                        // TODO: Navigate to Privacy Policy
                      },
                    ),
                    _buildMenuItem(
                      icon: FontAwesomeIcons.fileContract,
                      title: 'Terms & Condition',
                      onTap: () {
                        // TODO: Navigate to Terms & Condition
                      },
                    ),
                  ],
                ),
              ),
              // Logout Button
              Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: _buildMenuItem(
                  icon: FontAwesomeIcons.rightFromBracket,
                  title: 'Logout',
                  onTap: () {
                    // TODO: Implement logout
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.paddingMedium,
            horizontal: AppConstants.paddingSmall,
          ),
          child: Row(
            children: [
              FaIcon(
                icon,
                color: AppColors.white,
                size: 20,
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Regular',
                  fontSize: AppConstants.fontMedium,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
