import 'package:flutter/material.dart';

class ReservationModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final int tableNumber;
  final DateTime reservationDate;
  final TimeOfDay reservationTime;
  final int numberOfGuests;
  final String
      occasion; // e.g., "Birthday", "Anniversary", "Business Meeting", "Regular Dining"
  final String specialRequests;
  final ReservationStatus status;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? cancelledAt;
  final String? cancelledBy;
  final String? cancellationReason;
  final bool isWalkIn;
  final double? depositAmount;
  final bool depositPaid;
  final String? staffAssigned;
  final List<String>
      preferences; // e.g., ["Near Window", "Quiet Area", "High Chair Needed"]

  ReservationModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.tableNumber,
    required this.reservationDate,
    required this.reservationTime,
    required this.numberOfGuests,
    required this.occasion,
    required this.specialRequests,
    required this.status,
    required this.createdAt,
    this.confirmedAt,
    this.cancelledAt,
    this.cancelledBy,
    this.cancellationReason,
    this.isWalkIn = false,
    this.depositAmount,
    this.depositPaid = false,
    this.staffAssigned,
    this.preferences = const [],
  });

  // Factory constructor for creating a new reservation
  factory ReservationModel.create({
    required String customerName,
    required String customerPhone,
    required String customerEmail,
    required int tableNumber,
    required DateTime reservationDate,
    required TimeOfDay reservationTime,
    required int numberOfGuests,
    required String occasion,
    required String specialRequests,
    bool isWalkIn = false,
    double? depositAmount,
    List<String>? preferences,
  }) {
    return ReservationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      customerName: customerName,
      customerPhone: customerPhone,
      customerEmail: customerEmail,
      tableNumber: tableNumber,
      reservationDate: reservationDate,
      reservationTime: reservationTime,
      numberOfGuests: numberOfGuests,
      occasion: occasion,
      specialRequests: specialRequests,
      status: ReservationStatus.pending,
      createdAt: DateTime.now(),
      isWalkIn: isWalkIn,
      depositAmount: depositAmount,
      depositPaid: false,
      preferences: preferences ?? [],
    );
  }

  // Create a copy with updated values
  ReservationModel copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    int? tableNumber,
    DateTime? reservationDate,
    TimeOfDay? reservationTime,
    int? numberOfGuests,
    String? occasion,
    String? specialRequests,
    ReservationStatus? status,
    DateTime? createdAt,
    DateTime? confirmedAt,
    DateTime? cancelledAt,
    String? cancelledBy,
    String? cancellationReason,
    bool? isWalkIn,
    double? depositAmount,
    bool? depositPaid,
    String? staffAssigned,
    List<String>? preferences,
  }) {
    return ReservationModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      tableNumber: tableNumber ?? this.tableNumber,
      reservationDate: reservationDate ?? this.reservationDate,
      reservationTime: reservationTime ?? this.reservationTime,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      occasion: occasion ?? this.occasion,
      specialRequests: specialRequests ?? this.specialRequests,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancelledBy: cancelledBy ?? this.cancelledBy,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      isWalkIn: isWalkIn ?? this.isWalkIn,
      depositAmount: depositAmount ?? this.depositAmount,
      depositPaid: depositPaid ?? this.depositPaid,
      staffAssigned: staffAssigned ?? this.staffAssigned,
      preferences: preferences ?? this.preferences,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'tableNumber': tableNumber,
      'reservationDate': reservationDate.toIso8601String(),
      'reservationTime': '${reservationTime.hour}:${reservationTime.minute}',
      'numberOfGuests': numberOfGuests,
      'occasion': occasion,
      'specialRequests': specialRequests,
      'status': status.toString(),
      'createdAt': createdAt.toIso8601String(),
      'confirmedAt': confirmedAt?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'cancelledBy': cancelledBy,
      'cancellationReason': cancellationReason,
      'isWalkIn': isWalkIn,
      'depositAmount': depositAmount,
      'depositPaid': depositPaid,
      'staffAssigned': staffAssigned,
      'preferences': preferences,
    };
  }

  // Create from JSON
  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    final timeParts = (json['reservationTime'] as String).split(':');
    return ReservationModel(
      id: json['id'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerEmail: json['customerEmail'],
      tableNumber: json['tableNumber'],
      reservationDate: DateTime.parse(json['reservationDate']),
      reservationTime: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      numberOfGuests: json['numberOfGuests'],
      occasion: json['occasion'],
      specialRequests: json['specialRequests'],
      status: ReservationStatus.values.firstWhere(
        (status) => status.toString() == json['status'],
        orElse: () => ReservationStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      confirmedAt: json['confirmedAt'] != null
          ? DateTime.parse(json['confirmedAt'])
          : null,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'])
          : null,
      cancelledBy: json['cancelledBy'],
      cancellationReason: json['cancellationReason'],
      isWalkIn: json['isWalkIn'] ?? false,
      depositAmount: json['depositAmount']?.toDouble(),
      depositPaid: json['depositPaid'] ?? false,
      staffAssigned: json['staffAssigned'],
      preferences: List<String>.from(json['preferences'] ?? []),
    );
  }
}

enum ReservationStatus {
  pending, // Reservation made but not yet confirmed
  confirmed, // Reservation confirmed by staff
  seated, // Customer has arrived and been seated
  completed, // Dining experience completed
  cancelled, // Reservation was cancelled
  noShow, // Customer didn't arrive
  waiting, // Customer is waiting for table
}

// Extension to add helper methods to ReservationStatus
extension ReservationStatusExtension on ReservationStatus {
  String get displayName {
    switch (this) {
      case ReservationStatus.pending:
        return 'Pending';
      case ReservationStatus.confirmed:
        return 'Confirmed';
      case ReservationStatus.seated:
        return 'Seated';
      case ReservationStatus.completed:
        return 'Completed';
      case ReservationStatus.cancelled:
        return 'Cancelled';
      case ReservationStatus.noShow:
        return 'No Show';
      case ReservationStatus.waiting:
        return 'Waiting';
    }
  }

  Color get color {
    switch (this) {
      case ReservationStatus.pending:
        return Color(0xFFFFA726); // Orange
      case ReservationStatus.confirmed:
        return Color(0xFF66BB6A); // Green
      case ReservationStatus.seated:
        return Color(0xFF42A5F5); // Blue
      case ReservationStatus.completed:
        return Color(0xFF9E9E9E); // Grey
      case ReservationStatus.cancelled:
        return Color(0xFFEF5350); // Red
      case ReservationStatus.noShow:
        return Color(0xFFAB47BC); // Purple
      case ReservationStatus.waiting:
        return Color(0xFF29B6F6); // Light Blue
    }
  }

  bool get isActive {
    return this == ReservationStatus.pending ||
        this == ReservationStatus.confirmed ||
        this == ReservationStatus.waiting;
  }

  bool get isCompleted {
    return this == ReservationStatus.completed ||
        this == ReservationStatus.cancelled ||
        this == ReservationStatus.noShow;
  }
}

// Common reservation occasions in Philippine restaurants
class ReservationOccasion {
  static const String regularDining = 'Regular Dining';
  static const String birthday = 'Birthday';
  static const String anniversary = 'Anniversary';
  static const String businessMeeting = 'Business Meeting';
  static const String dateNight = 'Date Night';
  static const String familyGathering = 'Family Gathering';
  static const String holidayCelebration = 'Holiday Celebration';
  static const String companyEvent = 'Company Event';
  static const String other = 'Other';

  static List<String> getAllOccasions() {
    return [
      regularDining,
      birthday,
      anniversary,
      businessMeeting,
      dateNight,
      familyGathering,
      holidayCelebration,
      companyEvent,
      other,
    ];
  }
}

// Common table preferences in Philippine restaurants
class TablePreferences {
  static const String nearWindow = 'Near Window';
  static const String quietArea = 'Quiet Area';
  static const String nearExit = 'Near Exit';
  static const String highChairNeeded = 'High Chair Needed';
  static const String wheelchairAccessible = 'Wheelchair Accessible';
  static const String privateArea = 'Private Area';
  static const String nearRestroom = 'Near Restroom';
  static const String outdoorSeating = 'Outdoor Seating';
  static const String airConditioned = 'Air Conditioned Area';
  static const String smokingArea = 'Smoking Area';

  static List<String> getAllPreferences() {
    return [
      nearWindow,
      quietArea,
      nearExit,
      highChairNeeded,
      wheelchairAccessible,
      privateArea,
      nearRestroom,
      outdoorSeating,
      airConditioned,
      smokingArea,
    ];
  }
}
