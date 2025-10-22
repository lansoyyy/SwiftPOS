import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/reservation_model.dart';

class ReservationService {
  static ReservationService? _instance;
  static ReservationService get instance {
    _instance ??= ReservationService._();
    return _instance!;
  }

  ReservationService._();

  // In-memory storage for reservations
  List<ReservationModel> _reservations = [];

  // Get all reservations
  Future<List<ReservationModel>> getAllReservations() async {
    try {
      // For demo purposes, add some sample reservations if empty
      if (_reservations.isEmpty) {
        _addSampleReservations();
      }
      return List.from(_reservations);
    } catch (e) {
      debugPrint('Error getting reservations: $e');
      return [];
    }
  }

  // Add sample reservations for demonstration
  void _addSampleReservations() {
    final now = DateTime.now();
    _reservations = [
      ReservationModel.create(
        customerName: 'Juan dela Cruz',
        customerPhone: '+639123456789',
        customerEmail: 'juan@example.com',
        tableNumber: 1,
        reservationDate: now,
        reservationTime: const TimeOfDay(hour: 19, minute: 0),
        numberOfGuests: 4,
        occasion: 'Birthday',
        specialRequests: 'Near window please',
      ),
      ReservationModel.create(
        customerName: 'Maria Santos',
        customerPhone: '+639987654321',
        customerEmail: 'maria@example.com',
        tableNumber: 3,
        reservationDate: now.add(const Duration(days: 1)),
        reservationTime: const TimeOfDay(hour: 12, minute: 30),
        numberOfGuests: 2,
        occasion: 'Date Night',
        specialRequests: 'Quiet area preferred',
      ),
      ReservationModel.create(
        customerName: 'Jose Reyes',
        customerPhone: '+639555555555',
        customerEmail: 'jose@example.com',
        tableNumber: 5,
        reservationDate: now.add(const Duration(days: 2)),
        reservationTime: const TimeOfDay(hour: 18, minute: 0),
        numberOfGuests: 6,
        occasion: 'Family Gathering',
        specialRequests: 'High chair needed for child',
      ),
    ];

    // Mark some as confirmed for demonstration
    _reservations[0] =
        _reservations[0].copyWith(status: ReservationStatus.confirmed);
    _reservations[1] =
        _reservations[1].copyWith(status: ReservationStatus.confirmed);
  }

  // Get reservations by status
  Future<List<ReservationModel>> getReservationsByStatus(
      ReservationStatus status) async {
    final allReservations = await getAllReservations();
    return allReservations
        .where((reservation) => reservation.status == status)
        .toList();
  }

  // Get reservations for a specific date
  Future<List<ReservationModel>> getReservationsByDate(DateTime date) async {
    final allReservations = await getAllReservations();
    return allReservations.where((reservation) {
      return isSameDay(reservation.reservationDate, date);
    }).toList();
  }

  // Get reservations for a specific table
  Future<List<ReservationModel>> getReservationsByTable(int tableNumber) async {
    final allReservations = await getAllReservations();
    return allReservations
        .where((reservation) => reservation.tableNumber == tableNumber)
        .toList();
  }

  // Get active reservations (pending, confirmed, waiting)
  Future<List<ReservationModel>> getActiveReservations() async {
    final allReservations = await getAllReservations();
    return allReservations
        .where((reservation) => reservation.status.isActive)
        .toList();
  }

  // Get today's reservations
  Future<List<ReservationModel>> getTodayReservations() async {
    return getReservationsByDate(DateTime.now());
  }

  // Get upcoming reservations (future dates)
  Future<List<ReservationModel>> getUpcomingReservations() async {
    final allReservations = await getAllReservations();
    final now = DateTime.now();
    return allReservations.where((reservation) {
      return reservation.reservationDate.isAfter(now) &&
          reservation.status.isActive;
    }).toList();
  }

  // Create a new reservation
  Future<bool> createReservation(ReservationModel reservation) async {
    try {
      final allReservations = await getAllReservations();

      // Check if table is already reserved for the same date and time
      final conflictingReservation = allReservations.firstWhere(
        (r) =>
            r.tableNumber == reservation.tableNumber &&
            isSameDay(r.reservationDate, reservation.reservationDate) &&
            r.status.isActive &&
            _isTimeConflict(r.reservationTime, reservation.reservationTime),
        orElse: () => null as ReservationModel,
      );

      if (conflictingReservation != null) {
        debugPrint(
            'Table ${reservation.tableNumber} is already reserved for this time slot');
        return false;
      }

      allReservations.add(reservation);
      await _saveReservations(allReservations);
      return true;
    } catch (e) {
      debugPrint('Error creating reservation: $e');
      return false;
    }
  }

  // Update reservation status
  Future<bool> updateReservationStatus(
      String reservationId, ReservationStatus newStatus,
      {String? staffName}) async {
    try {
      final allReservations = await getAllReservations();
      final reservationIndex =
          allReservations.indexWhere((r) => r.id == reservationId);

      if (reservationIndex == -1) return false;

      final reservation = allReservations[reservationIndex];
      final updatedReservation = reservation.copyWith(
        status: newStatus,
        confirmedAt: newStatus == ReservationStatus.confirmed
            ? DateTime.now()
            : reservation.confirmedAt,
        cancelledAt: newStatus == ReservationStatus.cancelled
            ? DateTime.now()
            : reservation.cancelledAt,
        staffAssigned: staffName ?? reservation.staffAssigned,
      );

      allReservations[reservationIndex] = updatedReservation;
      await _saveReservations(allReservations);
      return true;
    } catch (e) {
      debugPrint('Error updating reservation status: $e');
      return false;
    }
  }

  // Cancel reservation
  Future<bool> cancelReservation(
      String reservationId, String reason, String cancelledBy) async {
    try {
      final allReservations = await getAllReservations();
      final reservationIndex =
          allReservations.indexWhere((r) => r.id == reservationId);

      if (reservationIndex == -1) return false;

      final reservation = allReservations[reservationIndex];
      final updatedReservation = reservation.copyWith(
        status: ReservationStatus.cancelled,
        cancelledAt: DateTime.now(),
        cancelledBy: cancelledBy,
        cancellationReason: reason,
      );

      allReservations[reservationIndex] = updatedReservation;
      await _saveReservations(allReservations);
      return true;
    } catch (e) {
      debugPrint('Error cancelling reservation: $e');
      return false;
    }
  }

  // Mark reservation as no-show
  Future<bool> markAsNoShow(String reservationId) async {
    try {
      final allReservations = await getAllReservations();
      final reservationIndex =
          allReservations.indexWhere((r) => r.id == reservationId);

      if (reservationIndex == -1) return false;

      final reservation = allReservations[reservationIndex];
      final updatedReservation = reservation.copyWith(
        status: ReservationStatus.noShow,
      );

      allReservations[reservationIndex] = updatedReservation;
      await _saveReservations(allReservations);
      return true;
    } catch (e) {
      debugPrint('Error marking reservation as no-show: $e');
      return false;
    }
  }

  // Check if table is available for a specific date and time
  Future<bool> isTableAvailable(int tableNumber, DateTime date, TimeOfDay time,
      {String? excludeReservationId}) async {
    final tableReservations = await getReservationsByTable(tableNumber);

    for (final reservation in tableReservations) {
      if (excludeReservationId != null &&
          reservation.id == excludeReservationId) {
        continue;
      }

      if (isSameDay(reservation.reservationDate, date) &&
          reservation.status.isActive &&
          _isTimeConflict(reservation.reservationTime, time)) {
        return false;
      }
    }

    return true;
  }

  // Get available tables for a specific date and time
  Future<List<int>> getAvailableTables(
      DateTime date, TimeOfDay time, int totalTables) async {
    final List<int> availableTables = [];

    for (int i = 1; i <= totalTables; i++) {
      if (await isTableAvailable(i, date, time)) {
        availableTables.add(i);
      }
    }

    return availableTables;
  }

  // Get reservation statistics
  Future<Map<String, int>> getReservationStatistics() async {
    final allReservations = await getAllReservations();
    final Map<String, int> stats = {
      'total': allReservations.length,
      'pending': 0,
      'confirmed': 0,
      'seated': 0,
      'completed': 0,
      'cancelled': 0,
      'noShow': 0,
      'waiting': 0,
    };

    for (final reservation in allReservations) {
      switch (reservation.status) {
        case ReservationStatus.pending:
          stats['pending'] = (stats['pending'] ?? 0) + 1;
          break;
        case ReservationStatus.confirmed:
          stats['confirmed'] = (stats['confirmed'] ?? 0) + 1;
          break;
        case ReservationStatus.seated:
          stats['seated'] = (stats['seated'] ?? 0) + 1;
          break;
        case ReservationStatus.completed:
          stats['completed'] = (stats['completed'] ?? 0) + 1;
          break;
        case ReservationStatus.cancelled:
          stats['cancelled'] = (stats['cancelled'] ?? 0) + 1;
          break;
        case ReservationStatus.noShow:
          stats['noShow'] = (stats['noShow'] ?? 0) + 1;
          break;
        case ReservationStatus.waiting:
          stats['waiting'] = (stats['waiting'] ?? 0) + 1;
          break;
      }
    }

    return stats;
  }

  // Auto-mark no-shows for reservations that are past their time
  Future<void> autoMarkNoShows() async {
    try {
      final allReservations = await getAllReservations();
      final now = DateTime.now();
      final List<ReservationModel> updatedReservations = [];

      for (final reservation in allReservations) {
        if (reservation.status == ReservationStatus.confirmed) {
          final reservationDateTime = DateTime(
            reservation.reservationDate.year,
            reservation.reservationDate.month,
            reservation.reservationDate.day,
            reservation.reservationTime.hour,
            reservation.reservationTime.minute,
          );

          // Mark as no-show if 30 minutes have passed since reservation time
          if (now.difference(reservationDateTime).inMinutes > 30) {
            updatedReservations.add(reservation.copyWith(
              status: ReservationStatus.noShow,
            ));
          } else {
            updatedReservations.add(reservation);
          }
        } else {
          updatedReservations.add(reservation);
        }
      }

      await _saveReservations(updatedReservations);
    } catch (e) {
      debugPrint('Error auto-marking no-shows: $e');
    }
  }

  // Private helper methods
  Future<void> _saveReservations(List<ReservationModel> reservations) async {
    try {
      _reservations = List.from(reservations);
      debugPrint(
          'Reservations saved successfully (${reservations.length} items)');
    } catch (e) {
      debugPrint('Error saving reservations: $e');
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isTimeConflict(TimeOfDay time1, TimeOfDay time2) {
    // Check if times are within 2 hours of each other
    final minutes1 = time1.hour * 60 + time1.minute;
    final minutes2 = time2.hour * 60 + time2.minute;
    final difference = (minutes1 - minutes2).abs();
    return difference < 120; // 2 hours in minutes
  }
}
