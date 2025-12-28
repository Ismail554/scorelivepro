import 'package:flutter/material.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/widget/home/all_matches/widget_match_header_view.dart';

class HomeLineupsScreen extends StatefulWidget {
  const HomeLineupsScreen({super.key});

  @override
  State<HomeLineupsScreen> createState() => _LineupsScreenState();
}

class _LineupsScreenState extends State<HomeLineupsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        //Top Match Header Part
        WidgetMatchHeaderView(
          backgroundImage: ImageAssets.home_bg,
          leagueName: '',
          matchStatus: '',
          homeTeamName: '',
          awayTeamName: '',
          score: '',
          onNotificationPressed: () {},
        ),
        //Lineups Body Part
      ],
    ));
  }
}
