import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/provider/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;

  // Password Change Controllers
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _firstNameController = TextEditingController(
        text: (user?.firstName != null && user!.firstName!.isNotEmpty)
            ? user.firstName!
            : "John");
    _lastNameController = TextEditingController(
        text: (user?.lastName != null && user!.lastName!.isNotEmpty)
            ? user.lastName!
            : "Doe");
    _emailController = TextEditingController(text: user?.email ?? "");
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              "Edit Profile",
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
            // Avatar (Same as Profile)
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundImage: context
                                    .watch<AuthProvider>()
                                    .user
                                    ?.profileImage !=
                                null &&
                            context
                                .watch<AuthProvider>()
                                .user!
                                .profileImage!
                                .isNotEmpty
                        ? NetworkImage(
                            context.watch<AuthProvider>().user!.profileImage!)
                        : const NetworkImage(
                            "https://avatar.iran.liara.run/public"), // Placeholder
                    onBackgroundImageError: (exception, stackTrace) {
                      debugPrint("Avatar load error: $exception");
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6B00),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.camera_alt,
                          color: Colors.white, size: 18.sp),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                "Change Photo",
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            SizedBox(height: 30.h),

            // Personal Details Card
            _buildSectionCard(
              title: "Personal Details",
              icon: Icons.person_outline,
              children: [
                _buildLabel("First Name"),
                _buildTextField(_firstNameController, "John"),
                SizedBox(height: 16.h),
                _buildLabel("Last Name"),
                _buildTextField(_lastNameController, "Doe"),
                SizedBox(height: 16.h),
                _buildLabel("Email Address"),
                _buildReadOnlyTextField(_emailController),
              ],
            ),

            SizedBox(height: 24.h),

            // Security Details Card
            _buildSectionCard(
              title: "Security Details",
              icon: Icons.shield_outlined,
              children: [
                _buildLabel("Current password"),
                _buildPasswordField(
                    _currentPassController, "Enter current password"),
                SizedBox(height: 16.h),
                _buildLabel("New password"),
                _buildPasswordField(_newPassController, "Enter new password"),
                SizedBox(height: 16.h),
                _buildLabel("Confirm password"),
                _buildPasswordField(_confirmPassController, "Confirm password"),
              ],
            ),

            SizedBox(height: 30.h),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: Consumer<AuthProvider>(builder: (context, auth, _) {
                    return ElevatedButton(
                      onPressed: auth.isLoading
                          ? null
                          : () async {
                              bool profileUpdated = false;
                              bool passwordUpdated = false;

                              // 1. Update Profile if names changed
                              if (_firstNameController.text !=
                                      (auth.user?.firstName ?? "") ||
                                  _lastNameController.text !=
                                      (auth.user?.lastName ?? "")) {
                                final success = await auth.updateProfile(
                                    _firstNameController.text,
                                    _lastNameController.text,
                                    null); // Not passing image for now
                                if (success) profileUpdated = true;
                              }

                              // 2. Change password if fields are filled
                              if (_currentPassController.text.isNotEmpty &&
                                  _newPassController.text.isNotEmpty &&
                                  _confirmPassController.text.isNotEmpty) {
                                if (_newPassController.text !=
                                    _confirmPassController.text) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "New passwords do not match")),
                                    );
                                  }
                                  return;
                                }

                                final success = await auth.changePassword(
                                    _currentPassController.text,
                                    _newPassController.text,
                                    _confirmPassController.text);
                                if (success) passwordUpdated = true;
                              }

                              if (context.mounted) {
                                if (profileUpdated || passwordUpdated) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Updated successfully!" +
                                            (passwordUpdated
                                                ? " Password changed."
                                                : ""))),
                                  );
                                  Navigator.pop(context);
                                } else if (_currentPassController
                                        .text.isNotEmpty ||
                                    _newPassController.text.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Failed to update password. Please check your current password.")),
                                  );
                                } else {
                                  // No changes made
                                  Navigator.pop(context);
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B00),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: auth.isLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: const CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              "Save changes",
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                    );
                  }),
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
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
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
              Icon(icon, color: const Color(0xFFFF6B00), size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Divider(height: 24.h, thickness: 1, color: Colors.grey.shade200),
          ...children,
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9FA),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 14.sp, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildReadOnlyTextField(TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9FA),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        controller: controller,
        readOnly: true,
        style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email_outlined,
              size: 18.sp, color: Colors.grey.shade400),
          suffixIcon: Icon(Icons.lock_outline,
              size: 16.sp, color: Colors.grey.shade300), // Lock icon
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9FA),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        controller: controller,
        obscureText: true,
        style: TextStyle(fontSize: 14.sp, color: Colors.black87),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_outlined,
              size: 18.sp, color: Colors.grey.shade400),
          suffixIcon: Icon(Icons.visibility_off_outlined,
              size: 18.sp, color: Colors.grey.shade400),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }
}
