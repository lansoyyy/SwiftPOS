import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:para/utils/colors.dart';
import 'package:para/utils/constants.dart';
import 'package:para/widgets/custom_button.dart';
import 'package:para/widgets/custom_text.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.arrowLeft,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const CustomText.bold(
          text: 'Privacy Policy',
          fontSize: AppConstants.fontTitle,
          color: AppColors.textPrimary,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingExtraLarge),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDark,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.shieldHalved,
                      color: AppColors.primary,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  const CustomText.bold(
                    text: 'SwiftPOS Privacy Policy',
                    fontSize: AppConstants.fontHeading,
                    color: AppColors.white,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  const CustomText.regular(
                    text: 'Last updated: January 2025',
                    fontSize: AppConstants.fontSmall,
                    color: AppColors.white,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingExtraLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      'Introduction',
                      'SwiftPOS ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our Point of Sale (POS) application.',
                    ),
                    _buildSection(
                      'Information We Collect',
                      'We collect information to provide better services to all our users. The types of information we collect include:\n\n'
                          '• Personal Information: Name, email address, phone number, and payment information\n'
                          '• Usage Data: How you interact with our app, features used, and time spent\n'
                          '• Device Information: Device type, operating system, and unique device identifiers\n'
                          '• Transaction Data: Sales records, inventory changes, and business analytics',
                    ),
                    _buildSection(
                      'How We Use Your Information',
                      'We use the information we collect to:\n\n'
                          '• Provide, maintain, and improve our services\n'
                          '• Process transactions and send related information\n'
                          '• Send technical notices and support messages\n'
                          '• Respond to your comments, questions, and requests\n'
                          '• Monitor and analyze trends and usage',
                    ),
                    _buildSection(
                      'Information Sharing',
                      'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this policy:\n\n'
                          '• With your consent\n'
                          '• For legal reasons (compliance with laws, protection of rights)\n'
                          '• With trusted service providers who assist in operating our business',
                    ),
                    _buildSection(
                      'Data Security',
                      'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet is 100% secure.',
                    ),
                    _buildSection(
                      'Data Retention',
                      'We retain your personal information for as long as necessary to provide our services and fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law.',
                    ),
                    _buildSection(
                      'Your Rights',
                      'You have the right to:\n\n'
                          '• Access and update your personal information\n'
                          '• Request deletion of your personal information\n'
                          '• Opt-out of marketing communications\n'
                          '• Request a copy of your data',
                    ),
                    _buildSection(
                      'Children\'s Privacy',
                      'SwiftPOS is not intended for children under the age of 13. We do not knowingly collect personal information from children under 13.',
                    ),
                    _buildSection(
                      'Changes to This Policy',
                      'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date.',
                    ),
                    _buildSection(
                      'Contact Us',
                      'If you have any questions about this Privacy Policy, please contact us at:\n\n'
                          'Email: privacy@swiftpos.com\n'
                          'Phone: +1 (555) 123-4567\n'
                          'Address: 123 Business Ave, Suite 100, City, State 12345',
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    CustomButton(
                      text: 'I Understand',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppConstants.paddingLarge),
        CustomText.bold(
          text: title,
          fontSize: AppConstants.fontLarge,
          color: AppColors.primary,
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        CustomText.regular(
          text: content,
          fontSize: AppConstants.fontMedium,
          color: AppColors.textSecondary,
          maxLines: null,
        ),
      ],
    );
  }
}
