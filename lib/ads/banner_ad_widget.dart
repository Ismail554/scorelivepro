import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  //ad unit id
  final String adUnitId = Platform.isAndroid
      ? "ca-app-pub-3940256099942544/9214589741"
      : "ca-app-pub-3940256099942544/2435281174";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAd();
    });
  }

  // Load the banner ad
  void _loadAd() async {
    // Get the size before loading the ad.
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.sizeOf(context).width.truncate());

    if (size == null) {
      // Unable to get the size.
      return;
    }
    // Create an extra parameter that aligns the bottom of the expanded ad to the
    // bottom of the banner ad.
    const adRequest = AdRequest(extras: {
      "collapsible": "bottom",
    });
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: adRequest,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
          debugPrint('Ad loaded: ${ad.adUnitId}');
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Ad failed to load: $error');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isAdLoaded && _bannerAd != null) {
      return SizedBox(
        width: double.maxFinite,
        height: _bannerAd?.size.height.toDouble(),
        child: _isAdLoaded && _bannerAd != null
            ? AdWidget(ad: _bannerAd!)
            : const SizedBox.shrink(),
      );
    }
    return const SizedBox.shrink();
  }
}
