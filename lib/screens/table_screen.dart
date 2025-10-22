import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:para/utils/colors.dart';
import 'package:para/utils/constants.dart';
import 'package:para/widgets/custom_drawer.dart';
import 'package:para/widgets/custom_text.dart';
import 'package:para/widgets/custom_button.dart';
import '../models/reservation_model.dart';
import '../services/reservation_service.dart';
import 'reservation_screen.dart';
import 'reservation_management_screen.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  int _currentPage = 1;
  final int _totalPages = 10;
  String _selectedFilter = 'All Table';
  List<Map<String, dynamic>> _tables = [];
  List<ReservationModel> _reservations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeTables();
    _loadReservations();
  }

  void _initializeTables() {
    _tables = List.generate(20, (index) {
      final tableNumber = index + 1;
      return {
        'number': tableNumber,
        'status': 'Available',
        'guest': 'Guest',
        'reservation': null as ReservationModel?,
      };
    });
  }

  Future<void> _loadReservations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final reservations =
          await ReservationService.instance.getTodayReservations();
      setState(() {
        _reservations = reservations;
        _updateTableStatuses();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading reservations: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _updateTableStatuses() {
    // Reset all tables to available
    for (var table in _tables) {
      table['status'] = 'Available';
      table['reservation'] = null;
    }

    // Update table statuses based on reservations
    final now = DateTime.now();
    for (final reservation in _reservations) {
      final tableIndex =
          _tables.indexWhere((t) => t['number'] == reservation.tableNumber);
      if (tableIndex != -1) {
        final reservationDateTime = DateTime(
          reservation.reservationDate.year,
          reservation.reservationDate.month,
          reservation.reservationDate.day,
          reservation.reservationTime.hour,
          reservation.reservationTime.minute,
        );

        // Check if reservation is active
        if (reservation.status.isActive) {
          _tables[tableIndex]['status'] =
              _getTableStatusFromReservation(reservation, reservationDateTime);
          _tables[tableIndex]['reservation'] = reservation;
        }
        // Check if reservation is recently completed (within last 2 hours)
        else if (reservation.status == ReservationStatus.completed &&
            now.difference(reservationDateTime).inHours < 2) {
          _tables[tableIndex]['status'] = 'Recently Used';
          _tables[tableIndex]['reservation'] = reservation;
        }
      }
    }
  }

  String _getTableStatusFromReservation(
      ReservationModel reservation, DateTime reservationDateTime) {
    final now = DateTime.now();
    final difference = reservationDateTime.difference(now);

    if (reservation.status == ReservationStatus.seated) {
      return 'Occupied';
    } else if (reservation.status == ReservationStatus.waiting) {
      return 'Waiting';
    } else if (difference.inMinutes > 30) {
      return 'Reserved';
    } else if (difference.inMinutes > 0) {
      return 'Arriving Soon';
    } else if (difference.inMinutes > -30) {
      return 'Expected';
    } else {
      return 'Reserved';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const CustomDrawer(currentRoute: 'table'),
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: AppConstants.paddingLarge),
                  Expanded(
                    child: _buildTableGrid(),
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),
                  _buildPagination(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Menu Icon
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingSmall),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Builder(
              builder: (context) => IconButton(
                icon: const FaIcon(FontAwesomeIcons.bars, size: 18),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          // Search Bar
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    fontFamily: 'Regular',
                    fontSize: AppConstants.fontMedium,
                    color: AppColors.textHint,
                  ),
                  prefixIcon: const Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: 18,
                    color: AppColors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMedium,
                    vertical: AppConstants.paddingMedium,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          // Filter Dropdown
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingMedium,
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText.medium(
                  text: _selectedFilter,
                  fontSize: AppConstants.fontMedium,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.chevronDown,
                    size: 10,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          // Reservation Management Button
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReservationManagementScreen(),
                ),
              );
            },
            icon: const FaIcon(FontAwesomeIcons.calendarCheck, size: 16),
            label: const CustomText.bold(
              text: 'Reservations',
              fontSize: AppConstants.fontMedium,
              color: AppColors.white,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingLarge,
                vertical: AppConstants.paddingMedium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText.bold(
          text: 'Table',
          fontSize: AppConstants.fontHeading,
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        const CustomText.regular(
          text:
              'Overview of Table Availability and Status for Efficient Order Management',
          fontSize: AppConstants.fontMedium,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildTableGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1.2,
        crossAxisSpacing: AppConstants.paddingMedium,
        mainAxisSpacing: AppConstants.paddingMedium,
      ),
      itemCount: _tables.length,
      itemBuilder: (context, index) {
        return _buildTableCard(_tables[index]);
      },
    );
  }

  Widget _buildTableCard(Map<String, dynamic> table) {
    final status = table['status'] as String;
    final reservation = table['reservation'] as ReservationModel?;
    final isAvailable = status == 'Available';
    final statusColor = _getTableStatusColor(status);
    final statusIcon = _getTableStatusIcon(status);

    return GestureDetector(
      onTap: () => _showTableOptions(context, table, reservation),
      onLongPress: () {
        if (isAvailable) {
          _navigateToReservation(table['number']);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(
            color: isAvailable
                ? AppColors.primary.withOpacity(0.3)
                : statusColor.withOpacity(0.5),
            width: isAvailable ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isAvailable
                  ? AppColors.primary.withOpacity(0.15)
                  : statusColor.withOpacity(0.08),
              blurRadius: isAvailable ? 15 : 10,
              offset: const Offset(0, 4),
            ),
          ],
          gradient: isAvailable
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.white,
                    AppColors.primary.withOpacity(0.02),
                  ],
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Table Header with Icon
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.paddingSmall,
                horizontal: AppConstants.paddingMedium,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isAvailable
                      ? [
                          AppColors.primary.withOpacity(0.1),
                          AppColors.primary.withOpacity(0.02),
                        ]
                      : [
                          statusColor.withOpacity(0.3),
                          statusColor.withOpacity(0.1),
                        ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.radiusMedium),
                  topRight: Radius.circular(AppConstants.radiusMedium),
                ),
              ),
              child: Column(
                children: [
                  // Table Icon with Animation
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? AppColors.primary.withOpacity(0.15)
                          : statusColor.withOpacity(0.5),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: isAvailable
                              ? AppColors.primary.withOpacity(0.2)
                              : statusColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.chair,
                      size: 18,
                      color: isAvailable ? AppColors.primary : statusColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Table Number
                  CustomText.bold(
                    text: 'Table ${table['number']}',
                    fontSize: AppConstants.fontMedium,
                    color:
                        isAvailable ? AppColors.primary : AppColors.textPrimary,
                  ),
                ],
              ),
            ),

            // Status Badge with Animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              margin: const EdgeInsets.all(AppConstants.paddingMedium),
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: AppConstants.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        statusIcon,
                        size: 12,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: CustomText.bold(
                          text: status,
                          fontSize: AppConstants.fontSmall,
                          color: AppColors.white,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (reservation != null) ...[
                    const SizedBox(height: 4),
                    CustomText.medium(
                      text: reservation.customerName,
                      fontSize: AppConstants.fontSmall - 2,
                      color: AppColors.white,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (reservation.numberOfGuests > 0)
                      CustomText.medium(
                        text: '${reservation.numberOfGuests} guests',
                        fontSize: AppConstants.fontSmall - 2,
                        color: AppColors.white.withOpacity(0.9),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTableStatusColor(String status) {
    switch (status) {
      case 'Available':
        return AppColors.primary;
      case 'Occupied':
        return AppColors.error;
      case 'Reserved':
      case 'Arriving Soon':
      case 'Expected':
        return AppColors.warning;
      case 'Waiting':
        return AppColors.info;
      case 'Recently Used':
        return AppColors.grey;
      default:
        return AppColors.greyLight;
    }
  }

  IconData _getTableStatusIcon(String status) {
    switch (status) {
      case 'Available':
        return FontAwesomeIcons.checkCircle;
      case 'Occupied':
        return FontAwesomeIcons.userCheck;
      case 'Reserved':
        return FontAwesomeIcons.calendarCheck;
      case 'Arriving Soon':
        return FontAwesomeIcons.personRunning;
      case 'Expected':
        return FontAwesomeIcons.clock;
      case 'Waiting':
        return FontAwesomeIcons.hourglassHalf;
      case 'Recently Used':
        return FontAwesomeIcons.history;
      default:
        return FontAwesomeIcons.questionCircle;
    }
  }

  void _navigateToReservation(int tableNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ReservationScreen(initialTableNumber: tableNumber),
      ),
    ).then((_) => _loadReservations());
  }

  void _showTableOptions(BuildContext context, Map<String, dynamic> table,
      ReservationModel? reservation) {
    final isAvailable = table['status'] == 'Available';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConstants.radiusLarge),
          topRight: Radius.circular(AppConstants.radiusLarge),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Table Info
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isAvailable
                        ? AppColors.primary.withOpacity(0.1)
                        : _getTableStatusColor(table['status'])
                            .withOpacity(0.5),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.chair,
                    size: 20,
                    color: isAvailable
                        ? AppColors.primary
                        : _getTableStatusColor(table['status']),
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText.bold(
                        text: 'Table ${table['number']}',
                        fontSize: AppConstants.fontLarge,
                        color: AppColors.textPrimary,
                      ),
                      CustomText.medium(
                        text: 'Status: ${table['status']}',
                        fontSize: AppConstants.fontMedium,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Reservation Info
            if (reservation != null) ...[
              const SizedBox(height: AppConstants.paddingLarge),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMedium),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText.bold(
                      text: 'Reservation Details',
                      fontSize: AppConstants.fontMedium,
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    _buildReservationDetailRow(
                        'Customer', reservation.customerName),
                    _buildReservationDetailRow(
                        'Guests', '${reservation.numberOfGuests}'),
                    _buildReservationDetailRow(
                        'Time', reservation.reservationTime.format(context)),
                    _buildReservationDetailRow(
                        'Status', reservation.status.displayName),
                  ],
                ),
              ),
            ],

            const SizedBox(height: AppConstants.paddingLarge),

            // Action Buttons
            if (isAvailable) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToReservation(table['number']);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingLarge,
                      vertical: AppConstants.paddingMedium,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                    elevation: 0,
                  ),
                  child: const CustomText.bold(
                    text: 'Make Reservation',
                    fontSize: AppConstants.fontMedium,
                    color: AppColors.white,
                  ),
                ),
              ),
            ] else if (reservation != null) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigate to reservation details
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingLarge,
                          vertical: AppConstants.paddingMedium,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMedium),
                          side: BorderSide(color: AppColors.primary),
                        ),
                        elevation: 0,
                      ),
                      child: const CustomText.bold(
                        text: 'View Details',
                        fontSize: AppConstants.fontMedium,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigate to reservation management
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ReservationManagementScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingLarge,
                          vertical: AppConstants.paddingMedium,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMedium),
                        ),
                        elevation: 0,
                      ),
                      child: const CustomText.bold(
                        text: 'Update Status',
                        fontSize: AppConstants.fontMedium,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: AppConstants.paddingLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall / 2),
      child: Row(
        children: [
          CustomText.medium(
            text: '$label:',
            color: AppColors.textSecondary,
            fontSize: AppConstants.fontSmall,
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          CustomText.medium(
            text: value,
            color: AppColors.textPrimary,
            fontSize: AppConstants.fontSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText.regular(
          text: 'Page $_currentPage of $_totalPages',
          fontSize: AppConstants.fontMedium,
          color: AppColors.textSecondary,
        ),
        Row(
          children: [
            _buildPaginationButton(
              icon: FontAwesomeIcons.chevronLeft,
              onPressed: _currentPage > 1
                  ? () {
                      setState(() {
                        _currentPage--;
                      });
                    }
                  : null,
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            ..._buildPageNumbers(),
            const SizedBox(width: AppConstants.paddingSmall),
            _buildPaginationButton(
              icon: FontAwesomeIcons.chevronRight,
              onPressed: _currentPage < _totalPages
                  ? () {
                      setState(() {
                        _currentPage++;
                      });
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildPageNumbers() {
    List<Widget> pages = [];

    // Show first page
    pages.add(_buildPageNumber(1));

    if (_currentPage > 3) {
      pages.add(const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: CustomText.regular(
          text: '...',
          fontSize: AppConstants.fontMedium,
          color: AppColors.textSecondary,
        ),
      ));
    }

    // Show current page and neighbors
    for (int i = _currentPage - 1; i <= _currentPage + 1; i++) {
      if (i > 1 && i < _totalPages) {
        pages.add(_buildPageNumber(i));
      }
    }

    if (_currentPage < _totalPages - 2) {
      pages.add(const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: CustomText.regular(
          text: '...',
          fontSize: AppConstants.fontMedium,
          color: AppColors.textSecondary,
        ),
      ));
    }

    // Show last page
    if (_totalPages > 1) {
      pages.add(_buildPageNumber(_totalPages));
    }

    return pages;
  }

  Widget _buildPageNumber(int pageNumber) {
    final isSelected = pageNumber == _currentPage;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentPage = pageNumber;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.greyLight.withOpacity(0.5),
          ),
        ),
        child: CustomText.medium(
          text: pageNumber.toString(),
          fontSize: AppConstants.fontSmall,
          color: isSelected ? AppColors.white : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildPaginationButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
        border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
      ),
      child: IconButton(
        icon: FaIcon(
          icon,
          size: 14,
          color: onPressed != null ? AppColors.textPrimary : AppColors.grey,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
