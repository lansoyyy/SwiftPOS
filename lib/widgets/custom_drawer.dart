import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:para/utils/colors.dart';
import 'package:para/utils/constants.dart';
import 'package:para/widgets/custom_text.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

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
                      borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
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
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                      border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
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
                    isSelected: true,
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  _buildMenuItem(
                    context,
                    icon: FontAwesomeIcons.tableList,
                    title: 'Table',
                    isSelected: false,
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  _buildMenuItem(
                    context,
                    icon: FontAwesomeIcons.chartLine,
                    title: 'Report',
                    isSelected: false,
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  _buildMenuItem(
                    context,
                    icon: FontAwesomeIcons.clockRotateLeft,
                    title: 'History',
                    isSelected: false,
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  _buildMenuItem(
                    context,
                    icon: FontAwesomeIcons.boxesStacked,
                    title: 'Supply',
                    isSelected: false,
                  ),
                ],
              ),
            ),
            // Logout Button
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: InkWell(
                onTap: () {
                  // TODO: Implement logout
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
}
