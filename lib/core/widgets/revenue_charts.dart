import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

/// Graphique Line Chart des revenus sur 7 jours
class RevenueLineChart extends StatelessWidget {
  final List<double> dailyRevenues; // 7 derniers jours
  final String currency;

  const RevenueLineChart({
    super.key,
    required this.dailyRevenues,
    this.currency = 'XOF',
  });

  @override
  Widget build(BuildContext context) {
    if (dailyRevenues.isEmpty) {
      return _buildEmptyState();
    }

    final maxY = dailyRevenues.reduce((a, b) => a > b ? a : b) * 1.2;
    final minY = 0.0;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Revenus (7 derniers jours)',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 14.r,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '+${_calculateGrowth()}%',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 180.h,
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.divider,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45.w,
                      getTitlesWidget: (value, meta) {
                        if (value == meta.max || value == meta.min) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          '${(value / 1000).toStringAsFixed(0)}k',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textTertiary,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
                        final index = value.toInt();
                        if (index < 0 || index >= days.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            days[index],
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      dailyRevenues.length,
                      (index) => FlSpot(index.toDouble(), dailyRevenues[index]),
                    ),
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: AppColors.primary,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: AppColors.primary,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.3),
                          AppColors.primary.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toStringAsFixed(0)} $currency',
                          TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat(
                'Total',
                '${dailyRevenues.reduce((a, b) => a + b).toStringAsFixed(0)} $currency',
                AppColors.primary,
              ),
              _buildStat(
                'Moyenne',
                '${(dailyRevenues.reduce((a, b) => a + b) / dailyRevenues.length).toStringAsFixed(0)} $currency',
                AppColors.textSecondary,
              ),
              _buildStat(
                'Max',
                '${dailyRevenues.reduce((a, b) => a > b ? a : b).toStringAsFixed(0)} $currency',
                const Color(0xFF10B981),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textTertiary,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  int _calculateGrowth() {
    if (dailyRevenues.length < 2) return 0;
    
    final firstHalf = dailyRevenues.sublist(0, (dailyRevenues.length / 2).ceil());
    final secondHalf = dailyRevenues.sublist((dailyRevenues.length / 2).ceil());
    
    final avgFirst = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
    final avgSecond = secondHalf.reduce((a, b) => a + b) / secondHalf.length;
    
    if (avgFirst == 0) return 0;
    
    return ((avgSecond - avgFirst) / avgFirst * 100).round();
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200.h,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.show_chart,
            size: 48.r,
            color: AppColors.textTertiary,
          ),
          SizedBox(height: 8.h),
          Text(
            'Aucune donnée disponible',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Graphique Bar Chart des bookings par offre
class BookingsBarChart extends StatelessWidget {
  final Map<String, int> offerBookings; // offerName -> bookingsCount
  final int topN;

  const BookingsBarChart({
    super.key,
    required this.offerBookings,
    this.topN = 5,
  });

  @override
  Widget build(BuildContext context) {
    final sortedEntries = offerBookings.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final topEntries = sortedEntries.take(topN).toList();

    if (topEntries.isEmpty) {
      return _buildEmptyState();
    }

    final maxValue = topEntries.first.value.toDouble() * 1.2;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top $topN offres (bookings)',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 200.h,
            child: BarChart(
              BarChartData(
                maxY: maxValue,
                barGroups: List.generate(
                  topEntries.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: topEntries[index].value.toDouble(),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.7),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: 24.w,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35.w,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textTertiary,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= topEntries.length) {
                          return const SizedBox.shrink();
                        }
                        final offerName = topEntries[index].key;
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            offerName.length > 10
                                ? '${offerName.substring(0, 8)}...'
                                : offerName,
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: AppColors.textTertiary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${topEntries[groupIndex].key}\n${rod.toY.toInt()} bookings',
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200.h,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bar_chart,
            size: 48.r,
            color: AppColors.textTertiary,
          ),
          SizedBox(height: 8.h),
          Text(
            'Aucune réservation pour le moment',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
