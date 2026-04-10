import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/provider/team_provider.dart';
import 'package:scorelivepro/widget/mini_widget/mw_blinking_dot.dart';
import 'package:scorelivepro/widget/mini_widget/mw_blinking_widget.dart';
import 'package:scorelivepro/widget/common/auto_marquee_text.dart';

/// Match status enum
enum MatchStatus {
  live,
  halfTime,
  upcoming,
  finished,
}

class MatchCard extends StatelessWidget {
  final String leagueName;
  final String homeTeam;
  final String awayTeam;
  final int? homeTeamId;
  final int? awayTeamId;
  final int? homeScore;
  final int? awayScore;
  final String timeInfo;
  final MatchStatus status;
  final VoidCallback? onTap;

  const MatchCard({
    super.key,
    required this.leagueName,
    required this.homeTeam,
    required this.awayTeam,
    this.homeTeamId,
    this.awayTeamId,
    this.homeScore,
    this.awayScore,
    required this.timeInfo,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLive = status == MatchStatus.live || status == MatchStatus.halfTime;
    final isUpcoming = status == MatchStatus.upcoming;
    final isFinished = status == MatchStatus.finished;

    // Parse timeInfo for upcoming and finished matches
    String dateText = '';
    String timeBadgeText = timeInfo;

    if ((isUpcoming || isFinished) && timeInfo.contains(',')) {
      final parts = timeInfo.split(',');
      dateText = parts[0].trim();
      if (parts.length > 1) {
        timeBadgeText = parts[1].trim();
      }
    } else if (isFinished && !timeInfo.contains(',')) {
      dateText = timeInfo;
      timeBadgeText = 'FT';
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showFavoritePopup(context),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: Colors.grey.shade400,
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: For live matches, show yellow dot + LIVE + league name
            if (isLive) ...[
              Row(
                children: [
                  BlinkingDot(
                    color: AppColors.warning,
                    size: 8,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'LIVE',
                    style: FontManager.labelMedium(
                      color: AppColors.warning,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: AutoMarqueeText(
                      text: leagueName,
                      style: FontManager.leagueName(
                        color: AppColors.textSecondary,
                        fontSize: 12.sp,
                      ),
                      height: 18.h,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Container(
                height: 1.h,
                color: AppColors.warning,
              ),
              SizedBox(height: 16.h),
            ] else ...[
              AutoMarqueeText(
                text: leagueName,
                style: FontManager.leagueName(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                ),
                height: 18.h,
              ),
              SizedBox(height: 16.h),
            ],

            // Home Team Row
            _buildTeamRow(homeTeam, homeScore),

            SizedBox(height: 12.h),

            // Away Team Row
            _buildTeamRow(awayTeam, awayScore),

            SizedBox(height: 12.h),

            // Divider
            Divider(
              color: AppColors.greyE8,
              thickness: 1.h,
              height: 1.h,
            ),

            if (!isLive) SizedBox(height: 12.h),

            AppSpacing.h10,

            // Footer: Time info and badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isLive ? timeInfo : dateText,
                    style: FontManager.bodySmall(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusBadge(isFinished ? 'FT' : timeBadgeText),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Show favorite popup on long press
  void _showFavoritePopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        return _FavoriteTeamPopup(
          homeTeam: homeTeam,
          awayTeam: awayTeam,
          homeTeamId: homeTeamId,
          awayTeamId: awayTeamId,
        );
      },
    );
  }

  /// Helper widget to build a row: "Team Name ......... Score"
  Widget _buildTeamRow(String teamName, int? score) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AutoMarqueeText(
            text: teamName,
            style: FontManager.heading4(
              color: AppColors.textPrimary,
              fontSize: 16.sp,
            ),
            height: 24.h,
          ),
        ),
        Text(
          score != null ? score.toString() : '-',
          style: FontManager.heading4(
            color: AppColors.textPrimary,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }

  /// Build status badge based on match status
  Widget _buildStatusBadge(String badgeText) {
    switch (status) {
      case MatchStatus.live:
        return BlinkingWidget(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.warning,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'LIVE',
              style: FontManager.labelMedium(
                color: AppColors.white,
                fontSize: 12.sp,
              ),
            ),
          ),
        );
      case MatchStatus.halfTime:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.grey,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            'HT',
            style: FontManager.labelMedium(
              color: AppColors.white,
              fontSize: 12.sp,
            ),
          ),
        );
      case MatchStatus.upcoming:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.greyE8,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            badgeText,
            style: FontManager.bodySmall(
              color: AppColors.textPrimary,
              fontSize: 12.sp,
            ),
          ),
        );
      case MatchStatus.finished:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.finishedMatch,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            'FT',
            style: FontManager.labelMedium(
              color: AppColors.white,
              fontSize: 12.sp,
            ),
          ),
        );
    }
  }
}

/// Glassmorphism popup for adding teams to favorites
class _FavoriteTeamPopup extends StatefulWidget {
  final String homeTeam;
  final String awayTeam;
  final int? homeTeamId;
  final int? awayTeamId;

  const _FavoriteTeamPopup({
    required this.homeTeam,
    required this.awayTeam,
    this.homeTeamId,
    this.awayTeamId,
  });

  @override
  State<_FavoriteTeamPopup> createState() => _FavoriteTeamPopupState();
}

class _FavoriteTeamPopupState extends State<_FavoriteTeamPopup>
    with SingleTickerProviderStateMixin {
  bool _homeLoading = false;
  bool _awayLoading = false;
  bool _homeAdded = false;
  bool _awayAdded = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _toggleFavorite({required bool isHome}) async {
    final teamId = isHome ? widget.homeTeamId : widget.awayTeamId;
    final teamName = isHome ? widget.homeTeam : widget.awayTeam;

    if (teamId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Team ID not available"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
      return;
    }

    setState(() {
      if (isHome) _homeLoading = true;
      if (!isHome) _awayLoading = true;
    });

    await Provider.of<TeamProvider>(context, listen: false)
        .addTeamToFavorites(teamId, teamName, context);

    if (mounted) {
      setState(() {
        if (isHome) {
          _homeLoading = false;
          _homeAdded = true;
        } else {
          _awayLoading = false;
          _awayAdded = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.4),
                  width: 1.w,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: AppColors.warning,
                            size: 24.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "Add to Favorites",
                            style: FontManager.heading3(
                              color: AppColors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: AppColors.white.withValues(alpha: 0.7),
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Subtitle
                  Text(
                    "Add teams to favorites for personalized notifications",
                    style: FontManager.bodySmall(
                      color: AppColors.white.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Home Team Row
                  _buildTeamTile(
                    teamName: widget.homeTeam,
                    label: "Home",
                    isLoading: _homeLoading,
                    isAdded: _homeAdded,
                    onTap: () => _toggleFavorite(isHome: true),
                  ),

                  SizedBox(height: 12.h),

                  // Away Team Row
                  _buildTeamTile(
                    teamName: widget.awayTeam,
                    label: "Away",
                    isLoading: _awayLoading,
                    isAdded: _awayAdded,
                    onTap: () => _toggleFavorite(isHome: false),
                  ),

                  SizedBox(height: 16.h),

                  // Close button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: BorderSide(
                            color: AppColors.white.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                      child: Text(
                        "Close",
                        style: FontManager.labelMedium(
                          color: AppColors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamTile({
    required String teamName,
    required String label,
    required bool isLoading,
    required bool isAdded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isAdded ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isAdded
              ? AppColors.success.withValues(alpha: 0.15)
              : AppColors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isAdded
                ? AppColors.success.withValues(alpha: 0.4)
                : AppColors.white.withValues(alpha: 0.15),
            width: 1.w,
          ),
        ),
        child: Row(
          children: [
            // Team badge
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  label.substring(0, 1),
                  style: FontManager.heading3(
                    color: AppColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            SizedBox(width: 14.w),

            // Team info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teamName,
                    style: FontManager.teamName(
                      color: AppColors.white,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    label,
                    style: FontManager.bodySmall(
                      color: AppColors.white.withValues(alpha: 0.5),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // Star toggle
            if (isLoading)
              SizedBox(
                width: 24.w,
                height: 24.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  color: AppColors.warning,
                ),
              )
            else
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  isAdded ? Icons.star_rounded : Icons.star_border_rounded,
                  key: ValueKey(isAdded),
                  color: isAdded
                      ? AppColors.warning
                      : AppColors.white.withValues(alpha: 0.5),
                  size: 28.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
