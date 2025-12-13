import 'package:flutter/material.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/font_manager.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text(
          AppStrings.news,
          style: FontManager.heading2(),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.newspaper_outlined,
              size: 64,
              color: AppColors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.noNews,
              style: FontManager.bodyLarge(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
