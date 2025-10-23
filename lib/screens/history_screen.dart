import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:para/utils/colors.dart';
import 'package:para/utils/constants.dart';
import 'package:para/widgets/custom_text.dart';
import 'package:para/widgets/custom_card.dart';
import 'package:para/widgets/custom_button.dart';
import 'package:para/widgets/custom_drawer.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _showFilters = false;

  // Sample transaction history data
  final List<Map<String, dynamic>> _allTransactions = [
    {
      'id': '#025',
      'date': DateTime(2024, 1, 20),
      'time': '09:15 AM',
      'cashier': 'Broicad',
      'table': 'Table 5',
      'items': 3,
      'subtotal': 125.00,
      'tax': 13.75,
      'total': 138.75,
      'payment': 'Cash',
      'status': 'Completed',
      'itemsList': ['Beef Burger', 'French Fries', 'Coke'],
    },
    {
      'id': '#024',
      'date': DateTime(2024, 1, 20),
      'time': '08:45 AM',
      'cashier': 'Avita',
      'table': 'Table 3',
      'items': 5,
      'subtotal': 215.50,
      'tax': 23.71,
      'total': 239.21,
      'payment': 'Card',
      'status': 'Completed',
      'itemsList': [
        'Chicken Supreme Pizza',
        'Garlic Bread',
        'Caesar Salad',
        'Coke',
        'Ice Cream'
      ],
    },
    {
      'id': '#023',
      'date': DateTime(2024, 1, 19),
      'time': '07:30 PM',
      'cashier': 'John',
      'table': 'Table 8',
      'items': 2,
      'subtotal': 85.00,
      'tax': 9.35,
      'total': 94.35,
      'payment': 'GCash',
      'status': 'Completed',
      'itemsList': ['Spaghetti', 'Orange Juice'],
    },
    {
      'id': '#022',
      'date': DateTime(2024, 1, 19),
      'time': '06:15 PM',
      'cashier': 'Broicad',
      'table': 'Table 2',
      'items': 4,
      'subtotal': 175.00,
      'tax': 19.25,
      'total': 194.25,
      'payment': 'Cash',
      'status': 'Refunded',
      'itemsList': ['Classic Burger', 'Cheeseburger', 'French Fries', 'Coffee'],
    },
    {
      'id': '#021',
      'date': DateTime(2024, 1, 19),
      'time': '02:45 PM',
      'cashier': 'Avita',
      'table': 'Table 6',
      'items': 6,
      'subtotal': 285.75,
      'tax': 31.43,
      'total': 317.18,
      'payment': 'Card',
      'status': 'Completed',
      'itemsList': [
        'Pepperoni Pizza',
        'Chicken Deluxe Burger',
        'Onion Rings',
        'Milkshake',
        'Salad',
        'Dessert'
      ],
    },
    {
      'id': '#020',
      'date': DateTime(2024, 1, 18),
      'time': '01:20 PM',
      'cashier': 'John',
      'table': 'Table 4',
      'items': 3,
      'subtotal': 145.50,
      'tax': 16.01,
      'total': 161.51,
      'payment': 'Cash',
      'status': 'Completed',
      'itemsList': ['Hawaiian Pizza', 'Garlic Bread', 'Lemonade'],
    },
    {
      'id': '#019',
      'date': DateTime(2024, 1, 18),
      'time': '11:30 AM',
      'cashier': 'Broicad',
      'table': 'Table 1',
      'items': 2,
      'subtotal': 95.00,
      'tax': 10.45,
      'total': 105.45,
      'payment': 'GCash',
      'status': 'Completed',
      'itemsList': ['Double Beef Burger', 'Coffee'],
    },
    {
      'id': '#018',
      'date': DateTime(2024, 1, 17),
      'time': '08:00 PM',
      'cashier': 'Avita',
      'table': 'Table 7',
      'items': 4,
      'subtotal': 185.25,
      'tax': 20.38,
      'total': 205.63,
      'payment': 'Card',
      'status': 'Completed',
      'itemsList': [
        'Chicken Supreme Pizza',
        'Caesar Salad',
        'Coke',
        'Ice Cream'
      ],
    },
  ];

  late List<Map<String, dynamic>> _filteredTransactions;

  @override
  void initState() {
    super.initState();
    _filteredTransactions = List.from(_allTransactions);
    _searchController.addListener(_filterTransactions);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTransactions() {
    setState(() {
      _filteredTransactions = _allTransactions.where((transaction) {
        // Search filter
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch = searchQuery.isEmpty ||
            transaction['id'].toString().toLowerCase().contains(searchQuery) ||
            transaction['cashier']
                .toString()
                .toLowerCase()
                .contains(searchQuery) ||
            transaction['table'].toString().toLowerCase().contains(searchQuery);

        // Status filter
        final matchesStatus = _selectedFilter == 'All' ||
            transaction['status'] == _selectedFilter;

        // Date filter
        bool matchesDate = true;
        if (_startDate != null) {
          matchesDate = transaction['date']
              .isAfter(_startDate!.subtract(const Duration(days: 1)));
        }
        if (_endDate != null) {
          matchesDate = matchesDate &&
              transaction['date']
                  .isBefore(_endDate!.add(const Duration(days: 1)));
        }

        return matchesSearch && matchesStatus && matchesDate;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: Builder(builder: (context) {
        return const CustomDrawer(currentRoute: 'history');
      }),
      body: Column(
        children: [
          _buildTopBar(),
          _buildSearchAndFilterBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: _buildTransactionsList(),
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
          bottom:
              BorderSide(color: AppColors.border.withOpacity(0.3), width: 1),
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
          // Title
          CustomText.bold(
            text: 'Transaction History',
            fontSize: AppConstants.fontHeading,
            color: AppColors.textPrimary,
          ),
          const Spacer(),
          // Summary Info
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(
                  FontAwesomeIcons.receipt,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                CustomText.medium(
                  text: '${_filteredTransactions.length} Transactions',
                  fontSize: AppConstants.fontMedium,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom:
              BorderSide(color: AppColors.border.withOpacity(0.3), width: 1),
        ),
      ),
      child: Column(
        children: [
          // Search Bar
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by order ID, cashier, or table...',
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
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.xmark,
                          size: 16,
                          color: AppColors.grey,
                        ),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingMedium,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          // Filter Options
          Row(
            children: [
              // Status Filter Dropdown
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMedium,
                    vertical: AppConstants.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMedium),
                    border:
                        Border.all(color: AppColors.greyLight.withOpacity(0.5)),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedFilter,
                    underline: const SizedBox(),
                    isDense: true,
                    isExpanded: true,
                    items: ['All', 'Completed', 'Refunded']
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Row(
                                children: [
                                  FaIcon(
                                    status == 'All'
                                        ? FontAwesomeIcons.list
                                        : status == 'Completed'
                                            ? FontAwesomeIcons.checkCircle
                                            : FontAwesomeIcons.timesCircle,
                                    size: 14,
                                    color: status == 'All'
                                        ? AppColors.grey
                                        : status == 'Completed'
                                            ? AppColors.success
                                            : AppColors.error,
                                  ),
                                  const SizedBox(
                                      width: AppConstants.paddingSmall),
                                  CustomText.medium(
                                    text: status,
                                    fontSize: AppConstants.fontMedium,
                                    color: AppColors.textPrimary,
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedFilter = value!;
                      });
                      _filterTransactions();
                    },
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              // Date Filter Button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showFilters = !_showFilters;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingMedium,
                      vertical: AppConstants.paddingSmall,
                    ),
                    decoration: BoxDecoration(
                      color: _showFilters
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.background,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMedium),
                      border: Border.all(
                        color: _showFilters
                            ? AppColors.primary
                            : AppColors.greyLight.withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.calendarDays,
                          size: 14,
                          color:
                              _showFilters ? AppColors.primary : AppColors.grey,
                        ),
                        const SizedBox(width: AppConstants.paddingSmall),
                        CustomText.medium(
                          text: 'Date Filter',
                          fontSize: AppConstants.fontMedium,
                          color: _showFilters
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                        if (_startDate != null || _endDate != null) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CustomText.regular(
                              text: '•',
                              fontSize: 10,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              // Export Button
              CustomButton(
                text: 'Export',
                onPressed: _exportHistory,
                icon: FontAwesomeIcons.download,
                width: 200,
                height: 45,
              ),
            ],
          ),
          // Date Filter Panel
          if (_showFilters) ...[
            const SizedBox(height: AppConstants.paddingMedium),
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.calendar,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppConstants.paddingSmall),
                      const CustomText.bold(
                        text: 'Date Range',
                        fontSize: AppConstants.fontMedium,
                        color: AppColors.textPrimary,
                      ),
                      const Spacer(),
                      if (_startDate != null || _endDate != null)
                        GestureDetector(
                          onTap: _clearDateFilter,
                          child: const CustomText.regular(
                            text: 'Clear',
                            fontSize: AppConstants.fontSmall,
                            color: AppColors.primary,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateSelector(
                          'Start Date',
                          _startDate,
                          (date) {
                            setState(() {
                              _startDate = date;
                            });
                            _filterTransactions();
                          },
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: _buildDateSelector(
                          'End Date',
                          _endDate,
                          (date) {
                            setState(() {
                              _endDate = date;
                            });
                            _filterTransactions();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickDateButton('Today'),
                      ),
                      const SizedBox(width: AppConstants.paddingSmall),
                      Expanded(
                        child: _buildQuickDateButton('Yesterday'),
                      ),
                      const SizedBox(width: AppConstants.paddingSmall),
                      Expanded(
                        child: _buildQuickDateButton('This Week'),
                      ),
                      const SizedBox(width: AppConstants.paddingSmall),
                      Expanded(
                        child: _buildQuickDateButton('This Month'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateSelector(
      String label, DateTime? selectedDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText.regular(
              text: label,
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.calendar,
                  size: 12,
                  color: AppColors.grey,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: CustomText.medium(
                    text: selectedDate != null
                        ? DateFormat('MMM dd').format(selectedDate)
                        : 'Select',
                    fontSize: AppConstants.fontSmall,
                    color: selectedDate != null
                        ? AppColors.textPrimary
                        : AppColors.textHint,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickDateButton(String label) {
    return GestureDetector(
      onTap: () {
        _setQuickDateRange(label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingSmall,
          vertical: AppConstants.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
        ),
        child: CustomText.medium(
          text: label,
          fontSize: 10,
          color: AppColors.textPrimary,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    if (_filteredTransactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(
              FontAwesomeIcons.receipt,
              size: 64,
              color: AppColors.grey,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            const CustomText.bold(
              text: 'No transactions found',
              fontSize: AppConstants.fontLarge,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            const CustomText.regular(
              text: 'Try adjusting your search or filters',
              fontSize: AppConstants.fontMedium,
              color: AppColors.textHint,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _filteredTransactions.length,
      itemBuilder: (context, index) {
        return _buildTransactionCard(_filteredTransactions[index]);
      },
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final isRefunded = transaction['status'] == 'Refunded';

    return CustomCard(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      onTap: () => _showTransactionDetails(transaction),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isRefunded
                      ? AppColors.error.withOpacity(0.1)
                      : AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                ),
                child: FaIcon(
                  isRefunded
                      ? FontAwesomeIcons.timesCircle
                      : FontAwesomeIcons.checkCircle,
                  size: 16,
                  color: isRefunded ? AppColors.error : AppColors.success,
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText.bold(
                      text: transaction['id'],
                      fontSize: AppConstants.fontLarge,
                      color:
                          isRefunded ? AppColors.error : AppColors.textPrimary,
                    ),
                    CustomText.regular(
                      text:
                          '${DateFormat('MMM dd, yyyy').format(transaction['date'])} at ${transaction['time']}',
                      fontSize: AppConstants.fontSmall,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color:
                      _getPaymentColor(transaction['payment']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      _getPaymentIcon(transaction['payment']),
                      size: 12,
                      color: _getPaymentColor(transaction['payment']),
                    ),
                    const SizedBox(width: 4),
                    CustomText.medium(
                      text: transaction['payment'],
                      fontSize: AppConstants.fontSmall,
                      color: _getPaymentColor(transaction['payment']),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          // Details
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.user,
                          size: 12,
                          color: AppColors.grey,
                        ),
                        const SizedBox(width: 4),
                        CustomText.regular(
                          text: transaction['cashier'],
                          fontSize: AppConstants.fontSmall,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.table,
                          size: 12,
                          color: AppColors.grey,
                        ),
                        const SizedBox(width: 4),
                        CustomText.regular(
                          text: transaction['table'],
                          fontSize: AppConstants.fontSmall,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText.regular(
                      text: '${transaction['items']} items',
                      fontSize: AppConstants.fontSmall,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 4),
                    CustomText.bold(
                      text: 'P${transaction['total'].toStringAsFixed(2)}',
                      fontSize: AppConstants.fontLarge,
                      color: isRefunded ? AppColors.error : AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Items Preview
          const SizedBox(height: AppConstants.paddingMedium),
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingSmall),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.utensils,
                  size: 12,
                  color: AppColors.grey,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: CustomText.regular(
                    text: (transaction['itemsList'] as List).join(', '),
                    fontSize: AppConstants.fontSmall,
                    color: AppColors.textSecondary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          child: Container(
            width: 500,
            constraints: const BoxConstraints(maxHeight: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primaryDark,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppConstants.radiusLarge),
                      topRight: Radius.circular(AppConstants.radiusLarge),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMedium),
                        ),
                        child: FaIcon(
                          transaction['status'] == 'Refunded'
                              ? FontAwesomeIcons.timesCircle
                              : FontAwesomeIcons.receipt,
                          size: 32,
                          color: transaction['status'] == 'Refunded'
                              ? AppColors.error
                              : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      CustomText.bold(
                        text: transaction['id'],
                        fontSize: AppConstants.fontHeading,
                        color: AppColors.white,
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      CustomText.regular(
                        text:
                            '${DateFormat('MMM dd, yyyy').format(transaction['date'])} at ${transaction['time']}',
                        fontSize: AppConstants.fontMedium,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Transaction Info
                        _buildDetailRow('Cashier', transaction['cashier']),
                        _buildDetailRow('Table', transaction['table']),
                        _buildDetailRow(
                            'Payment Method', transaction['payment']),
                        _buildDetailRow('Status', transaction['status'],
                            valueColor: transaction['status'] == 'Refunded'
                                ? AppColors.error
                                : AppColors.success),
                        const SizedBox(height: AppConstants.paddingLarge),

                        // Order Items
                        const CustomText.bold(
                          text: 'Order Items',
                          fontSize: AppConstants.fontLarge,
                          color: AppColors.textPrimary,
                        ),
                        const SizedBox(height: AppConstants.paddingMedium),
                        ...((transaction['itemsList'] as List)
                            .map((item) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppConstants.paddingSmall),
                                  child: Row(
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.circle,
                                        size: 8,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(
                                          width: AppConstants.paddingSmall),
                                      CustomText.regular(
                                        text: item,
                                        fontSize: AppConstants.fontMedium,
                                        color: AppColors.textPrimary,
                                      ),
                                    ],
                                  ),
                                ))),

                        const SizedBox(height: AppConstants.paddingLarge),

                        // Summary
                        Container(
                          padding:
                              const EdgeInsets.all(AppConstants.paddingMedium),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusMedium),
                          ),
                          child: Column(
                            children: [
                              _buildSummaryRow(
                                  'Sub Total', transaction['subtotal']),
                              const SizedBox(height: AppConstants.paddingSmall),
                              _buildSummaryRow('Tax (11%)', transaction['tax']),
                              const SizedBox(height: AppConstants.paddingSmall),
                              const Divider(),
                              _buildSummaryRow('Total', transaction['total'],
                                  isBold: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Actions
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(AppConstants.radiusLarge),
                      bottomRight: Radius.circular(AppConstants.radiusLarge),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (transaction['status'] == 'Completed') ...[
                        Expanded(
                          child: CustomButton(
                            text: 'Refund',
                            onPressed: () {
                              Navigator.of(context).pop();
                              _processRefund(transaction);
                            },
                            backgroundColor: AppColors.error,
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingMedium),
                      ],
                      Expanded(
                        child: CustomButton(
                          text: 'Print Receipt',
                          onPressed: () {
                            Navigator.of(context).pop();
                            _printReceipt(transaction);
                          },
                          backgroundColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: Row(
        children: [
          CustomText.regular(
            text: '$label:',
            fontSize: AppConstants.fontMedium,
            color: AppColors.textSecondary,
          ),
          const Spacer(),
          CustomText.bold(
            text: value,
            fontSize: AppConstants.fontMedium,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          fontSize: AppConstants.fontMedium,
          color: AppColors.textSecondary,
          fontFamily: isBold ? 'Bold' : 'Regular',
        ),
        CustomText(
          text: 'P${amount.toStringAsFixed(2)}',
          fontSize: AppConstants.fontMedium,
          color: AppColors.textPrimary,
          fontFamily: isBold ? 'Bold' : 'Regular',
        ),
      ],
    );
  }

  Color _getPaymentColor(String payment) {
    switch (payment) {
      case 'Cash':
        return AppColors.success;
      case 'Card':
        return AppColors.info;
      case 'GCash':
        return AppColors.primary;
      default:
        return AppColors.grey;
    }
  }

  IconData _getPaymentIcon(String payment) {
    switch (payment) {
      case 'Cash':
        return FontAwesomeIcons.wallet;
      case 'Card':
        return FontAwesomeIcons.creditCard;
      case 'GCash':
        return FontAwesomeIcons.g;
      default:
        return FontAwesomeIcons.moneyBill;
    }
  }

  void _setQuickDateRange(String range) {
    final now = DateTime.now();
    DateTime start;
    DateTime end;

    switch (range) {
      case 'Today':
        start = DateTime(now.year, now.month, now.day);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case 'Yesterday':
        start = DateTime(now.year, now.month, now.day - 1);
        end = DateTime(now.year, now.month, now.day - 1, 23, 59, 59);
        break;
      case 'This Week':
        start = now.subtract(Duration(days: now.weekday - 1));
        end = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
        break;
      case 'This Month':
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
      default:
        return;
    }

    setState(() {
      _startDate = start;
      _endDate = end;
    });
    _filterTransactions();
  }

  void _clearDateFilter() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
    _filterTransactions();
  }

  void _exportHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transaction history exported successfully!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _processRefund(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          child: Container(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.exclamationTriangle,
                    size: 32,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                const CustomText.bold(
                  text: 'Process Refund',
                  fontSize: AppConstants.fontHeading,
                  color: AppColors.textPrimary,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                CustomText.regular(
                  text:
                      'Are you sure you want to refund ${transaction['id']}? This action cannot be undone.',
                  fontSize: AppConstants.fontMedium,
                  color: AppColors.textSecondary,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Cancel',
                        onPressed: () => Navigator.of(context).pop(),
                        isOutlined: true,
                        backgroundColor: AppColors.greyLight,
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingMedium),
                    Expanded(
                      child: CustomButton(
                        text: 'Confirm Refund',
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Refund processed successfully!'),
                              backgroundColor: AppColors.success,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        backgroundColor: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _printReceipt(Map<String, dynamic> transaction) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Receipt sent to printer!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
