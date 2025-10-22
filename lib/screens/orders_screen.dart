import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:para/utils/colors.dart';
import 'package:para/utils/constants.dart';
import 'package:para/widgets/custom_button.dart';
import 'package:para/widgets/custom_text.dart';
import 'package:para/widgets/custom_drawer.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _selectedFilter = 'All Orders';
  String _selectedStatus = 'All Status';

  final List<Map<String, dynamic>> _orders = [
    {
      'id': '#010',
      'cashier': 'Broicad',
      'customer': 'John Doe',
      'items': 4,
      'table': 'Table 4',
      'order': '3x Burgers, 3x Orange juice',
      'total': 45.50,
      'status': 'Being Cooked',
      'statusColor': AppColors.warning,
      'time': DateTime.now().subtract(const Duration(minutes: 15)),
      'paymentMethod': 'Cash',
    },
    {
      'id': '#011',
      'cashier': 'Sarah',
      'customer': 'Jane Smith',
      'items': 2,
      'table': 'Table 7',
      'order': '2x Pizza Margherita',
      'total': 28.00,
      'status': 'Ready',
      'statusColor': AppColors.success,
      'time': DateTime.now().subtract(const Duration(minutes: 10)),
      'paymentMethod': 'Credit Card',
    },
    {
      'id': '#012',
      'cashier': 'Mike',
      'customer': 'Robert Johnson',
      'items': 6,
      'table': 'Table 2',
      'order': '3x Spaghetti, 2x Caesar Salad, 1x Garlic Bread',
      'total': 62.75,
      'status': 'Delivered',
      'statusColor': AppColors.info,
      'time': DateTime.now().subtract(const Duration(hours: 1)),
      'paymentMethod': 'GCash',
    },
    {
      'id': '#013',
      'cashier': 'Broicad',
      'customer': 'Emily Davis',
      'items': 3,
      'table': 'Table 5',
      'order': '1x Burger, 1x Fries, 1x Coke',
      'total': 18.50,
      'status': 'Cancelled',
      'statusColor': AppColors.error,
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'paymentMethod': 'Cash',
    },
    {
      'id': '#014',
      'cashier': 'Sarah',
      'customer': 'Michael Wilson',
      'items': 5,
      'table': 'Table 9',
      'order': '2x Pizza, 2x Coke, 1x Ice Cream',
      'total': 42.25,
      'status': 'Being Cooked',
      'statusColor': AppColors.warning,
      'time': DateTime.now().subtract(const Duration(minutes: 5)),
      'paymentMethod': 'Credit Card',
    },
  ];

  List<Map<String, dynamic>> get _filteredOrders {
    List<Map<String, dynamic>> filtered = List.from(_orders);

    if (_selectedStatus != 'All Status') {
      filtered = filtered
          .where((order) => order['status'] == _selectedStatus)
          .toList();
    }

    if (_selectedFilter == 'Recent') {
      filtered = filtered
          .where((order) => order['time']
              .isAfter(DateTime.now().subtract(const Duration(hours: 1))))
          .toList();
    } else if (_selectedFilter == 'Today') {
      filtered = filtered
          .where((order) => order['time'].day == DateTime.now().day)
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const CustomDrawer(currentRoute: 'orders'),
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
                  _buildFilters(),
                  const SizedBox(height: AppConstants.paddingLarge),
                  Expanded(
                    child: _buildOrdersList(),
                  ),
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
                  hintText: 'Search orders by ID, customer, or table...',
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
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText.bold(
          text: 'Orders',
          fontSize: AppConstants.fontHeading,
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        Row(
          children: [
            const CustomText.regular(
              text: 'Manage and track all customer orders',
              fontSize: AppConstants.fontMedium,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              ),
              child: CustomText.regular(
                text: '${_filteredOrders.length} Orders',
                fontSize: AppConstants.fontSmall,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        // Time Filter
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingSmall,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(
                FontAwesomeIcons.clock,
                size: 14,
                color: AppColors.grey,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              CustomText.regular(
                text: _selectedFilter,
                fontSize: AppConstants.fontSmall,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              const FaIcon(
                FontAwesomeIcons.chevronDown,
                size: 12,
                color: AppColors.grey,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppConstants.paddingMedium),
        // Status Filter
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingSmall,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(
                FontAwesomeIcons.filter,
                size: 14,
                color: AppColors.grey,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              CustomText.regular(
                text: _selectedStatus,
                fontSize: AppConstants.fontSmall,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              const FaIcon(
                FontAwesomeIcons.chevronDown,
                size: 12,
                color: AppColors.grey,
              ),
            ],
          ),
        ),
        const Spacer(),
        // Export Button
        OutlinedButton.icon(
          onPressed: () {
            // TODO: Implement export functionality
          },
          icon: const FaIcon(
            FontAwesomeIcons.download,
            size: 14,
            color: AppColors.primary,
          ),
          label: const CustomText.medium(
            text: 'Export',
            fontSize: AppConstants.fontSmall,
            color: AppColors.primary,
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingSmall,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
            side: BorderSide(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.radiusLarge),
                topRight: Radius.circular(AppConstants.radiusLarge),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                    flex: 1,
                    child: CustomText.bold(
                        text: 'Order ID', fontSize: AppConstants.fontSmall)),
                Expanded(
                    flex: 1,
                    child: CustomText.bold(
                        text: 'Customer', fontSize: AppConstants.fontSmall)),
                Expanded(
                    flex: 1,
                    child: CustomText.bold(
                        text: 'Table', fontSize: AppConstants.fontSmall)),
                Expanded(
                    flex: 2,
                    child: CustomText.bold(
                        text: 'Order', fontSize: AppConstants.fontSmall)),
                Expanded(
                    flex: 1,
                    child: CustomText.bold(
                        text: 'Total', fontSize: AppConstants.fontSmall)),
                Expanded(
                    flex: 1,
                    child: CustomText.bold(
                        text: 'Status', fontSize: AppConstants.fontSmall)),
                Expanded(
                    flex: 1,
                    child: CustomText.bold(
                        text: 'Time', fontSize: AppConstants.fontSmall)),
                Expanded(
                    flex: 1,
                    child: CustomText.bold(
                        text: 'Actions', fontSize: AppConstants.fontSmall)),
              ],
            ),
          ),
          // Table Body
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              itemCount: _filteredOrders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(_filteredOrders[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: AppColors.greyLight.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Order ID
          Expanded(
            flex: 1,
            child: CustomText.bold(
              text: order['id'],
              fontSize: AppConstants.fontMedium,
              color: AppColors.textPrimary,
            ),
          ),
          // Customer
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.medium(
                  text: order['customer'],
                  fontSize: AppConstants.fontSmall,
                  color: AppColors.textPrimary,
                ),
                CustomText.regular(
                  text: order['cashier'],
                  fontSize: AppConstants.fontSmall - 2,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          // Table
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingSmall,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: CustomText.medium(
                text: order['table'],
                fontSize: AppConstants.fontSmall,
                color: AppColors.primary,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Order Details
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.medium(
                  text: order['order'],
                  fontSize: AppConstants.fontSmall,
                  color: AppColors.textPrimary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                CustomText.regular(
                  text: '${order['items']} items',
                  fontSize: AppConstants.fontSmall - 2,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          // Total
          Expanded(
            flex: 1,
            child: CustomText.bold(
              text: 'P${order['total'].toStringAsFixed(2)}',
              fontSize: AppConstants.fontMedium,
              color: AppColors.primary,
            ),
          ),
          // Status
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingSmall,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: order['statusColor'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: CustomText.medium(
                text: order['status'],
                fontSize: AppConstants.fontSmall,
                color: order['statusColor'],
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Time
          Expanded(
            flex: 1,
            child: CustomText.regular(
              text: DateFormat('HH:mm').format(order['time']),
              fontSize: AppConstants.fontSmall,
              color: AppColors.textSecondary,
            ),
          ),
          // Actions
          Expanded(
            flex: 1,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _showOrderDetails(order),
                  icon: const FaIcon(
                    FontAwesomeIcons.eye,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  tooltip: 'View Details',
                ),
                if (order['status'] == 'Being Cooked') ...[
                  IconButton(
                    onPressed: () => _updateOrderStatus(order, 'Ready'),
                    icon: const FaIcon(
                      FontAwesomeIcons.check,
                      size: 14,
                      color: AppColors.success,
                    ),
                    tooltip: 'Mark as Ready',
                  ),
                ] else if (order['status'] == 'Ready') ...[
                  IconButton(
                    onPressed: () => _updateOrderStatus(order, 'Delivered'),
                    icon: const FaIcon(
                      FontAwesomeIcons.truck,
                      size: 14,
                      color: AppColors.info,
                    ),
                    tooltip: 'Mark as Delivered',
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.receipt,
                      size: 24,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText.bold(
                          text: 'Order ${order['id']}',
                          fontSize: AppConstants.fontLarge,
                          color: AppColors.textPrimary,
                        ),
                        CustomText.regular(
                          text:
                              'Table: ${order['table']} • ${order['items']} items',
                          fontSize: AppConstants.fontSmall,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const FaIcon(
                      FontAwesomeIcons.xmark,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingLarge),

              // Order Details
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMedium),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Customer', order['customer']),
                    _buildDetailRow('Cashier', order['cashier']),
                    _buildDetailRow('Payment Method', order['paymentMethod']),
                    _buildDetailRow(
                        'Order Time',
                        DateFormat('MMM dd, yyyy - HH:mm')
                            .format(order['time'])),
                    _buildDetailRow('Status', order['status']),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),

              // Order Items
              const CustomText.bold(
                text: 'Order Items',
                fontSize: AppConstants.fontMedium,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMedium),
                ),
                child: CustomText.medium(
                  text: order['order'],
                  fontSize: AppConstants.fontSmall,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText.bold(
                    text: 'Total Amount',
                    fontSize: AppConstants.fontMedium,
                    color: AppColors.textPrimary,
                  ),
                  CustomText.bold(
                    text: 'P${order['total'].toStringAsFixed(2)}',
                    fontSize: AppConstants.fontLarge,
                    color: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingLarge),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.paddingMedium),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMedium),
                        ),
                        side: BorderSide(color: AppColors.greyLight),
                      ),
                      child: const CustomText.medium(
                        text: 'Close',
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  if (order['status'] == 'Being Cooked')
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _updateOrderStatus(order, 'Ready');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          padding: const EdgeInsets.symmetric(
                              vertical: AppConstants.paddingMedium),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusMedium),
                          ),
                        ),
                        child: const CustomText.medium(
                          text: 'Mark as Ready',
                          color: AppColors.white,
                        ),
                      ),
                    )
                  else if (order['status'] == 'Ready')
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _updateOrderStatus(order, 'Delivered');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.info,
                          padding: const EdgeInsets.symmetric(
                              vertical: AppConstants.paddingMedium),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusMedium),
                          ),
                        ),
                        child: const CustomText.medium(
                          text: 'Mark as Delivered',
                          color: AppColors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: CustomText.medium(
              text: '$label:',
              fontSize: AppConstants.fontSmall,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: CustomText.medium(
              text: value,
              fontSize: AppConstants.fontSmall,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _updateOrderStatus(Map<String, dynamic> order, String newStatus) {
    setState(() {
      order['status'] = newStatus;

      // Update status color
      switch (newStatus) {
        case 'Ready':
          order['statusColor'] = AppColors.success;
          break;
        case 'Delivered':
          order['statusColor'] = AppColors.info;
          break;
        case 'Cancelled':
          order['statusColor'] = AppColors.error;
          break;
        default:
          order['statusColor'] = AppColors.warning;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order ${order['id']} status updated to $newStatus'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
