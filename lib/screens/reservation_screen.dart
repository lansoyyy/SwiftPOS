import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/reservation_model.dart';
import '../services/reservation_service.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_field.dart';

class ReservationScreen extends StatefulWidget {
  final int? initialTableNumber;

  const ReservationScreen({
    super.key,
    this.initialTableNumber,
  });

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _guestsController = TextEditingController(text: '2');
  final _specialRequestsController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int? _selectedTable;
  String _selectedOccasion = ReservationOccasion.regularDining;
  List<String> _selectedPreferences = [];
  bool _isWalkIn = false;
  bool _isLoading = false;

  List<int> _availableTables = [];
  List<ReservationModel> _existingReservations = [];

  @override
  void initState() {
    super.initState();
    _selectedTable = widget.initialTableNumber;
    _selectedDate = DateTime.now();
    _selectedTime = const TimeOfDay(hour: 19, minute: 0); // Default 7:00 PM
    _loadAvailableTables();
    _loadExistingReservations();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _guestsController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
  }

  Future<void> _loadAvailableTables() async {
    if (_selectedDate != null && _selectedTime != null) {
      final tables = await ReservationService.instance
          .getAvailableTables(_selectedDate!, _selectedTime!, 20);
      setState(() {
        _availableTables = tables;
        if (_selectedTable == null ||
            !_availableTables.contains(_selectedTable)) {
          _selectedTable =
              _availableTables.isNotEmpty ? _availableTables.first : null;
        }
      });
    }
  }

  Future<void> _loadExistingReservations() async {
    final reservations =
        await ReservationService.instance.getTodayReservations();
    setState(() {
      _existingReservations = reservations;
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      _loadAvailableTables();
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 19, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
      _loadAvailableTables();
    }
  }

  void _togglePreference(String preference) {
    setState(() {
      if (_selectedPreferences.contains(preference)) {
        _selectedPreferences.remove(preference);
      } else {
        _selectedPreferences.add(preference);
      }
    });
  }

  Future<void> _submitReservation() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null ||
        _selectedTime == null ||
        _selectedTable == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select date, time, and table'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final reservation = ReservationModel.create(
        customerName: _nameController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        customerEmail: _emailController.text.trim(),
        tableNumber: _selectedTable!,
        reservationDate: _selectedDate!,
        reservationTime: _selectedTime!,
        numberOfGuests: int.parse(_guestsController.text),
        occasion: _selectedOccasion,
        specialRequests: _specialRequestsController.text.trim(),
        isWalkIn: _isWalkIn,
        preferences: _selectedPreferences,
      );

      final success =
          await ReservationService.instance.createReservation(reservation);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reservation created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Failed to create reservation. Table may be unavailable.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const CustomText.bold(
          text: 'Make Reservation',
          fontSize: AppConstants.fontLarge,
          color: AppColors.textPrimary,
        ),
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Customer Information'),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildCustomerInfo(),
              const SizedBox(height: AppConstants.paddingLarge),
              _buildSectionTitle('Reservation Details'),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildReservationDetails(),
              const SizedBox(height: AppConstants.paddingLarge),
              _buildSectionTitle('Table Selection'),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildTableSelection(),
              const SizedBox(height: AppConstants.paddingLarge),
              _buildSectionTitle('Occasion & Preferences'),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildOccasionAndPreferences(),
              const SizedBox(height: AppConstants.paddingLarge),
              _buildSpecialRequests(),
              const SizedBox(height: AppConstants.paddingLarge),
              _buildWalkInOption(),
              const SizedBox(height: AppConstants.paddingLarge),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return CustomText.bold(
      text: title,
      fontSize: AppConstants.fontLarge,
      color: AppColors.textPrimary,
    );
  }

  Widget _buildCustomerInfo() {
    return CustomCard(
      child: Column(
        children: [
          CustomTextField(
            controller: _nameController,
            labelText: 'Full Name',
            hintText: 'Enter your full name',
            prefixIcon: FontAwesomeIcons.user,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          CustomTextField(
            controller: _phoneController,
            labelText: 'Phone Number',
            hintText: '+639XXXXXXXXX',
            prefixIcon: FontAwesomeIcons.phone,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your phone number';
              }
              if (!RegExp(r'^\+639\d{9}$').hasMatch(value.trim())) {
                return 'Please enter a valid Philippine phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          CustomTextField(
            controller: _emailController,
            labelText: 'Email Address',
            hintText: 'Enter your email',
            prefixIcon: FontAwesomeIcons.envelope,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value.trim())) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          CustomTextField(
            controller: _guestsController,
            labelText: 'Number of Guests',
            hintText: '2',
            prefixIcon: FontAwesomeIcons.users,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter number of guests';
              }
              final guests = int.tryParse(value);
              if (guests == null || guests < 1 || guests > 20) {
                return 'Please enter a valid number (1-20)';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReservationDetails() {
    return CustomCard(
      child: Column(
        children: [
          // Date Selection
          GestureDetector(
            onTap: _selectDate,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyLight),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.calendar,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: CustomText.medium(
                      text: _selectedDate != null
                          ? DateFormat('EEEE, MMMM d, y').format(_selectedDate!)
                          : 'Select Date',
                      color: _selectedDate != null
                          ? AppColors.textPrimary
                          : AppColors.textHint,
                    ),
                  ),
                  const FaIcon(
                    FontAwesomeIcons.chevronDown,
                    color: AppColors.grey,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),

          // Time Selection
          GestureDetector(
            onTap: _selectTime,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyLight),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.clock,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: CustomText.medium(
                      text: _selectedTime != null
                          ? _selectedTime!.format(context)
                          : 'Select Time',
                      color: _selectedTime != null
                          ? AppColors.textPrimary
                          : AppColors.textHint,
                    ),
                  ),
                  const FaIcon(
                    FontAwesomeIcons.chevronDown,
                    color: AppColors.grey,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableSelection() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_availableTables.isEmpty)
            const CustomText.medium(
              text: 'No available tables for selected date and time',
              color: AppColors.warning,
            )
          else
            CustomText.medium(
              text: '${_availableTables.length} tables available',
              color: AppColors.success,
            ),
          const SizedBox(height: AppConstants.paddingMedium),
          Wrap(
            spacing: AppConstants.paddingSmall,
            runSpacing: AppConstants.paddingSmall,
            children: _availableTables.map((tableNumber) {
              final isSelected = _selectedTable == tableNumber;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTable = tableNumber;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMedium,
                    vertical: AppConstants.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.white,
                    border: Border.all(
                      color:
                          isSelected ? AppColors.primary : AppColors.greyLight,
                    ),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                  child: CustomText.medium(
                    text: 'Table $tableNumber',
                    color: isSelected ? AppColors.white : AppColors.textPrimary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOccasionAndPreferences() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Occasion Selection
          const CustomText.medium(
            text: 'Occasion',
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Wrap(
            spacing: AppConstants.paddingSmall,
            runSpacing: AppConstants.paddingSmall,
            children: ReservationOccasion.getAllOccasions().map((occasion) {
              final isSelected = _selectedOccasion == occasion;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedOccasion = occasion;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingSmall,
                    vertical: AppConstants.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColors.primary : AppColors.background,
                    border: Border.all(
                      color:
                          isSelected ? AppColors.primary : AppColors.greyLight,
                    ),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                  child: CustomText.secondary(
                    text: occasion,
                    color: isSelected ? AppColors.white : AppColors.textPrimary,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppConstants.paddingMedium),

          // Preferences
          const CustomText.medium(
            text: 'Table Preferences',
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Wrap(
            spacing: AppConstants.paddingSmall,
            runSpacing: AppConstants.paddingSmall,
            children: TablePreferences.getAllPreferences().map((preference) {
              final isSelected = _selectedPreferences.contains(preference);
              return GestureDetector(
                onTap: () => _togglePreference(preference),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingSmall,
                    vertical: AppConstants.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.background,
                    border: Border.all(
                      color:
                          isSelected ? AppColors.primary : AppColors.greyLight,
                    ),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                  child: CustomText.secondary(
                    text: preference,
                    color:
                        isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialRequests() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText.medium(
            text: 'Special Requests',
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          TextField(
            controller: _specialRequestsController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Any special requests or dietary requirements...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                borderSide: BorderSide(color: AppColors.greyLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                borderSide: BorderSide(color: AppColors.greyLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                borderSide: BorderSide(color: AppColors.primary),
              ),
              contentPadding: const EdgeInsets.all(AppConstants.paddingMedium),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalkInOption() {
    return CustomCard(
      child: Row(
        children: [
          Checkbox(
            value: _isWalkIn,
            onChanged: (value) {
              setState(() {
                _isWalkIn = value ?? false;
              });
            },
            activeColor: AppColors.primary,
          ),
          Expanded(
            child: CustomText.medium(
              text: 'Walk-in Customer',
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return CustomButton(
      text: _isLoading ? 'Creating Reservation...' : 'Create Reservation',
      onPressed: () {
        if (!_isLoading) {
          _submitReservation();
        }
      },
      backgroundColor: AppColors.primary,
      textColor: AppColors.white,
    );
  }
}
