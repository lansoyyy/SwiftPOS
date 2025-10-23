import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:para/screens/login_screen.dart';
import 'package:para/utils/colors.dart';
import 'package:para/utils/constants.dart';
import 'package:para/widgets/custom_text.dart';
import 'package:para/widgets/custom_button.dart';
import 'package:para/screens/table_screen.dart';
import 'package:para/screens/dashboard_screen.dart';
import 'package:para/screens/orders_screen.dart';
import 'package:para/screens/menu_screen.dart';
import 'package:para/screens/reports_screen.dart';
import 'package:para/screens/history_screen.dart';

class CustomDrawer extends StatelessWidget {
  final String currentRoute;

  const CustomDrawer({super.key, this.currentRoute = 'cashier'});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingSmall),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusSmall),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.s,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  const CustomText.bold(
                    text: 'SwiftPOS',
                    fontSize: AppConstants.fontExtraLarge,
                    color: AppColors.textPrimary,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.xmark,
                      size: 20,
                      color: AppColors.grey,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: AppConstants.paddingMedium),
            // Cashier Section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingLarge,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText.regular(
                    text: 'Cashier',
                    fontSize: AppConstants.fontSmall,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMedium),
                      border: Border.all(
                          color: AppColors.greyLight.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: const FaIcon(
                            FontAwesomeIcons.user,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText.bold(
                                text: 'Broicad',
                                fontSize: AppConstants.fontMedium,
                                color: AppColors.textPrimary,
                              ),
                              const CustomText.regular(
                                text: '10:00 Am - 22:00 Pm',
                                fontSize: AppConstants.fontSmall,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                        const FaIcon(
                          FontAwesomeIcons.chevronDown,
                          size: 14,
                          color: AppColors.grey,
                        ),
                      ],
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
                    context,
                    icon: FontAwesomeIcons.cashRegister,
                    title: 'Cashier',
                    isSelected: currentRoute == 'cashier',
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  _buildMenuItem(
                    context,
                    icon: FontAwesomeIcons.bookmark,
                    title: 'Table',
                    isSelected: currentRoute == 'table',
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  _buildMenuItem(
                    context,
                    icon: FontAwesomeIcons.utensils,
                    title: 'Orders',
                    isSelected: currentRoute == 'orders',
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  const SizedBox(height: AppConstants.paddingSmall),
                  _buildMenuItem(
                    context,
                    icon: FontAwesomeIcons.bars,
                    title: 'Menu',
                    isSelected: currentRoute == 'menu',
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  _buildMenuItem(
                    context,
                    icon: FontAwesomeIcons.chartLine,
                    title: 'Report',
                    isSelected: currentRoute == 'reports',
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  _buildMenuItem(
                    context,
                    icon: FontAwesomeIcons.clockRotateLeft,
                    title: 'History',
                    isSelected: currentRoute == 'history',
                  ),
                ],
              ),
            ),
            // Logout Button
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: InkWell(
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMedium,
                    vertical: AppConstants.paddingMedium,
                  ),
                  child: Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.arrowRightFromBracket,
                        size: 18,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      const CustomText.medium(
                        text: 'Log out',
                        fontSize: AppConstants.fontMedium,
                        color: AppColors.error,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        // Navigate based on title
        if (title == 'Table') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TableScreen()),
          );
        } else if (title == 'Cashier') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        } else if (title == 'Orders') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OrdersScreen()),
          );
        } else if (title == 'Menu') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MenuScreen()),
          );
        } else if (title == 'Report') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ReportsScreen()),
          );
        } else if (title == 'History') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HistoryScreen()),
          );
        }
      },
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingMedium,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        child: Row(
          children: [
            FaIcon(
              icon,
              size: 18,
              color: isSelected ? AppColors.white : AppColors.grey,
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            CustomText.medium(
              text: title,
              fontSize: AppConstants.fontMedium,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.rightFromBracket,
                    size: 48,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                // Title
                const CustomText.bold(
                  text: 'Logout Confirmation',
                  fontSize: AppConstants.fontHeading,
                  color: AppColors.textPrimary,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                // Message
                const CustomText.regular(
                  text: 'Are you sure you want to logout from SwiftPOS?',
                  fontSize: AppConstants.fontMedium,
                  color: AppColors.textSecondary,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingSmall),
                const CustomText.regular(
                  text: 'Any unsaved data will be lost.',
                  fontSize: AppConstants.fontSmall,
                  color: AppColors.textHint,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Cancel',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        isOutlined: true,
                        backgroundColor: AppColors.grey,
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingMedium),
                    Expanded(
                      child: CustomButton(
                        text: 'Logout',
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        backgroundColor: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
