import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/l10n/app_localizations.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/widget/news/widget_news_card.dart';

/// News item model
class NewsItem {
  final String imageUrl;
  final String category;
  final String title;
  final String description;
  final String timeAgo;
  final String categoryType; // "All", "Team", "League", "Trending"

  const NewsItem({
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.categoryType,
  });
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  String _selectedCategory = "All";
  final TextEditingController _searchController = TextEditingController();

  // Sample news data
  final List<NewsItem> _allNews = [
    const NewsItem(
      imageUrl: ImageAssets.news_im1,
      category: "Transfer",
      title: "Manchester United Signs New Midfielder in Record Deal",
      description:
          "The Red Devils have completed the signing of a world-class midfielder in a deal worth €100",
      timeAgo: "2 hours ago",
      categoryType: "Team",
    ),
    const NewsItem(
      imageUrl: ImageAssets.home_bg,
      category: "Match",
      title: "Premier League: Arsenal Defeats Liverpool 3-1",
      description:
          "Arsenal secured a crucial victory against Liverpool in a thrilling match at the Emirates Stadium",
      timeAgo: "5 hours ago",
      categoryType: "League",
    ),
    const NewsItem(
      imageUrl: ImageAssets.home_bg,
      category: "Transfer",
      title: "Barcelona Confirms Signing of Brazilian Star",
      description:
          "The Catalan giants have announced the signing of a promising Brazilian talent for the upcoming season",
      timeAgo: "1 day ago",
      categoryType: "Trending",
    ),
    const NewsItem(
      imageUrl: ImageAssets.home_bg,
      category: "Injury",
      title: "Key Player Ruled Out for Rest of Season",
      description:
          "A major setback for the team as their star player faces a long-term injury",
      timeAgo: "2 days ago",
      categoryType: "Team",
    ),
    const NewsItem(
      imageUrl: ImageAssets.home_bg,
      category: "Match",
      title: "Champions League Quarter-Finals Draw Revealed",
      description:
          "The draw for the Champions League quarter-finals has been announced with exciting matchups",
      timeAgo: "3 days ago",
      categoryType: "League",
    ),
  ];

  List<NewsItem> get _filteredNews {
    if (_selectedCategory == "All") {
      return _allNews;
    }
    return _allNews
        .where((news) => news.categoryType == _selectedCategory)
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          // Header Section
          Container(
            color: AppColors.white,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              children: [
                // Title
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context).news,
                      style: FontManager.heading2(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),

                // Search Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: AppColors.greyE8,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: AppColors.textTertiary,
                          size: 20.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: "Search news...",
                              hintStyle: FontManager.bodyMedium(
                                color: AppColors.textTertiary,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: FontManager.bodyMedium(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Category Filter Chips
                SizedBox(
                  height: 40.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    children: [
                      _buildCategoryChip("All"),
                      SizedBox(width: 8.w),
                      _buildCategoryChip("Team"),
                      SizedBox(width: 8.w),
                      _buildCategoryChip("League"),
                      SizedBox(width: 8.w),
                      _buildCategoryChip("Trending"),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),
              ],
            ),
          ),

          // News List
          Expanded(
            child: _filteredNews.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.newspaper_outlined,
                          size: 64.sp,
                          color: AppColors.grey,
                        ),
                        AppSpacing.h16,
                        Text(
                          AppLocalizations.of(context).noNews,
                          style: FontManager.bodyLarge(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: _filteredNews.length,
                    itemBuilder: (context, index) {
                      final news = _filteredNews[index];
                      return NewsCard(
                        imageUrl: news.imageUrl,
                        category: news.category,
                        title: news.title,
                        description: news.description,
                        timeAgo: news.timeAgo,
                        onTap: () {
                          // TODO: Navigate to news details
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : AppColors.greyE8,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          category,
          style: FontManager.labelMedium(
            color: isSelected ? AppColors.white : AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
