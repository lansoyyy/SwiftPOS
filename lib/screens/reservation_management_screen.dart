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

class ReservationManagementScreen extends StatefulWidget {
  const ReservationManagementScreen({super.key});

  @override
  State<ReservationManagementScreen> createState() =>
      _ReservationManagementScreenState();
}

class _ReservationManagementScreenState
    extends State<ReservationManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ReservationModel> _allReservations = [];
  List<ReservationModel> _todayReservations = [];
  List<ReservationModel> _upcomingReservations = [];
  List<ReservationModel> _activeReservations = [];
  Map<String, int> _statistics = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadReservations();
    _loadStatistics();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadReservations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final all = await ReservationService.instance.getAllReservations();
      final today = await ReservationService.instance.getTodayReservations();
      final upcoming =
          await ReservationService.instance.getUpcomingReservations();
      final active = await ReservationService.instance.getActiveReservations();

      setState(() {
        _allReservations = all;
        _todayReservations = today;
        _upcomingReservations = upcoming;
        _activeReservations = active;
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

  Future<void> _loadStatistics() async {
    final stats = await ReservationService.instance.getReservationStatistics();
    setState(() {
      _statistics = stats;
    });
  }

  Future<void> _updateReservationStatus(
      String reservationId, ReservationStatus newStatus) async {
    final success = await ReservationService.instance.updateReservationStatus(
      reservationId,
      newStatus,
      staffName:
          'Current Staff', // In a real app, this would be the logged-in staff
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Reservation status updated to ${newStatus.displayName}'),
          backgroundColor: Colors.green,
        ),
      );
      _loadReservations();
      _loadStatistics();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update reservation status'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _cancelReservation(ReservationModel reservation) async {
    final reasonController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const CustomText.bold(text: 'Cancel Reservation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomText.regular(
              text: 'Please provide a reason for cancellation:',
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter reason...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const CustomText.medium(text: 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const CustomText.medium(text: 'Confirm'),
          ),
        ],
      ),
    );

    if (result == true && reasonController.text.trim().isNotEmpty) {
      final success = await ReservationService.instance.cancelReservation(
        reservation.id,
        reasonController.text.trim(),
        'Current Staff', // In a real app, this would be the logged-in staff
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reservation cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _loadReservations();
        _loadStatistics();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to cancel reservation'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    reasonController.dispose();
  }

  void _showReservationDetails(ReservationModel reservation) {
    showDialog(
      context: context,
      builder: (context) => ReservationDetailsDialog(reservation: reservation),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const CustomText.bold(
          text: 'Reservation Management',
          fontSize: AppConstants.fontLarge,
          color: AppColors.textPrimary,
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Active'),
            Tab(text: 'Upcoming'),
            Tab(text: 'All'),
          ],
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.refresh,
                color: AppColors.primary),
            onPressed: () {
              _loadReservations();
              _loadStatistics();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatisticsCards(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildReservationsList(
                    _todayReservations, 'Today\'s Reservations'),
                _buildReservationsList(
                    _activeReservations, 'Active Reservations'),
                _buildReservationsList(
                    _upcomingReservations, 'Upcoming Reservations'),
                _buildReservationsList(_allReservations, 'All Reservations'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total',
              _statistics['total']?.toString() ?? '0',
              AppColors.primary,
              FontAwesomeIcons.list,
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: _buildStatCard(
              'Pending',
              _statistics['pending']?.toString() ?? '0',
              AppColors.warning,
              FontAwesomeIcons.clock,
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: _buildStatCard(
              'Confirmed',
              _statistics['confirmed']?.toString() ?? '0',
              AppColors.success,
              FontAwesomeIcons.checkCircle,
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: _buildStatCard(
              'Completed',
              _statistics['completed']?.toString() ?? '0',
              AppColors.grey,
              FontAwesomeIcons.checkDouble,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, Color color, IconData icon) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          children: [
            FaIcon(icon, color: color, size: 24),
            const SizedBox(height: AppConstants.paddingSmall),
            CustomText.bold(
              text: value,
              fontSize: AppConstants.fontLarge,
              color: color,
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            CustomText.medium(
              text: title,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationsList(
      List<ReservationModel> reservations, String title) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (reservations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.calendarXmark,
              size: 64,
              color: AppColors.greyLight,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            CustomText.medium(
              text: 'No $title',
              color: AppColors.textSecondary,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadReservations();
        _loadStatistics();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          return ReservationCard(
            reservation: reservations[index],
            onTap: () => _showReservationDetails(reservations[index]),
            onStatusUpdate: (status) =>
                _updateReservationStatus(reservations[index].id, status),
            onCancel: () => _cancelReservation(reservations[index]),
          );
        },
      ),
    );
  }
}

class ReservationCard extends StatelessWidget {
  final ReservationModel reservation;
  final VoidCallback onTap;
  final Function(ReservationStatus) onStatusUpdate;
  final VoidCallback onCancel;

  const ReservationCard({
    super.key,
    required this.reservation,
    required this.onTap,
    required this.onStatusUpdate,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText.bold(
                          text: reservation.customerName,
                          fontSize: AppConstants.fontLarge,
                        ),
                        const SizedBox(height: AppConstants.paddingSmall),
                        CustomText.medium(
                          text:
                              'Table ${reservation.tableNumber} • ${reservation.numberOfGuests} guests',
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingSmall,
                      vertical: AppConstants.paddingSmall / 2,
                    ),
                    decoration: BoxDecoration(
                      color: reservation.status.color.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusSmall),
                    ),
                    child: CustomText.medium(
                      text: reservation.status.displayName,
                      color: reservation.status.color,
                      fontSize: AppConstants.fontSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.calendar,
                    size: 14,
                    color: AppColors.grey,
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  CustomText.medium(
                    text: DateFormat('MMM d, y')
                        .format(reservation.reservationDate),
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  FaIcon(
                    FontAwesomeIcons.clock,
                    size: 14,
                    color: AppColors.grey,
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  CustomText.medium(
                    text: reservation.reservationTime.format(context),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              if (reservation.occasion != ReservationOccasion.regularDining)
                CustomText.medium(
                  text: 'Occasion: ${reservation.occasion}',
                  color: AppColors.primary,
                ),
              if (reservation.specialRequests.isNotEmpty) ...[
                const SizedBox(height: AppConstants.paddingSmall),
                CustomText.medium(
                  text: 'Special: ${reservation.specialRequests}',
                  color: AppColors.textSecondary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: AppConstants.paddingMedium),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    switch (reservation.status) {
      case ReservationStatus.pending:
        return Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Confirm',
                onPressed: () => onStatusUpdate(ReservationStatus.confirmed),
                backgroundColor: AppColors.success,
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            Expanded(
              child: CustomButton(
                text: 'Cancel',
                onPressed: onCancel,
                isOutlined: true,
                backgroundColor: AppColors.error,
              ),
            ),
          ],
        );
      case ReservationStatus.confirmed:
        return Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Seat Customer',
                onPressed: () => onStatusUpdate(ReservationStatus.seated),
                backgroundColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            Expanded(
              child: CustomButton(
                text: 'Cancel',
                onPressed: onCancel,
                isOutlined: true,
                backgroundColor: AppColors.error,
              ),
            ),
          ],
        );
      case ReservationStatus.seated:
        return SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: 'Mark as Completed',
            onPressed: () => onStatusUpdate(ReservationStatus.completed),
            backgroundColor: AppColors.success,
          ),
        );
      case ReservationStatus.waiting:
        return Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Seat Customer',
                onPressed: () => onStatusUpdate(ReservationStatus.seated),
                backgroundColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            Expanded(
              child: CustomButton(
                text: 'Cancel',
                onPressed: onCancel,
                isOutlined: true,
                backgroundColor: AppColors.error,
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class ReservationDetailsDialog extends StatelessWidget {
  final ReservationModel reservation;

  const ReservationDetailsDialog({
    super.key,
    required this.reservation,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomText.bold(
                    text: 'Reservation Details',
                    fontSize: AppConstants.fontLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const FaIcon(FontAwesomeIcons.xmark),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            _buildDetailRow('Customer', reservation.customerName),
            _buildDetailRow('Phone', reservation.customerPhone),
            _buildDetailRow('Email', reservation.customerEmail),
            _buildDetailRow('Table', 'Table ${reservation.tableNumber}'),
            _buildDetailRow('Guests', '${reservation.numberOfGuests} guests'),
            _buildDetailRow(
                'Date',
                DateFormat('EEEE, MMMM d, y')
                    .format(reservation.reservationDate)),
            _buildDetailRow(
                'Time', reservation.reservationTime.format(context)),
            _buildDetailRow('Status', reservation.status.displayName),
            if (reservation.occasion != ReservationOccasion.regularDining)
              _buildDetailRow('Occasion', reservation.occasion),
            if (reservation.specialRequests.isNotEmpty)
              _buildDetailRow('Special Requests', reservation.specialRequests),
            if (reservation.preferences.isNotEmpty)
              _buildDetailRow(
                  'Preferences', reservation.preferences.join(', ')),
            _buildDetailRow('Created',
                DateFormat('MMM d, y HH:mm').format(reservation.createdAt)),
            if (reservation.confirmedAt != null)
              _buildDetailRow(
                  'Confirmed',
                  DateFormat('MMM d, y HH:mm')
                      .format(reservation.confirmedAt!)),
            const SizedBox(height: AppConstants.paddingLarge),
            CustomButton(
              text: 'Close',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: CustomText.medium(
              text: '$label:',
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: CustomText.medium(
              text: value,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
