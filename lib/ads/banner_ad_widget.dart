import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  final String? androidAdUnitId;
  final String? iosAdUnitId;
  final VoidCallback? onAdLoaded;
  final VoidCallback? onAdFailedToLoad;

  const BannerAdWidget({
    super.key,
    this.androidAdUnitId,
    this.iosAdUnitId,
    this.onAdLoaded,
    this.onAdFailedToLoad,
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  //ad unit id
  String get adUnitId {
    if (Platform.isAndroid) {
      return widget.androidAdUnitId ?? "ca-app-pub-6967886775553979/7655620271";
    } else {
      return widget.iosAdUnitId ?? "ca-app-pub-6967886775553979/7825631347";
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAd();
    });
  }

  // Load the banner ad
  void _loadAd() async {
    if (!mounted) return;

    final width = MediaQuery.sizeOf(context).width.truncate();
    // Get the size before loading the ad.
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);

    if (!mounted) return;

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
      size: size,
      request: adRequest,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _isAdLoaded = true;
          });
          widget.onAdLoaded?.call();
          debugPrint('Ad loaded: ${ad.adUnitId}');
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          widget.onAdFailedToLoad?.call();
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
        child: AdWidget(ad: _bannerAd!),
      );
    }
    return const SizedBox.shrink();
  }
}
