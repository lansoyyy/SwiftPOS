import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:para/utils/colors.dart';
import 'package:para/utils/constants.dart';
import 'package:para/widgets/custom_button.dart';
import 'package:para/widgets/custom_text.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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
          text: 'Terms & Conditions',
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
                      FontAwesomeIcons.fileContract,
                      color: AppColors.primary,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  const CustomText.bold(
                    text: 'SwiftPOS Terms & Conditions',
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
                      'Acceptance of Terms',
                      'By downloading, installing, or using SwiftPOS ("the App"), you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use our App.',
                    ),
                    _buildSection(
                      'Description of Service',
                      'SwiftPOS is a comprehensive Point of Sale (POS) application designed to help businesses manage transactions, inventory, sales analytics, and customer relationships. The service is provided "as is" and may include advertisements or sponsored content.',
                    ),
                    _buildSection(
                      'User Accounts',
                      'To use certain features of the App, you must create an account. You are responsible for:\n\n'
                          '• Providing accurate and complete information\n'
                          '• Maintaining the security of your account credentials\n'
                          '• Notifying us immediately of any unauthorized use\n'
                          '• Being responsible for all activities under your account',
                    ),
                    _buildSection(
                      'Acceptable Use',
                      'You agree to use SwiftPOS only for lawful purposes and in accordance with these Terms. You must not:\n\n'
                          '• Use the App for any illegal or unauthorized purpose\n'
                          '• Attempt to gain unauthorized access to our systems\n'
                          '• Interfere with or disrupt the App or servers\n'
                          '• Use the App to transmit malicious code or harmful content\n'
                          '• Reverse engineer, decompile, or attempt to extract source code',
                    ),
                    _buildSection(
                      'Payment and Subscription',
                      'SwiftPOS offers both free and paid subscription plans. For paid plans:\n\n'
                          '• You agree to pay all fees associated with your subscription\n'
                          '• Payments are processed through secure third-party payment providers\n'
                          '• Subscription fees are non-refundable except as required by law\n'
                          '• We reserve the right to change pricing with 30 days notice',
                    ),
                    _buildSection(
                      'Intellectual Property',
                      'SwiftPOS and its original content, features, and functionality are owned by SwiftPOS Inc. and are protected by international copyright, trademark, and other intellectual property laws.',
                    ),
                    _buildSection(
                      'Privacy',
                      'Your privacy is important to us. Please review our Privacy Policy, which also governs your use of the App, to understand our practices.',
                    ),
                    _buildSection(
                      'Termination',
                      'We may terminate or suspend your account immediately, without prior notice or liability, for any reason, including if you breach the Terms. Upon termination, your right to use the App will cease immediately.',
                    ),
                    _buildSection(
                      'Limitation of Liability',
                      'In no event shall SwiftPOS Inc., nor its directors, employees, partners, agents, or suppliers, be liable for any indirect, incidental, special, consequential, or punitive damages, including loss of profits, data, use, or other intangible losses, resulting from your use of the App.',
                    ),
                    _buildSection(
                      'Disclaimer',
                      'SwiftPOS is provided on an "AS IS" and "AS AVAILABLE" basis. We make no representations or warranties of any kind, express or implied, regarding the operation or availability of the App.',
                    ),
                    _buildSection(
                      'Governing Law',
                      'These Terms shall be interpreted and governed by the laws of the jurisdiction in which SwiftPOS Inc. operates, without regard to conflict of law provisions.',
                    ),
                    _buildSection(
                      'Changes to Terms',
                      'We reserve the right to modify these Terms at any time. If we make material changes, we will notify you by email or by posting a notice in the App prior to the change becoming effective.',
                    ),
                    _buildSection(
                      'Contact Information',
                      'If you have any questions about these Terms and Conditions, please contact us at:\n\n'
                          'Email: legal@swiftpos.com\n'
                          'Phone: +1 (555) 123-4567\n'
                          'Address: 123 Business Ave, Suite 100, City, State 12345',
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    CustomButton(
                      text: 'I Agree',
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
