import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scorelivepro/ads/banner_ad_widget.dart';

class FloatingBannerAd extends StatefulWidget {
  const FloatingBannerAd({super.key});

  @override
  State<FloatingBannerAd> createState() => _FloatingBannerAdState();
}

class _FloatingBannerAdState extends State<FloatingBannerAd> {
  bool _isVisible = true;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _hideAdTemporarily() {
    setState(() {
      _isVisible = false;
    });

    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 15), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            const BannerAdWidget(),
            GestureDetector(
              onTap: _hideAdTemporarily,
              child: Container(
                margin: const EdgeInsets.only(right: 4, top: 4),
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
