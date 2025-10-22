import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/reservation_model.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/custom_text.dart';

class NotificationService {
  static NotificationService? _instance;
  static NotificationService get instance {
    _instance ??= NotificationService._();
    return _instance!;
  }

  NotificationService._();

  // Show toast notification
  void showToast(String message, {Color? backgroundColor, Color? textColor}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor ?? AppColors.primary,
      textColor: textColor ?? AppColors.white,
      fontSize: 16.0,
    );
  }

  // Show reservation created notification
  void showReservationCreated(ReservationModel reservation) {
    showToast(
      'Reservation created for ${reservation.customerName} at Table ${reservation.tableNumber}',
      backgroundColor: AppColors.success,
    );
  }

  // Show reservation confirmed notification
  void showReservationConfirmed(ReservationModel reservation) {
    showToast(
      'Reservation confirmed for ${reservation.customerName}',
      backgroundColor: AppColors.success,
    );
  }

  // Show reservation cancelled notification
  void showReservationCancelled(ReservationModel reservation) {
    showToast(
      'Reservation cancelled for ${reservation.customerName}',
      backgroundColor: AppColors.error,
    );
  }

  // Show customer arrived notification
  void showCustomerArrived(ReservationModel reservation) {
    showToast(
      '${reservation.customerName} has arrived for their reservation',
      backgroundColor: AppColors.info,
    );
  }

  // Show reservation reminder (30 minutes before)
  void showReservationReminder(ReservationModel reservation) {
    showToast(
      'Reminder: ${reservation.customerName} reservation in 30 minutes',
      backgroundColor: AppColors.warning,
    );
  }

  // Show table available notification
  void showTableAvailable(int tableNumber) {
    showToast(
      'Table $tableNumber is now available',
      backgroundColor: AppColors.success,
    );
  }

  // Show waiting list notification
  void showWaitingListUpdate(int position) {
    showToast(
      'Your position in waiting list: $position',
      backgroundColor: AppColors.info,
    );
  }

  // Show no-show alert
  void showNoShowAlert(ReservationModel reservation) {
    showToast(
      '${reservation.customerName} did not arrive for their reservation',
      backgroundColor: AppColors.error,
    );
  }

  // Show deposit payment notification
  void showDepositPaymentReceived(ReservationModel reservation) {
    showToast(
      'Deposit payment received for ${reservation.customerName}',
      backgroundColor: AppColors.success,
    );
  }

  // Show special request notification
  void showSpecialRequest(ReservationModel reservation) {
    if (reservation.specialRequests.isNotEmpty) {
      showToast(
        'Special request from ${reservation.customerName}: ${reservation.specialRequests}',
        backgroundColor: AppColors.info,
      );
    }
  }

  // Show occasion notification
  void showOccasionNotification(ReservationModel reservation) {
    if (reservation.occasion != 'Regular Dining') {
      showToast(
        '${reservation.occasion} reservation for ${reservation.customerName}',
        backgroundColor: AppColors.primary,
      );
    }
  }

  // Show bulk notification for multiple events
  void showBulkNotification(List<String> messages) {
    for (final message in messages) {
      Future.delayed(Duration(milliseconds: messages.indexOf(message) * 500),
          () {
        showToast(message);
      });
    }
  }

  // Show error notification
  void showError(String message) {
    showToast(
      'Error: $message',
      backgroundColor: AppColors.error,
    );
  }

  // Show success notification
  void showSuccess(String message) {
    showToast(
      message,
      backgroundColor: AppColors.success,
    );
  }

  // Show info notification
  void showInfo(String message) {
    showToast(
      message,
      backgroundColor: AppColors.info,
    );
  }

  // Show warning notification
  void showWarning(String message) {
    showToast(
      message,
      backgroundColor: AppColors.warning,
    );
  }

  // Check for upcoming reservations and show reminders
  Future<void> checkUpcomingReservations(
      List<ReservationModel> reservations) async {
    final now = DateTime.now();

    for (final reservation in reservations) {
      if (reservation.status == ReservationStatus.confirmed) {
        final reservationDateTime = DateTime(
          reservation.reservationDate.year,
          reservation.reservationDate.month,
          reservation.reservationDate.day,
          reservation.reservationTime.hour,
          reservation.reservationTime.minute,
        );

        final difference = reservationDateTime.difference(now);

        // Show reminder 30 minutes before
        if (difference.inMinutes == 30 && difference.inSeconds > 0) {
          showReservationReminder(reservation);
        }

        // Show arrival notification 5 minutes after reservation time
        if (difference.inMinutes == -5 && difference.inMinutes > -10) {
          showCustomerArrived(reservation);
        }

        // Show no-show alert 15 minutes after reservation time
        if (difference.inMinutes == -15 && difference.inMinutes > -20) {
          showNoShowAlert(reservation);
        }
      }
    }
  }

  // Show daily summary notification
  void showDailySummary(Map<String, int> statistics) {
    final total = statistics['total'] ?? 0;
    final confirmed = statistics['confirmed'] ?? 0;
    final completed = statistics['completed'] ?? 0;

    showToast(
      'Daily Summary: $total total reservations, $confirmed confirmed, $completed completed',
      backgroundColor: AppColors.primary,
    );
  }

  // Show peak hours warning
  void showPeakHoursWarning() {
    showToast(
      'Peak hours: High reservation volume expected',
      backgroundColor: AppColors.warning,
    );
  }

  // Show table cleaning notification
  void showTableCleaningNotification(int tableNumber) {
    showToast(
      'Table $tableNumber is being cleaned',
      backgroundColor: AppColors.info,
    );
  }

  // Show staff assignment notification
  void showStaffAssignment(String staffName, int tableNumber) {
    showToast(
      '$staffName assigned to Table $tableNumber',
      backgroundColor: AppColors.info,
    );
  }
}

// Custom notification widget for more detailed notifications
class CustomNotification extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const CustomNotification({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingSmall),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.bold(
                  text: title,
                  fontSize: AppConstants.fontMedium,
                ),
                const SizedBox(height: AppConstants.paddingSmall / 2),
                CustomText.medium(
                  text: message,
                  color: AppColors.textSecondary,
                  fontSize: AppConstants.fontSmall,
                ),
              ],
            ),
          ),
          if (onDismiss != null)
            IconButton(
              onPressed: onDismiss,
              icon: const FaIcon(
                FontAwesomeIcons.xmark,
                size: 16,
                color: AppColors.grey,
              ),
            ),
        ],
      ),
    );
  }
}

// Notification manager for handling multiple notifications
class NotificationManager {
  static final List<CustomNotification> _notifications = [];
  static final List<VoidCallback> _listeners = [];

  static void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  static void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  static void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  static void addNotification(CustomNotification notification) {
    _notifications.add(notification);
    _notifyListeners();

    // Auto-remove notification after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      _notifications.remove(notification);
      _notifyListeners();
    });
  }

  static void removeNotification(CustomNotification notification) {
    _notifications.remove(notification);
    _notifyListeners();
  }

  static List<CustomNotification> get notifications =>
      List.from(_notifications);

  static void clearAll() {
    _notifications.clear();
    _notifyListeners();
  }
}
