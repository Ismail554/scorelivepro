import 'package:flutter/material.dart';
import 'package:scorelivepro/core/font_manager.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Terms of Service",
          style: FontManager.titleText(),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ScoreLivePro Terms of Service",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Welcome to ScoreLivePro! These Terms of Service explain the rules for using our app. By downloading, accessing, or using ScoreLivePro, you agree to these Terms.",
            ),
            SizedBox(height: 24),
            _SectionTitle("1. Using ScoreLivePro"),
            Text(
              "ScoreLivePro provides live football scores, match statistics, notifications, and related content for football fans. You may use the app for personal, non-commercial purposes only. If you do not agree with these Terms, please do not use the app.",
            ),
            SizedBox(height: 20),
            _SectionTitle("2. Your Account"),
            Text(
              "Some features, such as personalized notifications and preferences, may require an account.\n\n"
              "When creating an account, you agree to:\n"
              "• Provide accurate and up-to-date information.\n"
              "• Keep your login credentials secure.\n"
              "• Notify us if you believe your account has been accessed without your permission.\n\n"
              "You are responsible for all activity that occurs under your account.",
            ),
            SizedBox(height: 20),
            _SectionTitle("3. Acceptable Use"),
            Text(
              "To ensure a safe and reliable experience for everyone, you agree not to:\n\n"
              "• Use the app in violation of any applicable laws or regulations.\n"
              "• Attempt to access systems, servers, or data without authorization.\n"
              "• Disrupt, damage, or interfere with the app's functionality.\n"
              "• Use automated tools or methods to misuse the service.",
            ),
            SizedBox(height: 20),
            _SectionTitle("4. Content and Intellectual Property"),
            Text(
              "All content available through ScoreLivePro, including scores, statistics, graphics, logos, designs, and software, is owned by ScoreLivePro or its content providers and is protected by intellectual property laws.\n\n"
              "You may not copy, distribute, modify, or commercially exploit any content from the app without prior written permission.",
            ),
            SizedBox(height: 20),
            _SectionTitle("5. Data Accuracy"),
            Text(
              "We work hard to provide accurate and timely football information. However, live sports data can occasionally contain delays, errors, or interruptions.\n\n"
              "ScoreLivePro does not guarantee that all information will always be complete, accurate, or available at all times.",
            ),
            SizedBox(height: 20),
            _SectionTitle("6. Limitation of Liability"),
            Text(
              "To the fullest extent permitted by law, ScoreLivePro is not responsible for any indirect, incidental, special, or consequential damages resulting from your use of the app or reliance on its content.\n\n"
              "Your use of the app is at your own risk.",
            ),
            SizedBox(height: 20),
            _SectionTitle("7. Suspension or Termination"),
            Text(
              "We may suspend or terminate access to the app if we believe a user has violated these Terms, misused the service, or engaged in activities that could harm other users or ScoreLivePro.",
            ),
            SizedBox(height: 20),
            _SectionTitle("8. Changes to These Terms"),
            Text(
              "We may update these Terms from time to time. When we do, the updated version will be posted within the app and the 'Last Updated' date will be revised.\n\n"
              "Continued use of the app after changes become effective means you accept the updated Terms.",
            ),
            SizedBox(height: 20),
            _SectionTitle("9. Contact Us"),
            Text(
              "If you have any questions about these Terms, please contact us:\n\n"
              "Contact Form:\n"
              "https://scorelivepro.it/en/contact\n\n"
              "Email:\n"
              "support@scorelivepro.it",
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
