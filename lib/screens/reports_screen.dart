import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:para/utils/colors.dart';
import 'package:para/utils/constants.dart';
import 'package:para/widgets/custom_text.dart';
import 'package:para/widgets/custom_card.dart';
import 'package:para/widgets/custom_button.dart';
import 'package:para/widgets/custom_drawer.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedReportType = 'Sales';
  bool _showChart = true;
  bool _showTransactions = true;

  // Sample data for charts
  final List<Map<String, dynamic>> _salesData = [
    {'day': 'Mon', 'sales': 1200.0},
    {'day': 'Tue', 'sales': 1800.0},
    {'day': 'Wed', 'sales': 1500.0},
    {'day': 'Thu', 'sales': 2200.0},
    {'day': 'Fri', 'sales': 2800.0},
    {'day': 'Sat', 'sales': 3200.0},
    {'day': 'Sun', 'sales': 2900.0},
  ];

  final List<Map<String, dynamic>> _categoryData = [
    {'category': 'Burgers', 'value': 35.0, 'color': AppColors.primary},
    {'category': 'Pizza', 'value': 25.0, 'color': AppColors.warning},
    {'category': 'Beverages', 'value': 20.0, 'color': AppColors.info},
    {'category': 'Desserts', 'value': 12.0, 'color': AppColors.success},
    {'category': 'Others', 'value': 8.0, 'color': AppColors.grey},
  ];

  final List<Map<String, dynamic>> _transactions = [
    {
      'id': '#010',
      'date': '2024-01-15',
      'time': '10:30 AM',
      'cashier': 'Broicad',
      'items': 4,
      'total': 125.50,
      'payment': 'Cash',
      'status': 'Completed',
    },
    {
      'id': '#011',
      'date': '2024-01-15',
      'time': '11:45 AM',
      'cashier': 'Avita',
      'items': 2,
      'total': 85.75,
      'payment': 'Card',
      'status': 'Completed',
    },
    {
      'id': '#012',
      'date': '2024-01-15',
      'time': '12:15 PM',
      'cashier': 'Broicad',
      'items': 6,
      'total': 215.25,
      'payment': 'GCash',
      'status': 'Completed',
    },
    {
      'id': '#013',
      'date': '2024-01-15',
      'time': '01:30 PM',
      'cashier': 'John',
      'items': 3,
      'total': 95.00,
      'payment': 'Cash',
      'status': 'Refunded',
    },
    {
      'id': '#014',
      'date': '2024-01-15',
      'time': '02:45 PM',
      'cashier': 'Avita',
      'items': 5,
      'total': 175.50,
      'payment': 'Card',
      'status': 'Completed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: Builder(builder: (context) {
        return const CustomDrawer(currentRoute: 'reports');
      }),
      body: Row(
        children: [
          // Main Content
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildReportSummary(),
                          const SizedBox(height: AppConstants.paddingLarge),
                          _buildChartsSection(),
                          const SizedBox(height: AppConstants.paddingLarge),
                          _buildTransactionsSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Right Panel - Filters
          Container(
            width: 350,
            color: AppColors.white,
            child: _buildFilterPanel(),
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
            text: 'Reports & Analytics',
            fontSize: AppConstants.fontHeading,
            color: AppColors.textPrimary,
          ),
          const Spacer(),
          // Export Button
          CustomButton(
            text: 'Export Report',
            onPressed: _exportReport,
            icon: FontAwesomeIcons.download,
            width: 200,
            height: 45,
          ),
        ],
      ),
    );
  }

  Widget _buildReportSummary() {
    final totalSales = _salesData.fold(0.0, (sum, item) => sum + item['sales']);
    final totalTransactions = _transactions.length;
    final avgTransaction =
        totalSales > 0 ? totalSales / totalTransactions : 0.0;

    return Row(
      children: [
        Expanded(
          child: CustomCard(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusSmall),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.pesoSign,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    const CustomText.regular(
                      text: 'Total Sales',
                      fontSize: AppConstants.fontSmall,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                CustomText.bold(
                  text: 'P${totalSales.toStringAsFixed(2)}',
                  fontSize: AppConstants.fontHeading,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 4),
                const CustomText.regular(
                  text: '+12.5% from last period',
                  fontSize: AppConstants.fontSmall,
                  color: AppColors.success,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppConstants.paddingMedium),
        Expanded(
          child: CustomCard(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusSmall),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.receipt,
                        size: 16,
                        color: AppColors.info,
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    const CustomText.regular(
                      text: 'Transactions',
                      fontSize: AppConstants.fontSmall,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                CustomText.bold(
                  text: '$totalTransactions',
                  fontSize: AppConstants.fontHeading,
                  color: AppColors.info,
                ),
                const SizedBox(height: 4),
                const CustomText.regular(
                  text: '+8.2% from last period',
                  fontSize: AppConstants.fontSmall,
                  color: AppColors.success,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppConstants.paddingMedium),
        Expanded(
          child: CustomCard(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusSmall),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.chartLine,
                        size: 16,
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    const CustomText.regular(
                      text: 'Avg. Transaction',
                      fontSize: AppConstants.fontSmall,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                CustomText.bold(
                  text: 'P${avgTransaction.toStringAsFixed(2)}',
                  fontSize: AppConstants.fontHeading,
                  color: AppColors.warning,
                ),
                const SizedBox(height: 4),
                const CustomText.regular(
                  text: '+3.1% from last period',
                  fontSize: AppConstants.fontSmall,
                  color: AppColors.success,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText.bold(
              text: 'Analytics',
              fontSize: AppConstants.fontExtraLarge,
              color: AppColors.textPrimary,
            ),
            const Spacer(),
            // Report Type Selector
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
              child: DropdownButton<String>(
                value: _selectedReportType,
                underline: const SizedBox(),
                isDense: true,
                items: ['Sales', 'Orders', 'Items', 'Customers']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: CustomText.medium(
                            text: type,
                            fontSize: AppConstants.fontMedium,
                            color: AppColors.textPrimary,
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedReportType = value!;
                  });
                },
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            // Toggle Chart View
            GestureDetector(
              onTap: () {
                setState(() {
                  _showChart = !_showChart;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: _showChart
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.background,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMedium),
                  border: Border.all(
                    color: _showChart
                        ? AppColors.primary
                        : AppColors.greyLight.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      _showChart
                          ? FontAwesomeIcons.chartLine
                          : FontAwesomeIcons.chartPie,
                      size: 14,
                      color: _showChart ? AppColors.primary : AppColors.grey,
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    CustomText.medium(
                      text: _showChart ? 'Line Chart' : 'Pie Chart',
                      fontSize: AppConstants.fontSmall,
                      color: _showChart
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingLarge),
        // Charts
        SizedBox(
          height: 300,
          child: _showChart ? _buildLineChart() : _buildPieChart(),
        ),
      ],
    );
  }

  Widget _buildLineChart() {
    return CustomCard(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText.bold(
                text: 'Weekly Sales Trend',
                fontSize: AppConstants.fontLarge,
                color: AppColors.textPrimary,
              ),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const CustomText.regular(
                    text: 'Sales (PHP)',
                    fontSize: AppConstants.fontSmall,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.greyLight.withOpacity(0.3),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: AppColors.greyLight.withOpacity(0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final style = const TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        );
                        String text;
                        switch (value.toInt()) {
                          case 0:
                            text = 'Mon';
                            break;
                          case 1:
                            text = 'Tue';
                            break;
                          case 2:
                            text = 'Wed';
                            break;
                          case 3:
                            text = 'Thu';
                            break;
                          case 4:
                            text = 'Fri';
                            break;
                          case 5:
                            text = 'Sat';
                            break;
                          case 6:
                            text = 'Sun';
                            break;
                          default:
                            text = '';
                            break;
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(text, style: style),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        );
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            value.toInt().toString(),
                            style: style,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border:
                      Border.all(color: AppColors.greyLight.withOpacity(0.3)),
                ),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 3500,
                lineBarsData: [
                  LineChartBarData(
                    spots: _salesData.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value['sales']);
                    }).toList(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.8),
                        AppColors.primaryLight.withOpacity(0.8),
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppColors.primary,
                          strokeWidth: 2,
                          strokeColor: AppColors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.3),
                          AppColors.primary.withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return CustomCard(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          const CustomText.bold(
            text: 'Sales by Category',
            fontSize: AppConstants.fontLarge,
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 60,
                      sections: _categoryData.asMap().entries.map((entry) {
                        final index = entry.key;
                        final data = entry.value;
                        final isTouched =
                            index == 0; // First item is touched by default
                        final fontSize = isTouched ? 16.0 : 12.0;
                        final radius = isTouched ? 60.0 : 50.0;

                        return PieChartSectionData(
                          color: data['color'],
                          value: data['value'],
                          title: '${data['value']}%',
                          radius: radius,
                          titleStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _categoryData.map((data) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppConstants.paddingSmall),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: data['color'],
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CustomText.regular(
                                text: data['category'],
                                fontSize: AppConstants.fontSmall,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            CustomText.bold(
                              text: '${data['value']}%',
                              fontSize: AppConstants.fontSmall,
                              color: AppColors.textPrimary,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText.bold(
              text: 'Recent Transactions',
              fontSize: AppConstants.fontExtraLarge,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingSmall,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              ),
              child: CustomText.regular(
                text: '${_transactions.length} Transactions',
                fontSize: AppConstants.fontSmall,
                color: AppColors.white,
              ),
            ),
            const Spacer(),
            // Hide/Show Toggle
            GestureDetector(
              onTap: () {
                setState(() {
                  _showTransactions = !_showTransactions;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: _showTransactions
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.background,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMedium),
                  border: Border.all(
                    color: _showTransactions
                        ? AppColors.primary
                        : AppColors.greyLight.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      _showTransactions
                          ? FontAwesomeIcons.eyeSlash
                          : FontAwesomeIcons.eye,
                      size: 14,
                      color: _showTransactions
                          ? AppColors.primary
                          : AppColors.grey,
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    CustomText.medium(
                      text: _showTransactions ? 'Hide' : 'Show',
                      fontSize: AppConstants.fontSmall,
                      color: _showTransactions
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingLarge),
        // Transactions Table
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _showTransactions ? 400 : 0,
          curve: Curves.easeInOut,
          child: _showTransactions
              ? CustomCard(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    children: [
                      // Table Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingMedium,
                          vertical: AppConstants.paddingSmall,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusSmall),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomText.bold(
                                text: 'ID',
                                fontSize: AppConstants.fontSmall,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: CustomText.bold(
                                text: 'Date & Time',
                                fontSize: AppConstants.fontSmall,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: CustomText.bold(
                                text: 'Cashier',
                                fontSize: AppConstants.fontSmall,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: CustomText.bold(
                                text: 'Items',
                                fontSize: AppConstants.fontSmall,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: CustomText.bold(
                                text: 'Total',
                                fontSize: AppConstants.fontSmall,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: CustomText.bold(
                                text: 'Payment',
                                fontSize: AppConstants.fontSmall,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: CustomText.bold(
                                text: 'Status',
                                fontSize: AppConstants.fontSmall,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      // Table Content
                      Expanded(
                        child: ListView.builder(
                          itemCount: _transactions.length,
                          itemBuilder: (context, index) {
                            return _buildTransactionRow(_transactions[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildTransactionRow(Map<String, dynamic> transaction) {
    final isRefunded = transaction['status'] == 'Refunded';

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: isRefunded ? AppColors.error.withOpacity(0.05) : AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
        border: Border.all(
          color: isRefunded
              ? AppColors.error.withOpacity(0.2)
              : AppColors.greyLight.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: CustomText.bold(
              text: transaction['id'],
              fontSize: AppConstants.fontSmall,
              color: isRefunded ? AppColors.error : AppColors.textPrimary,
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.regular(
                  text: transaction['date'],
                  fontSize: AppConstants.fontSmall,
                  color: AppColors.textPrimary,
                ),
                CustomText.regular(
                  text: transaction['time'],
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: CustomText.regular(
              text: transaction['cashier'],
              fontSize: AppConstants.fontSmall,
              color: AppColors.textPrimary,
            ),
          ),
          Expanded(
            flex: 1,
            child: CustomText.regular(
              text: '${transaction['items']}',
              fontSize: AppConstants.fontSmall,
              color: AppColors.textPrimary,
            ),
          ),
          Expanded(
            flex: 1,
            child: CustomText.bold(
              text: 'P${transaction['total'].toStringAsFixed(2)}',
              fontSize: AppConstants.fontSmall,
              color: isRefunded ? AppColors.error : AppColors.textPrimary,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingSmall,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color:
                    _getPaymentColor(transaction['payment']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: CustomText.medium(
                text: transaction['payment'],
                fontSize: 10,
                color: _getPaymentColor(transaction['payment']),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingSmall,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: isRefunded
                    ? AppColors.error.withOpacity(0.1)
                    : AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: CustomText.medium(
                text: transaction['status'],
                fontSize: 10,
                color: isRefunded ? AppColors.error : AppColors.success,
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildFilterPanel() {
    return Column(
      children: [
        // Header
        Container(
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
                  color: AppColors.border.withOpacity(0.3), width: 1),
            ),
          ),
          child: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.filter,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              const CustomText.bold(
                text: 'Filters',
                fontSize: AppConstants.fontLarge,
                color: AppColors.textPrimary,
              ),
              const Spacer(),
              IconButton(
                onPressed: _resetFilters,
                icon: const FaIcon(
                  FontAwesomeIcons.rotateRight,
                  size: 16,
                  color: AppColors.grey,
                ),
                tooltip: 'Reset Filters',
              ),
            ],
          ),
        ),
        // Filter Options
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Range
                const CustomText.bold(
                  text: 'Date Range',
                  fontSize: AppConstants.fontMedium,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                _buildDateSelector('Start Date', _startDate, (date) {
                  setState(() {
                    _startDate = date;
                  });
                }),
                const SizedBox(height: AppConstants.paddingMedium),
                _buildDateSelector('End Date', _endDate, (date) {
                  setState(() {
                    _endDate = date;
                  });
                }),
                const SizedBox(height: AppConstants.paddingLarge),

                // Quick Date Ranges
                const CustomText.bold(
                  text: 'Quick Ranges',
                  fontSize: AppConstants.fontMedium,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                _buildQuickRangeButton('Today'),
                const SizedBox(height: AppConstants.paddingSmall),
                _buildQuickRangeButton('Yesterday'),
                const SizedBox(height: AppConstants.paddingSmall),
                _buildQuickRangeButton('This Week'),
                const SizedBox(height: AppConstants.paddingSmall),
                _buildQuickRangeButton('This Month'),
                const SizedBox(height: AppConstants.paddingSmall),
                _buildQuickRangeButton('Last Month'),
                const SizedBox(height: AppConstants.paddingLarge),

                // Report Type
                const CustomText.bold(
                  text: 'Report Type',
                  fontSize: AppConstants.fontMedium,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                _buildReportTypeOption('Sales', FontAwesomeIcons.pesoSign),
                const SizedBox(height: AppConstants.paddingSmall),
                _buildReportTypeOption('Orders', FontAwesomeIcons.receipt),
                const SizedBox(height: AppConstants.paddingSmall),
                _buildReportTypeOption('Items', FontAwesomeIcons.utensils),
                const SizedBox(height: AppConstants.paddingSmall),
                _buildReportTypeOption('Customers', FontAwesomeIcons.users),
                const SizedBox(height: AppConstants.paddingLarge),

                // Apply Filters Button
                CustomButton(
                  text: 'Apply Filters',
                  onPressed: _applyFilters,
                  backgroundColor: AppColors.primary,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
              ],
            ),
          ),
        ),
      ],
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
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText.regular(
              text: label,
              fontSize: AppConstants.fontSmall,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.calendar,
                  size: 14,
                  color: AppColors.grey,
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Expanded(
                  child: CustomText.medium(
                    text: selectedDate != null
                        ? DateFormat('MMM dd, yyyy').format(selectedDate)
                        : 'Select date',
                    fontSize: AppConstants.fontMedium,
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

  Widget _buildQuickRangeButton(String label) {
    return GestureDetector(
      onTap: () {
        _setQuickDateRange(label);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingMedium,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
        ),
        child: CustomText.medium(
          text: label,
          fontSize: AppConstants.fontMedium,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildReportTypeOption(String label, IconData icon) {
    final isSelected = _selectedReportType == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReportType = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.background,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.greyLight.withOpacity(0.5),
          ),
        ),
        child: Row(
          children: [
            FaIcon(
              icon,
              size: 16,
              color: isSelected ? AppColors.primary : AppColors.grey,
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            CustomText.medium(
              text: label,
              fontSize: AppConstants.fontMedium,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
            ),
            const Spacer(),
            if (isSelected)
              const FaIcon(
                FontAwesomeIcons.check,
                size: 14,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
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
      case 'Last Month':
        start = DateTime(now.year, now.month - 1, 1);
        end = DateTime(now.year, now.month, 0, 23, 59, 59);
        break;
      default:
        return;
    }

    setState(() {
      _startDate = start;
      _endDate = end;
    });
  }

  void _resetFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedReportType = 'Sales';
    });
  }

  void _applyFilters() {
    // Apply filters and refresh data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filters applied successfully!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _exportReport() {
    // Export report functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report exported successfully!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
