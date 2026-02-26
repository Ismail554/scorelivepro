import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scorelivepro/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
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

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

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
              AppLocalizations.of(context).editProfile,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppLocalizations.of(context).viewAndManageInfo,
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
                  GestureDetector(
                    onTap: _showImagePickerBottomSheet,
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!) as ImageProvider
                          : (context.watch<AuthProvider>().user?.profileImage !=
                                      null &&
                                  context
                                      .watch<AuthProvider>()
                                      .user!
                                      .profileImage!
                                      .isNotEmpty
                              ? NetworkImage(context
                                  .watch<AuthProvider>()
                                  .user!
                                  .profileImage!)
                              : const NetworkImage(
                                  "https://avatar.iran.liara.run/public")), // Placeholder
                      onBackgroundImageError: (exception, stackTrace) {
                        debugPrint("Avatar load error: $exception");
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showImagePickerBottomSheet,
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
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            GestureDetector(
              onTap: _showImagePickerBottomSheet,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  AppLocalizations.of(context).changePhoto,
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 30.h),

            // Personal Details Card
            _buildSectionCard(
              title: AppLocalizations.of(context).personalDetails,
              icon: Icons.person_outline,
              children: [
                _buildLabel(AppLocalizations.of(context).firstName),
                _buildTextField(_firstNameController, "John"),
                SizedBox(height: 16.h),
                _buildLabel(AppLocalizations.of(context).lastName),
                _buildTextField(_lastNameController, "Doe"),
                SizedBox(height: 16.h),
                _buildLabel(AppLocalizations.of(context).emailAddress),
                _buildReadOnlyTextField(_emailController),
              ],
            ),

            SizedBox(height: 24.h),

            // Security Details Card
            _buildSectionCard(
              title: AppLocalizations.of(context).securityDetails,
              icon: Icons.shield_outlined,
              children: [
                _buildLabel(AppLocalizations.of(context).currentPassword),
                _buildPasswordField(_currentPassController,
                    AppLocalizations.of(context).enterCurrentPassword),
                SizedBox(height: 16.h),
                _buildLabel(AppLocalizations.of(context).newPassword),
                _buildPasswordField(_newPassController,
                    AppLocalizations.of(context).enterNewPassword),
                SizedBox(height: 16.h),
                _buildLabel(AppLocalizations.of(context).confirmPassword),
                _buildPasswordField(_confirmPassController,
                    AppLocalizations.of(context).confirmPasswordHint),
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

                              // 1. Update Profile if names changed or image selected
                              if (_firstNameController.text !=
                                      (auth.user?.firstName ?? "") ||
                                  _lastNameController.text !=
                                      (auth.user?.lastName ?? "") ||
                                  _selectedImage != null) {
                                final success = await auth.updateProfile(
                                    _firstNameController.text,
                                    _lastNameController.text,
                                    _selectedImage?.path); // Pass image path
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
                                      SnackBar(
                                          content: Text(
                                              AppLocalizations.of(context)
                                                  .newPasswordsDoNotMatch)),
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
                                        content: Text(AppLocalizations.of(
                                                    context)
                                                .updatedSuccessfully +
                                            (passwordUpdated
                                                ? AppLocalizations.of(context)
                                                    .passwordChanged
                                                : ""))),
                                  );
                                  Navigator.pop(context);
                                } else if (_currentPassController
                                        .text.isNotEmpty ||
                                    _newPassController.text.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)
                                                .failedUpdatePassword)),
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
                              AppLocalizations.of(context).saveChanges,
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
                      AppLocalizations.of(context).cancel,
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
