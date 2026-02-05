import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/assets_manager.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  // Color Palette form the image
  final Color bgColor = const Color(0xFFF8F9FA);
  final Color cardColor = Colors.white;
  final Color textColor = const Color(0xFF1A1A1A);
  final Color subTextColor = const Color(0xFF757575);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: Text(
          "App Information",
          style: TextStyle(
              color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Section (Logo + Title)
            _buildHeader(),
            const SizedBox(height: 25),

            // 2. Key Features Section
            _buildSectionTitle("Key Features"),
            _buildCard(
              child: Column(
                children: [
                  _buildFeatureItem(Icons.bolt, "Real-Time Scores",
                      "Get live updates from matches around the world"),
                  _buildDivider(),
                  _buildFeatureItem(Icons.language, "Global Coverage",
                      "Follow leagues and teams from all over the world"),
                  _buildDivider(),
                  _buildFeatureItem(
                      Icons.star_outline,
                      "Personalized Favorites",
                      "Save your favorite teams and get quick access"),
                  _buildDivider(),
                  _buildFeatureItem(Icons.shield_outlined, "Match Statistics",
                      "Detailed stats, line-ups, and match timelines"),
                ],
              ),
            ),

            // 3. About Section
            const SizedBox(height: 20),
            _buildSectionTitle("About"),
            _buildCard(
              child: Text(
                "ScoreLivePRO is your ultimate companion for staying updated with football scores, news, and stats. Our mission is to provide football fans with the fastest and most accurate information.\n\nWhether you're following your favorite team or exploring new leagues, ScoreLivePRO offers a seamless experience.",
                style:
                    TextStyle(color: subTextColor, height: 1.5, fontSize: 13),
              ),
            ),

            // 4. Technical Information
            const SizedBox(height: 20),
            _buildSectionTitle("Technical Information"),
            _buildCard(
              child: Column(
                children: [
                  _buildInfoRow("Version", "1.0.0"),
                  _buildDivider(),
                  _buildInfoRow("Build Number", "100"),
                  _buildDivider(),
                  _buildInfoRow("Last Updated", "December 2, 2024"),
                  _buildDivider(),
                  _buildInfoRow("Platform", "iOS & Android"),
                ],
              ),
            ),

            // // 5. Credits Section
            // const SizedBox(height: 20),
            // _buildSectionTitle("Credits"),
            // _buildCard(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text("Built with modern technologies and inspired by leading sports apps", style: TextStyle(color: subTextColor, fontSize: 13)),
            //       const SizedBox(height: 10),
            //       Wrap(
            //         spacing: 8,
            //         children: [
            //           _buildChip("React"), // Keeping text from image, though we are coding in Flutter ;)
            //           _buildChip("TypeScript"),
            //           _buildChip("Tailwind CSS"),
            //           _buildChip("Lucide Icons"),
            //         ],
            //       )
            //     ],
            //   ),
            // ),

            // 6. Contact & Support
            const SizedBox(height: 20),
            _buildSectionTitle("Contact & Support"),
            _buildCard(
              child: Column(
                children: [
                  _buildContactRow("Email Support", "support@scorelivepro.com",
                      isLink: true),
                  _buildDivider(),
                  _buildContactRow("Website", "www.scorelivepro.com",
                      isLink: true),
                  _buildDivider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Follow Us",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: textColor)),
                        Row(
                          children: [
                            Icon(Icons.close,
                                size: 20, color: subTextColor), // X icon
                            const SizedBox(width: 10),
                            Icon(Icons.facebook, size: 20, color: Colors.blue),
                            const SizedBox(width: 10),
                            Icon(Icons.camera_alt,
                                size: 20,
                                color: Colors.purple), // Instagram-ish
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            // Footer
            const SizedBox(height: 30),
            Center(
              child: Text(
                "© 2024 ScoreLivePRO. All rights reserved.\nMade with ❤️ for football fans worldwide",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[400], fontSize: 11),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- Helper Methods (Code Organizer) ---

  // 1. Header (Logo & Name)
  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Container(
              height: 100.h,
              width: 100.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Container(
                height: 32.h,
                width: 32.w,
                child: Image.asset(
                  IconAssets.trophy,
                  // fit: BoxFit.cover,
                ),
              )),
          const SizedBox(height: 15),
          const Text(
            "ScoreLivePRO",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
            "Real-Time Football Scores & News",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Version 1.0.0",
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
          )
        ],
      ),
    );
  }

  // 2. Section Title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  // 3. Reusable Card Container
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  // 4. Feature Item Row
  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(color: subTextColor, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 5. Info Row (Label -> Value)
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: subTextColor, fontSize: 13)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  // 6. Contact Row
  Widget _buildContactRow(String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: isLink ? AppColors.primaryColor : Colors.black87)),
        ],
      ),
    );
  }

  // 7. Chip for Credits
  Widget _buildChip(String label) {
    return Chip(
      label: Text(label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      backgroundColor: Colors.grey[100],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), side: BorderSide.none),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  // 8. Custom Divider
  Widget _buildDivider() {
    return Divider(color: Colors.grey[100], thickness: 1);
  }
}
