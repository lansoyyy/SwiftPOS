import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:para/utils/colors.dart';
import 'package:para/utils/constants.dart';
import 'package:para/widgets/custom_button.dart';
import 'package:para/widgets/custom_text.dart';
import 'package:para/screens/privacy_policy_screen.dart';
import 'package:para/screens/terms_conditions_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _pin = '';
  String? _selectedCashier;
  bool _isDropdownExpanded = false;

  final List<Map<String, String>> _cashiers = [
    {'name': 'Brolead', 'time': '10:00 Am - 22:00 Pm', 'image': 'placeholder'},
    {'name': 'John Doe', 'time': '08:00 Am - 20:00 Pm', 'image': 'placeholder'},
    {
      'name': 'Jane Smith',
      'time': '12:00 Pm - 23:00 Pm',
      'image': 'placeholder'
    },
  ];

  void _onNumberPressed(String number) {
    if (_pin.length < 6) {
      setState(() {
        _pin += number;
      });
    }
  }

  void _onBackspacePressed() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _onStartShift() {
    // Handle start shift logic
    if (_selectedCashier != null && _pin.length >= 4) {
      // Navigate to main screen or validate PIN
      print('Starting shift for $_selectedCashier with PIN: $_pin');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWideScreen = size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Row(
        children: [
          // Left Panel - Branding
          if (isWideScreen)
            Expanded(
              flex: 5,
              child: _buildBrandingPanel(),
            ),
          // Right Panel - Login Form
          Expanded(
            flex: isWideScreen ? 5 : 1,
            child: _buildLoginPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandingPanel() {
    return Container(
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
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -100,
            bottom: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            right: 50,
            bottom: 200,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingExtraLarge * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingSmall),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusSmall),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.s,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Main heading
                const CustomText(
                  text: 'Transform Your\nBusiness with',
                  fontSize: 48,
                  fontFamily: 'Bold',
                  color: AppColors.white,
                  maxLines: 2,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.s,
                      color: AppColors.white,
                      size: 32,
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    const CustomText(
                      text: 'SwiftPOS',
                      fontSize: 48,
                      fontFamily: 'Bold',
                      color: AppColors.white,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingExtraLarge * 2),
                // Image mockup
                Center(
                  child: Container(
                    width: 400,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusLarge),
                    ),
                    child: Stack(
                      children: [
                        // Placeholder for person image
                        Positioned(
                          left: 20,
                          top: 20,
                          child: Container(
                            width: 180,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                  AppConstants.radiusMedium),
                            ),
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.user,
                                size: 80,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        // Placeholder for POS screen
                        Positioned(
                          right: 20,
                          bottom: 20,
                          child: Container(
                            width: 200,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  AppConstants.radiusSmall),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  AppConstants.paddingSmall),
                              child: Column(
                                children: [
                                  Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: GridView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        mainAxisSpacing: 4,
                                        crossAxisSpacing: 4,
                                      ),
                                      itemCount: 12,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.background,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                // Footer text
                const CustomText(
                  text:
                      'Your journey to faster transactions and smoother operations starts here.',
                  fontSize: AppConstants.fontMedium,
                  fontFamily: 'Regular',
                  color: AppColors.white,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginPanel() {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.all(AppConstants.paddingExtraLarge * 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusMedium),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.s,
                        color: AppColors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    // Title
                    const CustomText.bold(
                      text: 'Cashier Login',
                      fontSize: AppConstants.fontTitle,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    // Subtitle
                    const CustomText.regular(
                      text:
                          'Handle transactions effortlessly with the SwiftPOS cashier system.',
                      fontSize: AppConstants.fontSmall,
                      color: AppColors.textSecondary,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.paddingExtraLarge),
                    // Cashier Dropdown
                    _buildCashierDropdown(),
                    const SizedBox(height: AppConstants.paddingLarge),

                    // PIN Input Section
                    Container(
                      constraints: const BoxConstraints(maxWidth: 450),
                      padding: const EdgeInsets.all(AppConstants.paddingLarge),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusLarge),
                        border: Border.all(
                          color: AppColors.greyLight.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          const CustomText.medium(
                            text: 'Enter Your PIN',
                            fontSize: AppConstants.fontLarge,
                            color: AppColors.textPrimary,
                          ),
                          const SizedBox(height: AppConstants.paddingSmall),
                          const CustomText.regular(
                            text: 'Please input your PIN to validate yourself',
                            fontSize: AppConstants.fontSmall,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: AppConstants.paddingLarge),
                          _buildPinDisplay(),
                          const SizedBox(height: AppConstants.paddingLarge),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppConstants.paddingLarge),

                    // Number Pad
                    _buildNumberPad(),
                    const SizedBox(height: AppConstants.paddingLarge),

                    // Start Shift Button
                    Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: CustomButton(
                        text: 'Start Shift',
                        onPressed: _onStartShift,
                        height: 56,
                        backgroundColor:
                            _selectedCashier != null && _pin.length >= 4
                                ? AppColors.primary
                                : AppColors.greyLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Footer
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomText.regular(
                  text: '©2025 SwiftPOS Inc. All rights reserved.',
                  fontSize: AppConstants.fontSmall,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppConstants.paddingLarge),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen(),
                      ),
                    );
                  },
                  child: const CustomText.regular(
                    text: 'Privacy Policy',
                    fontSize: AppConstants.fontSmall,
                    color: AppColors.textSecondary,
                  ),
                ),
                const CustomText.regular(
                  text: ' | ',
                  fontSize: AppConstants.fontSmall,
                  color: AppColors.textSecondary,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TermsConditionsScreen(),
                      ),
                    );
                  },
                  child: const CustomText.regular(
                    text: 'Terms & Conditions',
                    fontSize: AppConstants.fontSmall,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashierDropdown() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 450),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isDropdownExpanded = !_isDropdownExpanded;
              });
            },
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.primaryDark,
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                    child: Center(
                      child: const FaIcon(
                        FontAwesomeIcons.user,
                        size: 20,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  // Name and time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText.bold(
                          text: _selectedCashier ?? 'Brolead',
                          fontSize: AppConstants.fontLarge,
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
                  // Dropdown icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.greyLight.withOpacity(0.3),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusSmall),
                    ),
                    child: FaIcon(
                      _isDropdownExpanded
                          ? FontAwesomeIcons.chevronUp
                          : FontAwesomeIcons.chevronDown,
                      size: 14,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Dropdown items
          if (_isDropdownExpanded)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.border),
                ),
                color: AppColors.white,
              ),
              child: Column(
                children: _cashiers.skip(1).map((cashier) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCashier = cashier['name'];
                        _isDropdownExpanded = false;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.greyLight,
                              borderRadius: BorderRadius.circular(
                                  AppConstants.radiusSmall),
                            ),
                            child: Center(
                              child: const FaIcon(
                                FontAwesomeIcons.user,
                                size: 18,
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppConstants.paddingMedium),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText.medium(
                                  text: cashier['name']!,
                                  fontSize: AppConstants.fontMedium,
                                  color: AppColors.textPrimary,
                                ),
                                CustomText.regular(
                                  text: cashier['time']!,
                                  fontSize: AppConstants.fontSmall,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPinDisplay() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(6, (index) {
          return Container(
            width: 50,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: index < _pin.length
                    ? AppColors.primary
                    : AppColors.greyLight,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              color: index < _pin.length
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.white,
            ),
            child: Center(
              child: CustomText.bold(
                text: index < _pin.length ? '•' : '',
                fontSize: 32,
                color: index < _pin.length
                    ? AppColors.primary
                    : Colors.transparent,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        children: [
          // Row 1: 1, 2, 3
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton('1'),
              _buildNumberButton('2'),
              _buildNumberButton('3'),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          // Row 2: 4, 5, 6
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton('4'),
              _buildNumberButton('5'),
              _buildNumberButton('6'),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          // Row 3: 7, 8, 9
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton('7'),
              _buildNumberButton('8'),
              _buildNumberButton('9'),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          // Row 4: empty, 0, backspace
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 80, height: 80), // Empty space
              _buildNumberButton('0'),
              _buildBackspaceButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return InkWell(
      onTap: () => _onNumberPressed(number),
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(
            color: AppColors.greyLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CustomText.bold(
          text: number,
          fontSize: AppConstants.fontTitle,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return InkWell(
      onTap: _onBackspacePressed,
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.greyLight.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(
            color: AppColors.greyLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const FaIcon(
          FontAwesomeIcons.deleteLeft,
          size: 24,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
