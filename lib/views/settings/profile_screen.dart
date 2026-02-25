import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/provider/auth_provider.dart';
import 'package:scorelivepro/views/settings/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "User Profile",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "View and manage your personal information",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            // Avatar & Change Photo
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundImage: user?.profileImage != null &&
                            user!.profileImage!.isNotEmpty
                        ? NetworkImage(user.profileImage!)
                        : const NetworkImage(
                            "https://avatar.iran.liara.run/public"), // Placeholder
                    onBackgroundImageError: (exception, stackTrace) {
                      debugPrint("Avatar load error: $exception");
                    },
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child: Container(
                  //     padding: EdgeInsets.all(6.w),
                  //     decoration: const BoxDecoration(
                  //       color: Color(0xFFFF6B00), // Orange
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: Icon(Icons.camera_alt,
                  //         color: Colors.white, size: 18.sp),
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.grey.shade300),
            //     borderRadius: BorderRadius.circular(20.r),
            //   ),
            //   child: Text(
            //     "Change Photo",
            //     style: TextStyle(
            //         fontSize: 12.sp,
            //         fontWeight: FontWeight.w500,
            //         color: Colors.black),
            //   ),
            // ),
            SizedBox(height: 30.h),

            // Personal Details Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_outline,
                          color: const Color(0xFFFF6B00), size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        "Personal Details",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                      height: 24.h, thickness: 1, color: Colors.grey.shade200),

                  // Fields
                  _buildReadOnlyField(
                      "First Name",
                      (user?.firstName != null && user!.firstName!.isNotEmpty)
                          ? user.firstName!
                          : "John"),
                  SizedBox(height: 16.h),
                  _buildReadOnlyField(
                      "Last Name",
                      (user?.lastName != null && user!.lastName!.isNotEmpty)
                          ? user.lastName!
                          : "Doe"),
                  SizedBox(height: 16.h),
                  _buildReadOnlyField(
                      "Email Address", user?.email ?? "john.doe@example.com",
                      icon: Icons.email_outlined),
                ],
              ),
            ),

            SizedBox(height: 30.h),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Edit profile",
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 6.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9FA), // Light grey field bg
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18.sp, color: Colors.grey),
                SizedBox(width: 10.w),
              ],
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
