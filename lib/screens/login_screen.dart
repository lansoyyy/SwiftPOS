import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:para/utils/colors.dart';
import 'package:para/utils/constants.dart';
import 'package:para/widgets/custom_button.dart';
import 'package:para/widgets/custom_text.dart';
import 'package:para/screens/privacy_policy_screen.dart';
import 'package:para/screens/terms_conditions_screen.dart';
import 'package:para/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  String _pin = '';
  String? _selectedCashier;
  bool _isDropdownExpanded = false;
  bool _isShifting = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, String>> _cashiers = [
    {
      'name': 'Brolead',
      'time': '10:00 Am - 22:00 Pm',
      'image': 'placeholder',
      'color': '#FF6B2D'
    },
    {
      'name': 'John Doe',
      'time': '08:00 Am - 20:00 Pm',
      'image': 'placeholder',
      'color': '#4CAF50'
    },
    {
      'name': 'Jane Smith',
      'time': '12:00 Pm - 23:00 Pm',
      'image': 'placeholder',
      'color': '#2196F3'
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

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

  void _onStartShift() async {
    // Handle start shift logic
    if (_selectedCashier != null && _pin.length >= 4) {
      setState(() {
        _isShifting = true;
      });

      // Simulate authentication delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Navigate to dashboard
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const DashboardScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
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
            // Animated decorative elements
            Positioned(
              right: -100,
              bottom: -100,
              child: AnimatedContainer(
                duration: const Duration(seconds: 3),
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              right: 50,
              bottom: 200,
              child: AnimatedContainer(
                duration: const Duration(seconds: 4),
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
                  // Main heading with staggered animation
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 600),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: const CustomText(
                            text: 'Transform Your\nBusiness with',
                            fontSize: 52,
                            fontFamily: 'Bold',
                            color: AppColors.white,
                            maxLines: 2,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 800),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: const CustomText(
                            text: 'SwiftPOS',
                            fontSize: 56,
                            fontFamily: 'Bold',
                            color: AppColors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppConstants.paddingExtraLarge * 2),
                  // Enhanced mockup
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 1000),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: Center(
                            child: Container(
                              width: 420,
                              height: 280,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusLarge),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Person illustration
                                  Positioned(
                                    left: 30,
                                    top: 30,
                                    child: Container(
                                      width: 180,
                                      height: 220,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(
                                            AppConstants.radiusMedium),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: const FaIcon(
                                                FontAwesomeIcons.userTie,
                                                size: 40,
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Container(
                                            width: 100,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            width: 80,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // POS screen
                                  Positioned(
                                    right: 30,
                                    bottom: 30,
                                    child: Container(
                                      width: 220,
                                      height: 170,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            AppConstants.radiusMedium),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 20,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 6,
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Expanded(
                                              child: GridView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4,
                                                  mainAxisSpacing: 6,
                                                  crossAxisSpacing: 6,
                                                ),
                                                itemCount: 16,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColors.background,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
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
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  // Footer text with animation
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 1200),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: const CustomText(
                            text:
                                'Your journey to faster transactions and smoother operations starts here.',
                            fontSize: AppConstants.fontMedium + 2,
                            fontFamily: 'Regular',
                            color: AppColors.white,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginPanel() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
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
                      // Logo with animation
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 600),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primaryDark,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusLarge),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const FaIcon(
                                FontAwesomeIcons.s,
                                color: AppColors.white,
                                size: 36,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppConstants.paddingLarge),
                      // Title with animation
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 800),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: const CustomText.bold(
                                text: 'Cashier Login',
                                fontSize: AppConstants.fontTitle + 4,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      // Subtitle with animation
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1000),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: const CustomText.regular(
                                text:
                                    'Handle transactions effortlessly with the SwiftPOS cashier system.',
                                fontSize: AppConstants.fontSmall + 2,
                                color: AppColors.textSecondary,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppConstants.paddingExtraLarge),
                      // Cashier Dropdown with animation
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1200),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: _buildCashierDropdown(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppConstants.paddingLarge),

                      // Enhanced PIN Input Section
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1400),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 480),
                                padding: const EdgeInsets.all(
                                    AppConstants.paddingLarge + 8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.background,
                                      AppColors.background.withOpacity(0.5),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusLarge),
                                  border: Border.all(
                                    color: AppColors.greyLight.withOpacity(0.3),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    const CustomText.medium(
                                      text: 'Enter Your PIN',
                                      fontSize: AppConstants.fontLarge + 2,
                                      color: AppColors.textPrimary,
                                    ),
                                    const SizedBox(
                                        height: AppConstants.paddingSmall),
                                    const CustomText.regular(
                                      text:
                                          'Please input your PIN to validate yourself',
                                      fontSize: AppConstants.fontSmall + 2,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(
                                        height: AppConstants.paddingLarge),
                                    _buildPinDisplay(),
                                    const SizedBox(
                                        height: AppConstants.paddingLarge),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: AppConstants.paddingLarge),

                      // Enhanced Number Pad
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1600),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: _buildNumberPad(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppConstants.paddingLarge),

                      // Enhanced Start Shift Button
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1800),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 400),
                                child: _isShifting
                                    ? Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              AppColors.primary,
                                              AppColors.primaryDark,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              AppConstants.radiusMedium),
                                        ),
                                        child: const Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          AppColors.white),
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                              CustomText.bold(
                                                text: 'Starting Shift...',
                                                fontSize:
                                                    AppConstants.fontMedium,
                                                color: AppColors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : CustomButton(
                                        text: 'Start Shift',
                                        onPressed: _onStartShift,
                                        height: 56,
                                        backgroundColor:
                                            _selectedCashier != null &&
                                                    _pin.length >= 4
                                                ? AppColors.primary
                                                : AppColors.greyLight,
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Footer with animation
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 2000),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Padding(
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
                                builder: (context) =>
                                    const PrivacyPolicyScreen(),
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
                                builder: (context) =>
                                    const TermsConditionsScreen(),
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCashierDropdown() {
    final selectedCashierData = _cashiers.firstWhere(
      (cashier) => cashier['name'] == _selectedCashier,
      orElse: () => _cashiers.first,
    );

    return Container(
      constraints: const BoxConstraints(maxWidth: 480),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(color: AppColors.greyLight.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
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
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium + 4),
              child: Row(
                children: [
                  // Avatar with gradient
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(int.parse(selectedCashierData['color']!
                              .replaceFirst('#', '0xFF'))),
                          Color(int.parse(selectedCashierData['color']!
                                  .replaceFirst('#', '0xFF')))
                              .withOpacity(0.8),
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMedium),
                      boxShadow: [
                        BoxShadow(
                          color: Color(int.parse(selectedCashierData['color']!
                                  .replaceFirst('#', '0xFF')))
                              .withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: const FaIcon(
                        FontAwesomeIcons.user,
                        size: 24,
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
                          text: selectedCashierData['name']!,
                          fontSize: AppConstants.fontLarge + 2,
                          color: AppColors.textPrimary,
                        ),
                        const SizedBox(height: 2),
                        CustomText.regular(
                          text: selectedCashierData['time']!,
                          fontSize: AppConstants.fontSmall + 2,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                  // Dropdown icon with animation
                  AnimatedRotation(
                    turns: _isDropdownExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.greyLight.withOpacity(0.2),
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusMedium),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.chevronDown,
                        size: 16,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Dropdown items with animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _isDropdownExpanded ? null : 0,
            child: _isDropdownExpanded
                ? Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: AppColors.greyLight.withOpacity(0.3)),
                      ),
                      color: AppColors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(AppConstants.radiusLarge),
                        bottomRight: Radius.circular(AppConstants.radiusLarge),
                      ),
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
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMedium),
                          child: Padding(
                            padding: const EdgeInsets.all(
                                AppConstants.paddingMedium + 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(int.parse(cashier['color']!
                                            .replaceFirst('#', '0xFF'))),
                                        Color(int.parse(cashier['color']!
                                                .replaceFirst('#', '0xFF')))
                                            .withOpacity(0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusMedium),
                                  ),
                                  child: Center(
                                    child: const FaIcon(
                                      FontAwesomeIcons.user,
                                      size: 20,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width: AppConstants.paddingMedium),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText.medium(
                                        text: cashier['name']!,
                                        fontSize: AppConstants.fontMedium + 2,
                                        color: AppColors.textPrimary,
                                      ),
                                      CustomText.regular(
                                        text: cashier['time']!,
                                        fontSize: AppConstants.fontSmall + 2,
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
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildPinDisplay() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(6, (index) {
          final isActive = index < _pin.length;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 54,
            height: 64,
            decoration: BoxDecoration(
              border: Border.all(
                color: isActive
                    ? AppColors.primary
                    : AppColors.greyLight.withOpacity(0.5),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              color: isActive
                  ? AppColors.primary.withOpacity(0.08)
                  : AppColors.white,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: CustomText.bold(
                  key: ValueKey(isActive),
                  text: isActive ? '•' : '',
                  fontSize: 36,
                  color: isActive ? AppColors.primary : Colors.transparent,
                ),
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
      onTap: () {
        _onNumberPressed(number);
        HapticFeedback.lightImpact();
      },
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      splashFactory: InkRipple.splashFactory,
      child: Container(
        width: 84,
        height: 84,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(
            color: AppColors.greyLight.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: CustomText.bold(
          text: number,
          fontSize: AppConstants.fontTitle + 4,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return InkWell(
      onTap: () {
        _onBackspacePressed();
        HapticFeedback.lightImpact();
      },
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      splashFactory: InkRipple.splashFactory,
      child: Container(
        width: 84,
        height: 84,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(
            color: AppColors.error.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.error.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const FaIcon(
          FontAwesomeIcons.deleteLeft,
          size: 26,
          color: AppColors.error,
        ),
      ),
    );
  }
}
