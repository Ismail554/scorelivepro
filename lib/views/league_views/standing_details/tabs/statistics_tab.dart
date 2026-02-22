import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/services/league_service.dart';
import 'package:scorelivepro/models/live_ws_model.dart' as ws;

/// Statistics Tab Widget
/// Displays team statistics with ListView.builder
class StatisticsTab extends StatefulWidget {
  final int? fixtureId;
  final int? homeTeamId;
  final int? awayTeamId;

  const StatisticsTab({
    super.key,
    this.fixtureId,
    this.homeTeamId,
    this.awayTeamId,
  });

  @override
  State<StatisticsTab> createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab> {
  bool _isLoading = true;
  List<ws.Statistic>? _statisticsData;

  @override
  void initState() {
    super.initState();
    _fetchStatistics();
  }

  Future<void> _fetchStatistics() async {
    if (widget.fixtureId == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    final data = await LeagueService.fetchMatchStatistics(widget.fixtureId!);
    if (mounted) {
      setState(() {
        _statisticsData = data;
        _isLoading = false;
      });
    }
  }

  // Helper to extract int value
  int _parseValue(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      // Remove % if present
      final clean = value.replaceAll('%', '').trim();
      return int.tryParse(clean) ?? 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_statisticsData == null || _statisticsData!.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            "Statistics not available yet",
            style: FontManager.bodyMedium(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    // Identify Stats lists for Home/Away (based on IDs passing from screen)
    final homeStatsData = _statisticsData!.firstWhere(
      (s) => s.team?.id == widget.homeTeamId,
      orElse: () => _statisticsData![0], // fallback
    );

    final awayStatsData = _statisticsData!.firstWhere(
      (s) => s.team?.id == widget.awayTeamId,
      orElse: () => _statisticsData!.length > 1
          ? _statisticsData![1]
          : _statisticsData![0], // fallback
    );

    final homeStats = homeStatsData.statistics ?? [];
    final awayStats = awayStatsData.statistics ?? [];

    // Unique types across both. Usually they match.
    final Set<String> types = {};
    for (var s in homeStats) {
      if (s.type != null) types.add(s.type!);
    }
    for (var s in awayStats) {
      if (s.type != null) types.add(s.type!);
    }

    if (types.isEmpty) {
      return Center(
        child: Text(
          "No statistics found",
          style: FontManager.bodyMedium(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: types.length,
      itemBuilder: (context, index) {
        final type = types.elementAt(index);

        final homeItem = homeStats.firstWhere(
          (s) => s.type == type,
          orElse: () => ws.StatisticItem(type: type, value: 0),
        );
        final awayItem = awayStats.firstWhere(
          (s) => s.type == type,
          orElse: () => ws.StatisticItem(type: type, value: 0),
        );

        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: _StatRow(
            statName: type,
            homeValue: _parseValue(homeItem.value),
            awayValue: _parseValue(awayItem.value),
          ),
        );
      },
    );
  }
}

/// Stat Row Widget
class _StatRow extends StatelessWidget {
  final String statName;
  final int homeValue;
  final int awayValue;

  const _StatRow({
    required this.statName,
    required this.homeValue,
    required this.awayValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(width: 1.w, color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Values Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Home Value (left)
              Text(
                homeValue.toString(),
                style: FontManager.heading3(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
              ),
              // Stat Name (centered)
              Text(
                statName,
                style: FontManager.labelMedium(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
              // Away Value (right)
              Text(
                awayValue.toString(),
                style: FontManager.heading3(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Progress Bar
          Row(
            children: [
              // Team progress (orange)
              Expanded(
                flex: homeValue == 0 && awayValue == 0
                    ? 1
                    : (homeValue == 0 ? 0 : homeValue),
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor, // Orange
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.r),
                      bottomLeft: Radius.circular(3.r),
                      topRight:
                          homeValue == 0 ? Radius.circular(3.r) : Radius.zero,
                      bottomRight:
                          homeValue == 0 ? Radius.circular(3.r) : Radius.zero,
                    ),
                  ),
                ),
              ),

              // Opponent progress (yellow)
              Expanded(
                flex: homeValue == 0 && awayValue == 0
                    ? 1
                    : (awayValue == 0 ? 0 : awayValue),
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: AppColors.warning, // Yellow
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(3.r),
                      bottomRight: Radius.circular(3.r),
                      topLeft:
                          awayValue == 0 ? Radius.circular(3.r) : Radius.zero,
                      bottomLeft:
                          awayValue == 0 ? Radius.circular(3.r) : Radius.zero,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
